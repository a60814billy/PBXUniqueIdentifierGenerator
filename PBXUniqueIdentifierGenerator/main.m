#import <Foundation/Foundation.h>
#import "NSString+PBXUniqueIdentifier.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *newObjId = [[NSString stringWithHexadecimalRepresentationOfUniqueIdentifier] uppercaseString];
        printf("%s\n", [newObjId UTF8String]);
    }
    return EXIT_SUCCESS;
}
