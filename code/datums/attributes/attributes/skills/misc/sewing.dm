/datum/attribute/skill/misc/sewing
	name = "Sewing"
	desc = "Represents your character's ability to sew. The higher your skill in Sewing, the more complex items you can create, and the faster you can sew."
	category = SKILL_CATEGORY_DOMESTIC
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...the needle goes through the cloth, in-and-out... then it's hide... then it's a man's flesh... you blink, the dress is done... the queen will love it..."
	)

/datum/attribute/skill/misc/sewing/mending
	name = "Mending"
	desc = "Represents your character's ability to repair damaged clothing and textiles. The higher your skill in Mending, the more severely damaged items you can restore, and the less visible your repairs will be."
	category = SKILL_CATEGORY_DOMESTIC
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		/datum/attribute/skill/misc/sewing = -4,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...the tear closes beneath your fingers like a wound healing... stitch by stitch... you cannot tell where the damage was... you cannot tell where anything was..."
	)
	shared_xp_percent = 0.5
