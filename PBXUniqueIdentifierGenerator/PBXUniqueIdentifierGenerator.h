#import <Foundation/Foundation.h>

/// Calculates a hash based on the current user's name.
///
/// This function computes a 32-bit hash value derived from the current user's login name.
/// It uses a specific packing table to map characters to values before hashing.
///
/// @return A 32-bit unsigned integer representing the user hash.
uint32_t UserHash(void);

/// Represents the global state used for generating unique identifiers.
///
/// This structure maintains the state needed to ensure uniqueness across calls,
/// including user identity, process ID, random values, timestamps, and sequence numbers.
typedef struct __attribute__((packed)) {
    /// The hash of the current user.
    uint8_t  userHash;
    /// The process identifier (PID) of the current process.
    uint8_t  pid;
    /// A random seed value.
    uint32_t randomValue;
    /// The last recorded timestamp.
    uint32_t time;
    /// The current sequence number.
    uint16_t sequence;
    /// The first sequence number recorded for the current timestamp.
    uint16_t firstSequenceForTheTime;
} PBXUniqueIdentifierGeneratorGlobalState;

/// Represents a generated PBX unique identifier structure.
///
/// This structure holds the components that make up the unique identifier used in Xcode project files.
/// It is packed to match the binary layout of the identifier.
typedef struct __attribute__((packed)) {
    /// The hash of the user who generated the identifier.
    uint8_t  userHash;
    /// The process identifier (PID) where the identifier was generated.
    uint8_t  pid;
    /// The sequence number of the identifier.
    uint16_t sequence;
    /// The timestamp when the identifier was generated.
    uint32_t time;
    /// A random value to ensure uniqueness.
    uint32_t random;
} PBXUniqueIdentifier;

/// A generator for creating Xcode-compatible unique identifiers (PBXObjectIDs).
///
/// `PBXUniqueIdentifierGenerator` produces unique identifiers similar to those used by Xcode
/// for objects in `project.pbxproj` files. These identifiers are 96-bit (12-byte) values
/// constructed from user info, process info, timestamps, sequences, and randomness.
///
/// ## Related Articles
/// - <doc:PBXObject_Unique_Identifier_Generation_Algorithm>
@interface PBXUniqueIdentifierGenerator : NSObject

/// Generates the next unique identifier.
///
/// This method updates the internal global state and returns a new `PBXUniqueIdentifier`.
/// It ensures that subsequent calls produce different identifiers by incrementing the sequence
/// and updating the timestamp if necessary.
///
/// @return A `PBXUniqueIdentifier` struct containing the generated identifier components.
+ (PBXUniqueIdentifier)nextIdentifier;

@end
