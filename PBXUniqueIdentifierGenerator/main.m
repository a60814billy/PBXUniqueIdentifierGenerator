#import <Foundation/Foundation.h>
#import "NSString+PBXUniqueIdentifier.h"
#import "PBXUniqueIdentifierGenerator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        NSString *baseId = [args stringForKey:@"baseid"];
        NSUInteger count = [args integerForKey:@"count"];
        if (count == 0) {
            count = 1;
        }
        
        if (baseId) {
            [PBXUniqueIdentifierGenerator restoreGlobalStateFromIdentifier:baseId];
        }

        for (NSUInteger i = 0; i < count; i++)
        {
            NSString *newObjId = [NSString stringWithHexadecimalRepresentationOfUniqueIdentifier];
            printf("%s\n", [newObjId cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
    return EXIT_SUCCESS;
}
