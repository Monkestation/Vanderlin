
/datum/action/cooldown/spell/psydonabsolve
	name = "ABSOLVE"
	spell_type = SPELL_PSYDONIC_MIRACLE
	spell_flags = SPELL_PSYDON
	spell_cost = 160
	charge_time = 1
	cast_range = 1
	sound = 'sound/magic/psyabsolution.ogg'
	invocation = "BE ABSOLVED!"
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	cooldown_time = 30 SECONDS // 60 seconds cooldown
	button_icon_state = "ABSOLVE"

/datum/action/cooldown/spell/psydonabsolve/cast(mob/living/carbon/human/H)
	. = ..()
	var/mob/living/user = owner
	if(!ishuman(H))
		to_chat(user, span_warning("ABSOLUTION is for those who walk in HIS image!"))
		return FALSE

	if(H == user)
		to_chat(user, span_warning("You cannot ABSOLVE yourself!"))
		return FALSE

	// Special case for dead targets
	if(H.stat >= DEAD)
		// Check if the target has a head, brain, and heart
		var/obj/item/bodypart/head = H.get_bodypart("head")
		var/obj/item/organ/brain/brain = H.getorganslot(ORGAN_SLOT_BRAIN)
		var/obj/item/organ/heart/heart = H.getorganslot(ORGAN_SLOT_HEART)

		if(head && brain && heart)
			if(!H.mind)
				return FALSE
			if(alert(user, "REACH OUT AND PULL?", "THERE'S NO LUX IN THERE", "YES", "NO") != "YES")
				return FALSE
			to_chat(user, span_warning("You attempt to revive [H] by ABSOLVING them!"))
			// Dramatic effect
			user.visible_message(span_danger("[user] grabs [H] by the wrists, attempting to ABSOLVE them!"))
			if(alert(H, "They want to ABSOLVE you. Will you let them?", "ABSOLUTION", "I'll allow it", "I refuse") != "I'll allow it")
				H.visible_message(span_notice("Nothing happens."))
				return FALSE
			// Create visual effects
			H.apply_status_effect(/datum/status_effect/buff/psyvived)
			// Kill the caster
			user.say("MY LIFE FOR YOURS! LIVE, AS DOES HE!", forced = TRUE)
			user.death()
			// Revive the target
			H.revive(HEAL_ALL)
			H.grab_ghost(force = TRUE, grab_spirit = TRUE) // even suicides
			H.emote("breathgasp")
			H.adjust_jitter(100 SECONDS)
			H.update_body()
			GLOB.vanderlin_round_stats[STATS_LUX_REVIVALS]++
			ADD_TRAIT(H, TRAIT_IWASREVIVED, "[type]")
			H.apply_status_effect(/datum/status_effect/buff/psyvived)
			user.apply_status_effect(/datum/status_effect/buff/psyvived)
			H.visible_message(span_notice("[H] is ABSOLVED!"), span_green("I awake from the void."))
			H.mind.remove_antag_datum(/datum/antagonist/zombie)
			return TRUE
		else
			to_chat(user, span_warning("[H] is missing vital organs and cannot be revived!"))
			return FALSE

	// Transfer afflictions from the target to the caster

	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)

	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Transfer blood
	var/blood_transfer = 0
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		blood_transfer = BLOOD_VOLUME_NORMAL - H.blood_volume
		H.blood_volume = BLOOD_VOLUME_NORMAL
		user.blood_volume -= blood_transfer
		to_chat(user, span_warning("You feel your blood drain into [H]!"))
		to_chat(H, span_notice("You feel your blood replenish!"))

	// Visual effects
	user.visible_message(span_danger("[user] absolves [H]'s suffering!"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")

	// Notify the user and target
	to_chat(user, span_warning("You absolve [H] of their injuries!"))
	to_chat(H, span_notice("[user] absolves you of your injuries!"))

	return TRUE
