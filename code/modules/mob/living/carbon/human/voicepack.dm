/datum/voicepack/proc/get_sound(soundin, modifiers)
	return

/datum/voicepack/proc/getfold(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("asdf")
				used = 'sound/blank.ogg'
		return used

/datum/voicepack/proc/getfyoung(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("asdf")
				used = 'sound/blank.ogg'
		return used

/datum/voicepack/proc/getmold(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("laugh")
				used = pick('sound/vo/male/old/laugh (1).ogg', 'sound/vo/male/old/laugh (2).ogg', 'sound/vo/male/old/laugh (3).ogg')
			if("scream")
				used = 'sound/vo/male/old/scream.ogg'
			if("pain")
				used = pick('sound/vo/male/old/pain (1).ogg','sound/vo/male/old/pain (2).ogg','sound/vo/male/old/pain (3).ogg')
			if("painscream")
				used = pick('sound/vo/male/old/pain (1).ogg','sound/vo/male/old/pain (2).ogg','sound/vo/male/old/pain (3).ogg')
		return used

/datum/voicepack/proc/getmsilenced(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("asdf")
				used = pick('sound/vo/male/squire/laugh (1).ogg','sound/vo/male/squire/laugh (2).ogg')
		if(!used) //always silent
			used = 'sound/blank.ogg'
		return used

/datum/voicepack/proc/getfsilenced(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("asdf")
				used = pick('sound/vo/male/squire/laugh (1).ogg','sound/vo/male/squire/laugh (2).ogg')
		if(!used) //always silent
			used = 'sound/blank.ogg'
		return used
