#define CLOSECOMBAT_PUNCH /datum/intent/unarmed/punch/closecombat
#define CLOSECOMBAT_JAB /datum/intent/unarmed/punch/jab
#define CLOSECOMBAT_SLUG /datum/intent/unarmed/punch/slug
#define CLOSECOMBAT_SLAM /datum/intent/unarmed/punch/slam

/obj/item/weapon/clenched_fist
	name = "clenched fist"
	desc = "The fist was humenity's first weapon, and still a fine one."
	icon = null
	icon_state = null
	force = 8
	minstr = 1
	item_weight = 100 GRAMS
	wbalance = HARD_TO_DODGE
	item_flags = DROPDEL
	wdefense = GOOD_PARRY
	possible_item_intents = list(CLOSECOMBAT_PUNCH, CLOSECOMBAT_JAB, CLOSECOMBAT_SLUG, CLOSECOMBAT_SLAM)

/obj/item/weapon/clenched_fist/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/datum/intent/unarmed/punch/closecombat
	name = "punch"
	acc_bonus = 15
	penfactor = 18
	damfactor = 1.2
	releasedrain = 5

/datum/intent/unarmed/punch/jab
	name = "jab"
	icon_state = "injab"
	acc_bonus = 5
	penfactor = 10
	damfactor = 0.9
	swingdelay = 0.7
	releasedrain = 4

/datum/intent/unarmed/punch/slug
	name = "slug"
	icon_state = "inslug"
	acc_bonus = 10
	penfactor = 30
	damfactor = 1.2
	swingdelay = 1.5
	releasedrain = 8

/datum/intent/unarmed/punch/slam
	name = "slam"
	icon_state = "inslam"
	acc_bonus = 5
	penfactor = 40
	damfactor = 1.5
	swingdelay = 2.5
	knockback = 2
	chargetime = 3
	releasedrain = 20
