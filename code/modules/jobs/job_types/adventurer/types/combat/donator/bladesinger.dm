/datum/job/advclass/combat/bladesinger
	title = "Bladesinger"
	tutorial = "Your vigil over the elven cities has long since ended. Though dutiful, the inevitable happened and now you hope these lands have use for your talents."
	allowed_races = list(SPEC_ID_ELF)
	total_positions = 1
	roll_chance = 15
	outfit = /datum/outfit/adventurer/bladesinger
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

/datum/outfit/adventurer/bladesinger/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.change_stat(STATKEY_STR, 1) // Same stat spread as lancer/swordmaster, but gets a small bonus to speed instead of a malus, at the cost of getting no constitution bonus
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_SPD, 1)
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()
	pants = /obj/item/clothing/pants/tights/colored/black
	backr = /obj/item/weapon/sword/long/greatsword/elfgsword
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	gloves = /obj/item/clothing/gloves/rare/elfplate/welfplate
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/rare/elfplate/welfplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/elfplate/welfplate
	neck = /obj/item/clothing/neck/chaincoif
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
