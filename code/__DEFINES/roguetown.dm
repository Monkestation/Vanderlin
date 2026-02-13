#define ALL_TEMPLE_PATRONS 		list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora)
#define ALL_CLERIC_PATRONS 		list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora)
#define ALL_PALADIN_PATRONS 	list(/datum/patron/psydon, /datum/patron/psydon/extremist, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora)
#define ALL_TEMPLAR_PATRONS 	list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/eora, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/pestra, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/malum, /datum/patron/divine/xylix)
#define ALL_PROFANE_PATRONS 	list(/datum/patron/inhumen/graggar, /datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
#define ALL_ICONOCLAST_PATRONS  list(/datum/patron/psydon, /datum/patron/psydon/extremist, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/inhumen/graggar, /datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)

/// Currently same as ALL_ICONOCLAST_PATRONS, but in text format because byond sucks and won't read things properly.
#define COLORFUL_PATRONS		list("Psydon", "Astrata", "Noc", "Dendor", "Abyssor", "Necra", "Ravox", "Xylix", "Pestra", "Malum", "Eora", "Graggar", "Zizo", "Matthios", "Baotha")

GLOBAL_LIST_INIT(curse_names, list())

#define TEN_CURSES list(\
	/datum/curse/astrata,\
	/datum/curse/noc,\
	/datum/curse/ravox,\
	/datum/curse/necra,\
	/datum/curse/xylix,\
	/datum/curse/pestra,\
	/datum/curse/eora\
)

#define INHUMEN_CURSES list(\
	/datum/curse/zizo,\
	/datum/curse/zizo/minor,\
	/datum/curse/graggar,\
	/datum/curse/matthios,\
	/datum/curse/baotha\
)
#define SPECIAL_CURSES list(\
	/datum/curse/atheism\
)
#define ALL_CURSES list(\
	SPECIAL_CURSES,\
	TEN_CURSES,\
	INHUMEN_CURSES\
)

#define PLATEHIT "plate"
#define CHAINHIT "chain"
#define SOFTHIT "soft"
#define SOFTUNDERHIT "softunder"

