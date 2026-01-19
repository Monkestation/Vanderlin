
///Whether a mob is a werewolf. Returns the werewolf antag datum if found.
#define IS_WEREWOLF(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/werewolf))

// Rage thresholds for /datum/rage/werewolf
#define WW_RAGE_LOW "25"
#define WW_RAGE_MEDIUM "50"
#define WW_RAGE_HIGH "75"
#define WW_RAGE_CRITICAL "100"
