/datum/attribute_holder/sheet/job/forestwarden
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 3,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/tanning = 20
	)


/datum/job/forestwarden
	title = JOB_FOREST_WARDEN
	tutorial = "You were born in the forest. Alone, you've always felt home in the woods. \
	In your tenure with the garrison, you've cleaved through the wildlife-- \
	and for your service in the short-lived Goblin War, the king has granted you nobility. \
	In turn, you've been entrusted to keep his lands clear of \
	the foul creachers that taint his land. Alone, you will die in these woods."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	display_order = JDO_FORWARDEN
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 900
	)

	outfit = /datum/outfit/forestwarden
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/guard/forest)
	give_bank_account = 45
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	job_bitflag = BITFLAG_GARRISON
	honorary = "Warden"

	attribute_sheet = /datum/attribute_holder/sheet/job/forestwarden

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE_POWER,
		TRAIT_FORAGER
	)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/forestwarden
	name = JOB_FOREST_WARDEN
	cloak = /obj/item/clothing/cloak/wardencloak
	armor = /obj/item/clothing/armor/plate
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	head = /obj/item/clothing/head/helmet/visored/warden
	gloves = /obj/item/clothing/gloves/leather
	neck = /obj/item/clothing/neck/bevor
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/axe/iron
	beltr = /obj/item/storage/belt/pouch/coins/mid
	backr = /obj/item/weapon/polearm/halberd/bardiche/warcutter
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/key/forrestgarrison = 1,
		/obj/item/signal_horn/ambush = 1
	)
