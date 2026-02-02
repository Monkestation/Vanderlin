/datum/job/advclass/bandit/sawbones // doctor class. like the pilgrim, but more evil
	title = "Sawbones"
	tutorial = "It was an accident! Your patient wasn't using his second kidney, anyway. After an unfortunate 'misunderstanding' with the town and your medical practice, you know practice medicine on the run with your new associates. Business has never been better!"
	outfit = /datum/outfit/bandit/sawbones
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit3.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MEDICAL)

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_LCK = 1,
	)

	skills = list(
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 2,
		/datum/skill/labor/lumberjacking = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 1,
		/datum/skill/misc/medicine = 5,
		/datum/skill/misc/sewing = 3,
		/datum/skill/craft/alchemy = 2,
	)

	traits = list(
		TRAIT_FORAGER,
	)

	spells = list(
		/datum/action/cooldown/spell/diagnose
	)

/datum/job/advclass/bandit/sawbones/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)


/datum/outfit/bandit/sawbones
	name = "Sawbones (Bandit)"
	mask = /obj/item/clothing/face/facemask/steel
	head = /obj/item/clothing/head/tophat
	armor = /obj/item/clothing/armor/leather/vest
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/cleaver
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/simpleshoes
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/backpack/satchel/surgbag
	backpack_contents = list(/obj/item/natural/worms/leech = 1, /obj/item/natural/cloth = 2)