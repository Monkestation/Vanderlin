/datum/attribute_holder/sheet/job/lunar_champion
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
	)

/datum/job/admin/lunar_champion
	title = JOB_ADMIN_LUNAR_CHAMPION
	tutorial = "You are a devoted follower of Noc. \
	Champion of the Lunar Order you guard their most sacred places. \
	Keep safe the nite."
	department_flag = ADMIN_SPECIAL
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_TOWN)
	cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)

	outfit = /datum/outfit/lunar_champion

	give_bank_account = 30
	knows_the_town = TRUE
	known_by_the_town = TRUE

	jobs_i_always_know = list(JOB_MONARCH, JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)
	jobs_always_know_me = list(JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/lunar_champion

	traits = list(
		TRAIT_LUNAR_ORDER,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_DUALWIELDER,
	)

	languages = list(
		/datum/language/celestial_moon,
		/datum/language/celestial,
		/datum/language/hellspeak
	)

/datum/job/admin/lunar_champion/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_lunar_champion()
		devotion.grant_to(spawned)

/datum/outfit/lunar_champion
	name = JOB_ADMIN_LUNAR_CHAMPION
	head = /obj/item/clothing/head/helmet/visored/knight/owl/lunar
	neck = /obj/item/clothing/neck/gorget/silver
	armor = /obj/item/clothing/armor/plate/silver
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/platelegs/silver
	shoes = /obj/item/clothing/shoes/boots/armor/silver
	gloves = /obj/item/clothing/gloves/plate/silver
	cloak = /obj/item/clothing/cloak/stabard/templar/noc
	wrists = /obj/item/clothing/neck/psycross/silver/divine/noc
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/sabre/noc
	beltr = /obj/item/weapon/flail/silver/noc
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/belt/pouch/coins/rich = 1,
		/obj/item/storage/keyring/oracle,
		/obj/item/flashlight/flare/torch/lantern,
	)
