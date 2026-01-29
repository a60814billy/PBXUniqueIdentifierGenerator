#import "PBXUniqueIdentifierGenerator.h"
#import "PBXUniqueIdentifierGlobalState.h"
#import "PBXUniqueIdentifier.h"

@implementation PBXUniqueIdentifierGenerator
+ (PBXUniqueIdentifierGlobalState *) globalState
{
    static PBXUniqueIdentifierGlobalState *state = nil;
    
    if (state == nil) {
        state = [[PBXUniqueIdentifierGlobalState alloc] init];
    }
    
    return state;
}

+ (PBXUniqueIdentifierGlobalState *) nextGlobalState
{
    [[self globalState] nextState];
    return [self globalState];
}

+ (PBXUniqueIdentifier *)nextIdentifier
{
    return [[self nextGlobalState] deriveIdentifier];
}

+ (void)restoreGlobalStateFromIdentifier:(NSString *)identifier
{
    PBXUniqueIdentifier *pbxId = [[PBXUniqueIdentifier alloc] initWithStringRepresentation:identifier];
    
    [[self globalState] restoreFromIdentifier:pbxId];
}

+ (void)resetGlobalState
{
    [[self globalState] resetState];
}

@end
