/datum/job/hand
	title = "Hand"
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
	exp_types_granted = list(EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 600,
		EXP_TYPE_NOBLE = 300,
	)

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_NOBLE
	)

/datum/outfit/hand
	name = "Hand"
	shoes = /obj/item/clothing/shoes/nobleboot/thighboots
	belt = /obj/item/storage/belt/leather/steel

/datum/job/hand/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
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

/datum/job/advclass/hand/hand
	title = "Hand"
	tutorial = " You have played blademaster and strategist to the Noble-Family for so long that you are a master tactician, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with swords than any spymaster could ever claim to."
	outfit = /datum/outfit/hand/handclassic
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/riding = 2,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_HEAVYARMOR
	)

/datum/outfit/hand/handclassic
	name = "Hand (Classic)"
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1
	)
	armor = /obj/item/clothing/armor/leather/jacket/handjacket
	pants = /obj/item/clothing/pants/tights/colored/black
	beltr = /obj/item/weapon/sword/rapier/dec
	scabbards = list(/obj/item/weapon/scabbard/sword/royal)

/datum/job/advclass/hand/spymaster
	title = "Spymaster"
	tutorial = " You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with those lips than any blademaster could ever claim to."
	outfit = /datum/outfit/hand/spymaster
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_PER = 2,
		STATKEY_SPD = 4,
		STATKEY_INT = 2
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 4,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 4,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 6,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sneaking = 5,
		/datum/skill/misc/stealing = 5,
		/datum/skill/misc/lockpicking = 5,
		/datum/skill/labor/mathematics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT
	)

/datum/outfit/hand/spymaster
	name = "Spymaster (Hand)"
	shirt = /obj/item/clothing/armor/gambeson/shadowrobe
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
	mask = /obj/item/clothing/face/shepherd/shadowmask
	pants = /obj/item/clothing/pants/trou/shadowpants
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/stiletto = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1
	)

/datum/outfit/hand/spymaster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(istype(equipped_human.dna?.species, /datum/species/dwarf))
		cloak = /obj/item/clothing/cloak/raincloak/colored/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/shirt/undershirt/colored/guard
		armor = /obj/item/clothing/armor/leather/jacket/hand
		pants = /obj/item/clothing/pants/tights/colored/black

/datum/job/advclass/hand/advisor
	title = "Advisor"
	tutorial = " You have played researcher and confidant to the Noble-Family for so long that you are a vault of knowledge, \
	something you exploit with potent conviction. Let no man ever forget the knowledge you wield. \
	You've read more books than any blademaster or spymaster could ever claim to."
	outfit = /datum/outfit/hand/advisor
	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	exp_types_granted  = list(EXP_TYPE_NOBLE)

	jobstats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3
	)

	skills = list(
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/reading = 5,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/alchemy = 4,
		/datum/skill/misc/medicine = 4,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/labor/mathematics = 3
	)

/datum/job/advclass/hand/advisor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, pick(0,1)) // Adjust from base of 4

	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)

/datum/outfit/hand/advisor
	name = "Advisor (Hand)"
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/paper/scroll/frumentarii/roundstart = 1
	)
	armor = /obj/item/clothing/armor/leather/jacket/hand
	pants = /obj/item/clothing/pants/tights/colored/black
