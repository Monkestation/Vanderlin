/datum/attribute_holder/sheet/job/kingsfield_constable
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/combat/firearms = 40,
	)

/datum/job/admin/kingsfield_constable
	title = JOB_ADMIN_KINGSFIELD_CONSTABLE
	tutorial = "A member of the Kingsfield Constabulary, responsable for true law and order."
	department_flag = ADMIN_SPECIAL
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_TOWN)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor2.ogg'
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/astrata)

	outfit = /datum/outfit/admin/kingsfield_constable
	honorary = "Constable"

	give_bank_account = 30
	knows_the_town = TRUE
	known_by_the_town = TRUE

	jobs_i_always_know = list(JOB_MONARCH, JOB_HAND, JOB_CONSORT, JOB_GUARD_CAPTAIN, JOB_ADMIN_KINGSFIELD_CONSTABLE)
	jobs_always_know_me = list(JOB_MONARCH, JOB_HAND, JOB_CONSORT, JOB_GUARD_CAPTAIN, JOB_ADMIN_KINGSFIELD_CONSTABLE)

	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900,
		EXP_TYPE_COMBAT = 900
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/kingsfield_constable

	traits = list(
		TRAIT_RECOGNIZED,
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_DIVINE_SERVANT,
	)
	mind_traits = list(
		TRAIT_KNOWBANDITS,
		TRAIT_KNOWCOURTAGENTS,
	)

	languages = list(
		/datum/language/celestial
	)

/datum/outfit/admin/kingsfield_constable
	name = JOB_ADMIN_KINGSFIELD_CONSTABLE
	head = /obj/item/clothing/head/articap
	neck = /obj/item/clothing/neck/bevor/iron
	armor = /obj/item/clothing/armor/medium/scale/inqcoat
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	gloves = /obj/item/clothing/gloves/angle/furlined/advanced
	wrists = /obj/item/clothing/wrists/bracers/iron/concealed
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/sword/rapier
	beltr = /obj/item/ammo_holder/bullet/bullets
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/gun/ballistic/powder/wheellock/puffer = 1,
		/obj/item/rope/chain = 1,
		/obj/item/weapon/mace/cudgel = 1,
		/obj/item/clothing/neck/psycross/silver/divine/astrata/real_silver = 1,
		/obj/item/reagent_containers/glass/bottle/aflask = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
