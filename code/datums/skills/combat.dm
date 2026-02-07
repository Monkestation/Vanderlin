/datum/skill/combat
	abstract_type = /datum/skill/combat
	name = "Combat"
	desc = ""
	dream_cost_base = 2
	dream_cost_per_level = 1

/datum/skill/combat/proc/get_skill_parry_modifier(level) //added parry drain/neg in parries and dodges
	switch(level)
		if(SKILL_LEVEL_NONE)
			return 0
		if(SKILL_LEVEL_NOVICE)
			return 5
		if(SKILL_LEVEL_APPRENTICE)
			return 10
		if(SKILL_LEVEL_JOURNEYMAN)
			return 15
		if(SKILL_LEVEL_EXPERT)
			return 20
		if(SKILL_LEVEL_MASTER)
			return 25
		if(SKILL_LEVEL_LEGENDARY)
			return 35

/datum/skill/combat/knives
	name = "Knife-fighting"
	desc = "Knife-fighting is a skill that represents your character's ability to fight with knives and short blades. The higher your skill in Knife-fighting, the more accurate you'll be with knives and the better you'll be at parrying with them."
	dreams = list(
		"...you're thrown to the dirt by volves - panicking and flailing, one lunges to rip your neck out, only for blood to flow from its maw as steel is plunged into its nape...."
	)

/datum/skill/combat/swords
	name = "Sword-fighting"
	desc = "Sword-fighting is a skill that represents your character's ability to fight with swords and long blades. The higher your skill in Sword-fighting, the more accurate you'll be with swords and the better you'll be at parrying with them."
	dreams = list(
		"...your heart beats wildly as your swords strike eachothers, you parry your opponent and finish him off with a decisive slash..."
	)

/datum/skill/combat/polearms
	name = "Polearms"
	desc = "Polearms is a skill that represents your character's ability to fight with polearms and spears. The higher your skill in Polearms, the more accurate you'll be with polearms and the better you'll be at parrying with them."
	dreams = list(
		"...his mouth meets his head, his teeth meets teeth, blood gushes from his mouth after a firm strike - you have no blade, yet you're armed..."
	)

/datum/skill/combat/axesmaces
	name = "Axes & Maces"
	desc = "Axes & Maces is a skill that represents your character's ability to fight with axes and maces. The higher your skill in Axes & Maces, the more accurate you'll be with axes and maces and the better you'll be at parrying with them."
	dreams = list(
		"...you drag your finger across the edge. picking it up from the table, you round the corner, and stare at your ailing father..."
	)

/datum/skill/combat/whipsflails
	name = "Whips & Flails"
	desc = "Whips & Flails is a skill that represents your character's ability to fight with whips and flails. The higher your skill in Whips & Flails, the more accurate you'll be with whips and flails and the better you'll be at parrying with them."
	dreams = list(
		"...you have a nightmare - accused of heresy, you reel and strike, skin sloughs off their back... you blink, you're the one in chains..."
	)

/datum/skill/combat/bows
	name = "Archery"
	desc = "Archery is a skill that represents your character's ability to fight with bows and arrows. The higher your skill in Archery, the more accurate you'll be with bows."
	dreams = list(
		"...you nock the arrow, and let it loose... as you have a hundred times before... tonight, he dies... the arrow flies through the carriage, you hear shrieking and... sobbing...?"
	)

/datum/skill/combat/crossbows
	name = "Crossbows"
	desc = "Crossbows is a skill that represents your character's ability to fight with crossbows. The higher your skill in Crossbows, the more accurate you'll be with crossbows."
	dreams = list(
		"...in your hands, it feels like it's the perfect weight. you rest the stock against your gut and pull the string back... and you raise your sights on the crowd below..."
	)

/datum/skill/combat/firearms
	name = "Firearms"
	desc = "Firearms is a skill that represents your character's ability to fight with firearms. The higher your skill in Firearms, the more accurate you'll be with firearms."
	dreams = list(
		"...one shot... you smell the sulfur... you spit the dirt out of your mouth, and blink the blood away... now... you know... you love to reload during a battle..."
	)

/datum/skill/combat/wrestling
	name = "Wrestling"
	desc = "Wrestling is a skill that represents your character's ability to grab and wrestle people. The higher your skill in Wrestling, the harder it will be to escape your grabs."
	dreams = list(
		"...he won't listen, your companion dies on the operating table. you feel nothing. you grab the medicine-man's head, and begin to twist... the screams, oh, what joyous whimsy..."
	)

/datum/skill/combat/unarmed
	name = "Fist-fighting"
	desc = "Fist-fighting is a skill that represents your character's ability to fight unarmed. The higher your skill in Fist-fighting, the more accurate you'll be with your fists and the better you'll be at parrying with them."
	dreams = list(
		"...ailing and old, the same guard comes back for a daily beating... you grit your teeth... you smile... the old shall teach the young a lesson in violence..."
	)

/datum/skill/combat/shields
	name = "Shields"
	desc = "Shields is a skill that represents your character's ability to defend yourself with shields. The higher your skill in Shields, the easier it will be to block with them."
	dreams = list(
		"...the deadite claws on the door, another crashes through a window... in a panic, you grab a chair, and utter a prayer to Necra..."
	)
