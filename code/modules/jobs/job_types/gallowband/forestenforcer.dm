/datum/attribute_holder/sheet/job/forestenforcer
	raw_attribute_list = list(
		STAT_STRENGTH = 3, //so they can get 12 str to wield their maul
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 3,
		STAT_SPEED = -2, //lowered to offset the str boost
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30
	)


/datum/job/forestenforcer
	title = JOB_FOREST_ENFORCER
	tutorial = "You are the Warden's right hand, having hunted by their side for decades. Keep the younger upstarts in line. Ensure they follow the ways of the Hunt. One day, you will die, bones buried beside your Warden, and your strength will go to the next to pick up your maul."
	department_flag = GALLOWBAND
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_GALLOWBAND
	total_positions = 1
	spawn_positions = 1
	display_order = JDO_FORFORCER
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD)

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900
	)

	outfit = /datum/outfit/forestenforcer
	give_bank_account = 40
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	job_bitflag = BITFLAG_GARRISON

	attribute_sheet = /datum/attribute_holder/sheet/job/forestenforcer

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)

	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)
	languages = list(/datum/language/gronnic)

/datum/job/forestenforcer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)
	spawned.set_patron(/datum/patron/alternate/great_hunt/proven)

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Osslandic"
		species.accent_language = species.get_accent(species.native_language)


/datum/outfit/forestenforcer
	name = JOB_FOREST_ENFORCER
	cloak = /obj/item/clothing/cloak/savage
	armor = /obj/item/clothing/armor/plate/iron/gronn
	shirt = /obj/item/clothing/armor/chainmail/hauberk/gronn
	pants = /obj/item/clothing/pants/platelegs/iron/gronn
	shoes = /obj/item/clothing/shoes/boots/armor/gronn
	wrists = /obj/item/clothing/wrists/bracers/leather
	head = /obj/item/clothing/head/helmet/heavy/ironplate/gronn
	gloves = /obj/item/clothing/gloves/plate/iron/gronn
	neck = /obj/item/clothing/neck/bevor
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	backl = /obj/item/storage/backpack/satchel
	r_hand = /obj/item/weapon/mace/goden/maul
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/key/forrestgarrison = 1,
	)
