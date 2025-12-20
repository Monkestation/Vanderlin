/datum/action/cooldown/spell/sundering_lightning
	name = "Sundering Lightning"
	desc = "Summons forth dangerous rapid lightning strikes."
	button_icon_state = "sundering"
	sound = 'sound/weather/rain/thunder_1.ogg'

	point_cost = 8
	cast_range = 4
	attunements = list(
		/datum/attunement/electric = 0.9
	)

	invocation = "Lightning strikes more than twice!"
	invocation_type = INVOCATION_SHOUT

	spell_flags = SPELL_RITUOS
	charge_time = 3.5 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 1.5 MINUTES
	spell_cost = 60

/datum/action/cooldown/spell/sundering_lightning/cast(atom/cast_on)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(create_lightning), get_turf(cast_on)), 3 SECONDS)

/datum/action/cooldown/spell/sundering_lightning/proc/create_lightning(turf/victim)
	var/last_dist = 0
	for(var/turf/T as anything in spiral_range_turfs(4, victim))
		if(T.density)
			continue
		var/dist = get_dist(victim, T)
		if(dist > last_dist)
			last_dist = dist
			sleep(2 + min(4 - last_dist, 12) * 0.5)
		new /obj/effect/temp_visual/target/lightning(T)
