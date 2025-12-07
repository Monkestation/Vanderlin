/datum/skill/labor
	abstract_type = /datum/skill/labor
	name = "Labor"
	dreams = list(
		"...all work, no play... all work, no play... all work, no play..."
	)

/datum/skill/labor/mining
	name = "Mining"
	desc = "Mining is a skill that represents your character's ability to mine. The higher your skill in Mining, the faster you can mine and the more materials you can get from veins."
	dreams = list(
		"...your masters scream as the man and his guards are slain by the knight... your brothers tremble, screaming and staring as the horror looms over the hero. you grab your pick, and begin to break the chains..."
	)

/datum/skill/labor/mining/get_skill_speed_modifier(level)
	switch(level)
		if(SKILL_LEVEL_NONE)
			return 1.3
		if(SKILL_LEVEL_NOVICE)
			return 1.2
		if(SKILL_LEVEL_APPRENTICE)
			return 1.1
		if(SKILL_LEVEL_JOURNEYMAN)
			return 1
		if(SKILL_LEVEL_EXPERT)
			return 0.9
		if(SKILL_LEVEL_MASTER)
			return 0.75
		if(SKILL_LEVEL_LEGENDARY)
			return 0.5

/datum/skill/labor/farming
	name = "Farming"
	desc = "Farming is a skill that represents your character's ability to farm. The higher your skill in Farming, the more you know about a seed, fertilizer, etc. by examining them."
	dreams = list(
		"...you plant your thumb into the dirt, before pulling it back - gently placing a seed into the crevice..."
	)

/datum/skill/labor/taming
	name = "Taming"
	desc = "Taming is a skill that represents your character's ability to tame animals. The higher your skill in Taming, the more dangerous animals you can tame and the more effective you will be at taming them."
	dreams = list(
		"...the water is stillborne, quiet... pristine, as if untouched... the line bobs down, and you let it writhe as you stare down at your reflection..."
	)

/datum/skill/labor/fishing
	name = "Fishing"
	desc = "Fishing is a skill that represents your character's ability to fish. The higher your skill in Fishing, the better the fish you can catch and the faster you can catch them."
	dreams = list(
		"...my only friend, the worm upon my hook. wriggling, writhing, struggling to surmount the mortal pointlessness that permeates this barren world. i am alone. i am empty. and yet, i fish. ..."
	)

/datum/skill/labor/butchering
	name = "Butchering"
	desc = "Butchering is a skill that represents your character's ability to butcher animals. The higher your skill in Butchering, the more meat and materials you can get from animals."
	dreams = list(
		"...you dream of chiseling a marble statue, a small rabbit... and when you open your eyes, the skin is separated from the flesh..."
	)

/datum/skill/labor/lumberjacking
	name = "Lumberjacking"
	desc = "Lumberjacking is a skill that represents your character's ability to chop down trees and split logs. The higher your skill in Lumberjacking, the more efficient you are at splitting logs."
	dreams = list(
		"...splinters fly off as a tree falls down on the ground, sending a thundering boom throughout the forest..."
	)

/datum/skill/labor/mathematics
	name = "Mathematics"
	desc = "Mathematics is a skill that represents your character's ability to do math. The higher your skill in Mathematics, the more complex math you can do and the faster you can do it."
	dreams = list(
		"...the hydra, a mathematically perfect beast... you lop one head off, two sprout, then four, eight, sixteen, thirty-two, sixty-four... there is a symmetry to this... the trees are like blood, vascular like the erosion of the canyons... the beat of the music marches to your heart..."
	)
