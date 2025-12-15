#define MAX_PLANT_HEALTH 100
#define MAX_PLANT_WATER 150
#define MAX_PLANT_NITROGEN 200  // N - for leafy growth
#define MAX_PLANT_PHOSPHORUS 200 // P - for root/flower development
#define MAX_PLANT_POTASSIUM 200  // K - for overall plant health
#define MAX_PLANT_WEEDS 100

#define WEED_NITROGEN_CONSUMPTION_RATE 5
#define WEED_PHOSPHORUS_CONSUMPTION_RATE 3
#define WEED_POTASSIUM_CONSUMPTION_RATE 4
#define NUTRIENT_DEFICIENCY_DAMAGE_RATE 0.04

// Plant growth timing constants
#define DEFAULT_GROW_TIME 6 MINUTES
#define FAST_GROWING 5 MINUTES
#define VERY_FAST_GROWING 4 MINUTES

#define SLOW_PRODUCE_TIME 4 MINUTES
#define DEFAULT_PRODUCE_TIME 3 MINUTES
#define FAST_PRODUCE_TIME 2 MINUTES

// Genetic trait definitions
#define TRAIT_YIELD 1
#define TRAIT_DISEASE_RESISTANCE 2
#define TRAIT_QUALITY 3
#define TRAIT_GROWTH_SPEED 4
#define TRAIT_WATER_EFFICIENCY 5
#define TRAIT_COLD_RESISTANCE 6

// Trait grades (higher is better)
#define TRAIT_GRADE_POOR 20
#define TRAIT_GRADE_AVERAGE 50
#define TRAIT_GRADE_GOOD 80
#define TRAIT_GRADE_EXCELLENT 110

// Mutation chances
#define BASE_MUTATION_CHANCE 1  // 1% base chance
#define STRESS_MUTATION_MULTIPLIER 3  // Stress increases mutations

// Plant family compatibility groups
#define FAMILY_BRASSICA 1      // Cabbage family
#define FAMILY_ALLIUM 2        // Onion family
#define FAMILY_GRAIN 3         // Wheat, oat
#define FAMILY_SOLANACEAE 4    // Nightshade family
#define FAMILY_ROSACEAE 5      // Rose family (apple, pear, berries)
#define FAMILY_RUTACEAE 6      // Citrus family
#define FAMILY_ASTERACEAE 7    // Sunflower family
#define FAMILY_HERB 8          // Alchemical herbs
#define FAMILY_ROOT 9          // Root vegetables
#define FAMILY_RUBIACEAE  10   // Coffee
#define FAMILY_THEACEAE  11    // Tea
#define FAMILY_FRUIT  12       // Tropical Fruits
#define FAMILY_DIKARYA 13      // Mushrooms
