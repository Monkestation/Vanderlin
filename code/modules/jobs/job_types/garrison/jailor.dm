/datum/attribute_holder/sheet/job/jailor
	attribute_variance = list(
		STAT_ENDURANCE = list(4, 6),
		STAT_INTELLIGENCE = list(-6, -4),
		STAT_PERCEPTION = list(-4, -3),
		/datum/attribute/skill/combat/wrestling = list(0, 10),
		/datum/attribute/skill/combat/unarmed = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_CONSTITUTION = -2,
		STAT_SPEED = -4,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20
	)

/datum/job/jailor
	title = "Jailor"
	tutorial = "Your eyes have laid bare upon true terror in the Crimson Valley Asylum. \
	Men, ripping apart one another for their own entertainment-- \
	not for sport, not for sadism, for blood. \
	You now live in this kingdom - a quiet peaceful place \
	compared to the Asylum you once warded, \
	having once kept bloodthirsty churls locked in the dark."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_JAILOR
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0

	allowed_ages = list(AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	outfit = /datum/outfit/jailor
	give_bank_account = 25
	cmode_music = 'sound/music/cmode/nobility/CombatDungeoneer.ogg'

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 300
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/jailor

/datum/job/jailor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

/datum/outfit/jailor
	name = "Jailor"
	head = /obj/item/clothing/head/roguehood/colored/black
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather/splint
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	pants = /obj/item/clothing/pants/loincloth/colored/black
	shoes = /obj/item/clothing/shoes/shortboots
	wrists = /obj/item/rope/chain
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/mace/spiked
	beltr = /obj/item/storage/keyring/guard
	backpack_contents = list(
		/obj/item/weapon/knife/dagger = 1
	)
