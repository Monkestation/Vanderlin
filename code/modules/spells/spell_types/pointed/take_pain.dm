/datum/action/cooldown/spell/transfer_pain
	name = "Take Pain"
	button_icon_state = "curse"
	sound = null
	has_visual_effects = FALSE

	cast_range = 1
	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/transfer_pain/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return

	if(!ishuman(owner))
		if(feedback)
			to_chat(owner, span_warning("The burden is too great for this body"))
		return FALSE

/datum/action/cooldown/spell/transfer_pain/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/transfer_pain/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.stat == DEAD)
		to_chat(owner, span_warning("[cast_on] is beyond help."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/transfer_pain/cast(mob/living/carbon/human/cast_on)
	. = ..()

	var/mob/living/carbon/human/follower = owner

	owner.visible_message(
		span_notice("[owner] begins a solemn prayer to Pestra."),
		span_notice("You begin the pain transfer ritual..."),
	)

	if(!do_after(owner, 5 SECONDS, cast_on))
		to_chat(owner, span_warning("The ritual was interrupted!"))
		return

	var/total_pain_to_transfer = 0
	var/list/affected_wounds = list()

	for(var/obj/item/bodypart/BP in cast_on.bodyparts)
		for(var/datum/wound/W in BP.wounds)
			if(W.woundpain <= W.sewn_woundpain)
				continue
			var/pain_reduction = W.woundpain * 0.5
			total_pain_to_transfer += pain_reduction
			W.woundpain = max(W.sewn_woundpain, W.woundpain - pain_reduction)
			affected_wounds += W

	for(var/datum/wound/W in cast_on.simple_wounds)
		if(W.woundpain <= W.sewn_woundpain)
			continue
		var/pain_reduction = W.woundpain * 0.5
		total_pain_to_transfer += pain_reduction
		W.woundpain = max(W.sewn_woundpain, W.woundpain - pain_reduction)
		affected_wounds += W

	if(total_pain_to_transfer <= 0)
		to_chat(owner, span_warning("[cast_on] is not in pain!"))
		return

	var/pain_percentage = 0
	if(follower.get_complex_pain() > 0)
		pain_percentage = (total_pain_to_transfer / follower.get_complex_pain()) * 100
	else
		pain_percentage = 100

	var/wound_severity_mod = clamp(pain_percentage / 50, 0.5, 3.0)

	var/pain_per_wound = total_pain_to_transfer / max(1, length(follower.bodyparts))
	for(var/obj/item/bodypart/BP in follower.bodyparts)
		var/datum/wound/existing_wound
		for(var/datum/wound/W in BP.wounds)
			if(W.woundpain > 0)
				existing_wound = W
				break

		if(existing_wound)
			existing_wound.woundpain += (pain_per_wound * wound_severity_mod) * 3
			existing_wound.whp += ((pain_per_wound / 2) * wound_severity_mod) * 2
			if(existing_wound.severity < WOUND_SEVERITY_CRITICAL && wound_severity_mod > 1.5)
				existing_wound.severity = WOUND_SEVERITY_CRITICAL
		else
			var/datum/wound/new_wound = new /datum/wound()
			new_wound.woundpain = (pain_per_wound * wound_severity_mod) * 3
			new_wound.whp += ((pain_per_wound / 2) * wound_severity_mod) * 2
			new_wound.sewn_woundpain = 0
			new_wound.severity = WOUND_SEVERITY_SEVERE
			new_wound.can_sew = FALSE
			new_wound.can_cauterize = FALSE
			new_wound.passive_healing = max(1, 3 - wound_severity_mod)

			if(wound_severity_mod > 2.0)
				new_wound.name = "transferred agony"
			else if(wound_severity_mod > 1.0)
				new_wound.name = "transferred serious pain"
			else
				new_wound.name = "transferred pain"

			new_wound.apply_to_bodypart(BP)

	playsound(get_turf(owner), 'sound/magic/heal.ogg', 50, TRUE)
	to_chat(owner, span_notice("You take [cast_on]'s pain upon yourself!"))
	to_chat(cast_on, span_notice("You feel [owner] take some of your pain away!"))
	SEND_SIGNAL(owner, COMSIG_PAIN_TRANSFERRED, pain_percentage)
