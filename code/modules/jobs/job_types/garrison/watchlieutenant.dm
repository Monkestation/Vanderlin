/datum/attribute_holder/sheet/job/lieutenant
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/lieutenant/flail
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(20, 30)
	)

/datum/attribute_holder/sheet/job/lieutenant/polearm
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(20, 30)
	)

/datum/attribute_holder/sheet/job/lieutenant/sword
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(20, 30)
	)

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
	allowed_races = RACES_PLAYER_NO_KOBOLD
	blacklisted_species = list(SPEC_ID_HALFLING)
	outfit = /datum/outfit/lieutenant
	give_bank_account = 50
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'
	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_GARRISON, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(EXP_TYPE_GARRISON = 900)
	honorary = "Lieutenant"

	attribute_sheet = /datum/attribute_holder/sheet/job/lieutenant

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

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
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/lieutenant/flail)
		if("Spear")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/buckleriron(), ITEM_SLOT_BACK_R, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/lieutenant/polearm)
		if("Sword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/heater(), ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword(), ITEM_SLOT_BACK_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/lieutenant/sword)

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
