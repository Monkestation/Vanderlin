
/mob/living/carbon/human/handle_suicide()
	if(!suicide_alert())
		return

	set_suicide(TRUE) //need to be called before calling suicide_act as fuck knows what suicide_act will do with your suicide

	var/obj/item/held_item = get_active_held_item()
	var/damage_type = SEND_SIGNAL(src, COMSIG_HUMAN_SUICIDE_ACT) || held_item?.suicide_act(src)

	if(damage_type)
		if(apply_suicide_damage(held_item, damage_type))
			final_checkout(held_item, apply_damage = FALSE)
		return

	final_checkout(held_item, apply_damage = TRUE)

/mob/living/carbon/human/apply_suicide_damage(obj/item/suicide_tool, damage_type = NONE)
	// if we don't have any damage_type passed in, default to parent.
	if(damage_type == NONE)
		return ..()

	if(damage_type & MANUAL_SUICIDE_NONLETHAL)
		set_suicide(FALSE)
		return FALSE

	if(damage_type & MANUAL_SUICIDE) // Assume that the suicide tool will handle the death.
		suicide_log(suicide_tool)
		return FALSE

	if(damage_type & (BRUTELOSS | FIRELOSS | OXYLOSS | TOXLOSS))
		handle_suicide_damage_spread(damage_type)
		return TRUE

	return ..() //if all else fails, hope parent accounts for it or just do whatever damage that parent prescribes.

/// Any "special" suicide messages are handled by the related item that the mob uses to kill itself. This is just messages for when it's done with the bare hands.
/mob/living/carbon/human/send_applicable_messages(message_type)
	var/suicide_message
	switch(used_intent.type)
		if(INTENT_DISARM)
			suicide_message = pick("[src] is attempting to push [p_their()] own head off [p_their()] shoulders! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is pushing [p_their()] thumbs into [p_their()] eye sockets! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is ripping [p_their()] own arms off! It looks like [p_theyre()] trying to commit suicide.")//heheh get it?
		if(INTENT_GRAB)
			suicide_message = pick("[src] is attempting to pull [p_their()] own head off! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is aggressively grabbing [p_their()] own neck! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is pulling [p_their()] eyes out of their sockets! It looks like [p_theyre()] trying to commit suicide.")
		if(INTENT_HELP)
			suicide_message = pick("[src] is hugging [p_them()]self to death! It looks like [p_theyre()] trying to commit suicide.", \
										"[src] is high-fiving [p_them()]self to death! It looks like [p_theyre()] trying to commit suicide.", \
										"[src] is getting too high on life! It looks like [p_theyre()] trying to commit suicide.")
		else
			suicide_message = pick("[src] is attempting to bite [p_their()] tongue off! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is jamming [p_their()] thumbs into [p_their()] eye sockets! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is twisting [p_their()] own neck! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is holding [p_their()] breath! It looks like [p_theyre()] trying to commit suicide.")

	visible_message(span_danger(suicide_message), span_userdanger(suicide_message), span_hear(get_blind_suicide_message()))

/mob/living/carbon/human/suicide_log(obj/item/suicide_tool)
	var/suicide_tool_type = suicide_tool?.type
	// var/list/suicide_data = null // log_message() is nullsafe for the data field
	if(!isnull(suicide_tool))
		// suicide_data = list("suicide tool" = suicide_tool_type)
		SSblackbox.record_feedback("tally", "suicide_item", 1, suicide_tool_type)

	investigate_log("has died from committing suicide[suicide_tool ? " with [suicide_tool] ([suicide_tool_type])" : ""].", INVESTIGATE_DEATHS)
	log_message("(job: [src.job ? "[src.job]" : "None"]) committed suicide", LOG_ATTACK)
