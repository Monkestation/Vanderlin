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
	spell_points = 17
	give_bank_account = 30
	knows_the_town = TRUE

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
	beltr = /obj/item/storage/keyring/oracle
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

/// Sentinel

/datum/attribute_holder/sheet/job/lunar_sentinel
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
	)

/datum/job/lunar_sentinel
	title = JOB_ORACLE_GUARD
	tutorial = "You are a devoted follower of Noc. \
	Sentinel of the Lunar Order you serve the agents of The Moon Prince. \
	Keep safe the nite."
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

	outfit = /datum/outfit/lunar_sentinel

	give_bank_account = 30
	knows_the_town = TRUE

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/lunar_sentinel

	traits = list(
		TRAIT_LUNAR_ORDER,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_DUALWIELDER,
	)

	languages = list(
		/datum/language/celestial,
		/datum/language/hellspeak
	)
	can_have_apprentices = FALSE

/datum/job/lunar_sentinel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

/datum/job/lunar_sentinel/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/selectable = list(
		"Moonlight Khopesh" = /obj/item/weapon/sword/sabre/noc,
		"Lunar Flail" = /obj/item/weapon/flail/silver/noc,
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "Choose Your Specialisation", title = "TEMPLAR")
	if(!choice)
		return
	switch(choice)
		if("Moonlight Khopesh")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/noc/khopesh)
		if("Lunar Flail")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/templar/patron/noc/flail)

/datum/outfit/lunar_sentinel
	name = JOB_ORACLE_GUARD
	head = /obj/item/clothing/head/helmet/visored/knight/owl/lunar
	neck = /obj/item/clothing/neck/gorget/silver
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	gloves = /obj/item/clothing/gloves/plate
	cloak = /obj/item/clothing/cloak/stabard/templar/noc
	wrists = /obj/item/clothing/neck/psycross/silver/divine/noc
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/storage/keyring/oracle
	)

/obj/item/storage/keyring/oracle
	keys = list(/obj/item/key/priest, /obj/item/key/church, /obj/item/key/graveyard, /obj/item/key/lunar_oracle)

/obj/item/key/lunar_oracle
	name = "dream key"
	desc = "A mysterious key to an even more mysterious place..."
	icon_state = "ekey"
	lockids = list("Dreamcave")


/// Champion

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

/datum/job/lunar_champion
	title = JOB_ORACLE_GUARD_HVY
	tutorial = "You are a devoted follower of Noc. \
	Champion of the Lunar Order you guard their most sacred places. \
	Keep safe the nite."
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

	outfit = /datum/outfit/lunar_champion

	give_bank_account = 30
	knows_the_town = TRUE

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
		/datum/language/celestial,
		/datum/language/hellspeak
	)
	can_have_apprentices = FALSE

/datum/job/lunar_champion/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	ADD_TRAIT(spawned, TRAIT_VIRGIN, JOB_TRAIT)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_lunar_champion()
		devotion.grant_to(spawned)

/datum/outfit/lunar_champion
	name = JOB_ORACLE_GUARD_HVY
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
