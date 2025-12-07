/datum/job/advclass/pilgrim/hunter
	title = "Hunter"
	tutorial = "Peasants that thrive on the woods, hunting creechers for pelt and hide, \
				or the boons of Dendor for their meat to sell, or consume."
	allowed_sexes = list(MALE)

	outfit = /datum/outfit/adventurer/hunter

	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Hunter Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg' // pilgrims aren't towners, this fits them more for a combat on the woods

/datum/outfit/adventurer/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt =  pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)
	shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = pick (/obj/item/clothing/head/brimmed, /obj/item/clothing/head/papakha, /obj/item/clothing/head/hatfur, /obj/item/clothing/head/headband/colored/red)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/storage/meatbag
	backpack_contents = list(/obj/item/reagent_containers/powder/salt = 1, /obj/item/flint = 1, /obj/item/bait = 1, /obj/item/weapon/knife/hunting = 1, /obj/item/flashlight/flare/torch/lantern = 1)
	gloves = /obj/item/clothing/gloves/leather
	if(H.mind)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/taming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_END, -1)
		else
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 3)
// Female variant below

/datum/job/advclass/pilgrim/huntress
	title = "Huntress"
	tutorial = "Women that thrive on the woods, hunting creechers for pelt and hide, \
				or the boons of Dendor for their meat to sell, or consume."
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/hunter // Everything is the same
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Huntress Apprentice"
