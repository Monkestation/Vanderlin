/datum/attribute_holder/sheet/job/oracle
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 4,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/reading = 60,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/magic/arcane = 40,
		/datum/attribute/skill/magic/holy = 40,
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

/datum/attribute_holder/sheet/job/oracle/old
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 5,
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

/datum/job/admin/oracle
	title = JOB_ADMIN_ORACLE
	tutorial = "You are a devoted follower of Noc. \
	The Moon Prince has chosen you. \
	Guide and educate the faithful. \
	You are the light in the night, watcher of dreams."
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_TOWN)

	cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)

	outfit = /datum/outfit/oracle
	honorary = "Oracle"

	magic_user = TRUE
	give_bank_account = 30
	knows_the_town = TRUE
	known_by_the_town = TRUE

	jobs_i_always_know = list(JOB_MONARCH, JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)
	jobs_always_know_me = list(JOB_ADMIN_ORACLE, JOB_ADMIN_LUNAR_SENTINEL, JOB_ADMIN_LUNAR_CHAMPION)

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
		TRAIT_LUNAR_ORDER,
		TRAIT_BLINDFIGHTING,
		TRAIT_SORCERER,
	)

	languages = list(
		/datum/language/celestial_moon,
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
		/datum/language/deepspeak,
		/datum/language/thievescant
	)

/datum/job/admin/oracle/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_oracle()
		devotion.grant_to(spawned)
	spawned.apply_status_effect(/datum/status_effect/buff/nocblessed)

	spawned.adjust_technique_mastery_points(12)
	spawned.adjust_form_mastery_points(20)
	spawned.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)

/datum/outfit/oracle
	name = JOB_ADMIN_ORACLE
	neck = /obj/item/clothing/neck/psycross/silver/divine/noc
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/flail/silver/noc
	beltr = /obj/item/storage/keyring/oracle
	armor = /obj/item/clothing/shirt/robe/noc
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/colored/chalk
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
	oracle.oracleannouncement()

/mob/living/carbon/human/proc/oracleannouncement()
	set name = "Oracle Announcement"
	set category = "RoleUnique.Divine"
	if(stat)
		return
	if(!istype(get_area(src), /area/indoors/town/church/dreamcave))
		to_chat(src, "<span class='warning'>I need to do this from the Dream Cave.</span>")
		return FALSE
	var/inputty = SANITIZE_HEAR_MESSAGE(html_decode(tgui_input_text(src, "Make an announcement to the faithful", "Oracle Announcement", multiline = TRUE)))
	if(inputty)
		priority_announce("[inputty]", title = "The Lunar Oracle Speaks", sound = 'sound/misc/bell.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Oracle announcement")

/obj/item/storage/keyring/oracle
	keys = list(/obj/item/key/priest, /obj/item/key/church, /obj/item/key/graveyard, /obj/item/key/lunar_oracle)

/obj/item/key/lunar_oracle
	name = "dream key"
	desc = "A mysterious key to an even more mysterious place..."
	icon_state = "ekey"
	lockids = list("Dreamcave")