/proc/get_armor_sound(blocksound, blade_dulling)
	switch(blocksound)
		if(PLATEHIT)
			if(blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/plate_slashed (1).ogg','sound/combat/hits/armor/plate_slashed (2).ogg','sound/combat/hits/armor/plate_slashed (3).ogg','sound/combat/hits/armor/plate_slashed (4).ogg')
			if(blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_BITE)
				return pick('sound/combat/hits/armor/plate_stabbed (1).ogg','sound/combat/hits/armor/plate_stabbed (2).ogg','sound/combat/hits/armor/plate_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/plate_blunt (1).ogg','sound/combat/hits/armor/plate_blunt (2).ogg','sound/combat/hits/armor/plate_blunt (3).ogg')
		if(CHAINHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/chain_slashed (1).ogg','sound/combat/hits/armor/chain_slashed (2).ogg','sound/combat/hits/armor/chain_slashed (3).ogg','sound/combat/hits/armor/chain_slashed (4).ogg')
			else
				return pick('sound/combat/hits/armor/chain_blunt (1).ogg','sound/combat/hits/armor/chain_blunt (2).ogg','sound/combat/hits/armor/chain_blunt (3).ogg')
		if(SOFTHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/light_stabbed (1).ogg','sound/combat/hits/armor/light_stabbed (2).ogg','sound/combat/hits/armor/light_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/light_blunt (1).ogg','sound/combat/hits/armor/light_blunt (2).ogg','sound/combat/hits/armor/light_blunt (3).ogg')
		if(SOFTUNDERHIT)
			if(blade_dulling == BCLASS_BITE||blade_dulling == BCLASS_STAB||blade_dulling == BCLASS_PICK||blade_dulling == BCLASS_CUT||blade_dulling == BCLASS_CHOP)
				return pick('sound/combat/hits/armor/light_stabbed (1).ogg','sound/combat/hits/armor/light_stabbed (2).ogg','sound/combat/hits/armor/light_stabbed (3).ogg')
			else
				return pick('sound/combat/hits/armor/light_blunt (1).ogg','sound/combat/hits/armor/light_blunt (2).ogg','sound/combat/hits/armor/light_blunt (3).ogg')

GLOBAL_LIST_EMPTY(confessors)
GLOBAL_LIST_EMPTY(indexed)
GLOBAL_LIST_EMPTY(cursedsamples)
GLOBAL_LIST_EMPTY(accused)

//preference stuff
#define FAMILY_NONE "None"
#define FAMILY_PARTIAL "Siblings"
#define FAMILY_NEWLYWED "Newlywed"
#define FAMILY_FULL "Parent"

#define ANY_GENDER "Any gender"
#define SAME_GENDER "Same gender"
#define DIFFERENT_GENDER "Different gender"

#define FAMILY_FATHER "Father"
#define FAMILY_MOTHER "Mother"
#define FAMILY_PROGENY "Progeny"
#define FAMILY_ADOPTED "Adoptive Progeny"
#define FAMILY_OMMER "Parents Sibling"
#define FAMILY_INLAW "In Law"

GLOBAL_LIST_EMPTY(job_respawn_delays)

//stress levels. Stress starts at 0.
#define STRESS_INSANE 7
#define STRESS_VBAD 5
#define STRESS_BAD 3
#define STRESS_NEUTRAL 2
#define STRESS_GOOD 1
#define STRESS_VGOOD -4

/*	........   Nutrition defines   ................ */
#define MEAL_FILLING 30
#define MEAL_GOOD 24
#define MEAL_AVERAGE 18
#define MEAL_MEAGRE 15
#define SNACK_CHUNKY 12
#define SNACK_NUTRITIOUS 9
#define SNACK_DECENT 6
#define SNACK_POOR 3


#define MEATPIE_NUTRITION (MINCE_NUTRITION * 3) + BUTTERDOUGH_NUTRITION
#define FRUITPIE_NUTRITION (SNACK_POOR * 3) + BUTTERDOUGH_NUTRITION
#define BREADSLICE_NUTRITION SNACK_POOR
#define DOUGH_NUTRITION BREADSLICE_NUTRITION * 6
#define SMALLDOUGH_NUTRITION (MEAL_MEAGRE / 2)
#define BUTTERDOUGH_NUTRITION DOUGH_NUTRITION + BUTTER_NUTRITION
#define BUTTERDOUGHSLICE_NUTRITION (BUTTERDOUGH_NUTRITION / 2)
#define BUTTER_NUTRITION SNACK_POOR
#define RAWMEAT_NUTRITION SNACK_DECENT
#define COOKED_MEAT_NUTRITION SNACK_NUTRITIOUS
#define MINCE_NUTRITION SNACK_DECENT
#define SAUSAGE_NUTRITION MINCE_NUTRITION + COOKED_FAT_NUTRITION
#define CHEESE_NUTRITION SNACK_DECENT
#define EGG_NUTRITION SNACK_DECENT
#define FRYVEGGIE_NUTRITION SNACK_POOR
#define COOKED_FAT_NUTRITION SNACK_DECENT

/*	........   Rotting Food defines   ................ */
#define SHELFLIFE_EXTREME 90 MINUTES
#define SHELFLIFE_LONG 50 MINUTES
#define SHELFLIFE_DECENT 30 MINUTES
#define SHELFLIFE_SHORT 20 MINUTES
#define SHELFLIFE_TINY 12 MINUTES
#define SHELFLIFE_MINISCULE 5 MINUTES

/*
	Formerly bitflags, now we are strings
	Currently used for classes, I could have used these for drifters tho
*/

#define CTAG_ALLCLASS "CAT_ALLCLASS" // just a define for allclass to not deal with actively typing strings
#define CTAG_PILGRIM "CAT_PILGRIM"  // Pilgrim classes
#define CTAG_ADVENTURER "CAT_ADVENTURER" // Adventurer classes
#define CTAG_TOWNER "CAT_TOWNER" // Villager class - Villagers can use it
#define CTAG_ANTAG "CAT_ANTAG" // Antag class - results in an antag
#define CTAG_BANDIT	"CAT_BANDIT" // Bandit class - Tied to the bandit antag really	<- Disabled; bandits got stuck with class selection
#define CTAG_CHALLENGE "CAT_CHALLENGE" // Challenge class - Meant to be free for everyone
#define CTAG_MERCENARY "CAT_MERCENARY"
#define CTAG_GARRISON "CAT_GARRISON"
#define CTAG_FORGARRISON "CAT_FORGARRISON"
#define CTAG_ADEPT "CAT_ADEPT" // Used for Adept class selection
#define CTAG_SQUIRE "CAT_SQUIRE" // Squire Love, Classes, as above.
#define CTAG_MAGIE "CAT_MAGIE" //for Mage Associate
#define CTAG_HEIR "CAT_HEIR"
#define CTAG_HAND "CAT_HAND" // Hand class - Handles Hand class selector
#define CTAG_CONSORT "CAT_CONSORT" // Consort classes
#define CTAG_VETERAN "CAT_VETERAN" // Veteran class - Handles Veteran class selector
#define CTAG_TOWN_ELDER "CAT_TOWN_ELDER" // Town Elder class - Handles Town Elder class selector
#define CTAG_ROYALKNIGHT "CAT_ROYAL_KNIGHT"
#define CTAG_ARCHIVIST "CAT_ARCHIVIST"
#define CTAG_MENATARMS "CAT_MENATARMS"
#define CTAG_SERVANT "CAT_SERVANT" // Servant class - 4 type of servant to fill in someplace.
#define CTAG_GATEMASTER "CAT_GATEMASTER"
#define CTAG_WRETCH "CAT_WRETCH"
#define CTAG_INQUISITION "CAT_INQUISITION" // For Orthodoxist subclasses
#define CTAG_PURITAN "CAT_PURITAN"
#define CTAG_FOLKHEROES "CAT_FOLKHEROES" //For the migrant wave

// .............. SELLPRICE/VALUE DEFINES ..................... //
// Basicallly material cost + work cost will be the value from now on. Needs work to value these things in comparison but its a simple way to get some consistency to it
// The material cost, work cost and bonus value should mostly be a under the hood thing so its easy to parse. Adjusting them will obviously affect end user costs.
// Keep values divisible by 2 and 3 and 4 without fractions, lets avoid money fractions guys.

// Material costs.
// theres two parts of what a material is worth, how hard is it to find it and how painful is it to collect, and how useful is it.
#define VALUE_OF_A_SIMPLE_MEAL 6	// some sort of base value, usually whats charged for a basic meal in the inn. Good measure to work from. Its comically low valued when looking at the actual invested material + effort vs smithing or crafting though
#define VALUE_OF_A_MUG_OF_ALE 2
#define M_MISC		1	// random stuff like stones or fibres I guess
#define M_WOOD		2	// one small log.
#define M_CLOTH		2	// one cloth piece
#define M_GRAIN		1	// one threshed wheat grain
#define M_FUR		M_CLOTH * 2
#define M_SILK		M_CLOTH * 2	// one silk thread
#define M_SALT		4	// one salt, or raw ore, or coal
#define M_LEATHER	M_CLOTH * 2 // one hide
#define M_IRON		12	// one iron bar  Twelve is a good number for it can be halved, cut in three and four without fractions. Multiples of 6
#define M_STEEL		M_IRON+W_MODERATE	// one steel bar
#define M_SILVER	M_IRON*3	// one silver bar
#define M_GOLD		M_IRON*5	// one gold bar

// Skill costs - a rarity value add, items requiring a high skill to produce are rarer and has more intrinsic value. So craftsmen can make a profit.
#define SKILL_1		2
#define SKILL_2		4
#define SKILL_3		6
#define SKILL_4		8
#define SKILL_5		10

// Work costs - valued VERY low compared to raw materials, this is a problem but at least its systemic and visible now and can be adjusted. Very rough, time to gather stuff, refine it etc etc as well as crafting time itself.
#define W_MINOR		2				// Less than 10 seconds of work
#define W_MODERATE	W_MINOR * 3		// Less than 1 minute of work, high skill required
#define W_MAJOR		W_MINOR * 6		// Less than 3 minutes of work

// Bonus value - totally arbitrary bonus slapped on. For magic items, unique stuff you want people to steal/plunder etc
#define BONUS_VALUE_TINY		6
#define BONUS_VALUE_SMALL		12
#define BONUS_VALUE_MODEST		BONUS_VALUE_SMALL * 2
#define BONUS_VALUE_BIG			BONUS_VALUE_SMALL * 4

#define GREED_SMALL_POTATO		BONUS_VALUE_TINY	// to get some profit margin to the offmap trading company and make economy make sense
#define GREEDY_TRADER			BONUS_VALUE_SMALL	// slap this on most stuff the trader imports (its the markup they pay their supplier, or just double value for stuff you want to keep rare)

/*--------------\
| VALUE DEFINES |	- If you find this confusing focus on this bit. Just use the value define below you think seems reasonable, done.
\--------------*/
// TINY is 1/3 of a bar, SMALL is 1/2
#define NO_MARKET_VALUE			null
#define VALUE_CHEAP_CLOTHING	M_CLOTH+W_MINOR
#define VALUE_FINE_CLOTHING		M_CLOTH+M_SILK+W_MINOR
#define VALUE_FANCY_HAT			M_SILK+W_MINOR+BONUS_VALUE_SMALL
#define VALUE_IRON_SMALL_ITEM	VALUE_IRON_ITEM/2
#define VALUE_IRON_ITEM			M_IRON+W_MINOR
#define VALUE_STEEL_SMALL_ITEM	VALUE_STEEL_ITEM/2
#define VALUE_STEEL_ITEM		M_STEEL+W_MINOR
#define VALUE_SILVER_TINY_ITEM	M_SILVER/3+W_MODERATE/3
#define VALUE_SILVER_ITEM		M_SILVER+W_MODERATE
#define VALUE_GOLD_TINY_ITEM	M_GOLD/3+W_MODERATE/3
#define VALUE_GOLD_ITEM			M_GOLD+W_MODERATE
#define VALUE_GOLD_RARE_ITEM	VALUE_GOLD_ITEM+BONUS_VALUE_MODEST

#define VALUE_PADDED_DRESS			M_SILK*5+W_MODERATE+BONUS_VALUE_TINY
#define VALUE_SMALL_LEATHER			M_LEATHER+W_MINOR
#define VALUE_MEDIUM_LEATHER		M_LEATHER*2+W_MINOR
#define VALUE_BIG_LEATHER			M_LEATHER*3+W_MINOR
#define VALUE_SMALL_FUR				M_FUR+M_MISC*2+W_MINOR

#define VALUE_LIGHT_GAMBESSON		M_CLOTH*2+M_MISC+W_MINOR
#define VALUE_GAMBESSON				M_CLOTH*4+M_MISC+W_MINOR
#define VALUE_HEAVY_GAMBESSON		M_CLOTH*6+M_MISC*4+W_MODERATE
#define VALUE_FUR_ARMOR				M_LEATHER*2+M_FUR+W_MINOR
#define VALUE_LEATHER_ARMOR			M_LEATHER*2+W_MINOR
#define VALUE_LEATHER_ARMOR_FUR		VALUE_LEATHER_ARMOR+M_SALT
#define VALUE_LEATHER_ARMOR_PLUS	VALUE_STEEL_SMALL_ITEM+M_LEATHER
#define VALUE_LEATHER_ARMOR_LORD	VALUE_LEATHER_ARMOR+BONUS_VALUE_MODEST
#define VALUE_IRON_ARMOR			VALUE_IRON_ITEM
#define VALUE_IRON_ARMOR_UNUSUAL	VALUE_IRON_ITEM+BONUS_VALUE_TINY
#define VALUE_STEEL_ARMOR			VALUE_STEEL_ITEM
#define VALUE_STEEL_ARMOR_FINE		VALUE_STEEL_ITEM+BONUS_VALUE_TINY
#define VALUE_SILVER_ARMOR			VALUE_SILVER_ITEM
#define VALUE_BRIGANDINE			VALUE_STEEL_ITEM*2+M_CLOTH+BONUS_VALUE_TINY
#define VALUE_FULL_PLATE			VALUE_STEEL_ITEM*3
#define VALUE_SNOWFLAKE_STEEL		VALUE_STEEL_ARMOR+BONUS_VALUE_MODEST

#define VALUE_LEATHER_HELMET		M_LEATHER*2+W_MINOR
#define VALUE_CHEAP_IRON_HELMET		VALUE_IRON_SMALL_ITEM
#define VALUE_IRON_HELMET			VALUE_IRON_ITEM
#define VALUE_CHEAP_STEEL_HELMET 	VALUE_STEEL_SMALL_ITEM
#define VALUE_STEEL_HELMET			VALUE_STEEL_ITEM
#define VALUE_SILVER_RING			VALUE_SILVER_TINY_ITEM
#define VALUE_GOLD_RING				VALUE_GOLD_TINY_ITEM
#define VALUE_MUSC_INSTRUMENT		VALUE_COMMON_GOODS
#define VALUE_RARE_MUSIC_INSTRUMENT	VALUE_COSTLY_THING


// Generic values - a lot of items lack materials for the above calculations so this is a super basic template to assign value to misc items
#define VALUE_DIRT_CHEAP	6
#define VALUE_COMMON_GOODS	VALUE_DIRT_CHEAP * 2		// so 12
#define VALUE_COSTLY_THING	VALUE_COMMON_GOODS * 3		// 36
#define VALUE_LUXURY_THING	VALUE_COSTLY_THING * 2		// and 72
#define VALUE_EXTREME		VALUE_LUXURY_THING * 4		// and 288

#define VALUE_MAGIC_ITEM_WEAK	VALUE_COSTLY_THING+BONUS_VALUE_MODEST
#define VALUE_MAGIC_ITEM_STRONG	VALUE_MAGIC_ITEM_WEAK+BONUS_VALUE_BIG






/*--------------------\
| ARMOR BASIC CONCEPT |
\--------------------*/
/*
Valid until the day someoen adds blunt/stab/cut damage defines from Blackstone

Five general types of armor with some general outlines.
*With current system armor less than 25 vs arrows is pretty much zero.
Armor values aren´t %
Differences between similar armorsets mostly about coverage or crit, small variation in armor value for non-smithed ones

Type					Melee/Arrow		Integrity		AC
Minor					10/0*			varies			varies (light)
Padded					25/30			low  			light
Leather					35/0*			medium			light
Mail/Scale/Medium		60/35			medium 			medium
Heavy Plate/Layered		90/70			good			heavy

Thing can move up or down an armor class by significant changes to coverage & crit protection. Like cuirass gets plate, but only covers torso, gets Medium AC instead of Heavy AC.
*/

/*------------------------\
| ARMOR INTEGRITY DEFINES |	- So armor makes sense
\------------------------*/

#define INTEGRITY_STRONGEST		500		// STEEL
#define INTEGRITY_STRONG		300		// IRON
#define INTEGRITY_STANDARD		200		// LEATHER
#define INTEGRITY_POOR			150		// GAMBESON, COPPER
#define INTEGRITY_WORST			100


/*--------------------\
| ARMOR VALUE DEFINES |	- So armor makes sense. Basic arrow got 25 AP so less than 25 "piercing" does nothing vs arrows generally
\--------------------*/

// Light AC
#define ARMOR_NONE			list("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_MINIMAL		list("blunt" = 5, "slash" = 5, "stab" = 5, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_WEAK			list("blunt" = 10, "slash" = 10, "stab" = 10, "piercing" = 5, "fire" = 0, "acid" = 0)

#define ARMOR_PADDED_BAD	list("blunt" = 15, "slash" = 15, "stab" = 15, "piercing" = 15, "fire" = 0, "acid" = 0)
#define ARMOR_PADDED		list("blunt" = 25, "slash" = 25, "stab" = 25, "piercing" = 30, "fire" = 0, "acid" = 0)
#define ARMOR_PADDED_GOOD	list("blunt" = 30, "slash" = 30, "stab" = 30, "piercing" = 35, "fire" = 0, "acid" = 0)

#define ARMOR_LEATHER_BAD	list("blunt" = 30, "slash" = 30, "stab" = 30, "piercing" = 10, "fire" = 0, "acid" = 0)
#define ARMOR_LEATHER		list("blunt" = 35, "slash" = 35, "stab" = 35, "piercing" = 15, "fire" = 0, "acid" = 0)
#define	ARMOR_LEATHER_GOOD	list("blunt" = 40, "slash" = 40, "stab" = 40, "piercing" = 20, "fire" = 0, "acid" = 0)

// Medium AC
#define ARMOR_MAILLE_IRON	list("blunt" = 45, "slash" = 45, "stab" = 50, "piercing" = 30, "fire" = 0, "acid" = 0)
#define ARMOR_MAILLE		list("blunt" = 55, "slash" = 55, "stab" = 55, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_MAILLE_GOOD	list("blunt" = 60, "slash" = 60, "stab" = 60, "piercing" = 45, "fire" = 0, "acid" = 0)
#define ARMOR_SCALE			list("blunt" = 65, "slash" = 65, "stab" = 65, "piercing" = 65, "fire" = 0, "acid" = 0)
#define ARMOR_BRIGANDINE	list("blunt" = 70, "slash" = 70, "stab" = 70, "piercing" = 50, "fire" = 0, "acid" = 0)

// Heavy AC
#define ARMOR_PLATE_BAD		list("blunt" = 75, "slash" = 75, "stab" = 75, "piercing" = 55, "fire" = 0, "acid" = 0)
#define ARMOR_PLATE			list("blunt" = 85, "slash" = 85, "stab" = 85, "piercing" = 70, "fire" = 0, "acid" = 0)
#define ARMOR_PLATE_SILVER	list("blunt" = 85, "slash" = 85, "stab" = 85, "piercing" = 80, "fire" = 0, "acid" = 0)
#define ARMOR_PLATE_GOOD	list("blunt" = 90, "slash" = 90, "stab" = 90, "piercing" = 85, "fire" = 0, "acid" = 0)

#define ARMOR_BLACKBAG list("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 75, "acid" = 100)
#define ARMOR_BROADSWORD list("blunt" = 40, "slash" = 50, "stab" = 50, "piercing" = 0)

// Misc defines. These are here just in case. Inherited by their relevant subtypes.
#define ARMOR_MACHINERY list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 10, "fire" = 50, "acid" = 70)
#define ARMOR_STRUCTURE list("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 50, "acid" = 50)
#define ARMOR_DISPLAYCASE list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 70, "acid" = 100)
#define ARMOR_CLOSET list("blunt" = 20, "slash" = 10, "stab" = 15, "piercing" = 10, "fire" = 70, "acid" = 60)

// Light AC | Chest
#define ARMOR_CLOTHING list("blunt" = 0, "slash" = 10, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)

#define ARMOR_SPELLSINGER list("blunt" = 70, "slash" = 70, "stab" = 50, "piercing" = 30, "fire" = 0, "acid" = 0)
#define ARMOR_LEATHER_STUDDED list("blunt" = 80, "slash" = 80, "stab" = 60, "piercing" = 20, "fire" = 0, "acid" = 0)

// Medium AC | Chest
#define ARMOR_CUIRASS list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_PLATE_BSTEEL list("blunt" = 80, "slash" = 100, "stab" = 90, "piercing" = 80, "fire" = 0, "acid" = 0) // It's EVIL. OH GOD.

// Boot Armor
#define ARMOR_BOOTS_PLATED list("blunt" = 10, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_BOOTS_PLATED_IRON list("blunt" = 10, "slash" = 100, "stab" = 70, "piercing" = 35, "fire" = 0, "acid" = 0)
#define ARMOR_BOOTS_BAD list("blunt" = 30, "slash" = 10, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_BOOTS list("blunt" = 30, "slash" = 40, "stab" = 60, "piercing" = 0, "fire" = 0, "acid" = 0)

// Glove Armor
#define ARMOR_GLOVES_LEATHER list("blunt" = 60, "slash" = 10, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_GLOVES_LEATHER_GOOD list("blunt" = 60, "slash" = 25, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)
#define ARMOR_GLOVES_CHAIN list("blunt" = 20, "slash" = 100, "stab" = 70, "piercing" = 20, "fire" = 0, "acid" = 0)
#define ARMOR_GLOVES_PLATE list("blunt" = 5, "slash" = 100, "stab" = 80, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_GLOVES_PLATE_GOOD list("blunt" = 20, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)

//  Head Armor
#define ARMOR_HEAD_CLOTHING list("blunt" = 0, "slash" = 20, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_HEAD_BAD list("blunt" = 50, "slash" = 20, "stab" = 30, "piercing" = 10, "fire" = 0, "acid" = 0)
#define ARMOR_HEAD_HELMET_BAD list("blunt" = 50, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
#define ARMOR_HEAD_HELMET list("blunt" = 50, "slash" = 100, "stab" = 80, "piercing" = 20, "fire" = 0, "acid" = 0)
#define ARMOR_HEAD_HELMET_VISOR list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_HEAD_PSYDON list("blunt" = 70, "slash" = 70, "stab" = 50, "piercing" = 30, "fire" = 0, "acid" = 0)	//Yeah they just have their own thing going on.
#define ARMOR_HEAD_LEATHER list("blunt" = 90, "slash" = 60, "stab" = 30, "piercing" = 20, "fire" = 0, "acid" = 0)

// Mask Armor
#define ARMOR_MASK_METAL_BAD list("blunt" = 50, "slash" = 50, "stab" = 50, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_MASK_METAL list("blunt" = 50, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)

// Neck Armor
#define ARMOR_BEVOR list("blunt" = 20, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_GORGET list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_NECK_BAD list("blunt" = 50, "slash" = 50, "stab" = 40, "piercing" = 20, "fire" = 0, "acid" = 0)

//Pants Armor
#define ARMOR_PANTS_LEATHER list("blunt" = 80, "slash" = 50, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)
#define ARMOR_PANTS_CHAIN list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 20, "fire" = 0, "acid" = 0)
#define ARMOR_PANTS_BRIGANDINE list("blunt" = 40, "slash" = 70, "stab" = 70, "piercing" = 50, "fire" = 0, "acid" = 0)

//Antag / Special / Unique armor defines
#define ARMOR_VAMP list("blunt" = 100, "slash" = 100, "stab" = 90, "piercing" = 80, "fire" = 0, "acid" = 0)
#define ARMOR_WWOLF list("blunt" = 100, "slash" = 90, "stab" = 80, "piercing" = 70, "fire" = 40, "acid" = 0)
#define ARMOR_DRAGONSCALE list("blunt" = 100, "slash" = 100, "stab" = 100, "fire" = 50, "acid" = 0)
#define ARMOR_ASCENDANT list("blunt" = 50, "slash" = 100, "stab" = 80, "piercing" = 80, "fire" = 0, "acid" = 0)
#define ARMOR_GRUDGEBEARER list("blunt" = 40, "slash" = 200, "stab" = 200, "piercing" = 100, "fire" = 0, "acid" = 0)
#define ARMOR_ZIZOCONCSTRUCT list("blunt" = 60, "slash" = 70, "stab" = 70, "piercing" = 60, "fire" = 40, "acid" = 10)
#define ARMOR_DRAGONHIDE list("blunt" = 30, "slash" = 30, "stab" = 30, "piercing" = 30, "fire" = 40, "acid" = 0) // snowflake armor for dragonhide, fire resist but lower other values from the ring since more integ
#define ARMOR_FATEWEAVER list("blunt" = 10, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 0, "acid" = 0)
// Blocks every hit, at least once
#define ARMOR_GRONN_LIGHT list("blunt" = 80, "slash" = 80, "stab" = 30, "piercing" = 30, "fire" = 0, "acid" = 0)

/*-----------------------\
| COVERAGE ARMOR DEFINES |
\-----------------------*/

#define COVERAGE_HEAD_NOSE		( HEAD | HAIR | EARS | NOSE )
#define COVERAGE_HEAD			( HEAD | HAIR | EARS )
#define COVERAGE_NASAL			( HEAD | HAIR | NOSE )
#define COVERAGE_SKULL			( HEAD | HAIR )

#define COVERAGE_VEST			( CHEST | VITALS )
#define COVERAGE_SHIRT			( CHEST | VITALS | ARMS )
#define COVERAGE_TORSO			( CHEST | GROIN | VITALS )
#define COVERAGE_ALL_BUT_ARMS	( CHEST | GROIN | VITALS | LEGS )
#define COVERAGE_ALL_BUT_LEGS	( CHEST | GROIN | VITALS | ARMS )
#define COVERAGE_FULL			( CHEST | GROIN | VITALS | LEGS | ARMS )

#define COVERAGE_PANTS			( GROIN | LEGS )
#define COVERAGE_FULL_LEG		( LEGS | FEET )

/*-----------------------------\
| CRITICAL HIT DEFENSE DEFINES |
\-----------------------------*/

#define ALL_CRITICAL_HITS list(\
BCLASS_CUT, \
BCLASS_CHOP, \
BCLASS_BLUNT, \
BCLASS_STAB, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

// Vampire heavy armor, always vulnerable to whips
#define ALL_CRITICAL_HITS_VAMP list(\
BCLASS_CUT, \
BCLASS_CHOP, \
BCLASS_BLUNT, \
BCLASS_STAB, \
BCLASS_BITE, \
BCLASS_TWIST, \
BCLASS_SHOT)

#define ALL_EXCEPT_STAB list(\
BCLASS_CUT, \
BCLASS_CHOP, \
BCLASS_BLUNT, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

// Typical maille
#define ALL_EXCEPT_BLUNT list(\
BCLASS_CUT, \
BCLASS_CHOP, \
BCLASS_STAB, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

// Plates cover only a few organs and bones
#define ONLY_VITAL_ORGANS list(\
BCLASS_CHOP, \
BCLASS_STAB, \
BCLASS_BLUNT)

#define ALL_EXCEPT_CHOP_AND_STAB list(\
BCLASS_CUT, \
BCLASS_BLUNT, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

#define ALL_EXCEPT_BLUNT_AND_STAB list(\
BCLASS_CUT, \
BCLASS_CHOP, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

#define CUT_AND_MINOR_CRITS list(\
BCLASS_CUT, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

#define BLUNT_AND_MINOR_CRITS list(\
BCLASS_BLUNT, \
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)

