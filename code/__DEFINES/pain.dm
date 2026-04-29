// ~pain levels when using the custom_pain proc and shit
#define PAIN_EMOTE_MINIMUM 10
#define PAIN_LEVEL_1 0
#define PAIN_LEVEL_2 10
#define PAIN_LEVEL_3 40
#define PAIN_LEVEL_4 70

// ~shock stages
#define SHOCK_STAGE_1 30
#define SHOCK_STAGE_2 90
#define SHOCK_STAGE_3 120
#define SHOCK_STAGE_4 180 // "Softcrit"
#define SHOCK_STAGE_5 240
#define SHOCK_STAGE_6 360 // "Hardcrit"
#define SHOCK_STAGE_7 450
#define SHOCK_STAGE_8 600
#define SHOCK_STAGE_MAX SHOCK_STAGE_8

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

/// Divisor used in several pain calculations
#define PAINKILLER_DIVISOR 4

#define PAIN_KNOCKDOWN_MESSAGE "<span class='bolddanger'>gives in to the pain!</span>"
#define PAIN_KNOCKDOWN_MESSAGE_SELF "<span class='animatedpain'>I give in to the pain!</span>"
#define PAIN_KNOCKOUT_MESSAGE "<span class='bolddanger'>caves in to the pain!</span>"
#define PAIN_KNOCKOUT_MESSAGE_SELF "<span class='animatedpain'>OH LORD! The PAIN!</span>"

/// Cooldown before resetting the injury penalty
#define SHOCK_PENALTY_COOLDOWN_DURATION 5 SECONDS
#define COOLDOWN_CARBON_ENDORPHINATION "carbon_endorphination"
/// Cooldown before our body endorphinates itself again
#define ENDORPHINATION_COOLDOWN_DURATION 2 MINUTES
