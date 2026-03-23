/datum/migrant_role/urchinbrain
	name = "Urchin Leader"
	greet_text = "Without you, your friends would be dead in a ditch. You're the boss, that's why you've got a nice hat. \
	Preform stick-ups, lurk in the alleys, and make sure your siblings don't invoke the ire of the Matron. She doesn't \
	deserve the headache you give her."
	migrant_job = /datum/job/migrant/urchinbrain

/datum/attribute_holder/sheet/job/migrant/urchinbrain
	raw_attribute_list = list(
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = -1,
		STAT_STRENGTH = -1,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/labor/mathematics = 40,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/combat/wrestling = 30,
	)

/datum/job/migrant/urchinbrain
	title = "Urchin Leader"
	tutorial = "Without you, your friends would be dead in a ditch. You're the boss, that's why you've got a nice hat. \
	Preform stick-ups, lurk in the alleys, and make sure your siblings don't invoke the ire of the Matron. She doesn't \
	deserve the headache you give her."
	outfit = /datum/outfit/urchinbrain
	allowed_ages = list(AGE_CHILD)
	is_foreigner = FALSE

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/urchinbrain

	traits = list(TRAIT_ORPHAN)
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/urchinbrain
	name = "Urchin Leader (Migrant Wave)"
	head = /obj/item/clothing/head/fancyhat
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/shirt/rags
	pants = /obj/item/clothing/pants/tights/colored/vagrant
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/dagger
	backr = /obj/item/storage/backpack/satchel

/datum/migrant_role/urchinbrawn
	name = "Urchin"
	greet_text = "Life in the orphanage is detestable, nobody ever brought you into a family. A child denied love will burn \
	down his village for warmth - that's what's happening. Listen to your boss, and stack coin; be the little shit this town \
	deserves... Don't overdo it, though - lest the Matron put an end to this scheme you lot have going."
	migrant_job = /datum/job/migrant/urchinbrawn

/datum/attribute_holder/sheet/job/migrant/urchinbrawn
	attribute_variance = list(
		/datum/attribute/skill/combat/unarmed = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = -1,
		STAT_INTELLIGENCE = -2,
		STAT_SPEED = -2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/job/migrant/urchinbrawn
	title = "Urchin"
	tutorial = "Life in the orphanage is detestable, nobody ever brought you into a family. A child denied love will burn \
	down his village for warmth - that's what's happening. Listen to your boss, and stack coin; be the little shit this town \
	deserves... Don't overdo it, though - lest the Matron put an end to this scheme you lot have going."
	outfit = /datum/outfit/urchinbrawn

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/urchinbrawn

	traits = list(TRAIT_ORPHAN)
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/urchinbrawn
	name = "Urchin (Migrant Wave)"
	neck = /obj/item/storage/belt/pouch/coins/poor
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	armor = /obj/item/clothing/shirt/rags
	pants = /obj/item/clothing/pants/tights/colored/vagrant
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/mace/cudgel

/datum/migrant_wave/urchin_wave
	name = "Urchin Gang"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/urchin_wave
	downgrade_wave = /datum/migrant_wave/urchin_wave_down
	weight = 8
	roles = list(
		/datum/migrant_role/urchinbrain = 1,
		/datum/migrant_role/urchinbrawn = 2,
	)
	greet_text = "There's two rules - one, you give the Boss your coin. Two, you don't mess with the boss. Three, I can't count that good..."

/datum/migrant_wave/urchin_wave_down
	name = "Urchin Gang"
	shared_wave_type = /datum/migrant_wave/urchin_wave
	downgrade_wave = /datum/migrant_wave/urchin_wave_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/urchinbrain = 1,
		/datum/migrant_role/urchinbrawn = 1,
	)
	greet_text = "There's two rules - one, you give the Boss your coin. Two, you don't mess with the boss. Three, I can't count that good..."

/datum/migrant_wave/urchin_wave_down_two
	name = "The Urchin"
	shared_wave_type = /datum/migrant_wave/urchin_wave
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/urchinbrain = 1,
	)
	greet_text = "You're tired of eating gruel, time for something completely different."
