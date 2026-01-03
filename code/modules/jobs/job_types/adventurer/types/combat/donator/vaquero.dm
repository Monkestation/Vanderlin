/datum/job/advclass/combat/vaquero
	title = "Vaquero"
	tutorial = "You have been taming beasts of burden all your life, and riding since you were old enough to walk. Perhaps these lands will have use for your skills?"
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/adventurer/vaquero
	cmode_music = 'sound/music/cmode/adventurer/combat_vaquero.ogg'
	category_tags = list(CTAG_ADVENTURER)
	roll_chance = 30
	total_positions = 1

	skills = list(
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 2, // Makes sense enough for an animal tamer
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 5,
		/datum/skill/labor/taming = 4, // How did they not have this skill before?!
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/lockpicking = 1,
		/datum/skill/misc/reading = 2,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/combat/vaquero/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))
	spawned.adjust_skillrank(/datum/skill/misc/music, rand(1, 2), TRUE)

/datum/outfit/adventurer/vaquero
	name = "Vaquero (Adventurer)"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/half/colored/red
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/weapon/sword/rapier
	beltr = /obj/item/weapon/whip
	neck = /obj/item/clothing/neck/chaincoif
	mask = /obj/item/alch/herb/rosa
