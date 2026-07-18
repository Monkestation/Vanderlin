/datum/attribute_holder/sheet/job/oracle
	attribute_variance = list(
		/datum/attribute/skill/magic/arcane = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 5,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/reading = 60,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/magic/arcane = 50,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 40
	)

/datum/attribute_holder/sheet/job/oracle/old
	attribute_variance = list(
		/datum/attribute/skill/magic/arcane = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = -2,
		STAT_SPEED = -2,
		/datum/attribute/skill/misc/reading = 60,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/magic/arcane = 50,
		/datum/attribute/skill/magic/holy = 50,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 40
	)

/datum/job/oracle
	title = JOB_ORACLE
	tutorial = "You are a devoted follower of Noc. \
	The Moon Prince has chosen you. \
	Guide and educate the faithful. \
	You are the light in the night, watcher of dreams."
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK)
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	selection_color = "#c2a45d"
	cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)

	outfit = /datum/outfit/oracle
	honorary = "Oracle"

	magic_user = TRUE
	spell_points = 12
	give_bank_account = 30

	exp_type = list(EXP_TYPE_CHURCH)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/oracle
	attribute_sheet_old = /datum/attribute_holder/sheet/job/oracle/old

	spells = list(
		/datum/action/oracle_announce,
	)

	traits = list(
		TRAIT_DREAM_WATCHER,
		TRAIT_EMPATH,
		TRAIT_STEELHEARTED,
	)

	languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/zalad,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/halfling,
		/datum/language/gronnic,
		/datum/language/newpsydonic,
		/datum/language/oldpsydonic,
		/datum/language/orcish,
		/datum/language/deepspeak
	)
	can_have_apprentices = FALSE

/datum/job/oracle/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	//spawned.virginity = TRUEADD_TRAIT
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_oracle()
		devotion.grant_to(spawned)
	spawned.apply_status_effect(/datum/status_effect/buff/nocblessed)

/datum/outfit/oracle
	name = JOB_ORACLE
	neck = /obj/item/clothing/neck/psycross/silver/divine/noc
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/flail/silver/noc
	beltr = /obj/item/storage/keyring/priest
	armor = /obj/item/clothing/shirt/robe/noc
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/colored/blue
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/belt/pouch/coins/rich = 1
	)

/datum/action/oracle_announce
	name = "Invoke Lunar Authority"
	desc = "Invoke your divine authority."
	button_icon_state = "recruit_acolyte"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/oracle_announce/Trigger(trigger_flags)
	. = ..()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/oracle = owner
	oracle.churchannouncement()
