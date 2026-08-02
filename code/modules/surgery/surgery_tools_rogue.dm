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
	item_flags = parent_type::item_flags | SURGICAL_TOOL

	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	max_blade_int = 100
	max_integrity = INTEGRITY_POOR + 25
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/attribute/skill/combat/knives
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	melting_material = /datum/material/iron
	melt_amount = 25 //it takes 2 iron bars to make 8 surgical tools, 240/8 = 30, -5 because I reckon some is lost during the process
	embedding = list(
		"embed_chance" = 20,
		"embedded_pain_multiplier" = 1,
		"embedded_fall_chance" = 0,
	)

	grid_width = 32
	grid_height = 64

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
	possible_item_intents = list(DAGGER_CUT, DAGGER_CHOP)
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

	associated_skill = /datum/attribute/skill/combat/axesmaces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_CAUTERY
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

/obj/item/weapon/surgery/cautery/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.cmode)
		return NONE

	if(istype(interacting_with, /obj/machinery/light/fueled))
		var/obj/machinery/light/fueled/forge = interacting_with
		if(forge.on)
			user.visible_message(span_info("[user] heats [src]."))
			fire_act(10)
			return ITEM_INTERACT_SUCCESS

	if(get_temperature() && iscarbon(interacting_with))
		var/mob/living/carbon/C = interacting_with
		var/obj/item/bodypart/part = C.get_bodypart(user.zone_selected)
		if(!part || part.skeletonized)
			balloon_alert(user, "nothing to cauterize!")
			return ITEM_INTERACT_BLOCKING

		// Hate
		if(!length(part.wounds))
			for(var/obj/item/organ/artery in part.getorganslotlist(ORGAN_SLOT_ARTERY))
				if(artery.damage)
					break
				balloon_alert(user, "no wounds!")
				return ITEM_INTERACT_BLOCKING

		var/on_who = "my"
		if(user != interacting_with)
			on_who = "[C]'s"

		user.visible_message(
			span_danger("[user] starts to cauterize [on_who] [parse_zone(user.zone_selected)]"),
			span_userdanger("I start to cauterize [on_who] [parse_zone(user.zone_selected)]"),
			span_userdanger("I hear flesh sizzle.")
		)

		if(!do_after(user, 3 SECONDS, C))
			return ITEM_INTERACT_BLOCKING

		for(var/datum/wound/bleeder as anything in part.wounds)
			bleeder.cauterize_wound()

		for(var/obj/item/organ/artery in part.getorganslotlist(ORGAN_SLOT_ARTERY))
			if(artery.damage)
				artery.applyOrganDamage(-artery.damage)

		part.bodypart_attacked_by(BCLASS_BURN, dam = 25, modifiers = list(CRIT_MOD_CHANCE = -100)) //painful, but the wounds go away eh?

		C.emote("scream")

		return ITEM_INTERACT_SUCCESS

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
	associated_skill = /datum/attribute/skill/combat/axesmaces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/weapon/surgery/hammer/Initialize(mapload)
	. = ..()
	item_flags &= ~SURGICAL_TOOL

/obj/item/weapon/surgery/hammer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.cmode)
		return NONE

	if(!ishuman(interacting_with))
		return NONE

	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine) < 10)
		return ITEM_INTERACT_BLOCKING

	if(interacting_with == user)
		user.visible_message(span_info("[user] begins smacking themself with a small hammer."))
	else
		user.visible_message(span_info("[user] begins to smack [interacting_with] with a small hammer."))

	if(!do_after(user, 0.5 SECONDS, interacting_with))
		return ITEM_INTERACT_BLOCKING

	interacting_with.visible_message(span_info("[interacting_with] jerks their knee after the hammer strikes!"))

	if(prob(1))
		playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)

	var/mob/living/carbon/human/human_target = interacting_with
	human_target.check_for_injuries(user, additional = TRUE)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A metal implement made for the drawing and injecting of various fluids."
	icon = 'icons/obj/medical.dmi'
	icon_state = "syringe"
	amount_per_transfer_from_this = 5
	fill_icon_thresholds = list(0, 1, 5, 10, 15)
	grid_width = 64
	grid_height = 32
	volume = 15
	reagent_flags = TRANSPARENT
	item_weight = 95 GRAMS

/obj/item/reagent_containers/syringe/proc/try_syringe(atom/target, mob/user)
	if(!target.reagents)
		return FALSE

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.can_inject())
			return FALSE

	return TRUE

/obj/item/reagent_containers/syringe/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE

	if(!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	var/contained = reagents.get_reagent_log_string()
	log_combat(user, target, "attempted to inject", src, addition="which had [contained]")

	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] is empty! Right-click to draw."))
		return ITEM_INTERACT_BLOCKING

	if(!isliving(target) && !target.is_injectable(user))
		to_chat(user, span_warning("You cannot directly fill [target]!"))
		return ITEM_INTERACT_BLOCKING

	if(target.reagents.holder_full())
		to_chat(user, span_notice("[target] is full."))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target != user)
			living_target.visible_message(
				span_danger("[user] is trying to inject [living_target]!"),
				span_userdanger("[user] is trying to inject you!"),
			)
			if(!do_after(user, 4 SECONDS, living_target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(!reagents.total_volume)
				return ITEM_INTERACT_BLOCKING
			if(living_target.reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
			living_target.visible_message(
				span_danger("[user] injects [living_target] with the syringe!"),
				span_userdanger("[user] injects you with the syringe!"),
			)

		if(living_target == user)
			living_target.log_message("injected themselves ([contained]) with [name]", LOG_ATTACK, color="orange")
		else
			log_combat(user, living_target, "injected", src, addition="which had [contained]")

	if(reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, method = INJECT))
		to_chat(user, span_notice("You inject [amount_per_transfer_from_this] units of the solution. The syringe now contains [reagents.total_volume] units."))
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/syringe/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE

	if(!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	if(reagents.holder_full())
		to_chat(user, span_notice("[src] is full."))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		var/drawn_amount = reagents.maximum_volume - reagents.total_volume
		if(target != user)
			target.visible_message(
				span_danger("[user] is trying to take a blood sample from [target]!"),
				span_userdanger("[user] is trying to take a blood sample from you!"),
			)
			if(!do_after(user, 4 SECONDS, target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
		if(living_target.transfer_blood_to(src, drawn_amount))
			user.visible_message(span_notice("[user] takes a blood sample from [living_target]."))
		else
			to_chat(user, span_warning("You are unable to draw any blood from [living_target]!"))
		return ITEM_INTERACT_SUCCESS

	if(!target.reagents.total_volume)
		to_chat(user, span_warning("[target] is empty!"))
		return ITEM_INTERACT_BLOCKING

	if(!target.is_drawable(user))
		to_chat(user, span_warning("You cannot directly remove reagents from [target]!"))
		return ITEM_INTERACT_BLOCKING

	var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user) // transfer from, transfer to - who cares?

	to_chat(user, span_notice("You fill [src] with [trans] units of the solution. It now contains [reagents.total_volume] units."))
	target.update_appearance()

	return ITEM_INTERACT_SUCCESS
