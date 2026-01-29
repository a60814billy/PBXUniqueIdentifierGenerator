# PBXUniqueIdentifierGenerator - Xcode PBXProject Identifier Generator
This project is an Objective-C implementation of the object identifier generation logic used in Xcode's `.pbxproj` files. It allows developers to generate 96-bit (24-character hex) unique identifiers that are fully compatible with Xcode's internal format.

## Inspiration & Attribution

This project is based on the research and reverse-engineering of Xcode's `DevToolsSupport.framework` and `DevToolCore.framework`. Special thanks to the detailed analysis in the blog post [PBXProj Identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html).

## Features

- **Xcode Compatibility**: Generates 24-character hexadecimal identifiers consistent with Xcode's algorithm.
- **State Restoration**: Ability to restore the generator's state from an existing identifier, useful for continuing sequences.

## Architecture

The project is structured into three main components:

1.  **`PBXUniqueIdentifierGenerator`**: The main public interface. It manages the singleton global state and exposes methods to generate new IDs or reset state.
2.  **`PBXUniqueIdentifierGlobalState`**: Encapsulates the state required for generation (User Hash, PID, Timestamp, Sequence, Random Seed). It handles the logic for incrementing sequences and handling time updates.
3.  **`PBXUniqueIdentifier`**: An object representation of the 96-bit identifier, allowing easy access to its components (User Hash, PID, Sequence, Time, Random) and conversion to/from string format.

## Usage

### Generating an Identifier

```objective-c
#import "PBXUniqueIdentifierGenerator.h"

PBXUniqueIdentifier *identifier = [PBXUniqueIdentifierGenerator nextIdentifier];
NSString *hexString = [identifier stringRepresentation];
NSLog(@"Generated ID: %@", hexString);
```

### Using the String Category

For convenience, a category on `NSString` is provided:

```objective-c
#import "NSString+PBXUniqueIdentifier.h"

NSString *newId = [NSString stringWithHexadecimalRepresentationOfUniqueIdentifier];
```

### Restoring State

If you need to generate a sequence of IDs starting after a known ID:

```objective-c
[PBXUniqueIdentifierGenerator restoreGlobalStateFromIdentifier:@"96C33B1234567890ABCDEF12"];
```

## Algorithm Details

The identifier is composed of:
- **User Hash (8 bits)**: Derived from the system user name.
- **PID (8 bits)**: The current process ID.
- **Sequence (16 bits)**: A rolling counter.
- **Timestamp (32 bits)**: Seconds since the Reference Date.
- **Random (32 bits)**: A session-unique random value.

For a detailed explanation of the algorithm, see [PBXObject_Unique_Identifier_Generation_Algorithm.md](PBXUniqueIdentifierGenerator/PBXUniqueIDentifierGenerator.docc/PBXObject_Unique_Identifier_Generation_Algorithm.md).

## License

See [LICENSE.txt](LICENSE.txt) for more information.
