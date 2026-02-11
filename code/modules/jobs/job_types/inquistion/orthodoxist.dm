/datum/job/orthodoxist
	title = "Sacrestants"
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 2 // TWO GOONS!!
	spawn_positions = 2
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_DWARF)
	bypass_lastclass = TRUE
	cmode_music = 'sound/music/cmode/church/CombatInquisitor2.ogg'
	allowed_patrons = list(
		/datum/patron/psydon
	) // no extremist psydon because you've been brought up right

	tutorial = "A student of the Oratorium in training to become a full Inquisitor. You’ve come here under the stern gaze of the Herr Präfekt to prove your wits and skill. This is your week. You’re going to take your place among the blades of Psydon."
	selection_color = JCOLOR_INQUISITION

	outfit = null
	outfit_female = null


	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ORTHODOXIST

	advclass_cat_rolls = list(CTAG_INQUISITION = 20)
	same_job_respawn_delay = 30 MINUTES
	antag_role = /datum/antagonist/purishep

	mind_traits = list(
		TRAIT_KNOW_INQUISITION_DOORS
	)
	languages = list(/datum/language/oldpsydonic)

	exp_type = list(EXP_TYPE_INQUISITION)
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_INQUISITION = 120
	)

/datum/job/orthodoxist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
	add_verb(spawned, /mob/living/carbon/human/proc/faith_test)
	add_verb(spawned, /mob/living/carbon/human/proc/view_inquisition)

	spawned.hud_used?.shutdown_bloodpool()
	spawned.hud_used?.initialize_bloodpool()
	spawned.hud_used?.bloodpool.set_fill_color("#dcdddb")
	spawned.hud_used?.bloodpool?.name = "Psydon's Grace: [spawned.bloodpool]"
	spawned.hud_used?.bloodpool?.desc = "Devotion: [spawned.bloodpool]/[spawned.maxbloodpool]"
	spawned.maxbloodpool = 1000

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Old Psydonic"
		species.accent_language = species.get_accent(species.native_language)

/datum/job/advclass/sacrestant
	exp_types_granted = list(EXP_TYPE_INQUISITION, EXP_TYPE_COMBAT)
