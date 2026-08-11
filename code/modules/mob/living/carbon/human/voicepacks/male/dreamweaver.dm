/datum/voicepack/male/dreamweaver/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("laugh")
			used = list('sound/vo/male/dreamweaver/dlaugh1.ogg', 'sound/vo/male/dreamweaver/dlaugh2.ogg', 'sound/vo/male/dreamweaver/dlaugh3.ogg', 'sound/vo/male/dreamweaver/dlaugh4.ogg')
		if("whistle")
			used = list('sound/vo/assassin/whistle1.ogg', 'sound/vo/assassin/whistle2.ogg')
	if(!used)
		used = ..(soundin, modifiers)
	return used
