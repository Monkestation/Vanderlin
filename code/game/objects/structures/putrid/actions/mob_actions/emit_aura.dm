/datum/action/cooldown/meatvine/personal/emit_aura
	name = "Aura"
	desc = "Emit an aura that buffs nearby meatvines."
	button_icon_state = "aura"
	cooldown_time = 30 SECONDS
	personal_resource_cost = 15
	var/aura_range = 3
	var/aura_duration = 20 SECONDS
	var/status_effect_type = /datum/status_effect/buff/meatvine_gigantism
	var/datum/proximity_monitor/advanced/meatvine_aura/aura_field

/datum/action/cooldown/meatvine/personal/emit_aura/Remove(mob/living/remove_from)
	QDEL_NULL(aura_field)
	return ..()

/datum/action/cooldown/meatvine/personal/emit_aura/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return FALSE

	aura_field = new /datum/proximity_monitor/advanced/meatvine_aura(user, aura_range, FALSE)
	aura_field.status_type = status_effect_type
	aura_field.aura_duration = aura_duration
	aura_field.recalculate_field(full_recalc = TRUE)

	user.visible_message(
		span_danger("[user] begins radiating a powerful aura!"),
		span_boldnotice("You activate your aura!")
	)

	for(var/mob/living/simple_animal/hostile/retaliate/meatvine/ally in range(aura_range, user))
		if(ally.master == user.master && ally != user)
			ally.apply_status_effect(status_effect_type, aura_duration)

	addtimer(CALLBACK(src, PROC_REF(deactivate_aura)), aura_duration)

	. = ..()
	return TRUE

/datum/action/cooldown/meatvine/personal/emit_aura/proc/deactivate_aura()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(istype(user))
		to_chat(user, span_warning("Your aura fades."))
	QDEL_NULL(aura_field)

/datum/proximity_monitor/advanced/meatvine_aura
	edge_is_a_field = TRUE
	var/datum/weakref/master_ref
	var/status_type
	var/aura_duration = 20 SECONDS

/datum/proximity_monitor/advanced/meatvine_aura/New(atom/_host, range, _ignore_if_not_on_turf = TRUE)
	. = ..(_host, range, _ignore_if_not_on_turf)
	if(istype(_host, /mob/living/simple_animal/hostile/retaliate/meatvine))
		var/mob/living/simple_animal/hostile/retaliate/meatvine/vine_host = _host
		master_ref = WEAKREF(vine_host.master)

/datum/proximity_monitor/advanced/meatvine_aura/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	if(!istype(movable, /mob/living/simple_animal/hostile/retaliate/meatvine))
		return

	var/mob/living/simple_animal/hostile/retaliate/meatvine/vine = movable
	var/obj/effect/meatvine_controller/master = master_ref?.resolve()

	if(!master || vine.master != master)
		return

	if(vine == host)
		return

	vine.apply_status_effect(status_type, aura_duration)

/datum/status_effect/buff/meatvine_speed
	id = "meatvine_speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/meatvine_speed
	effectedstats = list(STATKEY_SPD = 3)
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/buff/meatvine_speed
	name = "Speed Aura"
	desc = "Your speed is enhanced by a nearby ally's aura!"
	icon_state = "buff_speed"

/datum/status_effect/buff/meatvine_endurance
	id = "meatvine_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/meatvine_endurance
	effectedstats = list(STATKEY_END = 2, STATKEY_CON = 2)
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/buff/meatvine_endurance
	name = "Endurance Aura"
	desc = "Your endurance and constitution are enhanced by a nearby ally's aura!"
	icon_state = "buff_endurance"

/datum/status_effect/buff/meatvine_gigantism
	id = "meatvine_gigantism"
	alert_type = /atom/movable/screen/alert/status_effect/buff/meatvine_gigantism
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/buff/meatvine_gigantism
	name = "Enduring Aura"
	desc = "Your size and health are doubled by a nearby ally's aura!"
	icon_state = "buff_gigantism"

/datum/status_effect/buff/meatvine_gigantism/on_apply()
	. = ..()
	if(!isliving(owner))
		return FALSE

	var/mob/living/target = owner
	target.maxHealth *= 2
	target.health *= 2

	to_chat(target, span_nicegreen("You feel your body swell with power!"))
	return TRUE

/datum/status_effect/buff/meatvine_gigantism/on_remove()
	if(!isliving(owner))
		return

	var/mob/living/target = owner
	target.maxHealth *= 0.5
	target.health = min(target.health * 0.5, target.maxHealth)

	to_chat(target, span_warning("You feel your enhanced size fade away."))
	return ..()
