/datum/job/advclass/bandit/sellsword //Strength class, starts with axe or flails and medium armor training
	title = "Sellsword"
	tutorial = "Perhaps a mercenary, perhaps a deserter - at one time, you killed for a master in return for gold. Now you live with no such master over your head - and take what you please."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/bandit/sellsword
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_bandit2.ogg'

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/medicine = 1,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/bandit/sellsword/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Spear & Crossbow" = list(/obj/item/weapon/polearm/spear/billhook,  /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow),
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
