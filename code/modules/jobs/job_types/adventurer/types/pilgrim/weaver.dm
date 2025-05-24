/datum/advclass/pilgrim/weaver
	name = "Weaver"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/adventurer/seamstress
	category_tags = list(CTAG_DISABLED)
	apprentice_name = "Weaver"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/job/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	belt = /obj/item/storage/belt/leather/cloth/lady
	pants = /obj/item/clothing/pants/tights/random
	shoes = /obj/item/clothing/shoes/shortboots
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/mid
	shirt = /obj/item/clothing/shirt/undershirt
	beltr = /obj/item/weapon/knife/scissors
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/natural/cloth = 1, /obj/item/natural/bundle/fibers = 1, /obj/item/needle = 1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 1)