#define MINOR_CRITICALS list(\
BCLASS_LASHING, \
BCLASS_BITE, \
BCLASS_TWIST)



/*-----------------------\
| Decorated Helmet Lists |
\-----------------------*/

#define HELMET_KNIGHT_DECORATIONS list(\
		"Basic"="basic_decoration",\
		"Blue"="blue_decoration",\
		"Stripes"="stripes_decoration",\
		"Red Castle"="castle_red_decoration",\
		"White Castle"="castle_white_decoration",\
		"Graggar"="graggar_decoration",\
		"Efreet"="efreet_decoration",\
		"Sun"="sun_decoration",\
		"Peace"="peace_decoration",\
		"Feathers"="feathers_decoration",\
		"Lion"="lion_decoration",\
		"Red Dragon"="dragon_red_decoration",\
		"Green Dragon"="dragon_green_decoration",\
		"Horns"="horns_decoration",\
		"Swan"="swan_decoration",\
		"Fish"="fish_decoration",\
		"Windmill"="windmill_decoration", \
		"Oathtaker"="oathtaker_decoration",\
		"Skull"="skull_decoration")

#define HELMET_HOUNSKULL_DECORATIONS list(\
		"Basic"="basic_houndecoration",\
		"Blue"="blue_houndecoration",\
		"Stripes"="stripes_houndecoration",\
		"Red Castle"="castle_red_houndecoration",\
		"White Castle"="castle_white_houndecoration",\
		"Graggar"="graggar_houndecoration",\
		"Efreet"="efreet_houndecoration",\
		"Peace"="peace_houndecoration",\
		"Sun"="sun_houndecoration",\
		"Feathers"="feathers_houndecoration",\
		"Lion"="lion_houndecoration",\
		"Red Dragon"="dragon_red_houndecoration",\
		"Green Dragon"="dragon_green_houndecoration",\
		"Horns"="horns_houndecoration",\
		"Swan"="swan_houndecoration",\
		"Fish"="fish_houndecoration",\
		"Windmill"="peace_houndecoration",\
		"Oathtaker"="oathtaker_houndecoration",\
		"Skull"="skull_houndecoration")

