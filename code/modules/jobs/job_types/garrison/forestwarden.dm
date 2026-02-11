/datum/job/forestwarden
	title = "Forest Warden"
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

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_END = 3,
		STATKEY_SPD = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/bows = 4,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/riding = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/lumberjacking = 1,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/craft/tanning = 2
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE,
		TRAIT_FORAGER
	)

/datum/job/forestwarden/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Sir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Dame"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/forestwarden
	name = "Forest Warden"
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
		/obj/item/signal_horn = 1
	)
