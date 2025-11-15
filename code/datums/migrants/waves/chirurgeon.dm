/datum/migrant_role/chirurgeon
	name = "Chirurgeon"
	greet_text = "You've no acclaim to the tenures you say you have, and the history you recount is shoddy at best, and false at \
	worst. In a trade that is rife with charlatans, you are arguably a hand-picked example amongst them; but amongst the lies \
	there is one truth - your hands are indeed as steady as you claim them to be. Ensure you find an employer that won't stab \
	you in the back, and wait for an opportune moment to stab them in theirs. Make a fine practice far away from the eyes of \
	your competition, lest you find yourself dead and floating downstream."
	migrant_job = /datum/job/migrant/chirurgeon

/datum/job/migrant/chirurgeon
	title = "Chirurgeon"
	tutorial = "You've no acclaim to the tenures you say you have, and the history you recount is shoddy at best, and false at \
	worst. In a trade that is rife with charlatans, you are arguably a hand-picked example amongst them; but amongst the lies \
	there is one truth - your hands are indeed as steady as you claim them to be. Ensure you find an employer that won't stab \
	you in the back, and wait for an opportune moment to stab them in theirs. Make a fine practice far away from the eyes of \
	your competition, lest you find yourself dead and floating downstream."
	outfit = /datum/outfit/chirurgeon
	blacklisted_species = list(SPEC_ID_HALFLING)

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 1,
		STATKEY_STR = -2,
	)

	skills = list(
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/medicine = 3,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/alchemy = 1,
	)

	traits = list(
		TRAIT_EMPATH,
		TRAIT_DEADNOSE,
	)

	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

/datum/outfit/chirurgeon
	name = "Chirurgeon"
	mask = /obj/item/clothing/face/shepherd/clothmask
	head = /obj/item/clothing/head/brimmed
	cloak = /obj/item/clothing/cloak/apron/cook
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl = /obj/item/storage/backpack/satchel/surgbag/shit
	backr = /obj/item/storage/backpack/satchel/cloth
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/clothing/neck/phys
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/cleaver
	beltl = /obj/item/storage/belt/pouch/coins/poor

/datum/migrant_wave/chirurgeon
	name = "Chirurgeon"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/chirurgeon
	weight = 10
	roles = list(
		/datum/migrant_role/chirurgeon = 1,
	)
	greet_text = "A man who smells of death enters, crashing down on the stool and slumping forwards. There's nothing behind his eyes."
