#define ALL_TEMPLE_PATRONS 		list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora)
#define UNDIVIDED_TEMPLE_PATRONS list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/divine/centrist)
#define ALL_MIRACLE_PATRONS 	list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/inhumen/graggar, /datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
#define ALL_TEMPLAR_PATRONS 	list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/eora, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/pestra, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/malum, /datum/patron/divine/xylix)
#define ALL_PROFANE_PATRONS 	list(/datum/patron/inhumen/graggar, /datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
#define ALL_ICONOCLAST_PATRONS  list(/datum/patron/psydon, /datum/patron/psydon/extremist, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/inhumen/graggar, /datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
#define ALL_ACOLYTE_PATRONS		list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora) //No Necra because she has gravetenders

#define COLORFUL_PATRONS		list("Psydon", "Astrata", "Noc", "Dendor", "Abyssor", "Necra", "Ravox", "Xylix", "Pestra", "Malum", "Eora", "Graggar", "Zizo", "Matthios", "Baotha", "The Great Hunt", "The Black Briar", "Graggazo")
#define TEMPLE_PATRON_NAMES		list("Astrata", "Noc", "Dendor", "Abyssor", "Necra", "Ravox", "Xylix", "Pestra", "Malum", "Eora")

#define TEN_CURSES list(\
	/datum/curse/astrata,\
	/datum/curse/noc,\
	/datum/curse/ravox,\
	/datum/curse/necra,\
	/datum/curse/xylix,\
	/datum/curse/pestra,\
	/datum/curse/eora,\
	/datum/curse/malum\
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

#define ROYAL_STATUS_CONSORT "consort"
#define ROYAL_STATUS_PROGENY "progeny"
#define ROYAL_STATUS_OMMER "ommer"

#define FAMILY_MEMBER_PARENT "parent"
#define FAMILY_MEMBER_CHILD "child"
#define FAMILY_MEMBER_SIBLING "sibling"
#define FAMILY_MEMBER_SPOUSE "spouse"

GLOBAL_LIST_EMPTY(job_respawn_delays)

//stress levels. Stress starts at 0.
#define STRESS_INSANE 7
#define STRESS_VBAD 5
#define STRESS_BAD 3
#define STRESS_NEUTRAL 2
#define STRESS_GOOD 1
#define STRESS_VGOOD -4

/*
	Formerly bitflags, now we are strings
	Currently used for classes, I could have used these for drifters tho
*/

#define CTAG_ALLCLASS "CAT_ALLCLASS" // just a define for allclass to not deal with actively typing strings
#define CTAG_PILGRIM "CAT_PILGRIM"  // Pilgrim classes
#define CTAG_ADVENTURER "CAT_ADVENTURER" // Adventurer classes
#define CTAG_BANDIT	"CAT_BANDIT" // Bandit class - Tied to the bandit antag really	<- Disabled; bandits got stuck with class selection
#define CTAG_CHALLENGE "CAT_CHALLENGE" // Challenge class - Meant to be free for everyone
#define CTAG_MERCENARY "CAT_MERCENARY"
#define CTAG_GARRISON "CAT_GARRISON"
#define CTAG_FORGARRISON "CAT_FORGARRISON"
#define CTAG_ADEPT "CAT_ADEPT" // Used for Adept class selection
#define CTAG_SQUIRE "CAT_SQUIRE" // Squire Love, Classes, as above.
#define CTAG_HEIR "CAT_HEIR"
#define CTAG_HAND "CAT_HAND" // Hand class - Handles Hand class selector
#define CTAG_COURTAGENT "CAT_COURT_AGENT"
#define CTAG_MINOR_NOBLE "CAT_MINOR_NOBLE" // Minor Noble classes
#define CTAG_CONSORT "CAT_CONSORT" // Consort classes
#define CTAG_TOWN_ELDER "CAT_TOWN_ELDER" // Town Elder class - Handles Town Elder class selector
#define CTAG_ROYALKNIGHT "CAT_ROYAL_KNIGHT"
#define CTAG_ARCHIVIST "CAT_ARCHIVIST"
#define CTAG_MENATARMS "CAT_MENATARMS"
#define CTAG_GATEMASTER "CAT_GATEMASTER"
#define CTAG_WRETCH "CAT_WRETCH"
#define CTAG_INQUISITION "CAT_INQUISITION" // For Orthodoxist subclasses
#define CTAG_PURITAN "CAT_PURITAN"
#define CTAG_ORPHAN "CAT_ORPHAN" // For Orphan subclasses

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
		"gote"="skullmet_goat",\
		"rous"="skullmet_ruffian",\
		"bobcat"="skullmet_bobcat")

#define DENDOR_TAME_PROB_NONE 0
#define DENDOR_TAME_PROB_LOW 25
#define DENDOR_TAME_PROB_MEDIUM 50
#define DENDOR_TAME_PROB_HIGH 75
#define DENDOR_TAME_PROB_GURANTEED 100
