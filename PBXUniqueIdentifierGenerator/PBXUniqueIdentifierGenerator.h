#import <Foundation/Foundation.h>

uint32_t UserHash(void);

typedef struct __attribute__((packed)) {
    uint8_t  userHash;
    uint8_t  pid;
    uint32_t randomValue;
    uint32_t time;
    uint16_t sequence;
    uint16_t firstSequenceForTheTime;
} PBXUniqueIdentifierGeneratorGlobalState;

typedef struct __attribute__((packed)) {
    uint8_t  userHash;
    uint8_t  pid;
    uint16_t sequence;
    uint32_t time;
    uint32_t random;
} PBXUniqueIdentifier;

@interface PBXUniqueIdentifierGenerator : NSObject

+ (PBXUniqueIdentifier)nextIdentifier;

@end
