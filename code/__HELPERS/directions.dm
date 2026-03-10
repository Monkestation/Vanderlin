/// Get the direction between one atom to another in precise compass terms (North-northwest etc.)
/proc/get_precise_direction_between(atom/from_atom, atom/to_atom)
	var/turf/from_turf = get_turf(from_atom)
	var/turf/to_turf = get_turf(to_atom)
	if(!from_turf || !to_turf)
		return null

	var/dx = to_turf.x - from_turf.x
	var/dy = to_turf.y - from_turf.y
	if(!dx && !dy)
		return null

	var/angle = ATAN2(dx, dy)
	if(angle < 0)
		angle += 360
	return get_precise_direction_from_angle(angle)

/proc/get_precise_direction_from_angle(angle)
	// Normalize the incoming angle first.
	angle = (angle + 360) % 360

	// Convert to compass bearing (0° = north, 90° = east).
	var/compass_angle = (450 - angle) % 360 // 450 = 360 + 90

	switch(compass_angle)
		if(348.75 to 360, 0 to 11.25)
			return "north"
		if(11.25 to 33.75)
			return "north-northeast"
		if(33.75 to 56.25)
			return "northeast"
		if(56.25 to 78.75)
			return "east-northeast"
		if(78.75 to 101.25)
			return "east"
		if(101.25 to 123.75)
			return "east-southeast"
		if(123.75 to 146.25)
			return "southeast"
		if(146.25 to 168.75)
			return "south-southeast"
		if(168.75 to 191.25)
			return "south"
		if(191.25 to 213.75)
			return "south-southwest"
		if(213.75 to 236.25)
			return "southwest"
		if(236.25 to 258.75)
			return "west-southwest"
		if(258.75 to 281.25)
			return "west"
		if(281.25 to 303.75)
			return "west-northwest"
		if(303.75 to 326.25)
			return "northwest"
		if(326.25 to 348.75)
			return "north-northwest"

	return null
