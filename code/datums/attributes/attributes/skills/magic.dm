/datum/attribute/skill/magic
	category = SKILL_CATEGORY_MAGIC
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

/*---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
---------------------------------------------------------------------------------*/

/datum/attribute/skill/magic/druidic
	name = "Druidic Trickery"
	desc = "Represents your character's ability to perform Druidic Magic. The higher your skill in Druidic Trickery, the more powerful your Druidic Magic will be."
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -8,
	)
	dreams = list(
		"...you stare down at the party from the treetops... blinking, you stare at them from the sky... blinking, you stare at them from below... their attention drawn and quartered, you fire an arrow straight through the warrior's eye... he falls over, dead..."
	)

/*---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
---------------------------------------------------------------------------------*/

/datum/attribute/skill/magic/arcane
	name = FORM_ARCANE
	desc = "Represents your character's ability to perform Arcyne Magic. The higher your skill the more powerful your spells will be."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -8,
	)
	dreams = list(
		"...you look up to your captors, smiling through broken teeth. the cackling brings a kick to your ribs... you spit a broken tooth out of your mouth, and mutter under your breath... you hear gurgling as a baptism of blue fire spews from his open mouth..."
	)

/datum/attribute/skill/magic/arcane/fire
	name = FORM_FIRE
	desc = "Represents your character's ability to perform Fire Magic. The higher your skill the more powerful your Fire Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/water
	name = FORM_WATER
	desc = "Represents your character's ability to perform Water Magic. The higher your skill the more powerful your Water Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/ice
	name = FORM_ICE
	desc = "Represents your character's ability to perform Ice Magic. The higher your skill the more powerful your Ice Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/earth
	name = FORM_EARTH
	desc = "Represents your character's ability to perform Earth Magic. The higher your skill the more powerful your Earth Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/air
	name = FORM_AIR
	desc = "Represents your character's ability to perform Air Magic. The higher your skill the more powerful your Air Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/lightning
	name = FORM_LIGHTNING
	desc = "Represents your character's ability to perform Lightning Magic. The higher your skill the more powerful your Lightning Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/life
	name = FORM_LIFE
	desc = "Represents your character's ability to perform Life Magic. The higher your skill the more powerful your Life Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/magic/arcane/death
	name = FORM_DEATH
	desc = "Represents your character's ability to perform Death Magic. The higher your skill the more powerful your Death Magic will be. This is a sub-skill of Arcyne Magic."
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -10
	)
	shared_xp_percent = 0.5

/*---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
---------------------------------------------------------------------------------*/

/datum/attribute/skill/magic/blood
	name = "Hemomancy"
	desc = "Represents your character's ability to perform Blood Magic. The higher your skill the more powerful your Blood Magic will be."
	governing_attribute = STAT_CONSTITUTION
	default_attributes = list(
		STAT_CONSTITUTION = -8,
	)
	dreams = list(
		"...you burst into the tavern, unsheathing an exotic blade. all the folk in the establishment are pale. you raise your left arm, clenching a fist and slicing into your bicep like a viola... light cascades acrost the entire room..."
	)
