////////////////Area flags\\\\\\\\\\\\\\
/// If it's a valid territory for cult summoning or the CRAB-17 phone to spawn
#define VALID_TERRITORY (1 << 0)
/// If mining tunnel generation is allowed in this area
#define TUNNELS_ALLOWED (1 << 1)
/// If flora are allowed to spawn in this area randomly through tunnel generation
#define FLORA_ALLOWED (1 << 2)
/// If mobs can be spawned by natural random generation
#define MOB_SPAWN_ALLOWED (1 << 3)
/// Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
#define NO_TELEPORT (1 << 4)
/// Hides area from player Teleport function.
#define HIDDEN_AREA (1 << 5)
/// If false, loading multiple maps with this area type will create multiple instances.
#define UNIQUE_AREA (1 << 6)
/// Whether or not this area falls as "bog territory, a cheaper alternative to a bunch of typechecks."
#define BOGGY_AREA (1 << 7)
