/datum/voicepack/female/haughty/get_sound(soundin, modifiers)
	var/used
	switch(modifiers)
		if("old")
			used = getfold(soundin)
		if("silenced")
			used = getfsilenced(soundin)
	if(!used)
		switch(soundin)
			if("cackle")
				used = list('sound/vo/female/haughty/cackle (1).ogg','sound/vo/female/haughty/cackle (2).ogg')
			if("chuckle")
				used = list('sound/vo/female/haughty/chuckle (1).ogg','sound/vo/female/haughty/chuckle (2).ogg')
			if("gasp")
				used = list('sound/vo/female/haughty/gasp (1).ogg','sound/vo/female/haughty/gasp (2).ogg')
			if("giggle")
				used = list('sound/vo/female/haughty/giggle (1).ogg','sound/vo/female/haughty/giggle (2).ogg')
			if("laugh")
				used = list('sound/vo/female/haughty/laugh (1).ogg','sound/vo/female/haughty/laugh (2).ogg','sound/vo/female/haughty/laugh (3).ogg','sound/vo/female/haughty/laugh (4).ogg','sound/vo/female/haughty/laugh (5).ogg')
			if("paincrit")
				used = list('sound/vo/female/haughty/paincrit (1).ogg','sound/vo/female/haughty/paincrit (2).ogg')
			if("painmoan")
				used = list('sound/vo/female/haughty/painmoan (1).ogg','sound/vo/female/haughty/painmoan (2).ogg')
			if("painscream")
				used = list('sound/vo/female/haughty/painscream (1).ogg','sound/vo/female/haughty/painscream (2).ogg')
			if("sigh")
				used = 'sound/vo/female/haughty/sigh (1).ogg'
			if("attnwhistle")
				used = 'sound/vo/attn.ogg'
			if("psst")
				used = 'sound/vo/psst.ogg'
			if("clap")
				used = list('sound/vo/clap (1).ogg', 'sound/vo/clap (2).ogg', 'sound/vo/clap (3).ogg', 'sound/vo/clap (4).ogg')

	if(!used)
		used = ..(soundin, modifiers)

	return used
