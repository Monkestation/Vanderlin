
// Used in living mob offset list for determining pixel offsets
#define PIXEL_W_OFFSET "w"
#define PIXEL_X_OFFSET "x"
#define PIXEL_Y_OFFSET "y"
#define PIXEL_Z_OFFSET "z"

// Bleed check results
/// We cannot bleed (here, or in general) at all
#define BLEED_NONE 0
/// We cannot make a splatter, but we can add our DNA
#define BLEED_ADD_DNA 1
/// We can bleed just fine
#define BLEED_SPLATTER 2

/// Checks if the mob can have blood
#define CAN_HAVE_BLOOD(mob) (mob?.living_flags & LIVING_CAN_HAVE_BLOOD)
/// Queues a blood update for the next life tick for the mob
#define QUEUE_BLOOD_UPDATE(mob) mob.living_flags |= BLOOD_UPDATE_QUEUED
