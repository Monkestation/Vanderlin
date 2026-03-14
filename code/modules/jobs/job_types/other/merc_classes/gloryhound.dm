/datum/job/advclass/mercenary/gloryhound
	title = "Gloryhound"
	tutorial = "Once a traveling warrior of unknown origin, you perfomed a feat that put you in the spotlight for a short period of time. You yearn for this fame once more."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/gloryhound
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 5

	jobstats = list(
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_STR = 2,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)


/datum/outfit/mercenary/gloryhound
	name = "Gloryhound (Mercenary)"
	shoes = /obj/item/clothing/shoes/shortboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	head = /obj/item/clothing/head/helmet/visored/sallet
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather/advanced
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/cuirass
	backl = /obj/item/storage/backpack/satchel
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/chaincoif/iron
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/villager = 1
	)
/datum/job/advclass/mercenary/gloryhound/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/weapons = list("Sword", "Polehammer", "Mace")
	var/weapon_choice = tgui_input_list(player_client, "TAKE UP ARMS", "FOR FORTUNE AND GLORY!", weapons)
	switch(weapon_choice)
		if("Sword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword, ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/buckleriron, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather/splint, ITEM_SLOT_PANTS)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Polehammer")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/polearm/eaglebeak, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather, ITEM_SLOT_PANTS)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Mace")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/steel, ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/buckleriron, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather/splint, ITEM_SLOT_PANTS)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
