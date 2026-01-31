// Storage defines

// Storage collection defines
#define COLLECT_ONE 0
#define COLLECT_EVERYTHING 1
#define COLLECT_SAME 2

// Drop style defines
#define DROP_NOTHING 0
#define DROP_AT_PARENT 1
#define DROP_AT_LOCATION 2

// Defines for fancy boxes (ie. boxes that display how many items there are
// inside of them)
#define FANCY_CONTAINER_CLOSED 0
#define FANCY_CONTAINER_OPEN 1
#define FANCY_CONTAINER_ALWAYS_OPEN 2

// Defines for levels of storage locking
// Also used fort the force param of can_insert
// Higher values are "more" locked then lower ones
#define STORAGE_NOT_LOCKED 0
#define STORAGE_SOFT_LOCKED 1
#define STORAGE_FULLY_LOCKED 2

// Access flags
/// Must be in the user's hands to be accessed
#define STORAGE_ACCESS_INHANDS (1<<0)
/// Must be out of the user to be accessed
#define STORAGE_ACCESS_NOT_WORN (1<<1)

// Closure flags
/// Close on any movement [mob/living/move()]
#define STORAGE_CLOSE_MOVEMENT (1<<0)
/// Close on movement when not inhand. ITEMS ONLY.
#define STORAGE_CLOSE_MOVEMENT_WORN (1<<1)
