GLOBAL_VAR(lordsurname)
GLOBAL_LIST_EMPTY(lord_titles)

/datum/job/lord
	title = "Monarch"
	var/ruler_title = "Monarch"
	tutorial = "Elevated to your throne through a web of intrigue, political maneuvering, and divine sanction, you are the \
	unquestioned authority of these lands. The Church has bestowed upon you the legitimacy of the gods themselves, and now \
	you sit at the center of every plot, and every whisper of ambition. Every man, woman, and child may envy your power and \
	would replace you in the blink of an eye. But remember, its not envy that keeps you in place, it is your will. Show them \
	the error of their ways."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_LORD
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 1
	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/grant_title,
		/datum/action/cooldown/spell/undirected/list_target/grant_nobility,
	)
	allowed_races = RACES_PLAYER_ROYALTY
	outfit = /datum/outfit/lord
	bypass_lastclass = TRUE
	give_bank_account = 500
	selection_color = "#7851A9"
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	can_have_apprentices = FALSE
	job_bitflag = BITFLAG_ROYALTY
	exp_type = list(EXP_TYPE_NOBLE, EXP_TYPE_LIVING, EXP_TYPE_LEADERSHIP)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_NOBLE = 900,
		EXP_TYPE_LEADERSHIP = 300
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_END = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		STATKEY_LCK = 5
	)

	skills = list(
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/riding = 3,
		/datum/skill/labor/mathematics = 3
	)

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_NOBLE,
		TRAIT_NOSEGRAB,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

	voicepack_m = /datum/voicepack/male/evil

/datum/job/lord/get_informed_title(mob/mob, ignore_pronouns, change_title = FALSE, new_title)
	if(change_title)
		ruler_title = new_title
		return "[ruler_title]"
	else
		return "[ruler_title]"

/datum/job/lord/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	SSticker.rulermob = spawned

	addtimer(CALLBACK(spawned, TYPE_PROC_REF(/mob/living/carbon/human, lord_color_choice)), 7 SECONDS)

	if(spawned.pronouns != SHE_HER)
		ruler_title = "[SSmapping.config.monarch_title]"
	else
		ruler_title = "[SSmapping.config.monarch_title_f]"

	if(spawned.gender == MALE)
		SSfamilytree.AddRoyal(spawned, FAMILY_FATHER)
	else
		SSfamilytree.AddRoyal(spawned, FAMILY_MOTHER)

	to_chat(world, "<b>[span_notice(span_big("[spawned.real_name] is [ruler_title] of [SSmapping.config.map_name]."))]</b>")
	to_chat(world, "<br>")

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/evil()

/datum/outfit/lord
	name = "Monarch"
	head = /obj/item/clothing/head/crown/serpcrown
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/plaquegold
	beltl = /obj/item/weapon/knife/dagger/steel/royal
	beltr = /obj/item/weapon/sword/rapier
	scabbards = list(/obj/item/weapon/scabbard/knife/royal, /obj/item/weapon/scabbard/sword/royal)
	ring = /obj/item/clothing/ring/active/nomag
	l_hand = /obj/item/weapon/lordscepter

/datum/outfit/lord/map_override(mob/living/carbon/human/H)
	if(SSmapping.config.map_name != "Voyage")
		return
	head = /obj/item/clothing/head/helmet/leather/tricorn
	cloak = /obj/item/clothing/cloak/half
	l_hand = null
	armor = /obj/item/clothing/armor/leather/jacket/silk_coat
	shirt = /obj/item/clothing/shirt/undershirt/puritan
	wrists = null
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/lord/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/trou/formal
		shirt = /obj/item/clothing/shirt/undershirt/fancy
		armor = /obj/item/clothing/armor/gambeson/arming
		shoes = /obj/item/clothing/shoes/nobleboot
		cloak = /obj/item/clothing/cloak/lordcloak
	else
		pants = /obj/item/clothing/pants/tights/colored/random
		armor = /obj/item/clothing/shirt/dress/royal
		shoes = /obj/item/clothing/shoes/nobleboot
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		wrists = /obj/item/clothing/wrists/royalsleeves

	if(equipped_human.wear_mask)
		if(istype(equipped_human.wear_mask, /obj/item/clothing/face/eyepatch))
			qdel(equipped_human.wear_mask)
			mask = /obj/item/clothing/face/lordmask
		else if(istype(equipped_human.wear_mask, /obj/item/clothing/face/eyepatch/left))
			qdel(equipped_human.wear_mask)
			mask = /obj/item/clothing/face/lordmask/l

/datum/job/exlord //just used to change the lords title
	title = "Ex-Monarch"
	department_flag = NOBLEMEN
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LORD

/proc/give_lord_surname(mob/living/carbon/human/family_guy, preserve_original = FALSE)
	if(!GLOB.lordsurname)
		return
	if(preserve_original)
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
		return family_guy.real_name
	var/list/chopped_name = splittext(family_guy.real_name, " ")
	if(length(chopped_name) > 1)
		family_guy.fully_replace_character_name(family_guy.real_name, chopped_name[1] + " " + GLOB.lordsurname)
	else
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
	return family_guy.real_name
