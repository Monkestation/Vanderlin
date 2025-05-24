/datum/job/bard
	title = "Bard"
	tutorial = "Bards make up one of the largest populations of registered adventurers in Vanderlin, \
	mostly because they are the last ones in a party to die. \
	Their wish is to experience the greatest adventures of the age and write amazing songs \
	about them. This is not your story, for you are the storyteller."
	flag = BARD
	department_flag = PEASANTS
	display_order = JDO_BARD
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/job/bard
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

/datum/outfit/job/bard/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/random
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	if(prob(30))
		gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/raincloak/blue
	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/red
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(/obj/item/flint)
	if(H.dna?.species?.id == "dwarf")
		H.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_STR, -1)

/datum/job/bard/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.select_equippable(player_client, list( \
		"Harp" = /obj/item/instrument/harp, \
		"Lute" = /obj/item/instrument/lute, \
		"Accordion" = /obj/item/instrument/accord, \
		"Guitar" = /obj/item/instrument/guitar, \
		"Flute" = /obj/item/instrument/flute, \
		"Drum" = /obj/item/instrument/drum, \
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy, \
		"Viola" = /obj/item/instrument/viola), \
		message = "Choose your instrument.", \
		title = "XYLIX"
		)
