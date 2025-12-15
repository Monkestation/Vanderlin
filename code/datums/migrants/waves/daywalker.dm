/datum/migrant_role/daywalker
	name = "Daywalker"
	greet_text = "Some knaves are always trying to wade upstream. You witnessed your entire village be consumed by a subservient vampiric horde - the local Priest grabbed you, and brought you to a remote Monastery; ever since then you've sworn revenge against the restless dead. The Templars showed you everything you needed to know. You walk in the day, so that the undead may only walk in the night."
	migrant_job = /datum/job/migrant/daywalker

/datum/job/migrant/daywalker
	title = "Daywalker"
	tutorial = "Some knaves are always trying to wade upstream. You witnessed your entire village be consumed by a subservient vampiric horde - the local Priest grabbed you, and brought you to a remote Monastery; ever since then you've sworn revenge against the restless dead. The Templars showed you everything you needed to know. You walk in the day, so that the undead may only walk in the night."
	outfit = /datum/outfit/daywalker
	allowed_races = list(SPEC_ID_HUMEN)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/swimming = 4,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/combat/firearms = 2,
	)

	traits = list(TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/daywalker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE
	spawned.set_patron(/datum/patron/divine/astrata)
	spawned.verbs |= /mob/living/carbon/human/proc/torture_victim

/datum/outfit/daywalker
	name = "Daywalker"
	wrists = /obj/item/clothing/wrists/bracers/leather
	neck = /obj/item/clothing/neck/psycross/silver/astrata
	gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
	pants = /obj/item/clothing/pants/trou/shadowpants
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	armor = /obj/item/clothing/armor/leather/vest/winterjacket
	shoes = /obj/item/clothing/shoes/nobleboot
	beltl = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/face/goggles
	beltr = /obj/item/weapon/sword/rapier
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/silver

/datum/migrant_wave/daywalker
	name = "Astrata's Daywalker"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/daywalker
	weight = 3
	roles = list(
		/datum/migrant_role/daywalker = 1,
	)
	greet_text = "You give the Monarch's demesne a message. You tell them it's open season on all suckheads."
