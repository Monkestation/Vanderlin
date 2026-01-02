/datum/voicepack/glutton
	/// a scuffed way to make an ambiguous child datum
	var/datum/voicepack/parent_datum

/datum/voicepack/glutton/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("grumble")
			used = list('sound/vo/mobs/troll/aggro2.ogg')
		if("burploud")
			used = list('sound/vo/burploud.ogg')
		if("groan")
			used = list('sound/vo/mobs/troll/idle1.ogg')
	if(!used && parent_datum)
		used = parent_datum.get_sound(soundin, modifiers)
	return used

/datum/voicepack/glutton/Destroy(force, ...)
	parent_datum = null
	. = ..()
