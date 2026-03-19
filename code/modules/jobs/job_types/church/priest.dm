/datum/attribute_holder/sheet/job/priest
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/attribute_holder/sheet/job/priest/old
	raw_attribute_list = list(
		 STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/magic/holy = 50,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30
	)
#define PRIEST_ADD_PENANCE "Assign Penance"
#define PRIEST_REMOVE_PENANCE "Absolve Penance"
#define PRIEST_EXCOMMUNICATE "Excommunicate"
#define PRIEST_CORONATE "Coronate"
#define PRIEST_ANNOUNCE "Announcement"
#define PRIEST_CURSE "Curse"

/datum/job/priest
	title = "Priest"
	f_title = "Priestess"
	tutorial = "You are a devoted follower of Astrata. \
	The divine is all that matters in an immoral world. \
	The Sun Queen and her pantheon rule over all, and you will preach their wisdom to Vanderlin. \
	It is up to you to shepherd the flock into a Ten-fearing future."
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_PRIEST
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	selection_color = "#c2a45d"
	cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/astrata)

	outfit = /datum/outfit/priest
	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/convert_role/church/templar,
		/datum/action/cooldown/spell/undirected/list_target/convert_role/church/acolyte,
		/datum/action/cooldown/spell/undirected/list_target/convert_role/church/churchling,
		/datum/action/cooldown/spell/undirected/call_bird/priest,
	)
	honorary = "Vicar"

	exp_type = list(EXP_TYPE_CHURCH)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/priest
	attribute_sheet_old = /datum/attribute_holder/sheet/job/priest/old

	languages = list(/datum/language/celestial)
	can_have_apprentices = FALSE

/datum/job/priest/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.give_priest_verbs()

	spawned.virginity = TRUE

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_priest()
		devotion.grant_to(spawned)

/datum/outfit/priest
	name = "Priest"
	neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
	head = /obj/item/clothing/head/priestmask
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/shortboots
	beltl = /obj/item/storage/keyring/priest
	belt = /obj/item/storage/belt/leather/rope
	armor = /obj/item/clothing/shirt/robe/priest
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/storage/belt/pouch/coins/rich = 1
	)
	l_hand = /obj/item/weapon/polearm/woodstaff/aries

/datum/job/priest/demoted
	title = "Ex-Priest"
	f_title = "Ex-Priestess"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK)
	department_flag = CHURCHMEN
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0

/datum/job/priest/vice
	title = "Vice Priest"
	f_title = "Vice Priestess"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK)
	department_flag = CHURCHMEN
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0

/mob/living/carbon/human/proc/coronate_lord()
	set name = "Coronate"
	set category = "RoleUnique.Divine"
	if(!mind)
		return
	if(!istype(get_area(src), /area/indoors/town/church/chapel))
		to_chat(src, span_warning("I need to do this in my Chapel."))
		return FALSE

	var/mob/living/carbon/coronated
	for(var/mob/living/carbon/HU in get_step(src, src.dir))
		if(!HU.mind)
			continue
		if(is_lord_job(HU.mind.assigned_role))
			continue
		if(!HU.head)
			continue
		if(!istype(HU.head, /obj/item/clothing/head/crown/serpcrown))
			continue

		coronated = HU
		break

	if(!coronated)
		to_chat(src, span_warning("There are none capable of coronation in front of me."))
		return

	var/datum/job/lord_job = SSjob.GetJobType(/datum/job/lord)
	var/datum/job/consort_job = SSjob.GetJobType(/datum/job/consort)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.mind)
			if(is_lord_job(HL.mind.assigned_role) || is_consort_job(HL.mind.assigned_role))
				HL.mind.set_assigned_role(SSjob.GetJobType(/datum/job/villager))
		if(HL.job == "Monarch")
			HL.job = "Ex-Monarch"
			lord_job?.remove_spells(HL)
			HL.honorary = "Former [lord_job.honorary]"
		if(HL.job == "Consort")
			HL.job = "Ex-Consort"
			consort_job?.remove_spells(HL)

	var/new_title = (coronated.gender == MALE) ? SSmapping.config.monarch_title : SSmapping.config.monarch_title_f
	coronated.mind.set_assigned_role(/datum/job/lord)
	lord_job?.assign_honorary_titles(coronated)
	lord_job?.get_informed_title(coronated, TRUE, new_title)
	coronated.job = "Monarch"
	lord_job?.add_spells(coronated)
	SSticker.rulermob = coronated
	GLOB.badomens -= OMEN_NOLORD
	say("By the authority of the Gods, I pronounce you Ruler of all [SSmapping.config.map_name]!")
	priority_announce("[real_name] the [mind.assigned_role.get_informed_title(src)] has named [coronated.real_name] the inheritor of [SSmapping.config.map_name]!", \
	title = "Long Live [lord_job.get_informed_title(coronated)] [coronated.real_name]!", sound = 'sound/misc/bell.ogg')

