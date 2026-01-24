/datum/job/undertaker
	title = "Gravetender"
	tutorial = "As a servant of Necra, you embody the sanctity of her domain, \
	ensuring the dead rest peacefully within the earth. \
	You are the bane of grave robbers and necromancers, \
	and your holy magic brings undead back into Necra's embrace: \
	the only rightful place for lost souls."
	department_flag = CHURCHMEN
	display_order = JDO_GRAVETENDER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = list(/datum/patron/divine/necra)

	outfit = /datum/outfit/undertaker
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'

	job_bitflag = BITFLAG_CHURCH

	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 2,
		STATKEY_PER = -1,
		STATKEY_LCK = -1
	)

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 2, //Wrestling the deadites
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 3,
		/datum/skill/labor/mathematics = 2
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
		TRAIT_GRAVEROBBER
	)

	languages = list(/datum/language/celestial)

/datum/job/undertaker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Apply devotion holder
	var/holder = spawned.patron?.devotion_holder
	if (holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

/datum/outfit/undertaker
	name = "Gravetender"
	head = /obj/item/clothing/head/padded/deathshroud
	neck = /obj/item/clothing/neck/psycross/silver/necra
	pants = /obj/item/clothing/pants/trou/leather/mourning
	armor = /obj/item/clothing/shirt/robe/necra
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/gravetender
	beltr = /obj/item/storage/belt/pouch/coins/poor
	backr = /obj/item/weapon/shovel
	backpack_contents = list(/obj/item/inqarticles/tallowpot, /obj/item/reagent_containers/food/snacks/tallow/red) // Needed for coffin sanctification, they get enough for one, the rest they must source themselves.

/datum/outfit/undertaker/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.age == AGE_OLD)
		l_hand = /obj/item/weapon/mace/cane/necran
