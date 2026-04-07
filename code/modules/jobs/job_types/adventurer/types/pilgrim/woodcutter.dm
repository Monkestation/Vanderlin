/datum/attribute_holder/sheet/job/pilgrim/woodcutter
	attribute_variance = list(
		/datum/attribute/skill/misc/athletics = list(30, 40)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/lumberjacking = 30,
	)

/datum/job/advclass/pilgrim/woodcutter
	title = "Woodcutter"
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/pilgrim/woodcutter
	apprentice_name = "Woodcutter"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/woodcutter

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
