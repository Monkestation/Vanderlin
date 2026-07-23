/datum/attribute_holder/sheet/job/goon
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 20, //for bashing people with a cudgel
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 35,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/attribute_holder/sheet/job/goon/heavy
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 3,
		STAT_PERCEPTION = -1,
		STAT_SPEED = -1
	)

/datum/attribute_holder/sheet/job/goon/light
	raw_attribute_list = list(
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 2
	)

/datum/job/advclass/mercenary/goon
	title = "Goon"
	tutorial = "You grew up around the wrong people, becoming a personal goon for a local crime boss. When he was caught be the town watch, you were left with nothing but your hands to make a living."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/goon
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/goon

	traits = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)

/datum/outfit/mercenary/goon
	name = "Goon (Mercenary)"
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	shirt = /obj/item/clothing/shirt/undershirt/formal
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	pants = /obj/item/clothing/pants/trou/formal
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/needle = 1, // keep the boss alive
		/obj/item/weapon/mace/cudgel/carpenter = 1, // thematic, their fists are better though
		/obj/item/weapon/knife/dagger/navaja = 1 // same reason as fencer, funny noise
	)

/datum/job/advclass/mercenary/goon/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Knuckleduster" = /obj/item/weapon/knuckles,
		"Katar" = /obj/item/weapon/katar,
		"Barehands" = /obj/item/clothing/gloves/bandages/pugilist
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "FOR THE BOSS.")
	switch(weapon_choice)
		if("Barehands")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 5)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/wrestling, 5)

	var/static/list/armors = list(
		"Brute, Splint Armor" = /obj/item/clothing/armor/leather/splint,
		"Speedster, Leather Coat" = /obj/item/clothing/armor/leather/jacket/leathercoat,
	)

	var/armor_choice = spawned.select_equippable(player_client, armors, message = "Choose your ARCHETYPE.", title = "FOR THE BOSS.")
	switch(armor_choice)
		if("Brute, Splint Armor")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, JOB_TRAIT)
			ADD_TRAIT(spawned, TRAIT_NOPAINSTUN, JOB_TRAIT)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/goon/heavy)
		if("Speedster, Leather Coat")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/goon/light)
