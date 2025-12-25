/datum/job/advclass/pilgrim/woodcutter
	title = "Woodcutter"
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/pilgrim/woodcutter
	apprentice_name = "Woodcutter"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/lumberjacking = 3
	)

/datum/job/advclass/pilgrim/woodcutter/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/athletics, pick(3, 3, 4), TRUE)

/datum/outfit/pilgrim/woodcutter
	name = "Woodcutter (Pilgrim)"
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	pants = /obj/item/clothing/pants/trou
	neck = /obj/item/clothing/neck/coif
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/bracers/leather
	armor = /obj/item/clothing/armor/gambeson/light/striped
	beltr = /obj/item/weapon/axe/iron
	beltl = /obj/item/weapon/knife/villager
	backpack_contents = list(/obj/item/flint = 1)

/datum/outfit/pilgrim/woodcutter/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
