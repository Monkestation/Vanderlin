/datum/attribute_holder/sheet/job/hedgeknight
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 37, // experiment, they will be strongest skill wise. might go down later, idk.
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/educated/reading = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/educated/mathematics = 30,
	)

/datum/job/advclass/bandit/hedgeknight //heavy knight class - just like black knight adventurer class. starts with heavy armor training and plate, but less weapon skills than brigand, sellsword and knave
	title = "Hedge Knight"
	tutorial = "A noble fallen from grace, your tarnished armor sits upon your shoulders as a heavy reminder of the life you've lost. Take back what is rightfully yours."
	outfit = /datum/outfit/bandit/hedgeknight
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/hedgeknight

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE_BLOOD,
	)

/datum/job/advclass/bandit/hedgeknight/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Longsword & Shield" = list(/obj/item/weapon/sword/long, /obj/item/weapon/shield/tower/metal),
		"Steel Warhammer & Shield" = list(/obj/item/weapon/mace/warhammer, /obj/item/weapon/shield/tower/buckleriron),
		"Steel Sword & Shield" = list(/obj/item/weapon/sword, /obj/item/weapon/shield/tower/buckleriron),
		"Billhook & Steel Shortsword" = list(/obj/item/weapon/polearm/spear/billhook, /obj/item/weapon/sword/short),
		"Halberd" = /obj/item/weapon/polearm/halberd,
		"Greataxe" = /obj/item/weapon/greataxe/steel,
		"Eagle's Beak" = /obj/item/weapon/polearm/eaglebeak,
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "CHOOSE YOUR WEAPON.", title = "TAKE UP ARMS.")

	if(weapon_choice == "Steel Sword & Shield" || weapon_choice == "Billhook & Steel Shortsword" || weapon_choice == "Longsword & Shield")
		spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 37, 37)
	if(weapon_choice == "Steel Warhammer & Shield" || weapon_choice == "Greataxe")
		spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 37, 37)
	if(weapon_choice == "Billhook & Steel Shortsword" || weapon_choice == "Halberd" || weapon_choice == "Eagle's Beak")
		spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 37, 37)
	if(weapon_choice == "Steel Warhammer & Shield" || weapon_choice == "Steel Sword & Shield" || weapon_choice == "Longsword & Shield")
		spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/shields, 33, 33)

	var/armors = list("Rusted Set, Brigandine Set")
	var/armor_choice = browser_input_list(spawned, "CHOOSE YOUR ARMOR.", "EQUIP YOURSELF.", armors)

	switch(armor_choice)
		if("Rusted Set")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/plate/rust, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/gambeson/heavy, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/platelegs/rust, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/wrists/bracers, ITEM_SLOT_WRISTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/plate/rust, ITEM_SLOT_GLOVES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/neck/gorget, ITEM_SLOT_NECK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/armor/light/rust, ITEM_SLOT_SHOES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/heavy/rust, ITEM_SLOT_HEAD, TRUE)
		if("Brigandine Set")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/brigandine/light, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/chainmail, ITEM_SLOT_SHIRT, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather/brigandine, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/wrists/bracers/leather/brigandine, ITEM_SLOT_WRISTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/gloves/plate, ITEM_SLOT_GLOVES, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/neck/chaincoif, ITEM_SLOT_NECK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/darkboots, ITEM_SLOT_SHOES, TRUE)
			var/static/list/selectablehelmets = list(
				"Royal Slitted Kettle Helmet" = /obj/item/clothing/head/helmet/kettle/slit/atarms,
				"Slitted Kettle Helmet" = /obj/item/clothing/head/helmet/kettle/slit,
				"Kettle Helmet"	= /obj/item/clothing/head/helmet/kettle,
				"Steel Sallet" = /obj/item/clothing/head/helmet/sallet,
				"Nasal Helmet" = /obj/item/clothing/head/helmet/nasal,
			)
			spawned.select_equippable(player_client, selectablehelmets, message = "Choose Your Helmet", title = "Hedge Knight")

/datum/outfit/bandit/hedgeknight
	name = "Hedge Knight (Bandit)"
	belt = /obj/item/storage/belt/leather/bandit
	cloak = /obj/item/clothing/cloak/stabard/jupon
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/knife/dagger = 1, /obj/item/clothing/face/shepherd/rag = 1)