#define HELMET_BUCKET_DECORATIONS list(\
		"Basic"="basic_bucket",\
		"Blue"="blue_bucket",\
		"Stripes"="stripes_bucket",\
		"Red Castle"="castle_red_bucket",\
		"White Castle"="castle_white_bucket",\
		"Graggar"="graggar_bucket",\
		"Efreet"="efreet_bucket",\
		"Peace"="peace_bucket",\
		"Sun"="sun_bucket",\
		"Feathers"="feathers_bucket",\
		"Lion"="lion_bucket",\
		"Red Dragon"="dragon_red_bucket",\
		"Green Dragon"="dragon_green_bucket",\
		"Horns"="horns_bucket",\
		"Swan"="swan_bucket",\
		"Fish"="fish_bucket",\
		"Windmill"="windmill_bucket",\
		"Oathtaker"="oathtaker_bucket",\
		"Skull"="skull_bucket")

#define HELMET_GOLD_DECORATIONS list(\
		"Basic"="basic_gbucket",\
		"Blue"="blue_gbucket",\
		"Stripes"="stripes_gbucket",\
		"Red Castle"="castle_red_gbucket",\
		"White Castle"="castle_white_gbucket",\
		"Graggar"="graggar_gbucket",\
		"Efreet"="efreet_gbucket",\
		"Peace"="peace_gbucket",\
		"Sun"="sun_gbucket",\
		"Feathers"="feathers_gbucket",\
		"Lion"="lion_gbucket",\
		"Red Dragon"="dragon_red_gbucket",\
		"Green Dragon"="dragon_green_gbucket",\
		"Horns"="horns_gbucket",\
		"Swan"="swan_gbucket",\
		"Fish"="fish_gbucket",\
		"Windmill"="windmill_gbucket",\
		"Oathtaker"="oathtaker_gbucket",\
		"Skull"="skull_gbucket")

