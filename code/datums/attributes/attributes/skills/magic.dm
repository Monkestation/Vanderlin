/datum/attribute/skill/magic
	category = SKILL_CATEGORY_RESEARCH
	difficulty = SKILL_DIFFICULTY_VERY_HARD

/datum/attribute/skill/magic/holy
	name = "Miracles"
	desc = "Represents your character's ability to perform divine magic. The higher your skill in Miracles, the more powerful your divine magic will be."
	governing_attribute = STAT_FORTUNE
	default_attributes = list(
		STAT_FORTUNE = -8,
	)
	dreams = list(
		"...since the death of God, there has been a vacancy in the realm of miracleworkers... you can change this..."
	)

/datum/attribute/skill/magic/blood
	name = "Blood Sorcery"
	desc = "Represents your character's ability to perform blood magic. The higher your skill in Blood Sorcery, the more powerful your blood magic will be."
	governing_attribute = STAT_CONSTITUTION
	default_attributes = list(
		STAT_CONSTITUTION = -8,
	)
	dreams = list(
		"...you burst into the tavern, unsheathing an exotic blade. all the folk in the establishment are pale. you raise your left arm, clenching a fist and slicing into your bicep like a viola... light cascades acrost the entire room..."
	)

/datum/attribute/skill/magic/arcane
	name = "Arcyne Magic"
	desc = "Represents your character's ability to perform arcyne magic. The higher your skill in Arcyne Magic, the more powerful your arcyne magic will be and you'll have access to more spells."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -8,
	)
	dreams = list(
		"...you look up to your captors, smiling through broken teeth. the cackling brings a kick to your ribs... you spit a broken tooth out of your mouth, and mutter under your breath... you hear gurgling as a baptism of blue fire spews from his open mouth..."
	)

/datum/attribute/skill/magic/arcane/on_level_change(mob/owner, new_level, old_level)
	var/old_tier = floor(old_level / 10)
	var/new_tier = floor(new_level / 10)
	if(new_tier > old_tier)
		owner?.adjust_spell_points(new_tier - old_tier)
	else if(new_tier < old_tier)
		owner?.adjust_spell_points(new_tier - old_tier) // negative delta = remove points

/datum/attribute/skill/magic/druidic
	name = "Druidic Trickery"
	desc = "Represents your character's ability to perform druidic magic. The higher your skill in Druidic Trickery, the more powerful your druidic magic will be."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -8,
		STAT_FORTUNE = -9,
	)
	dreams = list(
		"...you stare down at the party from the treetops... blinking, you stare at them from the sky... blinking, you stare at them from below... their attention drawn and quartered, you fire an arrow straight through the warrior's eye... he falls over, dead..."
	)
