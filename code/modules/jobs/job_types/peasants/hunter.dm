/datum/job/hunter
	title = "Hunter"
	f_title = "Huntress"
	tutorial = "Silent and yet full of life, the forests of Dendor grant you both happiness and misery. \
	In tales you've heard of small woodland creechers frolicking, now there is only the beastspawn of Graggar and Dendor... \
	And yet you seek beasts small enough to skin, scalp, and sell. Take heed, lest you become a beast yourself."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_HUNTER
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/hunter
	give_bank_account = 15
	apprentice_name = "Hunter"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

/datum/outfit/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = /obj/item/clothing/head/brimmed
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/storage/meatbag
	backpack_contents = list(/obj/item/flint = 1, /obj/item/bait = 1, /obj/item/weapon/knife/hunting = 1, /obj/item/flashlight/flare/torch/lantern = 1)
	gloves = /obj/item/clothing/gloves/leather
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
	//old people get 2 extra perception from their age, hence the if/else
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_END, -1)
	else
		H.change_stat(STATKEY_PER, 3)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)

