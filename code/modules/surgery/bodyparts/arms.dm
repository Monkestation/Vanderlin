

/obj/item/bodypart/l_arm
	name = "left arm"
	desc = ""
	icon_state = "default_human_l_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 100
	body_zone = BODY_ZONE_L_ARM
	body_part = ARM_LEFT
	aux_zone = BODY_ZONE_PRECISE_L_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 1
	px_x = -6
	px_y = 0
	subtargets = list(BODY_ZONE_PRECISE_L_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM)
	offset = OFFSET_GLOVES
	dismember_wound = /datum/wound/dismemberment/l_arm
	can_be_disabled = TRUE

	artery_type = ARTERY_L_ARM

/obj/item/bodypart/l_arm/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_L_ARM))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_L_ARM))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM))
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_L_ARM))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_L_ARM trait.
/obj/item/bodypart/l_arm/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_L_ARM trait.
/obj/item/bodypart/l_arm/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_L_ARM)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_L_ARM))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_L_ARM), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/l_arm/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='boldwarning'>I can no longer move my [name]!</span>")
	// 	if(held_index)
	// 		owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_hands(owner.usable_hands - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(!bodypart_disabled)
		owner.set_usable_hands(owner.usable_hands + 1)

	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/hand_screen_object = owner.hud_used.hand_slots["[held_index]"]
		hand_screen_object?.update_appearance(UPDATE_OVERLAYS)

/obj/item/bodypart/l_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_l_arm"
	animal_origin = MONKEY_BODYPART
	px_x = -5
	px_y = -3


/obj/item/bodypart/l_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/r_arm
	name = "right arm"
	desc = ""
	icon_state = "default_human_r_arm"
	attack_verb = list("slapped", "punched")
	max_damage = 100
	body_zone = BODY_ZONE_R_ARM
	body_part = ARM_RIGHT
	aux_zone = BODY_ZONE_PRECISE_R_HAND
	aux_layer = HANDS_PART_LAYER
	body_damage_coeff = 1
	held_index = 2
	px_x = 6
	px_y = 0
	subtargets = list(BODY_ZONE_PRECISE_R_HAND)
	grabtargets = list(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_ARM)
	offset = OFFSET_GLOVES
	dismember_wound = /datum/wound/dismemberment/r_arm
	can_be_disabled = TRUE

	artery_type = ARTERY_R_ARM

/obj/item/bodypart/r_arm/set_owner(new_owner)
	. = ..()
	if(. == FALSE)
		return
	if(.)
		var/mob/living/carbon/old_owner = .
		if(HAS_TRAIT(old_owner, TRAIT_PARALYSIS_R_ARM))
			UnregisterSignal(old_owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM))
			if(!owner || !HAS_TRAIT(owner, TRAIT_PARALYSIS_R_ARM))
				REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
		else
			UnregisterSignal(old_owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM))
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_PARALYSIS_R_ARM))
			ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_loss))
		else
			REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_gain))

///Proc to react to the owner gaining the TRAIT_PARALYSIS_R_ARM trait.
/obj/item/bodypart/r_arm/proc/on_owner_paralysis_gain(mob/living/carbon/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_loss))

///Proc to react to the owner losing the TRAIT_PARALYSIS_R_ARM trait.
/obj/item/bodypart/r_arm/proc/on_owner_paralysis_loss(mob/living/carbon/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, TRAIT_PARALYSIS_R_ARM)
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS_R_ARM))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS_R_ARM), PROC_REF(on_owner_paralysis_gain))

/obj/item/bodypart/r_arm/set_disabled(new_disabled)
	. = ..()
	if(isnull(.) || !owner)
		return
	// if(disabled == BODYPART_DISABLED_DAMAGE || disabled == BODYPART_DISABLED_WOUND)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer move my [name]!</span>")
	// 	if(held_index)
	// 		owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	// else if(disabled == BODYPART_DISABLED_PARALYSIS)
	// 	if(owner.stat < DEAD)
	// 		to_chat(owner, "<span class='danger'>I can no longer feel my [name].</span>")
	if(!.)
		if(bodypart_disabled)
			owner.set_usable_hands(owner.usable_hands - 1)
			if(owner.stat < UNCONSCIOUS)
				to_chat(owner, "<span class='userdanger'>You lose control of your [name]!</span>")
			if(held_index)
				owner.dropItemToGround(owner.get_item_for_held_index(held_index))
	else if(!bodypart_disabled)
		owner.set_usable_hands(owner.usable_hands + 1)

	if(owner.hud_used)
		var/atom/movable/screen/inventory/hand/hand_screen_object = owner.hud_used.hand_slots["[held_index]"]
		hand_screen_object?.update_appearance(UPDATE_OVERLAYS)

/obj/item/bodypart/r_arm/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_r_arm"
	animal_origin = MONKEY_BODYPART
	px_x = 5
	px_y = -3

/obj/item/bodypart/r_arm/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART
