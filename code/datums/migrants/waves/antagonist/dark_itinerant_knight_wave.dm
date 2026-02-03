/datum/migrant_role/dark_itinerant_knight
	name = "Drow Knight"
	greet_text = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	migrant_job = /datum/job/migrant/dark_itinerant_knight

/datum/job/migrant/dark_itinerant_knight
	title = "Zizo Knight"
	tutorial = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	outfit = /datum/outfit/dark_itinerant_knight
	antag_role = /datum/antagonist/zizocultist/leader
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW)
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	faction = list(FACTION_UNDEAD, FACTION_CABAL)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/misc/climbing = 1,
	)

	traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

/datum/outfit/dark_itinerant_knight
	name = "Drow Knight"
	head = /obj/item/clothing/head/helmet/heavy/zizo
	gloves = /obj/item/clothing/gloves/plate/zizo
	pants = /obj/item/clothing/pants/platelegs/zizo
	shirt = /obj/item/clothing/shirt/shadowshirt
	armor = /obj/item/clothing/armor/plate/full/zizo
	shoes = /obj/item/clothing/shoes/boots/armor/zizo
	neck = /obj/item/clothing/neck/chaincoif
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/whip/spiderwhip
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/sword/long/greatsword/zizo
	wrists = /obj/item/clothing/neck/psycross/zizo
	ring = /obj/item/clothing/ring/collar_detonator
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/dirk = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1)

/datum/migrant_role/dark_itinerant_squire
	name = "Underling Squire"
	greet_text = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	migrant_job = /datum/job/migrant/dark_itinerant_squire

/datum/job/migrant/dark_itinerant_squire
	title = "Zizo Remnant"
	tutorial = "The siege was fast - no more than an hour. An insider in the keep had jammed the gates. The city was yours to terrorize in the Dark Lady's name.\
		\n\
		But something happened in the manor. A blast of vines, then screams. Agonizing screams. Her entire army was wiped out save you and your mistress.\
		That was two daes ago. You cannot leave; the <span class='briar'>briars</span> are too thick, and you dare not touch it. You have been surviving off scraps, trapped with the rest of the ignorant swine that roam the streets.\
		\n\n\
		Take what does not belong to them."
	outfit = /datum/outfit/zizo_remnant
	allowed_sexes = list(FEMALE, MALE)
	allowed_races = list(SPEC_ID_DROW, SPEC_ID_HALF_DROW)
	allowed_ages = list(AGE_ADULT)
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	spawn_positions = 4
	total_positions = 0
	job_flags = (JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS)
	faction = list(FACTION_UNDEAD, FACTION_CABAL)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_INT = -1,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 2,
	)
	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE
	shows_in_list = FALSE
	can_have_apprentices = FALSE


	traits = list(TRAIT_STEELHEARTED, TRAIT_VILLAIN)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

/datum/job/migrant/dark_itinerant_squire/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.gender == FEMALE && isdarkelf(spawned))
		spawned.verbs |= /mob/living/carbon/human/proc/torture_victim
		spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, -1)

		ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	else
		spawned.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, 2)
		ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)



/datum/outfit/dark_itinerant_squire
	name = "Underling Squire"
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/bolts
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/zizo

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1,
	)

/datum/outfit/zizo_remnant
	name = "Zizo Remnant"
	mask = /obj/item/clothing/face/shepherd/shadowmask
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/shadowpants
	backl = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/neck/psycross/zizo
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/dirk,
		/obj/item/reagent_containers/food/snacks/stale_bread
	)

/datum/outfit/zizo_remnant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE && isdarkelf(equipped_human))
		armor = /obj/item/clothing/armor/cuirass/iron/shadowplate
		gloves = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
		neck = /obj/item/clothing/neck/highcollier
		shirt = /obj/item/clothing/shirt/shadowshirt
		cloak = /obj/item/clothing/cloak/half/shadowcloak/cult
		backpack_contents |= (/obj/item/weapon/whip/spiderwhip)
		beltl = /obj/item/weapon/sword/sabre/stalker
		beltr = /obj/item/weapon/sword/sabre/stalker
		ring = /obj/item/clothing/ring/collar_detonator
	else
		armor = /obj/item/clothing/armor/gambeson/shadowrobe
		gloves = /obj/item/clothing/gloves/eastgloves1
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		neck = /obj/item/clothing/neck/gorget/explosive/zizo
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
		beltl = /obj/item/weapon/hammer
		beltr = /obj/item/ammo_holder/quiver/arrows


/datum/migrant_wave/evil_knight
	name = "The Unknightly journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/evil_knight
	downgrade_wave = /datum/migrant_wave/evil_knight_down
	weight = 8
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
		/datum/migrant_role/dark_itinerant_squire = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."

/datum/migrant_wave/evil_knight_down
	name = "The Unknightly journey"
	shared_wave_type = /datum/migrant_wave/evil_knight
	can_roll = FALSE
	weight = 35
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."
