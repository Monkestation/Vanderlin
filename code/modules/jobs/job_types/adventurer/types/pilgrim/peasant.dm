/datum/job/advclass/pilgrim/peasant
	title = "Peasant"
	tutorial = "A serf with no particular proficiency of their own, born poor \
				and more likely to die poor. Farm workers, carriers, handymen."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/peasant
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Handyman"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/labor/farming = 4,
		/datum/skill/labor/taming = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/tanning = 1,
		/datum/skill/misc/climbing = 2
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW
	)

/datum/job/advclass/pilgrim/peasant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/craft/crafting, rand(2, 3), TRUE)

/datum/outfit/pilgrim/peasant
	name = "Peasant (Pilgrim)"
	belt = /obj/item/storage/belt/leather/rope
	pants = /obj/item/clothing/pants/trou
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/weapon/hoe
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/gambeson/light/striped
	beltl = /obj/item/weapon/sickle
	beltr = /obj/item/weapon/flail/towner
	l_hand = /obj/item/weapon/pitchfork
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/neuFarm/seed/wheat = 1,
		/obj/item/neuFarm/seed/apple = 1,
		/obj/item/fertilizer/ash = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/weapon/shovel/small = 1
	)


/datum/outfit/pilgrim/peasant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)
	head = pick(/obj/item/clothing/head/strawhat, /obj/item/clothing/head/armingcap, /obj/item/clothing/head/headband/colored/red, /obj/item/clothing/head/roguehood/colored/random)
	shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)

	if(equipped_human.gender == FEMALE)
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
		pants = null
