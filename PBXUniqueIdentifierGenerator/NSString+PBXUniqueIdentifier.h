#import <Foundation/Foundation.h>

/// A category on `NSString` to provide convenience methods for generating PBX unique identifiers strings.
@interface NSString (PBXUniqueIdentifier)

/// Generates a new unique identifier as a hexadecimal string.
///
/// This convenience method uses `PBXUniqueIdentifierGenerator` to create a new unique identifier
/// and immediately converts it into its 24-character hexadecimal string representation.
/// This format is commonly used in Xcode's `project.pbxproj` files.
///
/// @return A 24-character uppercase hexadecimal string representing a new unique identifier.
+ (NSString *)stringWithHexadecimalRepresentationOfUniqueIdentifier;

@end
