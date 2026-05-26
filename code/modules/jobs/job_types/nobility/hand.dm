/datum/job/hand
	title = JOB_HAND
	tutorial = "You owe everything to your liege. \
	You are the most trusted of the ruler- their sibling, in fact. \
	You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, \
	something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. \
	You have killed more men with those lips than any blademaster could ever claim to.\
	You can add and remove agents with your Frumentarii scroll"
	department_flag = NOBLEMEN
	display_order = JDO_HAND
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	spells = list(/datum/action/cooldown/spell/undirected/list_target/grant_title)
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_ROYALTY
	outfit = /datum/outfit/hand
	advclass_cat_rolls = list(CTAG_HAND = 20)
	give_bank_account = 120
	noble_income = 22
	job_bitflag = BITFLAG_ROYALTY
	exp_type = list(EXP_TYPE_NOBLE, EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600,
		EXP_TYPE_NOBLE = 300,
	)

	honorary = "Lord"
	honorary_f = "Lady"

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)
	verbs = list(
		/mob/living/carbon/human/proc/torture_victim
	)

/datum/outfit/hand
	name = JOB_HAND
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/storage/keyring/hand


/datum/job/hand/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), spawned, FAMILY_OMMER), 10 SECONDS)
	// i know this sucks, but due to how job loading is, we can't just get the agents to load before the hand without some reworks
	if(SSticker.current_state < GAME_STATE_PLAYING)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(agent_callback), spawned))
	else
		agent_callback(spawned)

/datum/job/hand/proc/agent_callback(mob/living/carbon/human/H)
	addtimer(CALLBACK(src, PROC_REF(know_agents), H), 6 SECONDS)

/datum/job/hand/proc/know_agents(mob/living/carbon/human/H)
	if(!GLOB.roundstart_court_agents.len)
		to_chat(H, span_notice("You began the week with no agents."))
	else
		to_chat(H, span_notice("We began the week with these agents:"))
		for(var/name in GLOB.roundstart_court_agents)
			to_chat(H, span_notice(name))
			H.mind.cached_frumentarii[name] = TRUE

/datum/job/advclass/hand
	exp_types_granted = list(EXP_TYPE_NOBLE)

/datum/attribute_holder/sheet/job/hand
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/advclass/hand/hand
	title = JOB_HAND
	tutorial = "You have played blademaster and strategist to the Noble-Family for so long that you are a master tactician, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with swords than any spymaster could ever claim to."
	outfit = /datum/outfit/hand/handclassic
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	attribute_sheet = /datum/attribute_holder/sheet/job/hand
	honorary = "General"

	traits = list(
		TRAIT_HEAVYARMOR
	)

/datum/outfit/hand/handclassic
	name = "Hand (Classic)"
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1
	)
	armor = /obj/item/clothing/armor/leather/jacket/handjacket
	pants = /obj/item/clothing/pants/tights/colored/black
	belt = /obj/item/storage/belt/leather/steel
	beltl = /obj/item/weapon/sword/rapier/dec
	scabbards = list(/obj/item/weapon/scabbard/sword/royal)
	shoes = /obj/item/clothing/shoes/nobleboot/thighboots

/datum/attribute_holder/sheet/job/spymaster
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 4,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 60,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/advclass/hand/spymaster
	title = "Spymaster"
	tutorial = " You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with those lips than any blademaster could ever claim to."
	outfit = /datum/outfit/hand/spymaster
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	attribute_sheet = /datum/attribute_holder/sheet/job/spymaster
	honorary = "Spymaster"

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT
	)

/datum/outfit/hand/spymaster
	name = "Spymaster (Hand)"
	shirt = /obj/item/clothing/armor/gambeson/hand/spy
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
	mask = /obj/item/clothing/face/shepherd/shadowmask
	pants = /obj/item/clothing/pants/trou/shadowpants
	backr = /obj/item/storage/backpack/satchel/black
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard
	beltl = /obj/item/weapon/knife/dagger/steel/hand/parry
	shoes = /obj/item/clothing/shoes/boots
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1,
		/obj/item/weapon/knife/dagger/steel/hand = 1,
	)

/datum/outfit/hand/spymaster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(istype(equipped_human.dna?.species, /datum/species/dwarf))
		cloak = /obj/item/clothing/cloak/raincloak/colored/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/shirt/undershirt/colored/guard
		armor = /obj/item/clothing/armor/leather/jacket/hand
		pants = /obj/item/clothing/pants/tights/colored/black

/datum/attribute_holder/sheet/job/advisor
	attribute_variance = list(
		STAT_INTELLIGENCE = list(0, 1)
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 4,
		STAT_PERCEPTION = 3,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/misc/medicine = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/attribute_holder/sheet/job/advisor/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 5,
		STAT_PERCEPTION = 4,
		STAT_SPEED = -1,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/misc/medicine = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/advclass/hand/advisor
	title = "Advisor"
	tutorial = " You have played researcher and confidant to the Noble-Family for so long that you are a vault of knowledge, \
	something you exploit with potent conviction. Let no man ever forget the knowledge you wield. \
	You've read more books than any blademaster or spymaster could ever claim to."
	outfit = /datum/outfit/hand/advisor
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	attribute_sheet = /datum/attribute_holder/sheet/job/advisor
	attribute_sheet_old = /datum/attribute_holder/sheet/job/advisor/old
	honorary = "Councilor"

/datum/outfit/hand/advisor
	name = "Advisor (Hand)"
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1
	)
	armor = /obj/item/clothing/armor/gambeson/hand
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/boots
	beltl = /obj/item/weapon/sword/rapier/caneblade/hand
	scabbards = list(/obj/item/weapon/scabbard/cane/hand)
