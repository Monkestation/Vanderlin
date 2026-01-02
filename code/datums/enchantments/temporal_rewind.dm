/datum/enchantment/rewind
	enchantment_name = "Temporal Rewind"
	examine_text = "Its seems both hold and new at the same time."
	essence_recipe = list(
		/datum/thaumaturgical_essence/cycle = 50,
		/datum/thaumaturgical_essence/magic = 30,
		/datum/thaumaturgical_essence/void = 20
	)
	var/last_used
	var/active_item = FALSE
	var/warned = FALSE

/datum/enchantment/rewind/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))
	registered_signals += COMSIG_ITEM_HIT_RESPONSE
	RegisterSignal(item, COMSIG_ITEM_HIT_RESPONSE, PROC_REF(on_hit_response))

/datum/enchantment/rewind/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + 100)
		return
	else
		var/turf/target_turf = get_turf(user)
		active_item = TRUE
		sleep(5 SECONDS)
		to_chat(user, span_notice("[source] rewinds you back in time!"))
		do_teleport(user, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
		src.last_used = world.time

/datum/enchantment/rewind/proc/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 100)
		return
	if(!active_item)
		var/turf/target_turf = get_turf(owner)
		active_item = TRUE
		sleep(5 SECONDS)
		to_chat(owner, span_notice("[I] rewinds you back in time!"))
		do_teleport(owner, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
		src.last_used = world.time
		active_item = FALSE
