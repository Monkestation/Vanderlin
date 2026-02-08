/obj/item/weapon/surgery
	name = "surgical tool"
	desc = "Something that will tear your guts apart."
	icon = 'icons/roguetown/items/surgery.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = DAMAGE_DAGGER
	throwforce = DAMAGE_DAGGER
	wdefense = GOOD_PARRY
	wbalance = HARD_TO_DODGE

	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	max_blade_int = 100
	max_integrity = INTEGRITY_POOR + 25
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/blacksmithing
	melting_material = /datum/material/iron
	melt_amount = 25 //it takes 2 iron bars to make 8 surgical tools, 240/8 = 30, -5 because I reckon some is lost during the process
	embedding = list(
		"embed_chance" = 20,
		"embedded_pain_multiplier" = 1,
		"embedded_fall_chance" = 0,
	)

	grid_width = 32
	grid_height = 64

/obj/item/weapon/surgery/Initialize()
	. = ..()
	item_flags |= SURGICAL_TOOL //let's not stab patients for fun

/obj/item/weapon/surgery/scalpel
	name = "scalpel"
	desc = "A tool used to carve precisely into the flesh of the sickly."
	icon_state = "scalpel"
	possible_item_intents = list(DAGGER_CUT, DAGGER_THRUST)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_SCALPEL

/obj/item/weapon/surgery/saw
	name = "saw"
	desc = "A tool used to carve through bone."
	icon_state = "bonesaw"
	force = DAMAGE_DAGGER + 2
	throwforce = DAMAGE_KNIFE - 3
	wdefense = BAD_PARRY
	wbalance = DODGE_CHANCE_NORMAL
	armor_penetration = 0
	possible_item_intents = list(DAGGER_CUT, CLEAVER_CHOP)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_CHOP
	tool_behaviour = TOOL_SAW

/obj/item/weapon/surgery/hemostat
	name = "forceps"
	desc = "A tool used to clamp down on soft tissue."
	icon_state = "forceps"
	possible_item_intents = list(INTENT_USE)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_HEMOSTAT
	sharpness = IS_BLUNT

/obj/item/weapon/surgery/retractor
	name = "speculum"
	desc = "A tool used to spread tissue open for surgical access."
	icon_state = "speculum"
	possible_item_intents = list(INTENT_USE)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_RETRACTOR
	sharpness = IS_BLUNT

/obj/item/weapon/surgery/bonesetter
	name = "bone-setter"
	desc = "A tool used to manipulate joints and bones."
	icon_state = "bonesetter"
	possible_item_intents = list(INTENT_USE)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_BONESETTER
	sharpness = IS_BLUNT

/obj/item/weapon/surgery/cautery
	name = "cautery iron"
	desc = "A tool used to cauterize wounds. Heat it up before use."
	icon_state = "cauteryiron"
	force = DAMAGE_MACE - 2
	throwforce = DAMAGE_MACE - 2
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(INTENT_USE, MACE_STRIKE, MACE_SMASH)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED

	associated_skill = /datum/skill/combat/axesmaces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	/// Timer to cool down
	var/cool_timer
	/// Whether or not we are heated up
	var/heated = FALSE

/obj/item/weapon/surgery/cautery/examine(mob/user)
	. = ..()
	if(heated)
		. += "<span class='warning'>The tip is hot to the touch.</span>"

/obj/item/weapon/surgery/cautery/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][heated ? "_hot" : ""]"

/obj/item/weapon/surgery/cautery/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!istype(user.a_intent, INTENT_USE))
		return ..()
	var/heating = 0
	if(istype(A, /obj/machinery/light/fueled))
		var/obj/machinery/light/fueled/forge = A
		if(forge.on)
			heating = 20
	if(heating)
		user.visible_message("<span class='info'>[user] heats [src].</span>")
		fire_act(heating)
		return TRUE
	return ..()

/obj/item/weapon/surgery/cautery/fire_act(added, maxstacks)
	. = ..()
	if(!heated)
		playsound(src, 'sound/items/firelight.ogg', 100, vary = TRUE)
	update_heated(TRUE)
	if(cool_timer)
		deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(update_heated), FALSE), added SECONDS, TIMER_STOPPABLE)

/obj/item/weapon/surgery/cautery/get_temperature()
	if(heated)
		return 150+T0C
	return ..()

/obj/item/weapon/surgery/cautery/proc/update_heated(new_heated)
	heated = new_heated
	if(heated)
		damtype = BURN
	else
		damtype = BRUTE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/weapon/surgery/hammer
	name = "examination hammer"
	desc = "A small hammer used to check a patient's reactions and diagnose their condition."
	icon_state = "kneehammer"
	force = DAMAGE_CLUB - 5
	throwforce = DAMAGE_CLUB - 7
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(INTENT_USE, MACE_STRIKE, MACE_SMASH)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	associated_skill = /datum/skill/combat/axesmaces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/weapon/surgery/hammer/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(!istype(user.a_intent, INTENT_USE))
		return ..()
	if(user.get_skill_level(/datum/skill/misc/medicine) < 1)
		return ..()
	if(ishuman(A))
		if(A == user)
			user.visible_message("<span class='info'>[user] begins smacking themself with a small hammer.</span>")
		else
			user.visible_message("<span class='info'>[user] begins to smack [A] with a small hammer.</span>")
		if(do_after(user, 2.5 SECONDS, A))
			A.visible_message("<span class='info'>[A] jerks their knee after the hammer strikes!</span>")
			if(prob(1))
				playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)
			var/mob/living/carbon/human/human_target = A
			human_target.check_for_injuries(user, additional = TRUE)
	return ..()
