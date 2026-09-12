// ~pain levels when using the custom_pain proc and shit
#define PAIN_EMOTE_MINIMUM 10
#define PAIN_MESSAGE_COOLDOWN 40 SECONDS
#define PAIN_EMOTE_COOLDOWN 60 SECONDS

// ~shock stages
#define SHOCK_STAGE_1 10
#define SHOCK_STAGE_2 30
#define SHOCK_STAGE_3 40
#define SHOCK_STAGE_4 60 // "Softcrit"
#define SHOCK_STAGE_5 80
#define SHOCK_STAGE_6 120 // "Hardcrit"
#define SHOCK_STAGE_7 150
#define SHOCK_STAGE_8 200
#define SHOCK_STAGE_MAX SHOCK_STAGE_8

#define SHOCK_STAGE_HYSTERESIS 5
/// Weight decay per rank when stacking limb pain into shock (0.5 = each subsequent limb counts half as much as the last)
#define SHOCK_STACK_DECAY 0.7
/// Weight used with no stack limbs
#define SHOCK_USELESS_DECAY 0.3
/// How many limbs we bother weighting before the tail becomes negligible (6 covers arms/legs/chest/head)
#define SHOCK_STACK_MAX_LIMBS 6

// ~shock modifiers
#define SHOCK_MOD_BRUTE 0.7
#define SHOCK_MOD_BURN 0.8
#define SHOCK_MOD_TOXIN 1
#define SHOCK_MOD_CLONE 1.25

#define SHOCK_PENALTY_CAP 4

/// Above or equal this pain, affect DX and stuff intermittently
#define PAIN_SHOCK_PENALTY 50
/// Above or equal this pain, we cannot sleep intentionally
#define PAIN_NO_SLEEP 70
/// Above or equal this pain, we halve move and dodge
#define PAIN_HALVE_MOVE 130
/// Above or equal this pain, we give in
#define PAIN_GIVES_IN 200
/// Above or equal to this amount of pain, we can only speak in whispers
#define PAIN_NO_SPEAK 250

/// Divisor used in pain calculations, since carbon pain is a flat amount and spread across bodyparts
#define PAINKILLER_DIVISOR 3

/// Use this to keep the speed of pain-related systems consistent across the board
#define PAIN_SYSTEM_SPEED_MODIFIER 2

/// Recovery moves shock_stage toward traumatic_shock this much slower than growth does, at baseline endurance
#define SHOCK_RECOVERY_COEFF 0.4

/// Cooldown before resetting the injury penalty
#define SHOCK_PENALTY_COOLDOWN_DURATION 5 SECONDS
#define COOLDOWN_CARBON_ENDORPHINATION "carbon_endorphination"
/// Cooldown before our body endorphinates itself again
#define ENDORPHINATION_COOLDOWN_DURATION 60 SECONDS
