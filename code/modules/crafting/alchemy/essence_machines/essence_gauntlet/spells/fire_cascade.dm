/datum/action/cooldown/spell/essence/fire_cascade
	name = "Fire Cascade"
	desc = "Unleash a nova of spreading flames."
	button_icon_state = "fireaura"
	spell_cost = 4
	cooldown_time = 45 SECONDS
	click_to_activate = TRUE
	essences = list(/datum/thaumaturgical_essence/fire, /datum/thaumaturgical_essence/air)
	var/flame_radius = 2
	var/hotspot_lifetime = 3

/datum/action/cooldown/spell/essence/fire_cascade/cast(atom/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fire_cascade), owner, flame_radius)

/datum/action/cooldown/spell/essence/fire_cascade/proc/fire_cascade(mob/living/user, flame_radius = 1)
	var/turf/centre = get_turf(owner)

	for(var/i in 0 to flame_radius)
		for(var/turf/nearby_turf as anything in spiral_range_turfs(i + 1, centre))
			if(nearby_turf == centre)
				continue
			new /obj/effect/hotspot(nearby_turf, null, null, hotspot_lifetime)

		sleep(0.3 SECONDS)

/datum/action/cooldown/spell/essence/fire_cascade/spell
	name = "Cascade of Fire"
	charge_required = TRUE
	charge_time = 0.2 SECONDS
	spell_cost = 40
	spell_type = SPELL_MANA

	required_form = FORM_FIRE
	required_technique = TECHNIQUE_CREATION
