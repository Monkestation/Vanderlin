/datum/rune_effect/player_stat
	var/increase = 3
	var/stat_key = STAT_CONSTITUTION
	var/static/number = 1
	var/my_number = 1

/datum/rune_effect/player_stat/New(list/effect_data)
	. = ..()
	number++
	my_number = number

/datum/rune_effect/player_stat/apply_effects_from_list(list/effects)
	if(effects.len >= 1)
		increase = effects[1]

/datum/rune_effect/player_stat/get_description()
	return "+[increase] [stat_key]."

/datum/rune_effect/player_stat/get_combined_description(list/effects)
	var/total_increase = 0
	for(var/datum/rune_effect/player_stat/effect in effects)
		total_increase += effect.increase
	return "+[total_increase] [stat_key]"

/datum/rune_effect/player_stat/apply_stat_effect(datum/component/modifications/source, obj/item/item)
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(check_equipped))
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(remove_stats))

/datum/rune_effect/player_stat/proc/check_equipped(obj/item/source, mob/living/carbon/equipper, slot)
	if(!source.item_action_slot_check(slot, equipper))
		remove_stats(source, equipper)
		return
	equipper.set_stat_modifier("[my_number]_[type]", stat_key, increase)

/datum/rune_effect/player_stat/proc/remove_stats(obj/item/source, mob/living/carbon/equipper, slot)
	equipper.remove_stat_modifier("[my_number]_[type]")

/datum/rune_effect/player_stat/constitution


/datum/rune_effect/player_stat/intelligence
	stat_key = STAT_INTELLIGENCE
