/datum/job/adept
	title = "Adept"
	tutorial = "You were a convicted criminal, the lowest scum of Vanderlin. \
	Your master, the Inquisitor, saved you from the gallows \
	and has given you true purpose in service to Psydon. \
	You will not let him down."
	department_flag = INQUISITION
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SHEPHERD
	selection_color = JCOLOR_INQUISITION
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	min_pq = 5
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/adept
	advclass_cat_rolls = list(CTAG_ADEPT = 20)
	can_have_apprentices = FALSE
	is_foreigner = TRUE

	job_bitflag = BITFLAG_CHURCH

/datum/outfit/adept // Base outfit for Adepts, before loadouts
	name = "Adept"
	shoes = /obj/item/clothing/shoes/boots
	mask = /obj/item/clothing/face/facemask/silver
	beltr = /obj/item/storage/belt/pouch/coins/poor
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/armor/gambeson/light/colored/black
	wrists = /obj/item/clothing/neck/psycross/silver

/datum/outfit/adept/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		if(H.mind.has_antag_datum(/datum/antagonist))
			return
		var/datum/antagonist/new_antag = new /datum/antagonist/purishep()
		H.mind.add_antag_datum(new_antag)
		H.set_patron(/datum/patron/psydon, TRUE)
		H.verbs |= /mob/living/carbon/human/proc/torture_victim
		H.verbs |= /mob/living/carbon/human/proc/faith_test
		H.verbs |= /mob/living/carbon/human/proc/view_inquisition

		if(!H.has_language(/datum/language/oldpsydonic))
			H.grant_language(/datum/language/oldpsydonic)
			to_chat(H, span_info("I can speak Old Psydonic with ,m before my speech."))
		H.mind.teach_crafting_recipe(/datum/repeatable_crafting_recipe/reading/confessional)
