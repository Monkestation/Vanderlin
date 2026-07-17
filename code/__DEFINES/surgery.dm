#define ORGAN_ORGANIC 1
#define ORGAN_ROBOTIC 2

#define BODYPART_ORGANIC 1
#define BODYPART_ROBOTIC 2

/// Checks if the mob is lying down if they can lie down, otherwise always passes
#define IS_LYING_OR_CANNOT_LIE(mob) ((mob.mobility_flags & MOBILITY_LIEDOWN) ? (mob.body_position == LYING_DOWN) : TRUE)

/// Notable operations are specially logged and also leave memories
#define OPERATION_NOTABLE (1<<0)
/// Operation will automatically repeat until it can no longer be performed
#define OPERATION_LOOPING (1<<1)
/// Not innately available to doctors, must be added via COMSIG_MOB_ATTEMPT_SURGERY to show up
#define OPERATION_LOCKED (1<<2)
/// A surgeon cannot perform this operation on themselves
#define OPERATION_NOT_SELF_OPERABLE (1<<3)
/// Operation can be performed on standing patients - note: mobs that cannot lie down are *always* considered lying down for surgery
#define OPERATION_STANDING_ALLOWED (1<<4)
/// Some traits may cause operations to be infalliable - this flag disables that behavior, always allowing it to be failed
#define OPERATION_ALWAYS_FAILABLE (1<<5)
/// If set, the operation will ignore clothing when checking for access to the target body part.
#define OPERATION_IGNORE_CLOTHES (1<<6)
/// Operation is a mechanic / robotic surgery
#define OPERATION_MECHANIC (1<<7)

DEFINE_BITFIELD(operation_flags, list(
	"NOTABLE" = OPERATION_NOTABLE,
	"LOOPING" = OPERATION_LOOPING,
	"LOCKED" = OPERATION_LOCKED,
	"NOT SELF OPERABLE" = OPERATION_NOT_SELF_OPERABLE,
	"STANDING ALLOWED" = OPERATION_STANDING_ALLOWED,
	"ALWAYS FAILABLE" = OPERATION_ALWAYS_FAILABLE,
	"IGNORE CLOTHES" = OPERATION_IGNORE_CLOTHES,
	"MECHANIC" = OPERATION_MECHANIC,
))

/// All of these equipment slots are ignored when checking for clothing coverage during surgery
#define IGNORED_OPERATION_CLOTHING_SLOTS (ITEM_SLOT_NECK)

// Surgery related mood defines
#define SURGERY_STATE_STARTED "surgery_started"
#define SURGERY_STATE_FAILURE "surgery_failed"
#define SURGERY_STATE_SUCCESS "surgery_success"
#define SURGERY_MOOD_CATEGORY "surgery"

/// Dummy "tool" for surgeries which use hands
#define IMPLEMENT_HAND "hands"

// Operation argument indexes
/// Total speed/failure modifier applied to the operation
#define OPERATION_SPEED "speed_modifier"
/// The action being performed, simply "default" for 95% of surgeries
#define OPERATION_ACTION "action"
/// Whether the operation should automatically fail
#define OPERATION_FORCE_FAIL "force_fail"
/// The body zone being targeted by the operation
#define OPERATION_TARGET_ZONE "target_zone"
/// The specific target of the operation, usually a bodypart or organ, generally redundant
#define OPERATION_TARGET "target"
// For tend wounds - only reason these aren't local is we use them in unit testing
#define OPERATION_BRUTE_HEAL "brute_heal"
#define OPERATION_BURN_HEAL "burn_heal"
#define OPERATION_BRUTE_MULTIPLIER "brute_multiplier"
#define OPERATION_BURN_MULTIPLIER "burn_multiplier"
