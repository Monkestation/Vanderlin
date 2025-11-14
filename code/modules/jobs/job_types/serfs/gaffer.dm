/datum/job/gaffer
	title = "Gaffer"
	department_flag = SERFS
	faction = "Station"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE )
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_PLAYER_ALL
	//I say we let all species be the gaffer, this is job concerns the adventurers and mercs, and those come in all types and sizes,
	//so it fits better with the wild cards that is this demographic of people
	//having said that I am gate keeping the moment felinids are in the damn game
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL) //AGE_OLD with the ring on? I say unlikely - clown
	blacklisted_species = list(SPEC_ID_HALFLING)
	tutorial = "Forced out of your old adventure party, you applied to the Mercenary guild. Eventually becoming\
	the next Guild Master. Gone are the excitements of your past, today your life is engrossed with two \
	things: administrative work, and feeding the monstrous Head Eater. Act as the\
	Mercenary Guild's master in town, and make sure your members bring back the heads of any slain monsters\
	or bandits. For the Head Eater hungers..."

	display_order = JDO_GAFFER
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'
	outfit = /datum/outfit/gaffer
	give_bank_account = 20
	min_pq = 8
	bypass_lastclass = TRUE
	selection_color = "#3b150e"

	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/mercenary)

/datum/outfit/gaffer/pre_equip(mob/living/carbon/human/H, visuals_only)
	..()


	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1, /obj/item/merctoken = 2, /obj/item/natural/feather, /obj/item/paper = 3, /obj/item/weapon/knife/dagger/steel, /obj/item/paper)
	backl = /obj/item/weapon/sword/long/replica
	belt = /obj/item/storage/belt/leather/plaquegold
	beltl = /obj/item/storage/keyring/gaffer
	beltr = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	armor = /obj/item/clothing/armor/leather/hide
	if(!visuals_only)
		ring = /obj/item/clothing/ring/gold/burden
	else
		ring = /obj/item/clothing/ring/gold
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black
	mask = /obj/item/clothing/face/eyepatch/fake

	ADD_TRAIT(H, TRAIT_SEEPRICES, type)
	ADD_TRAIT(H, TRAIT_BURDEN, type)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, type)
	ADD_TRAIT(H, TRAIT_OLDPARTY, TRAIT_GENERIC)

	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_STR, 1)

	H.adjust_skillrank(/datum/skill/combat/swords, pick(1,2), TRUE) //they are practicing with their fake ass shit sword but its clearly not paying off yet
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 5, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 5, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE) //actual stealth archer
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.change_stat(STATKEY_PER, 1)