#define BASCINET_DECORATIONS list(\
		"Basic"="basic_bascinet",\
		"Blue"="blue_bascinet",\
		"Stripes"="stripes_bascinet",\
		"Red Castle"="castle_red_bascinet",\
		"White Castle"="castle_white_bascinet",\
		"Graggar"="graggar_bascinet",\
		"Efreet"="efreet_bascinet",\
		"Sun"="sun_bascinet",\
		"Peace"="peace_bascinet",\
		"Feathers"="feathers_bascinet",\
		"Lion"="lion_bascinet",\
		"Red Dragon"="dragon_red_bascinet",\
		"Green Dragon"="dragon_green_bascinet",\
		"Horns"="horns_bascinet",\
		"Swan"="swan_bascinet",\
		"Fish"="fish_bascinet",\
		"Windmill"="windmill_bascinet",\
		"Oathtaker"="oathtaker_bascinet",\
		"Skull"="skull_bascinet")

#define SKULLMET_ICONS list(\
		"volf"="skullmet_volf",\
		"bear"="skullmet_bear",\
		"gote"="skullmet_goat")

#define DENDOR_TAME_PROB_NONE 0
#define DENDOR_TAME_PROB_LOW 25
#define DENDOR_TAME_PROB_MEDIUM 50
#define DENDOR_TAME_PROB_HIGH 75
#define DENDOR_TAME_PROB_GURANTEED 100


