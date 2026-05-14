/datum/enchantment/frostveil
	enchantment_name = "Frostveil"
	examine_text = "It feels rather cold."
	essence_recipe = list(
		/datum/thaumaturgical_essence/frost = 40,
		/datum/thaumaturgical_essence/void = 20
	)
	COOLDOWN_DECLARE(frost_stack_cooldown)

/datum/enchantment/frostveil/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_HIT_RESPONSE
	RegisterSignal(item, COMSIG_ITEM_HIT_RESPONSE, PROC_REF(on_hit_response))

/datum/enchantment/frostveil/proc/on_hit_response(obj/item/I, mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	if(!COOLDOWN_FINISHED(src, frost_stack_cooldown))
		return
	if(isliving(attacker))
		apply_frost_stack(attacker, 3)
		COOLDOWN_START(src, frost_stack_cooldown, 10 SECONDS)
