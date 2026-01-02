/turf/closed/wall/mineral
	icon = 'icons/turf/walls.dmi'
	baseturfs = /turf/open/floor/dirt/road
	wallclimb = TRUE
	explosion_block = 10
	damage_deflection = 0

	smoothing_flags = NONE
	smoothing_groups = null
	smoothing_list = null

	var/last_event = 0
	var/active = null

/turf/closed/wall/mineral/examine()
	. += ..()
	if(uses_integrity)
		var/healthpercent = (atom_integrity / max_integrity) * 100
		switch(healthpercent)
			if(50 to 99)
				. += "It looks slightly damaged."
			if(25 to 50)
				. += "It appears heavily damaged."
			if(1 to 25)
				. +=  "<span class='warning'>It's falling apart!</span>"

