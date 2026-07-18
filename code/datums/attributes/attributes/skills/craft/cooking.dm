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
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/preparation
	name = "Preparation"
	desc = "Represents your character's ability to prepare raw ingredients for cooking, trimming, peeling, chopping, portioning, and readying components so that the actual craft of cooking can begin. A skilled preparer works quickly and wastes little, and their knife never slips."
	governing_attribute = STAT_SPEED
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -3,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...your hands move without you, breaking down something on the board in front of you... you do not look at what it is... the knife is very sharp and the sound is very wet... you wake before you are finished..."
	)

/datum/attribute/skill/craft/cooking/baking
	name = "Baking"
	desc = "Represents your character's ability to bake breads, pastries, and other oven-cooked goods. A skilled baker can produce everything from simple loaves to elaborate confections."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -4,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...the smell of warm bread fills the air... you reach out to touch the golden crust, still steaming from the oven... your stomach aches with a hunger you cannot name..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/confectionery
	name = "Confectionery"
	desc = "Represents your character's ability to work with sugar, chocolate, and other sweet ingredients. A skilled confectioner can produce candies, toffees, and elaborate sugar-work that borders on artistry."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -4,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...your fingers are sticky with something dark and sweet... you press it into a mold you do not recognize, over and over, filling shelf after shelf... you cannot stop... you are not sure you want to..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/grilling
	name = "Grilling"
	desc = "Represents your character's ability to cook over open flame. A practiced grillmaster knows how to coax the best from meat and fish, trading subtlety for the honest char of fire."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -4,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...fat drips into the coals below and the fire spits and roars... you turn the spit slowly, watching the skin crisp and blacken at the edges... someone is calling your name from far away..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/fine_cuisine
	name = "Fine Cuisine"
	desc = "Represents your character's mastery of elevated cookery, precise technique, rare ingredients, and dishes fit for noble tables. Few ever reach true mastery, but those who do are worth their weight in gold."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -6,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...a white plate sits before you, impossibly clean... atop it, something small and perfect, arranged just so... you raise the fork, but your hand is trembling... you cannot remember how you made it..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/preservation
	name = "Preservation"
	desc = "Represents your character's knowledge of curing, salting, smoking, and pickling. A capable preserver can stretch a season's harvest through the harshest winter."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -3,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...rows of dark jars line the cellar walls... you walk slowly between them, reading the faded labels... something shifts behind the glass of one, and you look away..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/brewing
	name = "Brewing"
	desc = "Represents your character's ability to ferment grains and honey into ales, meads, and simple beers. A seasoned brewer understands the temperament of yeast, the patience of fermentation, and the difference between a drink that warms the belly and one that ruins the batch."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking = -3,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you press your ear against the barrel and listen... something inside is alive, churning slowly in the dark... you pull away and the sound follows you out of the cellar and into the street..."
	)
	shared_xp_percent = 0.2

/datum/attribute/skill/craft/cooking/winemaking
	name = "Winemaking"
	desc = "Represents your character's ability to produce wine from fruit and grape. More sensitive than brewing and less forgiving of error, a true vintner can read a harvest and know already what it will become."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking/brewing = -4,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you walk between the rows in the low evening light, pinching a grape between your fingers... the juice runs down your wrist and drips into the dry earth... you cannot tell if the harvest will be good... you never can..."
	)
	shared_xp_percent = 0.4

/datum/attribute/skill/craft/cooking/distilling
	name = "Distilling"
	desc = "Represents your character's ability to distill fermented liquids into spirits and liquors. Distilling demands precision, too little heat and nothing comes, too much and the whole affair becomes dangerous. Those who master it produce spirits of remarkable potency and value."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking/brewing = -5,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...the copper still sweats in the firelight, dripping something clear and sharp into the waiting vessel... you lean close to smell it and the fumes sting your eyes to tears... somewhere behind you, a fire you did not start is burning..."
	)
	shared_xp_percent = 0.4

/datum/attribute/skill/craft/cooking/cheesemaking
	name = "Cheesemaking"
	desc = "Represents your character's ability to produce cheese from milk and curds. A skilled cheesemaker knows the character of their cultures, the right pressure for the press, and how long to leave a wheel to age in the dark. Good cheese takes time. The best takes years."
	governing_attribute = STAT_INTELLIGENCE
	default_attributes = list(
		/datum/attribute/skill/craft/cooking/preservation = -4,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you descend into the cave and walk the rows of wheels in the dark, running your fingers along the rind of each one... one is wrong somehow, though you cannot say how you know... you mark it and keep walking... you do not look back at it..."
	)
	shared_xp_percent = 0.5
