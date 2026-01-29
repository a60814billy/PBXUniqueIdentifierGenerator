#import <Foundation/Foundation.h>

@interface NSString (PBXUniqueIdentifier)

+ (NSString *)stringWithHexadecimalRepresentationOfUniqueIdentifier;
+ (NSString *)stringWithHexRepresentationOfBytes:(const uint8_t *)bytes length:(NSUInteger)length;

@end