/*------------------------\
| ARMOR INTEGRITY DEFINES | // Use these when possible on armor to keep value consistent.
\------------------------*/
// Side = Non-chest armor integrity
// For now. Steel vs Iron will be a difference of 75% integrity without rating differences.
// So Iron will actually be pretty decent and there shouldn't be a compulsive need to upgrade.

// Helmet
#define ARMOR_INT_HELMET_ANTAG 600
#define ARMOR_INT_HELMET_BLACKSTEEL 500
#define ARMOR_INT_HELMET_HEAVY_STEEL 400
#define ARMOR_INT_HELMET_HEAVY_IRON 300
#define ARMOR_INT_HELMET_HEAVY_DECREPIT 200
#define ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY 50 // Integrity reduction, if a helmet is adjustable
#define ARMOR_INT_HELMET_STEEL 300
#define ARMOR_INT_HELMET_IRON 225
#define ARMOR_INT_HELMET_HARDLEATHER 250
#define ARMOR_INT_HELMET_LEATHER 200
#define ARMOR_INT_HELMET_CLOTH 100

// Chest / Armor Pieces

// HEAVY
#define ARMOR_INT_CHEST_PLATE_ANTAG 700
#define ARMOR_INT_CHEST_PLATE_BLACKSTEEL 600
#define ARMOR_INT_CHEST_PLATE_STEEL 500
#define ARMOR_INT_CHEST_PLATE_BRIGANDINE 350
#define ARMOR_INT_CHEST_PLATE_PSYDON 400 // You get free training, less int
#define ARMOR_INT_CHEST_PLATE_IRON 375
#define ARMOR_INT_CHEST_PLATE_DECREPIT 250

