#include <array>
#include <cstdint>

#import "PBXUniqueIdentifierGenerator.h"

constexpr uint8_t get_packing_val(int c) {
    if (c >= 'A' && c <= 'Z') return c - 'A';      // 0x00 - 0x19
    if (c >= 'a' && c <= 'z') return c - 'a';      // 0x00 - 0x19
    if (c >= '0' && c <= '4') return 0x1a + (c - '0');
    if (c >= '5' && c <= '9') return 0x1a + (c - '5');
    return 0x1f; // default
}

template <size_t... Is>
constexpr std::array<uint8_t, 128> make_packing_table(std::index_sequence<Is...>) {
    return { get_packing_val(Is)... };
}

// build mapping table in compiler time
static constexpr auto PBXCharPackingTable = make_packing_table(std::make_index_sequence<128>{});

uint32_t UserHash(void)
{
    uint32_t hash = 0;
    NSString *userName = NSUserName();

    uint8_t shift = 0;
    for (NSUInteger i = 0; i < userName.length; i++) {
        unichar c = [userName characterAtIndex:i];
        uint32_t val;
        
        if (c & 0x80) {
            val = 0x1f;
        } else {
            // ascii
            val = PBXCharPackingTable[c];
        }
        
        if (shift != 0) {
            val = val << shift;
            val |= (val >> 8);
        }
        
        hash ^= val;
        shift = (shift + 0x05) & 0x07;
    }

    return hash;
}

@interface PBXUniqueIdentifierGenerator()
+ (PBXUniqueIdentifierGeneratorGlobalState *) globalState;
+ (PBXUniqueIdentifierGeneratorGlobalState *) nextGlobalState;
@end

@implementation PBXUniqueIdentifierGenerator

+ (PBXUniqueIdentifierGeneratorGlobalState *) globalState
{
    static PBXUniqueIdentifierGeneratorGlobalState *state = nil;
    
    if (state == nil) {
        state = (PBXUniqueIdentifierGeneratorGlobalState *) malloc(sizeof(PBXUniqueIdentifier));
        state->userHash = UserHash() & 0xFF;
        state->pid = [[NSProcessInfo processInfo] processIdentifier];
        state->randomValue = arc4random() & 0xFFFFFF;
        state->time = 0;
        state->sequence = arc4random();
    }
    
    return state;
}

+ (PBXUniqueIdentifierGeneratorGlobalState *) nextGlobalState
{
    @synchronized (self) {
        PBXUniqueIdentifierGeneratorGlobalState *state = [self globalState];
        // increse sequence
        state->sequence++;
        
        uint32_t currentTime = [NSDate timeIntervalSinceReferenceDate];
        if (currentTime > state->time) {
            state->time = currentTime;
            state->firstSequenceForTheTime = state->sequence;
        } else {
            // time not change, but sequence round to first seq at the time
            // force increse time tick
            if (state->sequence == state->firstSequenceForTheTime) {
                state->time++;
            }
        }
        
        return state;
    }
}

+ (PBXUniqueIdentifier)nextIdentifier
{
    PBXUniqueIdentifier identifier;
    PBXUniqueIdentifierGeneratorGlobalState *globalState = [self nextGlobalState];
    
    identifier.userHash = globalState->userHash;
    identifier.pid = globalState->pid;
    identifier.sequence = CFSwapInt16HostToBig(globalState->sequence);
    identifier.time = CFSwapInt32HostToBig(globalState->time);
    identifier.random = CFSwapInt32HostToBig(globalState->randomValue);
    
    return identifier;
}

+ (void)restoreGlobalStateFromIdentifier:(NSString *)identifier
{
    if (identifier.length != 24) return;

    PBXUniqueIdentifier pbxId;
    uint8_t *bytes = (uint8_t *)&pbxId;
    
    NSUInteger strLen = [identifier lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *cStr = [[identifier lowercaseString] UTF8String];
    
    for (int i = 0; i < sizeof(PBXUniqueIdentifier); i++) {
        if (i * 2 + 1 < strLen) {
            sscanf(cStr + (i*2), "%2hhx", &bytes[i]);
        }
    }

    @synchronized (self) {
        PBXUniqueIdentifierGeneratorGlobalState *state = [self globalState];
        
        state->userHash = pbxId.userHash;
        state->pid = pbxId.pid;
        state->sequence = CFSwapInt16BigToHost(pbxId.sequence);
        state->time = CFSwapInt32BigToHost(pbxId.time);
        state->randomValue = CFSwapInt32BigToHost(pbxId.random);
        
        state->firstSequenceForTheTime = state->sequence;
    }
}

@end
