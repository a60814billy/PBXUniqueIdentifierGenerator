#import <Foundation/Foundation.h>

/// A category on `NSString` to provide convenience methods for generating PBX unique identifiers strings.
@interface NSString (PBXUniqueIdentifier)

/// Generates a new unique identifier as a hexadecimal string.
///
/// This method uses `PBXUniqueIdentifierGenerator` to create a new unique identifier and then
/// converts it into its 24-character hexadecimal string representation.
/// This format is commonly used in Xcode's `project.pbxproj` files.
///
/// @return A 24-character hexadecimal string representing a new unique identifier.
+ (NSString *)stringWithHexadecimalRepresentationOfUniqueIdentifier;

/// Creates a hexadecimal string representation of the given bytes.
///
/// This utility method converts a raw byte array into a hexadecimal string.
///
/// @param bytes A pointer to the byte array to convert.
/// @param length The number of bytes to read from the array.
/// @return A string containing the hexadecimal representation of the bytes. Returns `nil` if `bytes` is NULL, or an empty string if `length` is 0.
+ (NSString *)stringWithHexRepresentationOfBytes:(const uint8_t *)bytes length:(NSUInteger)length;

@end
