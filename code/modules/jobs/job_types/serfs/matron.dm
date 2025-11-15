/datum/job/matron
	title = "Matron"
	tutorial = "You are the Matron of the orphanage, once a cunning rogue who walked the shadows alongside legends.\
	Time has softened your edge but not your wit, thanks to your unlikely kinship with your old adventuring party.\
	Now, you guide the orphans with both a firm and gentle hand, ensuring they grow up sharp, swift, and self-sufficient.\
	Perhaps one dae, those fledglings might leap from the your nest and soar to a greater legacy."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MATRON
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	min_pq = 10

	allowed_sexes = list(FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONEXOTIC
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/matron
	give_bank_account = 35
	can_have_apprentices = TRUE
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'

	spells = list(
		/datum/action/cooldown/spell/undirected/hag_call,
		/datum/action/cooldown/spell/undirected/seek_orphan,
	)

/datum/outfit/matron/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	if(H.age == AGE_OLD) // So that the role isn't roadkill
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE) //She is a old thief.
		H.change_stat(STATKEY_SPD, 1) //this is to counter the negative spd/end stats from being old so they can chase the orphans in case they're not listening, the other stats are left untouched.
		H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2)
	H.grant_language(/datum/language/thievescant)
	to_chat(H, "<span class='info'>I can gesture in thieves' cant with ,t before my speech.</span>")
	ADD_TRAIT(H, TRAIT_THIEVESGUILD, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OLDPARTY, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EARGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KITTEN_MOM, TRAIT_GENERIC)
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	armor = /obj/item/clothing/armor/leather/vest/colored/black
	pants = /obj/item/clothing/pants/trou/beltpants
	belt = /obj/item/storage/belt/leather/cloth/lady
	shoes = /obj/item/clothing/shoes/boots/leather
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		beltl = /obj/item/storage/belt/pouch/coins/rich
	else
		beltl = /obj/item/storage/belt/pouch/coins/mid
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/matron
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel = 1, /obj/item/key/matron = 1)
