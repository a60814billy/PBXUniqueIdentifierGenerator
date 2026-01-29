#import <Foundation/Foundation.h>
#import "NSString+PBXUniqueIdentifier.h"
#import "PBXUniqueIdentifierGenerator.h"
#import "PBXUniqueIdentifier.h"

@implementation NSString (PBXUniqueIdentifier)

+ (NSString *)stringWithHexadecimalRepresentationOfUniqueIdentifier
{
    return [[PBXUniqueIdentifierGenerator nextIdentifier] stringRepresentation];
}

@end
