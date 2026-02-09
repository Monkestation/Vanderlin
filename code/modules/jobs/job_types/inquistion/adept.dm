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
	bypass_lastclass = TRUE

	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/adept
	advclass_cat_rolls = list(CTAG_ADEPT = 20)
	can_have_apprentices = FALSE
	is_foreigner = TRUE


	job_bitflag = BITFLAG_CHURCH
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT)
	antag_role = /datum/antagonist/purishep
	mind_traits = list(
		TRAIT_KNOW_INQUISITION_DOORS
	)
	languages = list(/datum/language/oldpsydonic)

/datum/outfit/adept // Base outfit for Adepts, before loadouts
	name = "Adept"
	shoes = /obj/item/clothing/shoes/boots
	mask = /obj/item/clothing/face/facemask/silver
	beltr = /obj/item/storage/belt/pouch/coins/poor
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/armor/gambeson/light/colored/black
	wrists = /obj/item/clothing/neck/psycross/silver

/datum/job/advclass/adept/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", -10, "Reformed Thief")
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
	add_verb(spawned, /mob/living/carbon/human/proc/faith_test)
	add_verb(spawned, /mob/living/carbon/human/proc/view_inquisition)

	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/reading/confessional)

/datum/job/advclass/adept
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT)
