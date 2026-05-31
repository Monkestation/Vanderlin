/datum/action/cooldown/spell/essence/regeneration_cycle
	name = "Regeneration Cycle"
	desc = "Establishes a cycle of continuous healing over time."
	button_icon_state = "regeneratelimb"
	cast_range = 1
	point_cost = 8
	attunements = list(/datum/attunement/light, /datum/attunement/life)
	essences = list(/datum/thaumaturgical_essence/cycle, /datum/thaumaturgical_essence/life)

/datum/action/cooldown/spell/essence/regeneration_cycle/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] begins a cycle of natural regeneration."))
	target.apply_status_effect(/datum/status_effect/buff/regeneration_cycle, 300 SECONDS)
	new /obj/effect/temp_visual/snake/twin_up(null, target)

/atom/movable/screen/alert/status_effect/regeneration_cycle
	name = "Regeneration Cycle"
	desc = "Your body heals itself continuously."
	icon_state = "buff"

/datum/status_effect/buff/regeneration_cycle
	id = "regeneration_cycle"
	alert_type = /atom/movable/screen/alert/status_effect/regeneration_cycle
	duration = 300 SECONDS
	tick_interval = 10 SECONDS

/datum/status_effect/buff/regeneration_cycle/tick()
	var/mob/living/carbon/carbon = owner
	if(!iscarbon(owner))
		return
	for(var/datum/injury/injury as anything in carbon.all_injuries)
		if(injury.damage_type == WOUND_DIVINE)
			continue
		injury.heal_damage(0.1)
