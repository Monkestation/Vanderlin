/datum/migrant_role/daywalker
	name = "Daywalker"
	greet_text = "Some knaves are always trying to wade upstream. You witnessed your entire village be consumed by a subservient vampiric horde - the local Priest grabbed you, and brought you to a remote Monastery; ever since then you've sworn revenge against the restless dead. The Templars showed you everything you needed to know. You walk in the day, so that the undead may only walk in the night."
	migrant_job = /datum/job/migrant/daywalker

/datum/job/migrant/daywalker
	title = "Daywalker"
	tutorial = "Some knaves are always trying to wade upstream. You witnessed your entire village be consumed by a subservient vampiric horde - the local Priest grabbed you, and brought you to a remote Monastery; ever since then you've sworn revenge against the restless dead. The Templars showed you everything you needed to know. You walk in the day, so that the undead may only walk in the night."
	outfit = /datum/outfit/daywalker
	allowed_races = list(SPEC_ID_HUMEN)
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_END = 2,
		STATKEY_SPD = 2, //Giving speed for help with expert dodging at the cost of no added strength or constitution
	)

	skills = list(
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 2,
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
		///removed firearms skill, why did they even get this?
	)

	traits = list(TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/daywalker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE
	spawned.set_patron(/datum/patron/divine/astrata)
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

/datum/outfit/daywalker
	name = "Daywalker (Migrant Wave)"
	wrists = /obj/item/clothing/wrists/bracers/leather
	neck = /obj/item/clothing/neck/psycross/silver/astrata
	gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
	pants = /obj/item/clothing/pants/trou/shadowpants
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	armor = /obj/item/clothing/armor/leather/vest/winterjacket
	shoes = /obj/item/clothing/shoes/nobleboot
	beltl = /obj/item/ammo_holder/quiver/bolt/holy
	mask = /obj/item/clothing/face/goggles
	beltr = /obj/item/weapon/sword/silver ///Giving them something that ISNT an exact copy of the witch hunter.
	belt = /obj/item/storage/belt/leather/steel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/silver = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
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
