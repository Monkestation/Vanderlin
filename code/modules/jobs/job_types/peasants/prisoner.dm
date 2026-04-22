/datum/attribute_holder/sheet/job/prisoner
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_PERCEPTION = -1,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = -1,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/lockpicking = 20,
	)

/datum/attribute_holder/sheet/job/noble_prisoner
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/attribute_holder/sheet/job/commoner_prisoner
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/labor/fishing = 20,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/wrestling = 10,
	)

/datum/job/prisoner
	title = JOB_PRISONER
	tutorial = "For a crime, or false allegation; as a hostage against another, \
	or held for ransom: your fate until this day has been ill-starred save its first. \
	Perhaps your story, which none but you recall, \
	will move some pity from callous hearts or promises of riches parole your release. \
	Maybe your old associates conspire now to release you in a daring rescue. \
	Yet it is far surer that your tears will rust this cursed mask \
	than the sun shine upon your face a freed soul once more."
	department_flag = PEASANTS
	display_order = JDO_PRISONER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 2
	can_random = FALSE
	banned_leprosy = FALSE
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/prisoner

	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'
	can_be_apprentice = TRUE
	can_have_apprentices = FALSE
	antag_role = /datum/antagonist/prisoner

	attribute_sheet = /datum/attribute_holder/sheet/job/prisoner
	traits = list(
		TRAIT_BANDITCAMP
	)

/datum/job/prisoner/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/prisonertype = "Commoner" //If you're Tiefling, Hollowkin, or Medicator, this is your only option.
	if(spawned.dna?.species?.id in RACES_PLAYER_FOREIGNNOBLE)
		prisonertype = tgui_input_list(player_client, "What kind of prisoner are you?", "Filthy Criminal", list("Noble", "Commoner"))

	if(prisonertype == "Noble")
		SStreasury.create_bank_account(spawned, 173)
		spawned?.attributes.add_sheet(/datum/attribute_holder/sheet/job/noble_prisoner)
		ADD_TRAIT(spawned, TRAIT_NOBLE_BLOOD, TRAIT_GENERIC)
	else
		spawned?.attributes.add_sheet(/datum/attribute_holder/sheet/job/commoner_prisoner)

/datum/outfit/prisoner
	name = JOB_PRISONER
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	mask = /obj/item/clothing/face/facemask/prisoner
