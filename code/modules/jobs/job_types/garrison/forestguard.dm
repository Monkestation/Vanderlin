/datum/job/forestguard
	title = "Forest Guard"
	tutorial = "You've been keeping the streets clean of neer-do-wells and taffers for most of your time in the garrison.\
	You've been through the wringer - having been a soldier in the short-lived Goblin Wars. \
	You've emerged through it, beaten to hell.\
	Alive, but you wouldn't call it living. \
	\n\n\
	A fellow soldier had been given the title of Forest Warden for his valorant efforts \
	and he's plucked you from one dangerous position into another. \
	Atleast with the battle-brothers by your side, you will never die alone."
	flag = FORGUARD
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_FORGUARD
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	min_pq = 5
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_GUARD
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	outfit = /datum/outfit/job/forestguard
	advclass_cat_rolls = list(CTAG_FORGARRISON = 20)

/datum/outfit/job/forestguard
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/forestguard/pre_equip(mob/living/carbon/human/H)
	..()
	if(SSmapping.config.map_name == "Rosewood")
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
	else
		cloak = /obj/item/clothing/cloak/forrestercloak
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	shirt = /obj/item/clothing/shirt/undershirt/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather
	backl = /obj/item/storage/backpack/satchel

/datum/job/forestguard/after_spawn(mob/living/carbon/spawned, client/player_client)
	..()

// Axes Maces and Swords
/datum/advclass/forestguard/infantry
	name = "Forest Infantry"
	tutorial = "In the goblin wars you were deployed to the front lines, you caved in thier skulls and chopped thier legs off."
	outfit = /datum/outfit/job/forestguard/infantry
	category_tags = list(CTAG_FORGARRISON)

/datum/outfit/job/forestguard/infantry/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/gorget
	beltl = /obj/item/weapon/mace/steel/morningstar
	beltr = /obj/item/weapon/axe/iron
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/key/forrestgarrison = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell


	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_SPD, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORESTGUARD, TRAIT_GENERIC)

// Bows and Knives
/datum/advclass/forestguard/ranger
	name = "Forest Ranger"
	tutorial = "In the goblin wars you were always one of the fastest aswell as one of the weakest in the platoon. Your trusty bow has served you well."
	outfit = /datum/outfit/job/forestguard/ranger
	category_tags = list(CTAG_FORGARRISON)

/datum/outfit/job/forestguard/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif
	beltl = /obj/item/weapon/knife/cleaver/combat
	beltr = /obj/item/ammo_holder/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/key/forrestgarrison = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.change_stat(STATKEY_STR, -2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_SPD, 3)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FORESTGUARD, TRAIT_GENERIC)

// Reaver
/datum/advclass/forestguard/reaver
	name = "Forest Reaver"
	tutorial = "In the goblin wars you took an oath to never shy from a hit, you just enjoy the chaos of battle..."
	outfit = /datum/outfit/job/forestguard/reaver
	category_tags = list(CTAG_FORGARRISON)

/datum/outfit/job/forestguard/reaver/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/chaincoif
	beltl = /obj/item/weapon/mace/steel/morningstar
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	beltr = /obj/item/weapon/axe/iron
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/key/forrestgarrison = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_END, 3)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FORESTGUARD, TRAIT_GENERIC)
