/datum/attribute/skill/combat
	category = SKILL_CATEGORY_MELEE

/datum/attribute/skill/combat/knives
	name = "Knife-fighting"
	desc = "Represents your character's ability to fight with knives and short blades. The higher your skill in Knife-fighting, the more accurate you'll be with knives and the better you'll be at parrying with them."
	governing_attribute = STAT_SPEED
	default_attributes = list(
		STAT_SPEED = -5,
		STAT_PERCEPTION = -6,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...you're thrown to the dirt by volves - panicking and flailing, one lunges to rip your neck out, only for blood to flow from its maw as steel is plunged into its nape...."
	)

/datum/attribute/skill/combat/swords
	name = "Sword-fighting"
	desc = "Represents your character's ability to fight with swords and long blades. The higher your skill in Sword-fighting, the more accurate you'll be with swords and the better you'll be at parrying with them."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -5,
		STAT_SPEED = -6,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...your heart beats wildly as your swords strike eachothers, you parry your opponent and finish him off with a decisive slash..."
	)

/datum/attribute/skill/combat/polearms
	name = "Polearms"
	desc = "Represents your character's ability to fight with polearms and spears. The higher your skill in Polearms, the more accurate you'll be with polearms and the better you'll be at parrying with them."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -5,
		STAT_ENDURANCE = -7,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...his mouth meets his head, his teeth meets teeth, blood gushes from his mouth after a firm strike - you have no blade, yet you're armed..."
	)

/datum/attribute/skill/combat/axesmaces
	name = "Axes & Maces"
	desc = "Represents your character's ability to fight with axes and maces. The higher your skill in Axes & Maces, the more accurate you'll be with axes and maces and the better you'll be at parrying with them."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -5,
		STAT_ENDURANCE = -7,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you drag your finger across the edge. picking it up from the table, you round the corner, and stare at your ailing father..."
	)

/datum/attribute/skill/combat/whipsflails
	name = "Whips & Flails"
	desc = "Represents your character's ability to fight with whips and flails. The higher your skill in Whips & Flails, the more accurate you'll be with whips and flails and the better you'll be at parrying with them."
	governing_attribute = STAT_SPEED
	default_attributes = list(
		STAT_SPEED = -7,
		STAT_PERCEPTION = -8,
	)
	difficulty = SKILL_DIFFICULTY_HARD
	dreams = list(
		"...you have a nightmare - accused of heresy, you reel and strike, skin sloughs off their back... you blink, you're the one in chains..."
	)

/datum/attribute/skill/combat/bows
	name = "Archery"
	desc = "Represents your character's ability to fight with bows and arrows. The higher your skill in Archery, the more accurate you'll be with bows."
	category = SKILL_CATEGORY_RANGED
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_STRENGTH = -7,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...you nock the arrow, and let it loose... as you have a hundred times before... tonight, he dies... the arrow flies through the carriage, you hear shrieking and... sobbing...?"
	)

/datum/attribute/skill/combat/crossbows
	name = "Crossbows"
	desc = "Represents your character's ability to fight with crossbows. The higher your skill in Crossbows, the more accurate you'll be with crossbows."
	category = SKILL_CATEGORY_RANGED
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...in your hands, it feels like it's the perfect weight. you rest the stock against your gut and pull the string back... and you raise your sights on the crowd below..."
	)

/datum/attribute/skill/combat/firearms
	name = "Firearms"
	desc = "Represents your character's ability to fight with firearms. The higher your skill in Firearms, the more accurate you'll be with firearms."
	category = SKILL_CATEGORY_RANGED
	governing_attribute = STAT_PERCEPTION
	default_attributes = list(
		STAT_PERCEPTION = -5,
		STAT_INTELLIGENCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...one shot... you smell the sulfur... you spit the dirt out of your mouth, and blink the blood away... now... you know... you love to reload during a battle..."
	)

/datum/attribute/skill/combat/wrestling
	name = "Wrestling"
	desc = "Represents your character's ability to grab and wrestle people. The higher your skill in Wrestling, the harder it will be to escape your grabs."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -5,
		STAT_ENDURANCE = -6,
	)
	difficulty = SKILL_DIFFICULTY_AVERAGE
	dreams = list(
		"...he won't listen, your companion dies on the operating table. you feel nothing. you grab the medicine-man's head, and begin to twist... the screams, oh, what joyous whimsy..."
	)

/datum/attribute/skill/combat/unarmed
	name = "Fist-fighting"
	desc = "Represents your character's ability to fight unarmed. The higher your skill in Fist-fighting, the more accurate you'll be with your fists and the better you'll be at parrying."
	governing_attribute = STAT_STRENGTH
	default_attributes = list(
		STAT_STRENGTH = -4,
		STAT_ENDURANCE = -5,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...ailing and old, the same guard comes back for a daily beating... you grit your teeth... you smile... the old shall teach the young a lesson in violence..."
	)

/datum/attribute/skill/combat/shields
	name = "Shields"
	desc = "Represents your character's ability to defend yourself with shields. The higher your skill in Shields, the easier it will be to block with them."
	category = SKILL_CATEGORY_BLOCKING
	governing_attribute = STAT_ENDURANCE
	default_attributes = list(
		STAT_ENDURANCE = -4,
		STAT_STRENGTH = -6,
	)
	difficulty = SKILL_DIFFICULTY_EASY
	dreams = list(
		"...the deadite claws on the door, another crashes through a window... in a panic, you grab a chair, and utter a prayer to Necra..."
	)
