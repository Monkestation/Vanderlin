// ~pain levels when using the custom_pain proc and shit
#define PAIN_EMOTE_MINIMUM 10

// ~shock stages
#define SHOCK_STAGE_1 20
#define SHOCK_STAGE_2 40
#define SHOCK_STAGE_3 50
#define SHOCK_STAGE_4 70 // "Softcrit"
#define SHOCK_STAGE_5 90
#define SHOCK_STAGE_6 130 // "Hardcrit"
#define SHOCK_STAGE_7 160
#define SHOCK_STAGE_8 210
#define SHOCK_STAGE_MAX SHOCK_STAGE_8

// ~shock modifiers
#define SHOCK_MOD_BRUTE 0.5
#define SHOCK_MOD_BURN 0.75
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
#define PAINKILLER_DIVISOR 1.75

/// Use this to keep the speed of pain-related systems consistent relatively
#define PAIN_SYSTEM_SPEED_MODIFIER 3

#define PAIN_KNOCKDOWN_MESSAGE "<span class='bolddanger'>gives in to the pain!</span>"
#define PAIN_KNOCKDOWN_MESSAGE_SELF "<span class='animatedpain'>I give in to the pain!</span>"
#define PAIN_KNOCKOUT_MESSAGE "<span class='bolddanger'>caves in to the pain!</span>"
#define PAIN_KNOCKOUT_MESSAGE_SELF "<span class='animatedpain'>OH LORD! The PAIN!</span>"

/// Cooldown before resetting the injury penalty
#define SHOCK_PENALTY_COOLDOWN_DURATION 5 SECONDS
#define COOLDOWN_CARBON_ENDORPHINATION "carbon_endorphination"
/// Cooldown before our body endorphinates itself again
#define ENDORPHINATION_COOLDOWN_DURATION 60 SECONDS
