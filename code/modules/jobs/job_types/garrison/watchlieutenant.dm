/datum/job/lieutenant
	/*
	From wikipedia:
	The word lieutenant derives from French; the lieu meaning "place" as in a position (cf. in lieu of);
	and tenant meaning "holding" as in "holding a position";
	thus a "lieutenant" is a placeholder for a superior, during their absence.
	*/
	title = "City Watch Lieutenant"
	tutorial = "You are a lieutenant of the City Watch. \
	You have been chosen by the Captain to lead the Watch in his absence; \
	Failure is not an option."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CITYWATCHMEN
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_GUARD
	blacklisted_species = list(SPEC_ID_HALFLING)
	outfit = /datum/outfit/lieutenant
	give_bank_account = 50
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'
	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_GARRISON, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(EXP_TYPE_GARRISON = 900)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 1
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_KNOWBANDITS
	)

/datum/job/lieutenant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

	var/static/list/selectable = list( \
		"Flail" = /obj/item/weapon/flail, \
		"Spear" = /obj/item/weapon/polearm/spear, \
		"Sword" = /obj/item/weapon/sword/iron, \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "CHOOSE YOUR SECONDARY WEAPON", title = "LIEUTENANT")
	if(!choice)
		return
	switch(choice)
		if("Flail")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/wood(), ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 2, 3, TRUE)
		if("Spear")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/buckleriron(), ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/polearms, 2, 3, TRUE)
		if("Sword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/heater(), ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword(), ITEM_SLOT_BACK_L, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 3, TRUE)

/datum/outfit/lieutenant
	name = "City Watch Lieutenant"
	head = /obj/item/clothing/head/helmet/sargebarbute //veteran who won a nice helmet
	wrists = /obj/item/clothing/wrists/bracers/jackchain
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/armor/chainmail/iron
	armor = /obj/item/clothing/armor/cuirass/iron
	pants = /obj/item/clothing/pants/chainlegs/iron
	gloves = /obj/item/clothing/gloves/chain/iron
	neck = /obj/item/clothing/neck/chaincoif/iron
	beltl = /obj/item/weapon/mace/bludgeon
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/keyring/lieutenant = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/rope/chain = 1
	)

/datum/outfit/lieutenant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	cloak = pick(/obj/item/clothing/cloak/half/guard, /obj/item/clothing/cloak/half/guardsecond)

	if(equipped_human.dna && !(equipped_human.dna.species.id in RACES_PLAYER_NONDISCRIMINATED))
		var/obj/item/clothing/mask = new /obj/item/clothing/face/shepherd/clothmask()
		if(!equipped_human.equip_to_slot_if_possible(mask, ITEM_SLOT_MASK))
			qdel(mask)

/datum/outfit/lieutenant/post_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.cloak && !findtext(equipped_human.cloak.name,"([equipped_human.real_name])"))
		equipped_human.cloak.name = "[equipped_human.cloak.name]"+" "+"([equipped_human.real_name])"
