/datum/enchantment/frostveil
	enchantment_name = "Frostveil"
	examine_text = "It feels rather cold."
	essence_recipe = list(
		/datum/thaumaturgical_essence/frost = 40,
		/datum/thaumaturgical_essence/void = 20
	)
	var/last_used

/datum/enchantment/frostveil/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))
	registered_signals += COMSIG_ITEM_HIT_RESPONSE
	RegisterSignal(item, COMSIG_ITEM_HIT_RESPONSE, PROC_REF(on_hit_response))

/datum/enchantment/frostveil/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + 10 SECONDS)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.apply_status_effect(/datum/status_effect/debuff/cold)
		targeted.visible_message(span_danger("[source] chills [targeted]!"))
		src.last_used = world.time

/datum/enchantment/frostveil/proc/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 10 SECONDS)
		return
	if(isliving(attacker))
		attacker.apply_status_effect(/datum/status_effect/debuff/cold)
		attacker.visible_message(span_danger("[I] chills [attacker]!"))
		src.last_used = world.time
