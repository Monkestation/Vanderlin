GLOBAL_LIST_EMPTY(portals)					        //list of all /obj/effect/portal

GLOBAL_LIST(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used during chemical reactions
GLOBAL_LIST(chemical_reagents_list)				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_INIT(chemical_reagents_color_list, build_chemical_reagent_color_list())		//list of random colors for reagents, initiated at roundstart or when a reagent is created

GLOBAL_LIST_EMPTY(poi_list)					//list of points of interest for observe/follow
GLOBAL_LIST_EMPTY(pinpointer_list)			//list of all pinpointers. Used to change stuff they are pointing to all at once.
GLOBAL_LIST_EMPTY(zombie_infection_list) 		// A list of all zombie_infection organs, for any mass "animation"
GLOBAL_LIST_EMPTY(ladders)
GLOBAL_LIST_EMPTY(stairs)
GLOBAL_LIST_EMPTY(trophy_cases)

GLOBAL_LIST_EMPTY(mob_spawners) 		    // All mob_spawn objects

GLOBAL_LIST_INIT(distillation_recipes, setup_distillation_recipes())

/* COLORS */
/// Dull dye that should be associated with serfs
GLOBAL_LIST_INIT(peasant_dyes, list(
	"Ash Grey" = CLOTHING_ASH_GREY,
	"Berry Blue" = CLOTHING_BERRY_BLUE,
	"Canvas" = CLOTHING_CANVAS,
	"Chestnut" = CLOTHING_CHESTNUT,
	"Eggplant" = CLOTHING_EGGPLANT,
	"Linen" = CLOTHING_LINEN,
	"Mud Brown" = CLOTHING_MUD_BROWN,
	"Old Leather" = CLOTHING_OLD_LEATHER,
	"Peasant Brown" = CLOTHING_PEASANT_BROWN,
	"Pitch" = CLOTHING_PITCH,
	"Spring Green" = CLOTHING_SPRING_GREEN,
	"Soot Black" = CLOTHING_SOOT_BLACK,
	"Taraxacum Yellow" = CLOTHING_TARAXACUM_YELLOW,
	"White" = CLOTHING_WHITE,
	"Winestain Red" = CLOTHING_WINESTAIN_RED,
))
GLOBAL_PROTECT(peasant_dyes)

/// More valuable dyes that should be associated with merchants and those better off
GLOBAL_LIST_INIT(noble_dyes, list(
	"Blood Red" = CLOTHING_BLOOD_RED,
	"Dark Ink" = CLOTHING_DARK_INK,
	"Forest Green" = CLOTHING_FOREST_GREEN,
	"Mage Blue" = CLOTHING_MAGE_BLUE,
	"Mage Green" = CLOTHING_MAGE_GREEN,
	"Mage Grey" = CLOTHING_MAGE_GREY,
	"Mage Orange" = CLOTHING_MAGE_ORANGE,
	"Mage Yellow" = CLOTHING_MAGE_YELLOW,
	"Mustard Yellow" = CLOTHING_MUSTARD_YELLOW,
	"Maroon" = CLOTHING_MAROON,
	"Ocean" = CLOTHING_OCEAN,
	"Plum Purple" = CLOTHING_PLUM_PURPLE,
	"Red Ochre" =  CLOTHING_RED_OCHRE,
	"Russet" = CLOTHING_RUSSET,
	"Salmon" = CLOTHING_SALMON,
	"Scarlet" = CLOTHING_SCARLET,
	"Sky Blue" = CLOTHING_SKY_BLUE,
	"Swampweed" = CLOTHING_SWAMPWEED,
	"Violet" = CLOTHING_VIOLET,
	"Yellow Ochre" = CLOTHING_YELLOW_OCHRE,
))
GLOBAL_PROTECT(noble_dyes)

/// Most vibrant dyes that should be associated with the royal family
GLOBAL_LIST_INIT(royal_dyes, list(
	"Bog Green" = CLOTHING_BOG_GREEN,
	"Bark Brown" = CLOTHING_BARK_BROWN,
	"Chalk White" = CLOTHING_CHALK_WHITE,
	"Fyritius Orange" = CLOTHING_FYRITIUS_ORANGE,
	"Royal Black" = CLOTHING_ROYAL_BLACK,
	"Royal Majenta" = CLOTHING_ROYAL_MAJENTA,
	"Royal Purple" = CLOTHING_ROYAL_PURPLE,
	"Royal Red" = CLOTHING_ROYAL_RED,
	"Royal Teal" = CLOTHING_ROYAL_TEAL,
	"Pear Yellow" = CLOTHING_PEAR_YELLOW,
))
GLOBAL_PROTECT(royal_dyes)

GLOBAL_LIST_INIT(steam_armor, list(
	/obj/item/clothing/armor/steam,
	/obj/item/clothing/gloves/plate/steam,
	/obj/item/clothing/head/helmet/heavy/steam,
	/obj/item/clothing/shoes/boots/armor/steam,
	/obj/item/clothing/cloak/boiler,
))
