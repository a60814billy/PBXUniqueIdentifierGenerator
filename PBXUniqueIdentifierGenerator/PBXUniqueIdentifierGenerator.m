#import "PBXUniqueIdentifierGenerator.h"

static const uint8_t PBXCharPackingTable[128] = {
    // control character / symbols
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    // 0 - 9
    0x1a, 0x1b, 0x1c, 0x1d, 0x1e,
    0x1a, 0x1b, 0x1c, 0x1d, 0x1e,
    // control character / symbols
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    // A-Z
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
    0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
    // control character / symbols
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f,
    // a-z
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
    0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,
    // control character / symbols
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f
};

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
        state->randomValue = arc4random();
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
    identifier.random = globalState->randomValue;
    
    return identifier;
}

@end
