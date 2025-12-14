/datum/job/advclass/pilgrim/fisher
	title = "Fisher"
	tutorial = "Simple folk with an affinity for catching fish out of any body of water, \
				they are decent cooks and swimmers, living off the gifts of Abyssor."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/fisher
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Fisher Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_CON = 2
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 3,
		/datum/skill/craft/cooking = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/fishing = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/climbing = 1
	)

/datum/job/advclass/pilgrim/fisher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/sewing, pick(1, 2), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(2, 2, 3), TRUE)

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)

/datum/outfit/pilgrim/fisher
	name = "Fisher (Pilgrim)"
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = /obj/item/clothing/head/fisherhat
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/fishingrod/fisher
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/flint

/datum/outfit/pilgrim/fisher/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/random
		shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)
		shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)
		armor = /obj/item/clothing/armor/gambeson/light/striped
		backpack_contents = list(
			/obj/item/weapon/knife/villager = 1,
			/obj/item/natural/worms = 1,
			/obj/item/weapon/shovel/small = 1,
			/obj/item/reagent_containers/food/snacks/saltfish = 1
		)
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
		armor = /obj/item/clothing/armor/gambeson/light/striped
		shoes = /obj/item/clothing/shoes/boots/leather
		backpack_contents = list(
			/obj/item/weapon/knife/hunting = 1,
			/obj/item/natural/worms = 1,
			/obj/item/weapon/shovel/small = 1
		)
