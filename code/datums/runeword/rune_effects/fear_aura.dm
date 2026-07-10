/datum/rune_effect/fear_aura
	var/reflect = 3
	COOLDOWN_DECLARE(fear)

/datum/rune_effect/fear_aura/apply_effects_from_list(list/effects)
	if(effects.len >= 1)
		reflect = effects[1]

/datum/rune_effect/fear_aura/get_description()
	return "[reflect] chance to fear when being hit."

/datum/rune_effect/fear_aura/get_combined_description(list/effects)
	var/total_increase = 0
	for(var/datum/rune_effect/fear_aura/effect in effects)
		total_increase += effect.reflect
	return "[total_increase] chance to fear when being hit."

/datum/rune_effect/fear_aura/apply_stat_effect(datum/component/modifications/source, obj/item/item)
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(check_equipped))
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(remove_stats))

/datum/rune_effect/fear_aura/proc/check_equipped(obj/item/source, mob/living/carbon/equipper, slot)
	if(!source.item_action_slot_check(slot, equipper))
		remove_stats(source, equipper)
		return
	equipper.AddElement(/datum/element/relay_attackers)
	RegisterSignal(equipper, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(retaliate))

/datum/rune_effect/fear_aura/proc/remove_stats(obj/item/source, mob/living/carbon/equipper, slot)
	equipper.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(equipper, COMSIG_ATOM_WAS_ATTACKED)

/datum/rune_effect/fear_aura/proc/retaliate(mob/living/attacked, mob/living/carbon/human/attacker, damage)
	if(!COOLDOWN_FINISHED(src, fear))
		return
	if(!istype(attacker))
		return
	var/odds = reflect * 10 / GET_MOB_ATTRIBUTE_VALUE(attacker, STAT_INTELLIGENCE)
	if(!prob(odds))
		return

	COOLDOWN_START(src, fear, 10 SECONDS)

	var/datum/cb = CALLBACK(attacker, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), attacked)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * attacker.total_multiplicative_slowdown())
