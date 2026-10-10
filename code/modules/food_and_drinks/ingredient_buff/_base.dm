/**
 * Describes one buff an ingredient can contribute to a cooked dish.
 * Snapshotted per-craft, so quality is frozen at the time of cooking.
 */
/datum/ingredient_buff
	var/name = "ingredient buff"
	///the weight we have for random choice, if 0 we simply don't add
	var/random_choice = 10
	var/status_effect_type = /datum/status_effect/buff/ingredient
	var/list/base_stats = list()
	var/base_duration = 10 MINUTES
	var/quality_potency_step = 0.25
	var/quality_duration_step = 0.1

	// Snapshot data, frozen at craft time
	var/quality = 0
	var/composition_required = 20
	/// Percent of the dish's buff-bearing content this buff represented when assembled (100 for a raw ingredient)
	var/composition_share = 100
	/// Condiment/modifier multipliers, stacked multiplicatively
	var/potency_mult = 1
	var/duration_mult = 1

/datum/ingredient_buff/proc/copy()
	var/datum/ingredient_buff/new_buff = new type()
	new_buff.quality = quality
	new_buff.composition_required = composition_required
	new_buff.composition_share = composition_share
	new_buff.potency_mult = potency_mult
	new_buff.duration_mult = duration_mult
	return new_buff

/datum/ingredient_buff/proc/get_scaled_stats(multiplier = 1)
	var/list/scaled = list()
	var/mult = 1 + (max(0, quality) * quality_potency_step)
	for(var/stat in base_stats)
		var/base = base_stats[stat]
		var/value = FLOOR(base * mult, 1)
		value = FLOOR(value * multiplier * potency_mult, 1)
		if(!value)
			value = (base > 0) ? 1 : -1
		scaled[stat] = value
	return scaled

/datum/ingredient_buff/proc/get_scaled_duration()
	return round(base_duration * (1 + (max(0, quality) * quality_duration_step)) * duration_mult)

/datum/ingredient_buff/proc/apply_to(mob/living/eater, multiplier = 1)
	if(!istype(eater))
		return
	eater.apply_status_effect(status_effect_type, get_scaled_duration(), get_scaled_stats(multiplier), quality, multiplier)

/datum/ingredient_buff/proc/examine_string()
	if(length(base_stats))
		var/datum/attribute/stat/stat = base_stats[1]
		return span_notice("When cooked with boosts [initial(stat.name)] for a time.")
	return FALSE

/datum/status_effect/buff/ingredient
	id = "ingredient"
	status_type = STATUS_EFFECT_REFRESH
	duration = 5 MINUTES
	tick_interval = STATUS_EFFECT_NO_TICK
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	alert_type = /atom/movable/screen/alert/status_effect/buff/ingredient
	var/quality = 1

/datum/status_effect/buff/ingredient/on_creation(mob/living/new_owner, duration_override, list/scaled_stats, _quality = 1, multiplier = 1)
	if(islist(scaled_stats) && length(scaled_stats))
		effectedstats = scaled_stats.Copy()
	quality = max(1, _quality) * multiplier
	return ..()

/datum/status_effect/buff/ingredient/refresh(mob/living/new_owner, duration_override, list/scaled_stats, _quality = 1, multiplier = 1)
	if(!islist(scaled_stats) || !length(scaled_stats))
		return ..()
	if(get_stat_power(scaled_stats) < get_stat_power(effectedstats))
		return
	owner.remove_stat_modifier("[id]")
	effectedstats = scaled_stats.Copy()
	owner.set_stat_modifier("[id]", effectedstats)
	quality = max(1, _quality) * multiplier
	if(isnum(duration_override))
		initial_duration = duration_override
	duration = initial_duration

/datum/status_effect/buff/ingredient/proc/get_stat_power(list/stats)
	var/power = 0
	for(var/stat in stats)
		power += abs(stats[stat])
	return power

/atom/movable/screen/alert/status_effect/buff/ingredient
	name = "Ingredient Buff"
	desc = "You feel invigorated."

/atom/movable/screen/alert/status_effect/buff/ingredient/after_attach()
	name = attached_effect.id
