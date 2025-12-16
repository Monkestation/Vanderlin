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
	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/grant_title,
	)
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

/datum/outfit/hand
	shoes = /obj/item/clothing/shoes/nobleboot/thighboots
	belt = /obj/item/storage/belt/leather/steel

/datum/job/hand/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/H = spawned
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), H, FAMILY_OMMER), 10 SECONDS)

	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 5 SECONDS)
	// i know this sucks, but due to how job loading is, we can't just get the agents to load before the hand without some reworks
	if(SSticker.current_state < GAME_STATE_PLAYING)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(agent_callback), H))
	else
		agent_callback(H)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

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

//Classical hand start - same as before, nothing changed.
/datum/outfit/hand/handclassic/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel = 1, /obj/item/storage/keyring/hand = 1, /obj/item/paper/scroll/frumentarii/roundstart = 1)
	armor = /obj/item/clothing/armor/leather/jacket/handjacket
	pants = /obj/item/clothing/pants/tights/colored/black
	beltr = /obj/item/weapon/sword/rapier/dec
	scabbards = list(/obj/item/weapon/scabbard/sword/royal)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_INT, 3)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

/datum/job/advclass/hand/spymaster
	title = "Spymaster"
	tutorial = " You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with those lips than any blademaster could ever claim to."
	outfit = /datum/outfit/hand/spymaster

	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'

//Spymaster start. More similar to the rogue adventurer - loses heavy armor and sword skills for more sneaky stuff.
/datum/outfit/hand/spymaster/pre_equip(mob/living/carbon/human/H)
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1, /obj/item/storage/keyring/hand = 1, /obj/item/lockpickring/mundane = 1, /obj/item/paper/scroll/frumentarii/roundstart = 1)
	if(!istype(H.dna.species, /datum/species/dwarf))
		shirt = /obj/item/clothing/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
		mask = /obj/item/clothing/face/shepherd/shadowmask
		pants = /obj/item/clothing/pants/trou/shadowpants
	else
		cloak = /obj/item/clothing/cloak/raincloak/colored/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/shirt/undershirt/colored/guard
		armor = /obj/item/clothing/armor/leather/jacket/hand
		pants = /obj/item/clothing/pants/tights/colored/black
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 5, TRUE) // not like they're gonna break into the vault.
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 4)
	H.change_stat(STATKEY_INT, 2)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

/datum/job/advclass/hand/advisor
	title = "Advisor"
	tutorial = " You have played researcher and confidant to the Noble-Family for so long that you are a vault of knowledge, \
	something you exploit with potent conviction. Let no man ever forget the knowledge you wield. \
	You've read more books than any blademaster or spymaster could ever claim to."
	outfit = /datum/outfit/hand/advisor

	category_tags = list(CTAG_HAND)
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/hand/advisor/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel = 1, /obj/item/storage/keyring/hand = 1, /obj/item/reagent_containers/glass/bottle/poison = 1, /obj/item/paper/scroll/frumentarii/roundstart = 1) //starts with a vial of poison, like all wizened evil advisors do!
	armor = /obj/item/clothing/armor/leather/jacket/hand
	pants = /obj/item/clothing/pants/tights/colored/black
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_INT, rand(4,5))
	H.change_stat(STATKEY_PER, 3)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