// MEDIUM
#define ARMOR_INT_CHEST_MEDIUM_STEEL 300
#define ARMOR_INT_CHEST_MEDIUM_IRON 225
#define ARMOR_INT_CHEST_MEDIUM_SCALE 200 // More coverage, less integrity
#define ARMOR_INT_CHEST_MEDIUM_DECREPIT 150

// LIGHT
#define ARMOR_INT_CHEST_LIGHT_MASTER 300 // High tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_MEDIUM 250 // Medium tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_BASE 200
#define ARMOR_INT_CHEST_LIGHT_STEEL 180
#define ARMOR_INT_CHEST_CIVILIAN 100

// LEG PIECES - Leg Armor
#define ARMOR_INT_LEG_ANTAG 600
#define ARMOR_INT_LEG_BLACKSTEEL 500
#define ARMOR_INT_LEG_STEEL_PLATE 400
#define ARMOR_INT_LEG_IRON_PLATE 300
#define ARMOR_INT_LEG_DECREPIT_PLATE 200
#define ARMOR_INT_LEG_STEEL_CHAIN 300
#define ARMOR_INT_LEG_BRIGANDINE 250 // Iron grade but whatever.
#define ARMOR_INT_LEG_IRON_CHAIN 225
#define ARMOR_INT_LEG_DECREPIT_CHAIN 150
#define ARMOR_INT_LEG_HARDLEATHER 250
#define ARMOR_INT_LEG_LEATHER 200
#define ARMOR_INT_LEG_CLOTH 10

// SIDE PIECES - Non-Chest armor
#define ARMOR_INT_SIDE_ANTAG 500 // Integrity for antag pieces
#define ARMOR_INT_SIDE_BLACKSTEEL 400 // Integrity for blacksteel pieces
#define ARMOR_INT_SIDE_STEEL 300 // Integrity for steel pieces
#define ARMOR_INT_SIDE_IRON 225 // Integrity for iron pieces
#define ARMOR_INT_SIDE_HARDLEATHER 250 // Integrity for hardened leather pieces
#define ARMOR_INT_SIDE_LEATHER 200 // Integrity for leather / copper pieces
#define ARMOR_INT_SIDE_DECREPIT 150 // Integrity for decrepit pieces
#define ARMOR_INT_SIDE_CLOTH 100 // Integrity for cloth / aesthetic oriented pieces
