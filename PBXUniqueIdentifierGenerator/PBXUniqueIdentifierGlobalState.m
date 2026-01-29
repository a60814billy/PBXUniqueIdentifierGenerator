#import "PBXUniqueIdentifierGlobalState.h"
#import "PBXUniqueIdentifier.h"

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

    if (userName == nil || userName.length == 0) {
        return hash;
    }

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

@implementation PBXUniqueIdentifierGlobalState
{
    CPBXUniqueIdentifierGlobalState *globalState;
}

#pragma mark -
#pragma mark Lifecycle

-(instancetype)init
{
    if (self = [super init])
    {
        globalState = malloc(sizeof(CPBXUniqueIdentifierGlobalState));
        [self resetState];
    }
    return self;
}

-(void)dealloc
{
    if (globalState != NULL)
    {
        free(globalState);
        globalState = NULL;
    }
}

#pragma mark -
#pragma mark Methods

- (instancetype)nextState
{
    @synchronized (self) {
        // increse sequence
        globalState->sequence++;
        
        uint32_t currentTime = [NSDate timeIntervalSinceReferenceDate];
        if (currentTime > globalState->time) {
            globalState->time = currentTime;
            globalState->firstSequenceForTheTime = globalState->sequence;
        } else {
            // time not change, but sequence round to first seq at the time
            // force increse time tick
            if (globalState->sequence == globalState->firstSequenceForTheTime) {
                globalState->time++;
            }
        }
    }
    return self;
}

- (PBXUniqueIdentifier *)deriveIdentifier
{
    PBXUniqueIdentifier *identifier = [[PBXUniqueIdentifier alloc] init];
    
    identifier.userHash = globalState->userHash;
    identifier.pid = globalState->pid;
    identifier.sequence = globalState->sequence;
    identifier.time = globalState->time;
    identifier.random = globalState->randomValue;
    
    return identifier;
}

- (void)resetState
{
    @synchronized (self) {
        globalState->userHash = UserHash() & 0xFF;
        globalState->pid = [[NSProcessInfo processInfo] processIdentifier];
        globalState->time = [NSDate timeIntervalSinceReferenceDate];

        srandom(globalState->pid << 16 ^ globalState->time);
        
        globalState->randomValue = random() & 0xFFFFFF;
        globalState->sequence = random();
    }
}

- (void)restoreFromIdentifier:(PBXUniqueIdentifier *) identifier
{
    @synchronized (self) {
        globalState->userHash = identifier.userHash;
        globalState->pid = identifier.pid;
        globalState->sequence = identifier.sequence;
        globalState->time = identifier.time;
        globalState->randomValue = identifier.random;
        
        globalState->firstSequenceForTheTime = identifier.sequence;
    }
}

#pragma mark - Accessors

- (uint8_t)userHash
{
    return globalState->userHash;
}

- (uint8_t)pid
{
    return globalState->pid;
}

- (uint32_t)randomValue
{
    return globalState->randomValue;
}

- (uint32_t)time
{
    return globalState->time;
}

- (uint16_t)sequence
{
    return globalState->sequence;
}

- (uint16_t)firstSequenceForTheTime
{
    return globalState->firstSequenceForTheTime;
}

@end
