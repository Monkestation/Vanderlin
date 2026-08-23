#define ENCUMBRANCE_NONE 0
#define ENCUMBRANCE_LIGHT 1
#define ENCUMBRANCE_MEDIUM 2
#define ENCUMBRANCE_HEAVY 3
#define ENCUMBRANCE_EXTREME 4

#define GRAMS * 0.001
#define KILOGRAMS * 1

/// Weight of an average human in kgs
#define HUMAN_WEIGHT 60
/// Weight required for someone to fall in water
#define DROWNING_WEIGHT HUMAN_WEIGHT * 2

#define FALL_DAMAGE_SCALE 0.1

// you could say i'm sonewhat of a sigmoid myself. tier = 0 => 0.00252. tier = 4 => 0.982
#define ENCUMBRANCE_TO_SIGMOID(tier) (1 / (1 + (2.71 ** -(((tier / 4.0) - 0.6)) * 10)))
