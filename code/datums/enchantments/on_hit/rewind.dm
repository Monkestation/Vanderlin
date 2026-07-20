/datum/enchantment/on_hit/rewind
	enchantment_name = "Temporal Rewind"
	examine_text = "It seems both old and new at the same time."
	essence_recipe = list(
		/datum/thaumaturgical_essence/cycle = 50,
		/datum/thaumaturgical_essence/magic = 30,
		/datum/thaumaturgical_essence/void = 20
	)
	cooldown_time = 10 SECONDS
	var/active_item = FALSE

/datum/enchantment/on_hit/rewind/register_triggers(atom/item)
	. = ..()
	// on_hit/on_simple_attack handled by parent; add the defensive signal manually
	registered_signals += COMSIG_ITEM_HIT_RESPONSE
	RegisterSignal(item, COMSIG_ITEM_HIT_RESPONSE, PROC_REF(on_hit_response))

/datum/enchantment/on_hit/rewind/apply_attack_effects(obj/item/source, mob/living/carbon/human/attacked, mob/living/carbon/attacker, actual_damage)
	var/turf/target_turf = get_turf(attacker)
	active_item = TRUE
	sleep(5 SECONDS)
	to_chat(attacker, span_notice("[source] rewinds you back in time!"))
	do_teleport(attacker, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
	active_item = FALSE

/datum/enchantment/on_hit/rewind/proc/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(!COOLDOWN_FINISHED(src, hit_cooldown))
		return
	if(active_item)
		return
	var/turf/target_turf = get_turf(owner)
	active_item = TRUE
	COOLDOWN_START(src, hit_cooldown, cooldown_time)
	sleep(5 SECONDS)
	to_chat(owner, span_notice("[I] rewinds you back in time!"))
	do_teleport(owner, target_turf, channel = TELEPORT_CHANNEL_QUANTUM)
	active_item = FALSE
