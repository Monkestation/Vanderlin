/datum/attribute_holder/sheet/job/forestsupport
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = -1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/carpentry = 30,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/labor/lumberjacking = 30,
		/datum/attribute/skill/labor/butchering = 10
	)


/datum/job/forestsupport
	title = JOB_FOREST_SUPPORT
	f_title = JOB_FOREST_SUPPORT_FEM
	tutorial = "Disillusioned with the Church of the Ten for whatever reason or adopted as a child, you have yet to prove yourself in the hunt. You live and work with the Gallowband. Keep them fed and their gear maintained as you learn of the Osslandic way. One dae, you will take your place in the cycle, too."
	department_flag = GALLOWBAND
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_GALLOWBAND
	total_positions = 2
	spawn_positions = 2
	display_order = JDO_FORSUPP
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = ALL_AGES_LIST_CHILD
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD)
	allowed_patrons = list(/datum/patron/alternate/great_hunt)


	outfit = /datum/outfit/forestsupport
	give_bank_account = 20
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	job_bitflag = BITFLAG_GARRISON

	attribute_sheet = /datum/attribute_holder/sheet/job/forestsupport

	traits = list(
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)

	mind_traits = list(TRAIT_GALLOWBAND_SECRETS)
	languages = list(/datum/language/gronnic)

/datum/job/forestsupport/set_spawn_and_total_positions(count)
	// Calculate the new spawn positions
	var/new_spawn = gallowslave_slot_formula(count)

	// Sync everything
	spawn_positions = new_spawn
	total_positions_so_far = new_spawn
	total_positions = new_spawn

	return spawn_positions

/datum/job/forestsupport/get_total_positions()
	var/slots = gallowslave_slot_formula(get_total_town_members())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	return slots

/datum/outfit/forestsupport/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	//gronn pants don't have a child sprite, so I'll do this to make sure kids get pants.
	if(equipped_human.age == AGE_CHILD)
		pants = /obj/item/clothing/pants/trou/leather
	else
		pants = /obj/item/clothing/pants/trou/leather/gronn

/datum/job/forestsupport/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_CHILD)
		add_verb(spawned, /mob/proc/haltyellorphan)
	else
		add_verb(spawned, /mob/proc/haltyell)

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Osslandic"
		species.accent_language = species.get_accent(species.native_language)


/datum/outfit/forestsupport
	name = JOB_FOREST_SUPPORT
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	head = /obj/item/clothing/head/roguehood
	gloves = /obj/item/clothing/gloves/angle/gronn
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/key/forrestgarrison = 1,
		/obj/item/needle = 1,
		/obj/item/weapon/hammer/wood = 1,
	)
