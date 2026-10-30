/datum/attribute/skill/educated
	category = SKILL_CATEGORY_RESEARCH

/datum/attribute/skill/educated/mathematics
	name = "Mathematics"
	desc = "Represents your character's ability to do math. The higher your skill in Mathematics, the more complex math you can do and the faster you can do it."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...the hydra, a mathematically perfect beast... you lop one head off, two sprout, then four, eight, sixteen, thirty-two, sixty-four... there is a symmetry to this... the trees are like blood, vascular like the erosion of the canyons... the beat of the music marches to your heart..."
	)

/datum/attribute/skill/educated/reading
	name = "Reading"
	desc = "Represents your character's ability to read and write. Without at least some skill in Reading, you'll be totally unable to read or write."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -8,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you lick your fingers, gently flipping through the old, decaying pages... re-reading the page, your eyes widen in shock... the truth is terrible... you feel a presence behind you... and the cold blade in your throat..."
	)
