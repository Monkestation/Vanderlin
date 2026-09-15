/datum/job/courtagent
	title = JOB_COURT_AGENT
	tutorial = "Whether acquired by merit, shrewd negotiation or fulfilled bounties, \
	you have found yourself under the underhanded employ of the Hand. \
	Fulfill desires and whims of the court that they would rather not be publicly known. \
	Your position is anything but secure, and any mistake can leave you disowned and charged like the petty criminal you are."
	department_flag = NOBLEMEN
	job_flags = (JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_TOWN, SUB_FACTION_KEEP)
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE

	knows_the_town = TRUE
	known_by_the_town = FALSE
	jobs_i_always_know = KNOW_COURT_AGENT_LIST
	jobs_always_know_me = list(JOB_MONARCH, JOB_HAND, JOB_COURT_AGENT)

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/courtagent
	advclass_cat_rolls = list(CTAG_COURTAGENT = 20)
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
	job_bitflag = BITFLAG_GARRISON // counts for antag shit

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_COMBAT) //noble EXP as new Court Agents may want to transition to playing Hand with enough hours played
	exp_requirements = list(
		EXP_TYPE_LIVING = 300,
	)

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS,
		TRAIT_KNOW_COURTAGENT_DOORS,
		TRAIT_KNOWCOURTAGENTS,
		TRAIT_KNOWBANDITS
	)
	traits = list(
		TRAIT_COURTAGENT,
		TRAIT_STEELHEARTED,
		TRAIT_KEENEARS
	)
	verbs = list(
		/mob/living/carbon/human/proc/torture_victim
	)

	languages = list(/datum/language/thievescant)

/datum/job/courtagent/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	if(ishuman(spawned))
		GLOB.court_agents += spawned.real_name
	return ..()

/datum/outfit/courtagent
	abstract_type = /datum/outfit/courtagent
	name = "Court Agent Base"

/datum/job/advclass/courtagent
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_COMBAT)
	factions = list(FACTION_TOWN, SUB_FACTION_KEEP)

/datum/job/advclass/courtagent/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/rings = list(
		"Bronze Ring" = /obj/item/clothing/ring/courtagent_ring/bronze,
		"Silver Ring" = /obj/item/clothing/ring/courtagent_ring/silver,
		"Gold Ring" = /obj/item/clothing/ring/courtagent_ring/gold,
	)
	spawned.select_equippable(player_client, rings, message = "Choose Your Ring", title = "COURT AGENT")

/datum/attribute_holder/sheet/job/courtagent
	raw_attribute_list = list(
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
	)
