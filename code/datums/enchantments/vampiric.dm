
/datum/enchantment/vampiric
	enchantment_name = "Vampiric"
	examine_text = "This weapon has a dark, blood-red aura."
	enchantment_color = "#8B0000"
	enchantment_end_message = "The vampiric aura fades away."
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 35,
		/datum/thaumaturgical_essence/void = 35,
		/datum/thaumaturgical_essence/poison = 20
	)

/datum/enchantment/vampiric/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/vampiric/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(isliving(target) && isliving(user))
		var/mob/living/victim = target
		var/mob/living/attacker = user

		var/damage_dealt = 8
		victim.apply_damage(damage_dealt, BRUTE)

		var/heal_amount = damage_dealt / 2
		attacker.heal_bodypart_damage(heal_amount, heal_amount)

		to_chat(attacker, span_green("You feel invigorated as your weapon drains life!"))
		to_chat(victim, span_warning("You feel your life force being drained!"))
