/datum/attribute/skill/craft
	category = SKILL_CATEGORY_ENGINEERING

/datum/attribute/skill/craft/crafting
	name = "Crafting"
	desc = "A general skill that represents your character's ability to craft items. The higher your skill in Crafting, the more complex items you can craft."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -4,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you feel grass under you feet as you peer onto a meadow, you prepare a campfire and a tent and drift off into deeper slumber.."
	)

/datum/attribute/skill/craft/weaponsmithing
	name = "Weaponsmithing"
	desc = "Represents your character's ability to craft metal weapons. The higher your skill in Weaponsmithing, the more complex weapons you can create, and the better the resulting quality, up to Masterwork."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/blacksmithing = -5,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...you gently grasp the tang of the blade. without water nor oil, you turn over to the basin, slicing your hand, and letting the blood fill the void... you quench the blade."
	)

/datum/attribute/skill/craft/armorsmithing
	name = "Armorsmithing"
	desc = "Represents your character's ability to craft metal armor. The higher your skill in Armorsmithing, the more complex armor you can create, and the better the resulting quality, up to Masterwork."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/blacksmithing = -5,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...you are assailed by a faceless adversary. he pummels you - crack, crack, crack... it hurts, you scream... he tires, you do not..."
	)

/datum/attribute/skill/craft/blacksmithing
	name = "Blacksmithing"
	desc = "Represents your character's ability to craft metal items. The higher your skill in Blacksmithing, the more complex items you can create, and the better the resulting quality, up to Masterwork."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -5,
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...CLANG! Clang! Clang... you feel the weight of the hammer reverberate up your arm, past your shoulder, through your spine... the hits march to the drums of your heart. you feel attuned to the metal."
	)

/datum/attribute/skill/craft/smelting
	name = "Smelting"
	desc = "Represents your character's ability to smelt metal into ingots. The higher your skill in Smelting, the better the ingots you create, which affect the quality of the resulting item."
	governing_attribute = STAT_ENDURANCE
	default_attributes = list(
		STAT_ENDURANCE = -4,
		STAT_INTELLIGENCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...the heat brings warmth to you on this dreary night. your feet ache, and your arms remain sore - but the stress of the day melts away, along with the snow around you - becoming just another distant memory."
	)

/datum/attribute/skill/craft/carpentry
	name = "Carpentry"
	desc = "Represents your character's ability to craft wooden items. The higher your skill in Carpentry, the faster you can create wooden items and buildings."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_INTELLIGENCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...in the bitter cold, you stay in your cabin... in the dreary fire, the chair you made burns... the effort wasted, and yet you live..."
	)

/datum/attribute/skill/craft/masonry
	name = "Masonry"
	desc = "Represents your character's ability to craft stone items. The higher your skill in Masonry, the faster you can make stone items and buildings."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_ENDURANCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you chisel and chisel at the marble, the hammer slipping and smacking you square in the thumb... blood gently trickles over the stone, as the statue reflects the scars of its artisan..."
	)

/datum/attribute/skill/craft/traps
	name = "Trapping"
	desc = "Represents your character's ability to lay traps. The higher your skill in Trapping, the more effective your traps will be and the less likely you are to set them off accidentally."
	category = SKILL_CATEGORY_SKULDUGGERY
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you hear a quick snap in the distance... you rush over, and notice a small cabbit with a snare wrapped around its leg... you gently unsheath your knife, and loom over the poor, frightened thing..."
	)

/datum/attribute/skill/craft/cooking
	name = "Cooking"
	desc = "Represents your character's ability to cook food. The higher your skill in Cooking, the better the food you can cook and the more you can make with your ingredients."
	category = SKILL_CATEGORY_DOMESTIC
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -4,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you sit by the table in your dreary hovel, staring at the wooden bowl of soup given to you by your mother... you blink and look around the tavern, before your vision returns to the bowl... you feel comforted..."
	)

/datum/attribute/skill/craft/alchemy
	name = "Alchemy"
	desc = "Represents your character's ability to craft potions. The higher your skill in Alchemy, the better you can identify potions and ingredients."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		STAT_INTELLIGENCE = -7,
	)
	difficulty = SKILL_DIFFICULTY_VERY_HARD
	dreams = list(
		"...the smell of sulfur singes your nostrils... you taste iron... the smoke clears as you stare down at the reflection in your cauldron... the Queen stares back at you... she looks like she's crying..."
	)

/**
 * Grants or removes TRAIT_LEGENDARY_ALCHEMIST based on skill level.
 * Threshold is >= 50 (master tier). Call from wherever attribute changes are detected.
 */
/datum/attribute/skill/craft/alchemy/on_level_change(mob/owner, new_level, old_level)
	if(new_level >= 50)
		ADD_TRAIT(owner, TRAIT_LEGENDARY_ALCHEMIST, type)
	else
		REMOVE_TRAIT(owner, TRAIT_LEGENDARY_ALCHEMIST, type)

/datum/attribute/skill/craft/bombs
	name = "Bombcrafting"
	desc = "Represents your character's ability to craft bombs. The higher your skill in Bombcrafting, the better the bombs you can create and the more you can make with your materials."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/alchemy = -6,
	)
	difficulty = SKILL_DIFFICULTY_VERY_HARD
	dreams = list(
		"...you pour the powder down the barrel of the cannon, and without a projectile to follow the dust, you cut off a finger, and toss it in there... you turn to light the fuse..."
	)

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
