
/datum/attribute_holder/sheet/job/mason
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/labor/mining = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/masonry = 40,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/mason
	title = "Mason"
	tutorial = "This city's walls have a memory, and you are their confidant. You work pavement, polish marble, and carve statues for the vainglory of your overlord. \
	Your true liege, however, is this town's stone. Treat it well, and when your foolish master inevitably gets overthrown, all you have maintained shall in turn protect you."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MASON
	faction = FACTION_TOWN
	total_positions = 6
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/mason
	give_bank_account = 8
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/mason

/datum/job/mason/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna.species.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/outfit/mason
	name = "Mason"
	head = /obj/item/clothing/head/hatfur
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/apron/waist/colored/brown
	neck = /obj/item/storage/belt/pouch/coins/mid
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/hammer
	beltr = /obj/item/weapon/chisel
	backl = /obj/item/storage/backpack/backpack

/datum/outfit/mason/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/tunic/colored/random)
	if(H.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
	else
		head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu)

