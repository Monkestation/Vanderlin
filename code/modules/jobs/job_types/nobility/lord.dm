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
	exp_types_granted  = list(EXP_TYPE_NOBLE, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_NOBLE = 900,
		EXP_TYPE_LEADERSHIP = 300
	)


/datum/job/lord/get_informed_title(mob/mob, change_title = FALSE, new_title)
	if(change_title)
		ruler_title = new_title
		return "[ruler_title]"
	else
		return "[ruler_title]"

//TODO: MOVE THIS INTO TICKER INIT
/datum/job/lord/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	SSticker.rulermob = spawned
	var/mob/living/carbon/human/H = spawned
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, lord_color_choice)), 7 SECONDS)
	if(spawned.pronouns != SHE_HER)
		ruler_title = "[SSmapping.config.monarch_title]"
	else
		ruler_title = "[SSmapping.config.monarch_title_f]"
	if(spawned.gender == MALE)
		SSfamilytree.AddRoyal(H, FAMILY_FATHER)
	else
		SSfamilytree.AddRoyal(H, FAMILY_MOTHER)
	to_chat(world, "<b>[span_notice(span_big("[H.real_name] is [ruler_title] of [SSmapping.config.map_name]."))]</b>")
	to_chat(world, "<br>")
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 7 SECONDS)

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

/datum/outfit/lord/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/crown/serpcrown
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/plaquegold
	beltl = /obj/item/weapon/knife/dagger/steel/special
	beltr = /obj/item/weapon/sword/rapier
	scabbards = list(/obj/item/weapon/scabbard/knife/royal, /obj/item/weapon/scabbard/sword/royal)
	ring = /obj/item/clothing/ring/active/nomag
	l_hand = /obj/item/weapon/lordscepter

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_END, 3)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_LCK, 5)
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/trou/formal
		shirt = /obj/item/clothing/shirt/undershirt/fancy
		armor = /obj/item/clothing/armor/gambeson/arming
		shoes = /obj/item/clothing/shoes/nobleboot
		cloak = /obj/item/clothing/cloak/lordcloak
		if(H.dna?.species)
			if(H.dna.species.id == SPEC_ID_HUMEN)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
	else
		pants = /obj/item/clothing/pants/tights/colored/random
		armor = /obj/item/clothing/shirt/dress/royal
		shoes = /obj/item/clothing/shoes/nobleboot
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		wrists = /obj/item/clothing/wrists/royalsleeves

		if(H.wear_mask)
			if(istype(H.wear_mask, /obj/item/clothing/face/eyepatch))
				qdel(H.wear_mask)
				mask = /obj/item/clothing/face/lordmask
			if(istype(H.wear_mask, /obj/item/clothing/face/eyepatch/left))
				qdel(H.wear_mask)
				mask = /obj/item/clothing/face/lordmask/l

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSEGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

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
