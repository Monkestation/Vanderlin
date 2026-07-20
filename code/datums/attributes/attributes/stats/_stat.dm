/datum/attribute/stat
	/// Used when space is too valuable to write a full word
	var/shorthand = "FK"

/datum/attribute/stat/description_from_level(level)
	switch(CEILING(level, 1))
		if(-INFINITY to 9)
			return "poor"
		if(10 to 19)
			return "novice"
		if(20 to 29)
			return "apprentice"
		if(30 to 39)
			return "journeyman"
		if(40 to 49)
			return "expert"
		if(50 to 59)
			return "master"
		if(60 to INFINITY)
			return "legendary"
		else
			return "invalid"
