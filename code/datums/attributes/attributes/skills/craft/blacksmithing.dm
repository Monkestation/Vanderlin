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

/datum/attribute/skill/craft/weapon_repair
	name = "Weapon Repair"
	desc = "Represents your character's ability to maintain and restore damaged weapons. A skilled weapon repairman can re-edge a dulled blade, re-set a loose haft, and pull a weapon back from the brink of uselessness though restoring a truly ruined weapon to its former glory demands more than repair alone."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/weaponsmithing = -8,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you turn the blade over in your hands, tracing the notches along the edge with your thumb... each one tells you something... a hard parry, a bad angle, a desperate blow... you set it to the stone and begin to work them out one by one..."
	)
	shared_xp_percent = 0.5

/datum/attribute/skill/craft/armor_repair
	name = "Armor Repair"
	desc = "Represents your character's ability to maintain and restore damaged armor. Dented plates, burst rivets, torn mail a capable armorer can address all of it, returning protection to gear that has seen hard use. What cannot be repaired must be replaced, and knowing the difference is half the skill."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		/datum/attribute/skill/craft/armorsmithing = -8,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you run your hand across the breastplate, feeling every dent and crease beneath your palm... you think about the blow that made each one... you raise your hammer and begin to answer them in reverse..."
	)
	shared_xp_percent = 0.5
