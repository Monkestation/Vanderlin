/obj/item/weapon/clenched_fist
	name = "clenched fist"
	desc = "The fist was humenity's first weapon, and still sees much use."
	icon = 'icons/roguetown/weapons/32/fists_claws.dmi'
	icon_state = "clenchedfist"
	item_flags = ABSTRACT | DROPDEL
	force = 10
	minstr = 1
	item_weight = 0 GRAMS
	wbalance = HARD_TO_DODGE
	wdefense = GOOD_PARRY
	possible_item_intents = list(CLOSECOMBAT_PUNCH, CLOSECOMBAT_JAB, CLOSECOMBAT_SLUG, CLOSECOMBAT_SLAM)
	weapon_special = /datum/special_intent/upper_cut

/obj/item/weapon/clenched_fist/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOEMBED, INNATE_TRAIT)

/datum/intent/unarmed/punch/closecombat
	name = "punch"
	acc_bonus = 15
	penfactor = 18
	damfactor = 1.2
	misscost = 5

/datum/intent/unarmed/punch/jab
	name = "jab"
	icon_state = "injab"
	acc_bonus = 5
	penfactor = 10
	damfactor = 0.75
	swingdelay = 0.5
	clickcd = 7
	misscost = 4

/datum/intent/unarmed/punch/slug
	name = "slug"
	icon_state = "inslug"
	acc_bonus = 15
	penfactor = 30
	damfactor = 1.5
	swingdelay = 1.5
	clickcd = 15
	releasedrain = 8
	misscost = 5

/datum/intent/unarmed/punch/slam
	name = "slam"
	icon_state = "inslam"
	acc_bonus = 5
	penfactor = 40
	damfactor = 1.8
	clickcd = 20
	swingdelay = 2.5
	knockback = 10
	chargetime = 3
	chargedrain = 3
	releasedrain = 20
	misscost = 10
