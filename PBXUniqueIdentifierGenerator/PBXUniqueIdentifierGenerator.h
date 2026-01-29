#import <Foundation/Foundation.h>

@class PBXUniqueIdentifier;
@class PBXUniqueIdentifierGlobalState;

/// A static generator class for creating Xcode-compatible unique identifiers (PBXObjectIDs).
///
/// `PBXUniqueIdentifierGenerator` manages the global state and orchestration required to produce
/// unique identifiers similar to those used by Xcode for objects in `project.pbxproj` files.
/// These identifiers are 96-bit (12-byte) values constructed from user info, process info,
/// timestamps, sequences, and randomness.
///
/// ## Related Articles
/// - <doc:PBXObject_Unique_Identifier_Generation_Algorithm>
@interface PBXUniqueIdentifierGenerator : NSObject

/// Generates the next unique identifier.
///
/// This method accesses the shared global state, updates it (incrementing sequence, updating time),
/// and returns a new identifier based on that state. It is thread-safe.
///
/// @return A `PBXUniqueIdentifier` object containing the generated identifier components.
+ (PBXUniqueIdentifier *)nextIdentifier;

/// Restores the global state from a given identifier string.
///
/// This method parses the provided 24-character hexadecimal identifier string
/// and updates the internal global state to match the values found in the identifier.
/// The next generated identifier will continue from this restored state, which is useful
/// for maintaining sequence continuity or debugging.
///
/// @param identifier A 24-character hexadecimal string representing a PBXUniqueIdentifier.
+ (void)restoreGlobalStateFromIdentifier:(NSString *)identifier;

/// Resets the global state to a new random configuration.
///
/// This method re-initializes the global state with the current user hash, process ID,
/// and generates new random values for the sequence and random seed.
+ (void)resetGlobalState;

@end
