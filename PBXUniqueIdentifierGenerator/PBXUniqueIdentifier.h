#import <Foundation/Foundation.h>

/// The raw structure representing the packed PBX unique identifier.
typedef struct __attribute__((packed)) {
    uint8_t  userHash;
    uint8_t  pid;
    uint16_t sequence;
    uint32_t time;
    uint32_t random;
} CPBXUniqueIdentifier;

/// Represents a generated PBX unique identifier structure.
///
/// This class acts as a wrapper around the `CPBXUniqueIdentifier` C structure.
/// It provides an object-oriented interface to access the individual components
/// of the 96-bit identifier used in Xcode project files.
@interface PBXUniqueIdentifier : NSObject

/// The hash of the user who generated the identifier (8 bits).
@property (nonatomic, assign) uint8_t userHash;

/// The process identifier (PID) where the identifier was generated (8 bits).
@property (nonatomic, assign) uint8_t pid;

/// The sequence number of the identifier (16 bits).
@property (nonatomic, assign) uint16_t sequence;

/// The timestamp when the identifier was generated (32 bits).
@property (nonatomic, assign) uint32_t time;

/// A random value to ensure uniqueness (32 bits, but effectively 24 bits).
/// The first byte is always 0.
@property (nonatomic, assign) uint32_t random;

/// Initializes a new instance from a hexadecimal string.
///
/// @param identifier A 24-character hexadecimal string.
/// @return A configured `PBXUniqueIdentifier` instance.
- (instancetype) initWithStringRepresentation:(NSString *)identifier;

/// Returns the raw bytes of the identifier.
///
/// @return A pointer to the underlying byte array of the identifier.
- (const uint8_t*) bytes;

/// Returns the hexadecimal string representation of the identifier.
///
/// @return A 24-character uppercase hexadecimal string.
- (NSString *)stringRepresentation;

@end
