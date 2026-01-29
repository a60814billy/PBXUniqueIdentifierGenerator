#import <Foundation/Foundation.h>
#import "NSString+PBXUniqueIdentifier.h"
#import "PBXUniqueIdentifierGenerator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        NSString *baseId = [args stringForKey:@"baseid"];
        
        if (baseId) {
            [PBXUniqueIdentifierGenerator restoreGlobalStateFromIdentifier:baseId];
        }

        NSString *newObjId = [[NSString stringWithHexadecimalRepresentationOfUniqueIdentifier] uppercaseString];
        printf("%s\n", [newObjId UTF8String]);
    }
    return EXIT_SUCCESS;
}
