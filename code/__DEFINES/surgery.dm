#define ORGAN_ORGANIC 1
#define ORGAN_ROBOTIC 2

#define BODYPART_ORGANIC 1
#define BODYPART_ROBOTIC 2

// Flags for surgery_flags on surgery datums
///Will allow the surgery to bypass clothes
#define SURGERY_IGNORE_CLOTHES (1<<0)
///Will allow the surgery to be performed by the user on themselves.
#define SURGERY_SELF_OPERABLE (1<<1)
///Will allow the surgery to work on mobs that aren't lying down.
#define SURGERY_REQUIRE_RESTING (1<<2)
///Will allow the surgery to work only if there's a limb.
#define SURGERY_REQUIRE_LIMB (1<<3)
///Will allow the surgery to work only if there's a real (eg. not pseudopart) limb.
#define SURGERY_REQUIRES_REAL_LIMB (1<<4)
/**
 * Instead of checking if the tool used is an actual surgery tool to avoid accidentally whacking patients with the wrong tool,
 * it'll check if it has a defined tool behaviour instead. Useful for surgeries that use mechanical tools instead of medical ones,
 * like hardware manipulation.
 */
#define SURGERY_CHECK_TOOL_BEHAVIOUR (1<<5)

///Return true if target is not in a valid body position for the surgery
#define IS_IN_INVALID_SURGICAL_POSITION(target, surgery) ((surgery.surgery_flags & SURGERY_REQUIRE_RESTING) && (target.mobility_flags & MOBILITY_LIEDOWN && target.body_position != LYING_DOWN))
