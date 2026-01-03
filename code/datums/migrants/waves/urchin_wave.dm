/datum/migrant_role/urchinbrain
	name = "Urchin Leader"
	greet_text = "Without you, your friends would be dead in a ditch. You're the boss, that's why you've got a nice hat. \
	Preform stick-ups, lurk in the alleys, and make sure your siblings don't invoke the ire of the Matron. She doesn't \
	deserve the headache you give her."
	migrant_job = /datum/job/migrant/urchinbrain

/datum/job/migrant/urchinbrain
	title = "Urchin Leader"
	tutorial = "Without you, your friends would be dead in a ditch. You're the boss, that's why you've got a nice hat. \
	Preform stick-ups, lurk in the alleys, and make sure your siblings don't invoke the ire of the Matron. She doesn't \
	deserve the headache you give her."
	outfit = /datum/outfit/urchinbrain
	allowed_ages = list(AGE_CHILD)
	is_foreigner = FALSE

	jobstats = list(
		STATKEY_CON = -2,
		STATKEY_END = -1,
		STATKEY_STR = -1,
		STATKEY_SPD = -1,
		STATKEY_INT = 3,
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/mathematics = 4,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 5,
		/datum/skill/misc/climbing = 4,
	)

	traits = list(TRAIT_ORPHAN)
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/job/migrant/urchinbrain/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/wrestling, rand(3), TRUE)

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

/datum/job/migrant/urchinbrawn
	title = "Urchin"
	tutorial = "Life in the orphanage is detestable, nobody ever brought you into a family. A child denied love will burn \
	down his village for warmth - that's what's happening. Listen to your boss, and stack coin; be the little shit this town \
	deserves... Don't overdo it, though - lest the Matron put an end to this scheme you lot have going."
	outfit = /datum/outfit/urchinbrawn

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = -1,
		STATKEY_END = -1,
		STATKEY_INT = -2,
		STATKEY_SPD = -2,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/climbing = 2,
	)

	traits = list(TRAIT_ORPHAN)
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/job/migrant/urchinbrawn/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/unarmed, pick(1, 2), TRUE)

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
