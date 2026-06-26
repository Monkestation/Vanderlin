// ~pain levels when using the custom_pain proc and shit
#define PAIN_EMOTE_MINIMUM 10
#define PAIN_MESSAGE_COOLDOWN 40 SECONDS
#define PAIN_EMOTE_COOLDOWN 60 SECONDS

// ~shock stages
#define SHOCK_STAGE_1 20
#define SHOCK_STAGE_2 40
#define SHOCK_STAGE_3 60
#define SHOCK_STAGE_4 80 // "Softcrit"
#define SHOCK_STAGE_5 95
#define SHOCK_STAGE_6 110
#define SHOCK_STAGE_7 130 // "Hardcrit"
#define SHOCK_STAGE_8 200
#define SHOCK_STAGE_MAX SHOCK_STAGE_8

// ~shock modifiers
#define SHOCK_MOD_BRUTE 0.6
#define SHOCK_MOD_BURN 0.8
#define SHOCK_MOD_TOXIN 1
#define SHOCK_MOD_CLONE 1.2

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
#define PAINKILLER_DIVISOR 1.5

/// Use this to keep the speed of pain-related systems consistent across the board
#define PAIN_SYSTEM_SPEED_MODIFIER 10

/// Cooldown before resetting the injury penalty
#define SHOCK_PENALTY_COOLDOWN_DURATION 5 SECONDS
#define COOLDOWN_CARBON_ENDORPHINATION "carbon_endorphination"
/// Cooldown before our body endorphinates itself again
#define ENDORPHINATION_COOLDOWN_DURATION 60 SECONDS
