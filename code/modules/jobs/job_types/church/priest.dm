/datum/job/priest
	title = "Priest"
	f_title = "Priestess"
	tutorial = "You are a devoted follower of Astrata. \
	The divine is all that matters in an immoral world. \
	The Sun Queen and her pantheon rule over all, and you will preach their wisdom to Vanderlin. \
	It is up to you to shephard the flock into a Ten-fearing future."
	flag = PRIEST
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_PRIEST
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	min_pq = 20
	bypass_lastclass = TRUE
	selection_color = "#c2a45d"
	cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	outfit = /datum/outfit/job/priest
	spells = list(
		/obj/effect/proc_holder/spell/self/convertrole/templar,
		/obj/effect/proc_holder/spell/self/convertrole/monk,
		/obj/effect/proc_holder/spell/self/convertrole/churchling,
	)

/datum/outfit/job/priest/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	H.verbs |= /mob/living/carbon/human/proc/coronate_lord
	H.verbs |= /mob/living/carbon/human/proc/churchexcommunicate
	H.verbs |= /mob/living/carbon/human/proc/churchcurse
	H.verbs |= /mob/living/carbon/human/proc/churchannouncement
	neck = /obj/item/clothing/neck/psycross/silver/astrata
	head = /obj/item/clothing/head/priestmask
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/black
	shoes = /obj/item/clothing/shoes/shortboots
	beltl = /obj/item/storage/keyring/priest
	belt = /obj/item/storage/belt/leather/rope
	armor = /obj/item/clothing/shirt/robe/priest
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle = 1, /obj/item/storage/belt/pouch/coins/rich = 1 )

	var/obj/item/weapon/polearm/woodstaff/aries/P = new()
	H.put_in_hands(P, forced = TRUE)

	if(H.patron != /datum/patron/divine/astrata) // For some stupid reason this was checking for Dendor before.
		H.set_patron(/datum/patron/divine/astrata)

	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE) // Privilege of being the SECOND biggest target in the game, and arguably the worse of the two targets to lose
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.change_stat(STATKEY_STR, 1) // One slot and a VERY important role, it deserves a half-decent statline
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 1)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron) // This creates the cleric holder used for devotion spells
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	C.grant_spells_priest(H)

	H.update_icons()

/datum/job/priest/demoted //just used to change the priest title
	title = "Ex-Priest"
	f_title = "Ex-Priestess"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK)
	flag = PRIEST
	department_flag = CHURCHMEN
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 0

/datum/job/priest/vice //just used to change the priest title
	title = "Vice Priest"
	f_title = "Vice Priestess"
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_EQUIP_RANK)
	flag = PRIEST
	department_flag = CHURCHMEN
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 0

/mob/living/carbon/human/proc/coronate_lord()
	set name = "Coronate"
	set category = "Priest"
	if(!mind)
		return
	if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
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
		//this sucks ass. refactor to locate the current ruler/consort
		if(HL.mind)
			if(is_lord_job(HL.mind.assigned_role) || is_consort_job(HL.mind.assigned_role))
				HL.mind.set_assigned_role(SSjob.GetJobType(/datum/job/villager))
		//would be better to change their title directly, but that's not possible since the title comes from the job datum
		if(HL.job == "Monarch")
			HL.job = "Ex-Monarch"
			lord_job?.remove_spells(HL)
		if(HL.job == "Consort")
			HL.job = "Ex-Consort"
			consort_job?.remove_spells(HL)

	coronated.mind.set_assigned_role(/datum/job/lord)
	coronated.job = "Monarch" //Monarch is used when checking if the ruler is alive, not "King" or "Queen". Can also pass it on and have the title change properly later.
	lord_job?.add_spells(coronated)
	SSticker.rulermob = coronated
	GLOB.badomens -= OMEN_NOLORD
	say("By the authority of the Gods, I pronounce you Ruler of all [SSmapping.config.map_name]!")
	priority_announce("[real_name] the [mind.assigned_role.get_informed_title(src)] has named [coronated.real_name] the inheritor of [SSmapping.config.map_name]!", \
	title = "Long Live [lord_job.get_informed_title(coronated)] [coronated.real_name]!", sound = 'sound/misc/bell.ogg')

