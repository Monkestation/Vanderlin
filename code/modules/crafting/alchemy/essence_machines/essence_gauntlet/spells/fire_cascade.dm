/datum/action/cooldown/spell/essence/fire_cascade
	name = "Fire Cascadec"
	desc = "Unleash a spreading fan of slow-moving flame projectiles."
	school = "evocation"
	button_icon_state = "fireaura"
	spell_cost = 4
	cooldown_time = 45 SECONDS
	point_cost = 4
	click_to_activate = TRUE
	attunements = list(/datum/attunement/fire, /datum/attunement/aeromancy)
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
