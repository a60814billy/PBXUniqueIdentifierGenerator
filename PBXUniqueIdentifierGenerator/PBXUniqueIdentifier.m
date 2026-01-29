//
//  PBXUniqueIdentifier.m
//  PBXUniqueIdentifierGenerator
//
//  Created by Raccoon on 2026/1/30.
//

#import "PBXUniqueIdentifier.h"

@implementation PBXUniqueIdentifier
{
    CPBXUniqueIdentifier *cIdentifier;
}

#pragma mark -
#pragma mark LifeCycle
- (instancetype) init
{
    if (self = [super init])
    {
        cIdentifier = calloc(1, sizeof(CPBXUniqueIdentifier));
    }
    return self;
}

- (instancetype) initWithStringRepresentation:(NSString *)identifier
{
    NSAssert([identifier length] == 24, @"Identifier must be 24 characters");
    
    if (self = [super init])
    {
        CPBXUniqueIdentifier *pbxId = malloc(sizeof(CPBXUniqueIdentifier));
        uint8_t *bytes = (uint8_t *)pbxId;
        
        NSUInteger strLen = [identifier lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        const char *cStr = [[identifier lowercaseString] UTF8String];
        
        for (int i = 0; i < sizeof(CPBXUniqueIdentifier); i++) {
            if (i * 2 + 1 < strLen) {
                sscanf(cStr + (i*2), "%2hhx", &bytes[i]);
            }
        }
        
        cIdentifier = pbxId;
    }
    return self;
}

- (void)dealloc
{
    if (cIdentifier != NULL) {
        free(cIdentifier);
        cIdentifier = NULL;
    }
}


#pragma mark -
#pragma mark Properties

- (void)setUserHash:(uint8_t)userHash
{
    cIdentifier->userHash = userHash;
}

- (uint8_t)userHash
{
    return cIdentifier->userHash;
}

- (void)setPid:(uint8_t)pid
{
    cIdentifier->pid = pid;
}

- (uint8_t)pid
{
    return cIdentifier->pid;
}

- (void)setSequence:(uint16_t)sequence
{
    cIdentifier->sequence = sequence;
}

- (uint16_t)sequence
{
    return cIdentifier->sequence;
}

- (void)setTime:(uint32_t)time
{
    cIdentifier->time = time;
}

- (uint32_t)time
{
    return cIdentifier->time;
}

- (void)setRandom:(uint32_t)random
{
    cIdentifier->random = random;
}

- (uint32_t)random
{
    return cIdentifier->random;
}

- (const uint8_t*) bytes
{
    return (const uint8_t *)cIdentifier;
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
