/datum/enchantment/phoenix_guard
	enchantment_name = "Phoenix Guard"
	examine_text = "It gives off radiant heat."
	essence_recipe = list(
		/datum/thaumaturgical_essence/fire = 35,
		/datum/thaumaturgical_essence/life = 25
	)
	var/last_used

/datum/enchantment/phoenix_guard/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_HIT_RESPONSE
	RegisterSignal(item, COMSIG_ITEM_HIT_RESPONSE, PROC_REF(on_hit_response))

/datum/enchantment/phoenix_guard/proc/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 100)
		return
	attacker.adjust_fire_stacks(5)
	attacker.IgniteMob()
	attacker.visible_message(span_danger("[I] sets [attacker] on fire!"))
	src.last_used = world.time