/mob/living/carbon/human/proc/churchexcommunicate()
	set name = "Excommunicate"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Excommunicate someone, cutting off their connection to the Ten. (excommunicate them again to remove it)", "Sinner Name") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, span_warning("I need to do this from the chapel."))
			return FALSE
		if(inputty in GLOB.excommunicated_players)
			GLOB.excommunicated_players -= inputty
			priority_announce("[real_name] has forgiven [inputty]. The Ten hear their prayers once more!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.real_name == inputty)
					H.cleric?.recommunicate()
			return
		if(length(GLOB.tennite_schisms))
			to_chat(src, span_warning("I cannot excommunicate anyone during the schism!"))
			return FALSE

		var/found = FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.advjob == "Faceless One")
				to_chat(src, span_danger("I wasn't able to do that!"))
				return FALSE
			if(H.real_name == inputty)
				found = TRUE
				H.cleric?.excommunicate()
		if(!found)
			return FALSE

		GLOB.excommunicated_players += inputty
		priority_announce("[real_name] has excommunicated [inputty]! The Ten have turned away from them!", title = "SHAME", sound = 'sound/misc/excomm.ogg')

/mob/living/carbon/human/proc/churchcurse()
	set name = "Curse"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Curse someone as a heretic. (curse them again to remove it)", "Sinner Name") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, "<span class='warning'>I need to do this from the chapel.</span>")
			return FALSE
		if(inputty in GLOB.heretical_players)
			GLOB.heretical_players -= inputty
			priority_announce("[real_name] has forgiven [inputty]. Once more walk in the light!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')
			for(var/mob/living/carbon/H in GLOB.player_list)
				if(H.real_name == inputty)
					H.remove_stress(/datum/stressevent/psycurse)
			return
		if(length(GLOB.tennite_schisms))
			to_chat(src, span_warning("I cannot curse anyone during the schism!"))
			return FALSE
		var/found = FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.advjob == "Faceless One")
				to_chat(src, span_danger("I wasn't able to do that!"))
				return FALSE
			if(H.real_name == inputty)
				found = TRUE
				H.add_stress(/datum/stressevent/psycurse)
		if(!found)
			return FALSE
		GLOB.heretical_players += inputty
		priority_announce("[real_name] has put Xylix's curse of woe on [inputty] for offending the church!", title = "SHAME", sound = 'sound/misc/excomm.ogg')

/mob/living/carbon/human/proc/churchannouncement()
	set name = "Announcement"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Make an announcement", "VANDERLIN") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, "<span class='warning'>I need to do this from the chapel.</span>")
			return FALSE
		priority_announce("[inputty]", title = "The [get_role_title()] Speaks", sound = 'sound/misc/bell.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Priest announcement")

/obj/effect/proc_holder/spell/self/convertrole/templar
	name = "Recruit Templar"
	new_role = "Templar"
	overlay_state = "recruit_templar"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/templar/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(recruit, recruit.patron)
	C.grant_spells_templar(recruit)
	recruit.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)

/obj/effect/proc_holder/spell/self/convertrole/monk
	name = "Recruit Acolyte"
	new_role = "Acolyte"
	overlay_state = "recruit_acolyte"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/monk/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(recruit, recruit.patron)
	C.grant_spells(recruit)
	recruit.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)

/obj/effect/proc_holder/spell/self/convertrole/churchling
	name = "Recruit Churchling"
	new_role = "Churchling"
	overlay_state = "recruit_acolyte"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/churchling/can_convert(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//only orphans who aren't apprentices
	if(istype(recruit.mind.assigned_role, /datum/job/orphan) && !recruit.is_apprentice())
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/churchling/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(recruit, recruit.patron)
	C.grant_spells_churchling(recruit)
	recruit.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
