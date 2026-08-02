/datum/attribute/skill/labor
	category = SKILL_CATEGORY_DOMESTIC
	dreams = list(
		"...all work, no play... all work, no play... all work, no play..."
	)

/datum/attribute/skill/labor/mining
	name = "Mining"
	desc = "Represents your character's ability to mine. The higher your skill in Mining, the faster you can mine and the more materials you can get from veins."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_ENDURANCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...your masters scream as the man and his guards are slain by the knight... your brothers tremble, screaming and staring as the horror looms over the hero. you grab your pick, and begin to break the chains..."
	)

/datum/attribute/skill/labor/farming
	name = "Farming"
	desc = "Represents your character's ability to farm. The higher your skill in Farming, the more you know about a seed, fertilizer, etc. by examining them."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -4,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you plant your thumb into the dirt, before pulling it back - gently placing a seed into the crevice..."
	)

/datum/attribute/skill/labor/taming
	name = "Taming"
	desc = "Represents your character's ability to tame animals. The higher your skill in Taming, the more dangerous animals you can tame and the more effective you will be at taming them."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -6,
		STAT_FORTUNE = -7,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...the water is stillborne, quiet... pristine, as if untouched... the line bobs down, and you let it writhe as you stare down at your reflection..."
	)

/datum/attribute/skill/labor/fishing
	name = "Fishing"
	desc = "Represents your character's ability to fish. The higher your skill in Fishing, the better the fish you can catch and the faster you can catch them."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -4,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...my only friend, the worm upon my hook. wriggling, writhing, struggling to surmount the mortal pointlessness that permeates this barren world. i am alone. i am empty. and yet, i fish. ..."
	)

/datum/attribute/skill/labor/butchering
	name = "Butchering"
	desc = "Represents your character's ability to butcher animals. The higher your skill in Butchering, the more meat and materials you can get from animals."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_PERCEPTION = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you dream of chiseling a marble statue, a small rabbit... and when you open your eyes, the skin is separated from the flesh..."
	)

/datum/attribute/skill/labor/lumberjacking
	name = "Lumberjacking"
	desc = "Represents your character's ability to chop down trees and split logs. The higher your skill in Lumberjacking, the more efficient you are at splitting logs."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_ENDURANCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...splinters fly off as a tree falls down on the ground, sending a thundering boom throughout the forest..."
	)

/datum/attribute/skill/labor/mathematics
	name = "Mathematics"
	desc = "Represents your character's ability to do math. The higher your skill in Mathematics, the more complex math you can do and the faster you can do it."
	category = SKILL_CATEGORY_RESEARCH
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...the hydra, a mathematically perfect beast... you lop one head off, two sprout, then four, eight, sixteen, thirty-two, sixty-four... there is a symmetry to this... the trees are like blood, vascular like the erosion of the canyons... the beat of the music marches to your heart..."
	)
