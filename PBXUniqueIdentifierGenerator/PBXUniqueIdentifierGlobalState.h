#import <Foundation/Foundation.h>

/// The structure representing the raw global state data.
typedef struct __attribute__((packed)) {
    uint8_t  userHash;
    uint8_t  pid;
    uint32_t randomValue;
    uint32_t time;
    uint16_t sequence;
    uint16_t firstSequenceForTheTime;
} CPBXUniqueIdentifierGlobalState;

@class PBXUniqueIdentifier;

/// Represents the global state used for generating unique identifiers.
///
/// This object maintains the state needed to ensure uniqueness across calls,
/// including user identity, process ID, random values, timestamps, and sequence numbers.
/// It wraps the raw `CPBXUniqueIdentifierGlobalState` structure.
@interface PBXUniqueIdentifierGlobalState : NSObject

/// The hash of the current user.
@property (nonatomic, assign, readonly) uint8_t userHash;

/// The process identifier (PID) of the current process.
@property (nonatomic, assign, readonly) uint8_t pid;

/// A random seed value (first byte always 0).
@property (nonatomic, assign, readonly) uint32_t randomValue;

/// The last recorded timestamp (seconds since reference date).
@property (nonatomic, assign, readonly) uint32_t time;

/// The current sequence number.
@property (nonatomic, assign, readonly) uint16_t sequence;

/// The first sequence number recorded for the current timestamp.
@property (nonatomic, assign, readonly) uint16_t firstSequenceForTheTime;

/// Advances the state to the next sequence/time.
///
/// This method increments the sequence and updates the timestamp if necessary.
/// @return The updated `PBXUniqueIdentifierGlobalState` instance.
- (instancetype)nextState;

/// Derives a `PBXUniqueIdentifier` from the current state.
///
/// @return A new `PBXUniqueIdentifier` instance containing the packed identifier data.
- (PBXUniqueIdentifier *)deriveIdentifier;

/// Resets the state to initial values.
///
/// Re-calculates user hash, PID, and generates new random seeds.
- (void)resetState;

/// Restores the state from an existing identifier.
///
/// Useful for continuing a sequence from a known identifier.
/// @param identifier The identifier to restore state from.
- (void)restoreFromIdentifier:(PBXUniqueIdentifier *)identifier;

@end
