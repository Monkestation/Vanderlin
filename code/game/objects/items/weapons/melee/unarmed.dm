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
	max_integrity = INTEGRITY_STATIC_200
	experimental_inhand = FALSE
	possible_item_intents = list(CLOSECOMBAT_PUNCH, CLOSECOMBAT_JAB, CLOSECOMBAT_SLUG, CLOSECOMBAT_SLAM)
	weapon_special = /datum/special_intent/upper_cut

/obj/item/weapon/clenched_fist/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOEMBED, INNATE_TRAIT)
	RegisterSignal(src, COMSIG_ATOM_INTEGRITY_CHANGED, PROC_REF(on_integrity_changed))

/obj/item/weapon/clenched_fist/Destroy()
	UnregisterSignal(src, COMSIG_ATOM_INTEGRITY_CHANGED)
	return ..()

/obj/item/weapon/clenched_fist/proc/on_integrity_changed(datum/source, old_value, new_value)
	if(new_value >= old_value || !ismob(loc))
		return
	var/mob/living/carbon/human/user = loc
	var/arm_damage = max(1, round((old_value - new_value) / 2))
	var/target_zone = user.get_active_hand() == LEFT_HANDS ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM
	user.apply_damage(arm_damage, BRUTE, target_zone, damage_type = BCLASS_BLUNT, can_crit = FALSE)

/obj/item/weapon/clenched_fist/atom_destruction(damage_flag)
	if(ismob(loc))
		var/mob/living/carbon/human/user = loc
		var/target_zone = BODY_ZONE_L_ARM
		if(user.get_active_hand() == LEFT_HANDS)
			target_zone = BODY_ZONE_L_ARM
		else
			target_zone = BODY_ZONE_R_ARM
		user.apply_damage(40, BRUTE, target_zone, damage_type = BCLASS_BLUNT, can_crit = TRUE)
	. = ..()

/datum/intent/unarmed/punch/closecombat
	name = "punch"
	acc_bonus = 15
	penfactor = 18
	damfactor = 1.2
	misscost = 5
	animname = "stab"

/datum/intent/unarmed/punch/jab
	name = "jab"
	icon_state = "injab"
	acc_bonus = 5
	penfactor = 10
	damfactor = 0.75
	swingdelay = 0.5
	clickcd = 7
	misscost = 4
	animname = "stab"

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
	animname = "stab"

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
	animname = "stab"
