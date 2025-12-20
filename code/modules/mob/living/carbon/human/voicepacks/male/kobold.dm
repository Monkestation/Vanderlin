/datum/voicepack/male/kobold/get_sound(soundin, modifiers)
	var/used
	switch(modifiers)
		if("old")
			used = getfold(soundin)
		if("silenced")
			used = getfsilenced(soundin)
	if(!used)
		switch(soundin)
			if("sniff")
				used = 'sound/vo/mobs/rousman/ratidle2.ogg'
			if("clearthroat")
				used = 'sound/vo/mobs/rousman/ratdeathgurgle1.ogg'
			if("cough")
				used = 'sound/vo/mobs/rousman/ratdeathgurgle2.ogg'
			if("deathgurgle")
				used = 'sound/vo/mobs/rousman/ratdeathgurgle3.ogg'
			if("chuckle")
				used = 'sound/vo/mobs/rousman/ratlaugh1.ogg'
			if("laugh")
				used = 'sound/vo/mobs/rousman/ratlaugh2.ogg'
			if("pain")
				used = pick('sound/vo/mobs/rousman/ratpain1.ogg','sound/vo/mobs/rousman/ratpain2.ogg','sound/vo/mobs/rousman/ratpain3.ogg')
			if("paincrit")
				used = list('sound/vo/male/dwarf/paincrit (1).ogg','sound/vo/male/dwarf/paincrit (2).ogg','sound/vo/male/dwarf/paincrit (3).ogg')
			if("painscream")
				used = pick('sound/vo/mobs/rousman/ratpainscream3.ogg','sound/vo/mobs/rousman/ratpainscream4.ogg','sound/vo/mobs/rousman/ratpainscream6.ogg')
			if("scream")
				used = pick('sound/vo/mobs/rousman/ratscream1.ogg','sound/vo/mobs/rousman/ratscream2.ogg')
			if("sigh")
				used = 'sound/vo/mobs/rousman/ratidle3.ogg'
			if("hmm")
				used = 'sound/vo/male/dwarf/hmm.ogg'
			if("hum")
				used = list('sound/vo/male/dwarf/hum (1).ogg','sound/vo/male/dwarf/hum (2).ogg','sound/vo/male/dwarf/hum (3).ogg')
			if("whimper")
				used = 'sound/vo/mobs/rousman/ratpainscream5.ogg'
			if("rage")
				used = 'sound/vo/mobs/rousman/ratrage1.ogg'
			if("grumble")
				used = 'sound/vo/male/elf/grumble.ogg'

	if(!used)
		used = ..(soundin, modifiers)

	return used
