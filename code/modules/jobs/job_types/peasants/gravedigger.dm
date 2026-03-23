/datum/attribute_holder/sheet/job/undertaker
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = -1,
		STAT_FORTUNE = -1,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 20, //Wrestling the deadites
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 30,
		/datum/attribute/skill/labor/mathematics = 20
	)

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
	can_be_apprentice = TRUE

	job_bitflag = BITFLAG_CHURCH

	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/undertaker

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
	neck = /obj/item/clothing/neck/psycross/silver/divine/necra
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
