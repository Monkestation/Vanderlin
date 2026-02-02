/datum/fauna_spawn_rule
	var/min_temperature = 0.0
	var/max_temperature = 1.0
	var/min_moisture = 0.0
	var/max_moisture = 1.0
	var/min_height = 0
	var/max_height = 999
	var/beach_only = FALSE
	var/no_beach = FALSE
	var/spawn_weight = 100

/datum/fauna_spawn_rule/New(min_temp = 0.0, max_temp = 1.0, min_moist = 0.0, max_moist = 1.0, min_h = 0, max_h = 999, beach = FALSE, no_beach_spawn = FALSE, weight = 100)
	..()
	min_temperature = min_temp
	max_temperature = max_temp
	min_moisture = min_moist
	max_moisture = max_moist
	min_height = min_h
	max_height = max_h
	beach_only = beach
	no_beach = no_beach_spawn
	spawn_weight = weight
