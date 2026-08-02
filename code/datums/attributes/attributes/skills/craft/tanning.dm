/datum/attribute/skill/craft/tanning
	name = "Skincrafting"
	desc = "Represents your character's ability to process and use animal hide. The higher your skill in Skincrafting, the more leather you can create and the more you can make with it."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_STRENGTH = -6,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you stare down at the rabbit, its eyes wide and unblinking... you feel the knife in your hand, and the blood on your hands... and the warmth of the pelt..."
	)

/datum/attribute/skill/craft/tanning/patching
	name = "Hide Patching"
	desc = "Represents your character's ability to repair damaged leather and hide goods. The higher your skill in Hide Patching, the more heavily damaged leatherwork you can restore, and the cleaner your patches will blend."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		/datum/attribute/skill/craft/tanning = -4
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...the hide is cracked and split... you press the patch down and it gives like skin... warm, still warm... you cannot find the seam when you are done... you are not sure you want to..."
	)
	shared_xp_percent = 0.5
