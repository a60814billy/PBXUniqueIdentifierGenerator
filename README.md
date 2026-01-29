# PBXUniqueIdentifierGenerator - Xcode PBXProject Identifier Generator

This project is an Objective-C implementation of the object identifier generation logic used in Xcode's `.pbxproj` files.

## Inspiration & Attribution

This project was inspired by the detailed analysis in the blog post [PBXProj Identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html).

## Implementation Details

The core logic of this generator is derived from reverse-engineering the `DevToolsSupport.framework` and `DevToolCore.framework` found in **Xcode 26.2.0**. It faithfully recreates the identifier generation process using native Objective-C.

> **Note**: In the original implementation, the random seed was derived from `hostid` and the current time. In this implementation, we use `arc4random()` directly for better randomness and simplicity.

## Features

- Generates 24 hex characters identifiers consistent with Xcode's internal algorithm.
- Implemented in pure Objective-C.

## Disclaimer

This project is for research purposes only. There is no guarantee whether the generation logic for older or newer versions of Xcode differs.

## License

See [LICENSE.txt](LICENSE.txt) for more information.
