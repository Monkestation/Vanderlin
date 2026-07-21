/datum/job/forestguard //TODO: change all descriptions
	title = JOB_FOREST_GUARD
	tutorial = "Decades ago, your ancestors were a mercenary band that earned their keep here. Now you inherit their oaths. Protect the forests from beasts and aid travelers. They will never stay for long, but at least with your battle-family by your side, you will never die alone."
	department_flag = GALLOWBAND
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_FORGUARD
	faction = FACTION_GALLOWBAND
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)
	give_bank_account = 30
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison2.ogg'

	outfit = /datum/outfit/forestguard
	advclass_cat_rolls = list(CTAG_FORGARRISON = 20)

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_GARRISON = 600
	)
	verbs = list(
		/mob/proc/haltyell
	)

	languages = list(/datum/language/gronnic)

/datum/job/forestguard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)
	spawned.set_patron(/datum/patron/alternate/great_hunt/proven)

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Osslandic"
		species.accent_language = species.get_accent(species.native_language)

/datum/job/forestguard/set_spawn_and_total_positions(count)
	// Calculate the new spawn positions
	var/new_spawn = gallowband_slot_formula(count)

	// Sync everything
	spawn_positions = new_spawn
	total_positions_so_far = new_spawn
	total_positions = new_spawn

	return spawn_positions

/datum/job/forestguard/get_total_positions()
	var/slots = gallowband_slot_formula(get_total_town_members())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	return slots

/datum/outfit/forestguard
	name = "Forest Guard Base"
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/fgarrison
	backl = /obj/item/storage/backpack/satchel

/datum/outfit/forestguard/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(SSmapping.config.map_name == "Rosewood")
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
	else
		cloak = /obj/item/clothing/cloak/forrestercloak

/datum/job/advclass/forestguard
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	banned_patrons = list()

/datum/attribute_holder/sheet/job/forestguard/infantry
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 3,
		STAT_SPEED = -1,
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
		/datum/attribute/skill/combat/axesmaces = 33,
		/datum/attribute/skill/combat/whipsflails = 33,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30
	)

/datum/job/advclass/forestguard/infantry
	title = JOB_FOREST_GUARD_THEGN_RAVAGER
	tutorial = "In the many battles, you alone were deployed to the front lines, caving skulls and chopping legs - saving your family-at-arms through your reckless diversions. With your bloodied axe and flail, every swing and crack was another hatch on your tally. Now the forest is calmer, for the moment. Keep up your indomitable spirit and tireless zeal. Let no orc or goblin past."
	outfit = /datum/outfit/forestguard/infantry
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = ALL_AGES_LIST
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)

	attribute_sheet = /datum/attribute_holder/sheet/job/forestguard/infantry

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)
	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)

/datum/outfit/forestguard/infantry
	name = JOB_FOREST_GUARD_THEGN_RAVAGER
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	beltl = /obj/item/weapon/flail/militia
	beltr = /obj/item/weapon/axe/iron
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/weapon/shield/heater
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/attribute_holder/sheet/job/forestguard/ranger
	raw_attribute_list = list(
		STAT_STRENGTH = -3,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 3,
		STAT_SPEED = 3,
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
		/datum/attribute/skill/combat/bows = 33,
		/datum/attribute/skill/combat/crossbows = 33,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/wrestling = 10
	)

/datum/job/advclass/forestguard/ranger
	title = JOB_FOREST_GUARD_THEGN_RANGER
	tutorial = "In the many battles, you were always one of the fastest, as well as one of the frailest in the platoon. Your trusty bow has served you well- of course, none you've set your sights on have found the tongue to disagree."
	outfit = /datum/outfit/forestguard/ranger
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = ALL_AGES_LIST
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)

	attribute_sheet = /datum/attribute_holder/sheet/job/forestguard/ranger

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)
	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)

/datum/outfit/forestguard/ranger
	name = JOB_FOREST_GUARD_THEGN_RANGER
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/highcollier
	shirt = /obj/item/clothing/armor/gambeson
	beltl = /obj/item/weapon/knife/cleaver/combat
	beltr = /obj/item/ammo_holder/quiver/arrows
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/gun/ballistic/bow/long
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/attribute_holder/sheet/job/forestguard/reaver
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 33
	)

/datum/job/advclass/forestguard/reaver
	title = JOB_FOREST_GUARD_THEGN_REAVER
	tutorial = "In your youth you took an oath to never shy from a hit. Axe in hand, thirsting for blood, you simply enjoy the <i>chaos of battle...</i>"
	outfit = /datum/outfit/forestguard/reaver
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = ALL_AGES_LIST
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)

	attribute_sheet = /datum/attribute_holder/sheet/job/forestguard/reaver

	traits = list(
		TRAIT_DUALWIELDER,
		TRAIT_MEDIUMARMOR,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)
	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)

/datum/outfit/forestguard/reaver
	name = JOB_FOREST_GUARD_THEGN_REAVER
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	beltl = /obj/item/weapon/mace/steel/morningstar
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	beltr = /obj/item/weapon/axe/iron
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/attribute_holder/sheet/job/forestguard/ossland_scout
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = -1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/lumberjacking = 20,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 35
	)

/datum/job/advclass/forestguard/ossland_scout
	title = JOB_FOREST_GUARD_HUSKARL_SCOUT
	tutorial = "The younger of your band do not remember the Goblin Wars as deeply as you. Keep up your vigilance. Pass down your knowledge to those less experienced in the Hunt. When the Graggarspawn tide rises again, you'll be the first to know."
	outfit = /datum/outfit/forestguard/ossland_scout
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)

	attribute_sheet = /datum/attribute_holder/sheet/job/forestguard/ossland_scout

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)
	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/forestguard/ossland_scout
	name = JOB_FOREST_GUARD_HUSKARL_SCOUT
	head = /obj/item/clothing/head/helmet/bascinet/atgervi/gronn/ownel
	shirt = /obj/item/clothing/armor/chainmail/hauberk/gronn
	gloves = /obj/item/clothing/gloves/angle/gronnfur
	pants = /obj/item/clothing/pants/trou/leather/gronn
	armor = /obj/item/clothing/armor/leather/gronn
	beltl = /obj/item/weapon/handclaw/gronn
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/attribute_holder/sheet/job/forestguard/ossland_fighter
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/lumberjacking = 20,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/swords = 33,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20
	)

/datum/job/advclass/forestguard/ossland_fighter
	title = JOB_FOREST_GUARD_HUSKARL_FIGHTER
	tutorial = "The younger of your band do not remember the Goblin Wars as closely as you. Uphold your warband's oath to the crown. Let no orc, goblin, or beast slay those who aren't ready to go to the Skull. Your blade stands between them and being severed from the cycle."
	outfit = /datum/outfit/forestguard/ossland_fighter
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)

	attribute_sheet = /datum/attribute_holder/sheet/job/forestguard/ossland_fighter

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)
	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/forestguard/ossland_fighter
	name = JOB_FOREST_GUARD_HUSKARL_FIGHTER
	head = /obj/item/clothing/head/helmet/bascinet/atgervi/gronn
	shirt = /obj/item/clothing/armor/chainmail/hauberk/gronn
	gloves = /obj/item/clothing/gloves/chain/gronn
	beltl = /obj/item/weapon/sword/short/gronn
	pants = /obj/item/clothing/pants/trou/leather/splint/gronn
	armor = /obj/item/clothing/armor/leather/gronn
	backr = /obj/item/weapon/shield/wood
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1
	)
