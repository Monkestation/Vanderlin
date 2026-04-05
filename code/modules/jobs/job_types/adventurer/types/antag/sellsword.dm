/datum/attribute_holder/sheet/job/sellsword
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
	)

/datum/job/advclass/bandit/sellsword //Strength class, starts with axe or flails and medium armor training
	title = "Sellsword"
	tutorial = "Perhaps a mercenary, perhaps a deserter - at one time, you killed for a master in return for gold. Now you live with no such master over your head - and take what you please."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/bandit/sellsword
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_bandit2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sellsword

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/bandit/sellsword/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Spear & Crossbow" = list(/obj/item/weapon/polearm/spear/billhook,  /obj/item/gun/ballistic/bow/cross),
		"Sword & Buckler" = list(/obj/item/weapon/sword , /obj/item/weapon/shield/tower/buckleriron)
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your weapon.", title = "TAKE UP ARMS.")
	switch(weapon_choice)
		if("Spear & Crossbow")
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/kettle, ITEM_SLOT_HEAD, TRUE)
		if("Sword & Buckler")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sallet, ITEM_SLOT_HEAD, TRUE)


/datum/outfit/bandit/sellsword
	name = "Sellsword (Bandit)"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/armor/gambeson
	shoes = /obj/item/clothing/shoes/boots
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1)
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/chainmail
