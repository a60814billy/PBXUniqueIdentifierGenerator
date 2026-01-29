#import "PBXUniqueIdentifier.h"

@implementation PBXUniqueIdentifier
{
    NSMutableData *identifierData;
}

#pragma mark -
#pragma mark Internal

- (CPBXUniqueIdentifier *)cIdentifier
{
    return (CPBXUniqueIdentifier *)[identifierData mutableBytes];
}

#pragma mark -
#pragma mark LifeCycle
- (instancetype) init
{
    if (self = [super init])
    {
        identifierData = [[NSMutableData alloc] initWithLength:sizeof(CPBXUniqueIdentifier)];
    }
    return self;
}

- (instancetype) initWithStringRepresentation:(NSString *)identifier
{
    NSAssert([identifier length] == 24, @"Identifier must be 24 characters");
    
    if (self = [super init])
    {
        identifierData = [[NSMutableData alloc] initWithLength:sizeof(CPBXUniqueIdentifier)];
        uint8_t *bytes = (uint8_t *)[identifierData mutableBytes];
        
        NSUInteger strLen = [identifier lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        const char *cStr = [[identifier lowercaseString] UTF8String];
        
        for (int i = 0; i < sizeof(CPBXUniqueIdentifier); i++) {
            if (i * 2 + 1 < strLen) {
                sscanf(cStr + (i*2), "%2hhx", &bytes[i]);
            }
        }
    }
    return self;
}

#pragma mark -
#pragma mark Properties

- (void)setUserHash:(uint8_t)userHash
{
    self.cIdentifier->userHash = userHash;
}

- (uint8_t)userHash
{
    return self.cIdentifier->userHash;
}

- (void)setPid:(uint8_t)pid
{
    self.cIdentifier->pid = pid;
}

- (uint8_t)pid
{
    return self.cIdentifier->pid;
}

- (void)setSequence:(uint16_t)sequence
{
    self.cIdentifier->sequence = CFSwapInt16HostToBig(sequence);
}

- (uint16_t)sequence
{
    return CFSwapInt16BigToHost(self.cIdentifier->sequence);
}

- (void)setTime:(uint32_t)time
{
    self.cIdentifier->time = CFSwapInt32HostToBig(time);
}

- (uint32_t)time
{
    return CFSwapInt32BigToHost(self.cIdentifier->time);
}

- (void)setRandom:(uint32_t)random
{
    self.cIdentifier->random = CFSwapInt32HostToBig(random);
}

- (uint32_t)random
{
    return CFSwapInt32BigToHost(self.cIdentifier->random);
}

- (const uint8_t*) bytes
{
    return (const uint8_t *)[identifierData bytes];
}

#pragma mark -
#pragma mark Methods
- (NSString *)stringRepresentation
{
    const uint8_t *bytes = self.bytes;
    NSUInteger length = sizeof(CPBXUniqueIdentifier);
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:length * 2];
    
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendFormat:@"%02X", bytes[i]];
    }

    return [hexString copy];
}

@end
