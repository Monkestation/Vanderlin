/datum/job/miner
	title = "Miner"
	tutorial = "The depths of the hills, the ends of the lands - deeper and deeper below, you seek salt, ores, rocks - \
	the heat and encroaching darkness shepherds you, giving forth your living... Soon enough, the earth will swallow you whole."
	department_flag = PEASANTS
	display_order = JDO_MINER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/miner
	give_bank_account = 6
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

	job_bitflag = BITFLAG_CONSTRUCTOR

/datum/outfit/miner/map_override(mob/living/carbon/human/H)
	if(SSmapping.config.map_name != "Voyage")
		return
	head = /obj/item/clothing/head/armingcap
	shirt = /obj/item/clothing/shirt/undershirt/sailor
	pants = /obj/item/clothing/pants/tights/sailor
	wrists = null
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/miner/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/armingcap
	pants = /obj/item/clothing/pants/trou
	armor = /obj/item/clothing/armor/gambeson/light/striped
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/pick
	backr = /obj/item/weapon/shovel
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(/obj/item/flint = 1, /obj/item/weapon/knife/villager = 1, /obj/item/storage/keyring/artificer = 1)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)//I assume they would know a thing or two about smithing
	H.adjust_skillrank(/datum/skill/craft/smelting, pick(2,3,3,4), TRUE)//if they are such good smelters
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, -2)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_CON, 1)

	if(H.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
		H.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'
	else
		beltr = /obj/item/flashlight/flare/torch/lantern
