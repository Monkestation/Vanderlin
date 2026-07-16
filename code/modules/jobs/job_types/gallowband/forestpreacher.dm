/datum/attribute_holder/sheet/job/forestpreacher
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/craft/carpentry = 30,
		/datum/attribute/skill/labor/farming = 30,
		/datum/attribute/skill/magic/holy = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/labor/butchering = 30,
		/datum/attribute/skill/labor/lumberjacking = 10
	)


/datum/job/forestpreacher
	title = JOB_FOREST_PREACHER
	tutorial = "Once you walked these woods as its Warden, until your bones ached too much to pick up your axe. Now you guide the next generation of hunters to follow in your footsteps. Advise them well. Accept your devotion's rewards with open eyes and arms."
	department_flag = GALLOWBAND
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_GALLOWBAND
	total_positions = 1
	spawn_positions = 1
	display_order = JDO_FORPREACH
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = list(AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD)

	exp_type = list(EXP_TYPE_CHURCH)
	exp_types_granted = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_CHURCH)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 600
	)

	outfit = /datum/outfit/forestpreacher
	give_bank_account = 40
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	job_bitflag = BITFLAG_GARRISON

	attribute_sheet = /datum/attribute_holder/sheet/job/forestpreacher

	traits = list(
		TRAIT_FORAGER,
		TRAIT_GALLOWBAND
	)

	mind_traits = list(TRAIT_KNOWBANDITS, TRAIT_GALLOWBAND_SECRETS)
	languages = list(/datum/language/gronnic)

/datum/job/forestpreacher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.set_patron(/datum/patron/alternate/great_hunt/proven)
	spawned.apply_status_effect(/datum/status_effect/buff/bone_ward)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Osslandic"
		species.accent_language = species.get_accent(species.native_language)


/datum/outfit/forestpreacher
	name = JOB_FOREST_PREACHER
	armor = /obj/item/clothing/armor/leather/atgervi
	neck = /obj/item/clothing/neck/psycross/great_hunt
	pants = /obj/item/clothing/pants/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	head = /obj/item/clothing/head/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/plate/atgervi
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	backl = /obj/item/storage/backpack/satchel
	r_hand = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
		/obj/item/key/forrestgarrison = 1,
		/obj/item/needle = 1,
	)
