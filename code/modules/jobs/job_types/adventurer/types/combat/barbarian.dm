/datum/attribute_holder/sheet/job/barbarian
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/job/advclass/combat/barbarian
	title = "Barbarian"
	tutorial = "Wildmen and warriors all, Barbarians forego the intricacies of modern warfare in favour of raw strength and brutal cunning. Few of them can truly adjust to the civilized, docile lands of lords and ladies."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_TIEFLING,\
	)
	outfit = /datum/outfit/adventurer/barbarian
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/barbarian

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_DUALWIELDER,
	)

	voicepack_m = /datum/voicepack/male/warrior

	spells = list(
		/datum/action/cooldown/spell/undirected/barbrage
	)
/datum/job/advclass/combat/barbarian/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list("Claymore", "Greataxe", "Goedendag", "Dual Axes", "WHO NEEDS A WEAPON?")
	var/weapon_choice = tgui_input_list(player_client, "CHOOSE YOUR WEAPON", "SPILL SOME BLOOD!", weapons)
	switch(weapon_choice)
		if("Claymore")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/long/greatsword/claymore/iron, ITEM_SLOT_BACK_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 20)
		if("Greataxe")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/greataxe, ITEM_SLOT_BACK_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20)
		if("Goedendag")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/goden, ITEM_SLOT_BACK_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20)
		if("Dual Axes")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_R, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20)
		if("WHO NEEDS A WEAPON?")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/bandages/weighted, ITEM_SLOT_GLOVES, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 5) //only a slight bonus compared to most unarmed classes due to the sheer amount of strength
			spawned.adjust_skill_level(/datum/attribute/skill/combat/wrestling, 10)

/datum/outfit/adventurer/barbarian
	name = "Barbarian (Adventurer)"
	head = /obj/item/clothing/head/helmet/horned
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	belt = /obj/item/storage/belt/leather/adventurer
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather

