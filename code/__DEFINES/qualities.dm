// For recipe and crafting quality defines

#define BLACKSMITH_QUALITY_SPOILED -8  // Spoil bars and crude smithing skill
#define BLACKSMITH_QUALITY_AWFUL -5  // Shit bars and crude skill
#define BLACKSMITH_QUALITY_CRUDE -2
#define BLACKSMITH_QUALITY_ROUGH -1
#define BLACKSMITH_QUALITY_COMPETENT 0
#define BLACKSMITH_QUALITY_FINE 2
#define BLACKSMITH_QUALITY_FLAWLESS 5
#define BLACKSMITH_QUALITY_LEGENDARY 8

#define MINIMUM_ANVIL_MINIGAME_SCORE 15

//Smelting quality results
#define SMELTERY_QUALITY_SPOIL 1
#define SMELTERY_QUALITY_POOR 2
#define SMELTERY_QUALITY_NORMAL 3
#define SMELTERY_QUALITY_GOOD 4
#define SMELTERY_QUALITY_GREAT 5
#define SMELTERY_QUALITY_EXCELLENT 6

#define SMELTING_DENOMINATOR 22

//Food and reagent qualities for cooking
#define COOK_QUALITY_NORMAL 1
#define COOK_QUALITY_NICE 2
#define COOK_QUALITY_GOOD 3
#define COOK_QUALITY_VERYGOOD 4

/// Labels for food quality
GLOBAL_ALIST_INIT(food_quality_description, alist(
	COOK_QUALITY_NORMAL = "okay",
	COOK_QUALITY_NICE = "nice",
	COOK_QUALITY_GOOD = "good",
	COOK_QUALITY_VERYGOOD = "very good",
))

// Stardew Valley-style qualities
#define CROP_QUALITY_REGULAR 1
#define CROP_QUALITY_SILVER 2
#define CROP_QUALITY_GOLD 3
#define CROP_QUALITY_DIAMOND 4
