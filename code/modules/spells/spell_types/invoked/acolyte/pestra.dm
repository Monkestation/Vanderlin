// Diagnose
/obj/effect/proc_holder/spell/invoked/diagnose
	name = "Diagnose"
	overlay_state = "diagnose"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS //very stupidly simple spell
	miracle = TRUE
	healing_miracle = TRUE
	devotion_cost = 5 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/diagnose/secular
	name = "Secular Diagnosis"
	overlay_state = "diagnose"
	range = 1
	associated_skill = /datum/skill/misc/medicine
	miracle = FALSE
	devotion_cost = 0 //Doctors are not clerics
	uses_mana = FALSE
	healing_miracle = FALSE

/obj/effect/proc_holder/spell/invoked/diagnose/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/human_target = targets[1]
		human_target.check_for_injuries(user, additional = TRUE)
		return ..()
	return FALSE

// Limb or organ attachment
/obj/effect/proc_holder/spell/invoked/attach_bodypart
	name = "Bodypart Miracle"
	overlay_state = "limb_attach"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	req_items = list(/obj/item/clothing/neck/psycross)
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/gore/flesh_eat_03.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 60 SECONDS //attaching a limb is pretty intense
	miracle = TRUE
	healing_miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/attach_bodypart/proc/get_organs(mob/living/target, mob/living/user)
	var/list/missing_organs = list(
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_TONGUE,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_APPENDIX,
	)
	for(var/missing_organ_slot in missing_organs)
		if(!target.getorganslot(missing_organ_slot))
			continue
		missing_organs -= missing_organ_slot
	if(!length(missing_organs))
		return
	var/list/organs = list()
	//try to get from user's hands first
	for(var/obj/item/organ/potential_organ in user?.held_items)
		if(potential_organ.owner || !(potential_organ.slot in missing_organs))
			continue
		organs += potential_organ
	//then target's hands
	for(var/obj/item/organ/dismembered in target.held_items)
		if(dismembered.owner || !(dismembered.slot in missing_organs))
			continue
		organs += dismembered
	//then finally, 1 tile range around target
	for(var/obj/item/organ/dismembered in range(1, target))
		if(dismembered.owner || !(dismembered.slot in missing_organs))
			continue
		organs += dismembered
	return organs

/obj/effect/proc_holder/spell/invoked/attach_bodypart/proc/get_limbs(mob/living/target, mob/living/user)
	var/list/missing_limbs = target.get_missing_limbs()
	if(!length(missing_limbs))
		return
	var/list/limbs = list()
	//try to get from user's hands first
	for(var/obj/item/bodypart/potential_limb in user?.held_items)
		if(potential_limb.owner || !(potential_limb.body_zone in missing_limbs))
			continue
		limbs += potential_limb
	//then target's hands
	for(var/obj/item/bodypart/dismembered in target.held_items)
		if(dismembered.owner || !(dismembered.body_zone in missing_limbs))
			continue
		limbs += dismembered
	//then finally, 1 tile range around target
	for(var/obj/item/bodypart/dismembered in range(1, target))
		if(dismembered.owner || !(dismembered.body_zone in missing_limbs))
			continue
		limbs += dismembered
	return limbs

// consider adding functionality to regrow one entire organ or limb per casting?
/obj/effect/proc_holder/spell/invoked/attach_bodypart/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/human_target = targets[1]
		for(var/obj/item/bodypart/limb as anything in get_limbs(human_target, user))
			if(!limb?.attach_limb(human_target))
				continue
			human_target.visible_message("<span class='info'>\The [limb] attaches itself to [human_target]!</span>", \
								"<span class='notice'>\The [limb] attaches itself to me!</span>")
		for(var/obj/item/organ/organ as anything in get_organs(human_target, user))
			if(!organ?.Insert(human_target))
				continue
			human_target.visible_message("<span class='info'>\The [organ] attaches itself to [human_target]!</span>", \
								"<span class='notice'>\The [organ] attaches itself to me!</span>")
		// if(!(human_target.mob_biotypes & MOB_UNDEAD))
		// 	for(var/obj/item/bodypart/limb as anything in human_target.bodyparts)
		// 		limb.rotted = FALSE
		// 		limb.skeletonized = FALSE
		user.update_inv_hands()
		human_target.update_body()
		return ..()
	return FALSE

// Cure rot
/obj/effect/proc_holder/spell/invoked/cure_rot
	name = "Cure Rot"
	overlay_state = "cure_rot"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/psycross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	healing_miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/cure_rot/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/lux_state = target.get_lux_status()
		if(lux_state != LUX_HAS_LUX)
			return
		if(target == user)
			return FALSE
		var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)
		var/has_rot = was_zombie
		if(!has_rot && iscarbon(target))
			var/mob/living/carbon/stinky = target
			for(var/obj/item/bodypart/bodypart as anything in stinky.bodyparts)
				if(bodypart.rotted || bodypart.skeletonized)
					has_rot = TRUE
					break
		if(!has_rot)
			to_chat(user, "<span class='warning'>Nothing happens.</span>")
			return FALSE
		if(was_zombie)
			if(was_zombie.become_rotman && prob(5)) //5% chance to NOT become a rotman
				was_zombie.become_rotman = FALSE
			target.mind.remove_antag_datum(/datum/antagonist/zombie)
			target.death()
			if(!HAS_TRAIT(target, TRAIT_IWASUNZOMBIFIED))
				ADD_TRAIT(target, TRAIT_IWASUNZOMBIFIED, "[type]")
		var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
		if(rot)
			rot.amount = 0
		if(iscarbon(target))
			var/mob/living/carbon/stinky = target
			for(var/obj/item/bodypart/rotty in stinky.bodyparts)
				rotty.rotted = FALSE
				rotty.skeletonized = FALSE
				rotty.update_limb()
				if(rotty.can_be_disabled)
					rotty.update_disabled()
		target.update_body()
		if(!HAS_TRAIT(target, TRAIT_ROTMAN))
			target.visible_message("<span class='notice'>The rot leaves [target]'s body!</span>", "<span class='green'>I feel the rot leave my body!</span>")
		else
			target.visible_message("<span class='warning'>The rot fails to leave [target]'s body!</span>", "<span class='warning'>I feel no different...</span>")
		if(ishuman(target))
			var/mob/living/carbon/human/human = target
			if(human.funeral)
				if(human.client)
					to_chat(human, span_warning("My funeral rites were undone!"))
				else
					var/mob/dead/observer/ghost = human.get_ghost(TRUE, TRUE)
					if(ghost)
						to_chat(ghost, span_warning("My funeral rites were undone!"))
			human.funeral = FALSE
		if(target.stat < DEAD)
			target.remove_client_colour(/datum/client_colour/monochrome/death)
		return ..()
	return FALSE

/obj/effect/proc_holder/spell/invoked/cure_rot/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross."))
		return FALSE
	return TRUE
