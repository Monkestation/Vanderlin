/datum/attribute/skill/craft/engineering
	name = "Engineering"
	desc = "Represents your character's ability to craft mechanical items. The higher your skill in Engineering, the more complex items you can create without failure."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -7,
	)
	difficulty = SKILL_DIFFICULTY_VERY_HARD
	dreams = list(
		"...visions plague your mind. you toss and turn this nite. you see mechanical beasts gutting their masters with bare hands, fire raging acrost unknown streets... you grab a brick off the road and peer below into an infinite void... you inhale, and feel the steam burn your lungs..."
	)

/datum/attribute/skill/craft/locksmithing
	name = "Locksmithing"
	desc = "Represents your character's ability to craft, repair, and work with locks and their mechanisms. A skilled locksmith understands the intimate relationship between lock and key, the tolerances, the pins, the tension; and can produce work that ranges from simple padlocks to complex mechanisms that would humble a king's treasury."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		/datum/attribute/skill/craft/engineering = -4,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you hold a lock up to the light and peer into it... something peers back... you set it down carefully on the workbench and take up your pick, and begin to work... the pins give one by one... the last one does not..."
	)
	shared_xp_percent = 0.5