/mob/living/carbon/human/proc/churchexcommunicate()
	set name = "Excommunicate"
	set category = "RoleUnique.Divine"
	if(stat)
		return
	if(!istype(get_area(src), /area/indoors/town/church/chapel))
		to_chat(src, span_warning("I need to do this from the prayer hall."))
		return FALSE
	var/inputty = input("Excommunicate someone, cutting off their connection to the Ten. (excommunicate them again to remove it)", "Sinner Name") as text|null
	if(inputty)
		if(inputty in GLOB.excommunicated_players)
			GLOB.excommunicated_players -= inputty
			priority_announce("[real_name] has forgiven [inputty]. The Ten hear their prayers once more!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.real_name == inputty)
					H.cleric?.recommunicate()
			return
		if(length(GLOB.tennite_schisms))
			to_chat(src, span_warning("I cannot excommunicate anyone during the schism!"))
			return FALSE

		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.real_name == inputty)
				if(H.job == "Faceless One")
					to_chat(src, span_danger("I wasn't able to do that!"))
					return FALSE
				H.cleric?.excommunicate()
				GLOB.excommunicated_players += inputty
				priority_announce("[real_name] has excommunicated [inputty]! The Ten have turned away from them!", title = "SHAME", sound = 'sound/misc/excomm.ogg')
				break

/mob/living/carbon/human/proc/churchcurse()
	set name = "Curse"
	set category = "RoleUnique.Divine"
	if(stat)
		return
	if(!istype(get_area(src), /area/indoors/town/church/chapel))
		to_chat(src, "<span class='warning'>I need to do this from the prayer hall.</span>")
		return FALSE
	var/inputty = input("Curse someone as a heretic. (curse them again to remove it)", "Sinner Name") as text|null
	if(inputty)
		if(inputty in GLOB.heretical_players)
			GLOB.heretical_players -= inputty
			priority_announce("[real_name] has forgiven [inputty]. Once more walk in the light!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')
			for(var/mob/living/carbon/H in GLOB.player_list)
				if(H.real_name == inputty)
					H.remove_stress(/datum/stress_event/psycurse)
			return
		if(length(GLOB.tennite_schisms))
			to_chat(src, span_warning("I cannot curse anyone during the schism!"))
			return FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.real_name == inputty)
				if(H.job == "Faceless One")
					to_chat(src, span_danger("I wasn't able to do that!"))
					return FALSE
				H.add_stress(/datum/stress_event/psycurse)
				GLOB.heretical_players += inputty
				priority_announce("[real_name] has put Xylix's curse of woe on [inputty] for offending the church!", title = "SHAME", sound = 'sound/misc/excomm.ogg')
				break

/mob/living/carbon/human/proc/churchannouncement()
	set name = "Priest Announcement"
	set category = "RoleUnique.Divine"
	if(stat)
		return
	if(!istype(get_area(src), /area/indoors/town/church/chapel))
		to_chat(src, "<span class='warning'>I need to do this from the prayer hall.</span>")
		return FALSE
	var/inputty = input("Make an announcement", "VANDERLIN") as text|null
	if(inputty)
		priority_announce("[inputty]", title = "The [get_role_title()] Speaks", sound = 'sound/misc/bell.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Priest announcement")

/// Helper for giving priest verbs, and whether that should include coronation or penance verbs.
/mob/living/carbon/human/proc/give_priest_verbs(coronate = TRUE, penance = TRUE)
	var/datum/action/priestly_powers/action = new(src)

	if(coronate)
		action.authorized_powers += PRIEST_CORONATE
	if(penance)
		action.authorized_powers += PRIEST_ADD_PENANCE
		action.authorized_powers += PRIEST_REMOVE_PENANCE
	action.Grant(src)

/// Helper for removing priest verbs
/mob/living/carbon/human/proc/remove_priest_verbs()
	for(var/datum/action/priestly_powers/priest_action in actions)
		priest_action.Remove(src)

/datum/action/priestly_powers
	name = "Invoke Divine Authority"
	desc = "Invoke your divine authority."
	button_icon_state = "recruit_acolyte"
	check_flags = AB_CHECK_CONSCIOUS
	var/list/authorized_powers = list(PRIEST_ANNOUNCE, PRIEST_CURSE, PRIEST_EXCOMMUNICATE)

/datum/action/priestly_powers/Trigger(trigger_flags)
	. = ..()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/priest = owner

	var/choice = tgui_input_list(priest, "What right do you wish to invoke?", "Choice", authorized_powers)
	if(!choice)
		return

	switch(choice)
		if(PRIEST_ANNOUNCE)
			priest.churchannouncement()
		if(PRIEST_CURSE)
			priest.churchcurse()
		if(PRIEST_EXCOMMUNICATE)
			priest.churchexcommunicate()
		if(PRIEST_ADD_PENANCE)
			priest.assign_penance_verb()
		if(PRIEST_REMOVE_PENANCE)
			priest.absolve_penance_verb()
		if(PRIEST_CORONATE)
			priest.coronate_lord()

#undef PRIEST_ANNOUNCE
#undef PRIEST_CURSE
#undef PRIEST_EXCOMMUNICATE
#undef PRIEST_ADD_PENANCE
#undef PRIEST_REMOVE_PENANCE
#undef PRIEST_CORONATE
