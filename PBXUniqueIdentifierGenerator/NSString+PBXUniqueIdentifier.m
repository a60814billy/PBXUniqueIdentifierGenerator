#import <Foundation/Foundation.h>
#import "NSString+PBXUniqueIdentifier.h"
#import "PBXUniqueIdentifierGenerator.h"

@implementation NSString (PBXUniqueIdentifier)

+ (NSString *)stringWithHexadecimalRepresentationOfUniqueIdentifier
{
    PBXUniqueIdentifier identifier = [PBXUniqueIdentifierGenerator nextIdentifier];
    
    return [self stringWithHexRepresentationOfBytes:(const uint8_t *)&identifier length:sizeof(identifier)];
}

+ (NSString *)stringWithHexRepresentationOfBytes:(const uint8_t *)bytes length:(NSUInteger)length
{
    if (bytes == NULL) return nil;
    if (length == 0) return @"";
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:length * 2];
    
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }

    return [hexString copy];
}

@end
