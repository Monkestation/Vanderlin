/datum/job/advclass/bandit/knave //sneaky bastards - ranged classes of two flavors archers and rogues
	title = "Knave"
	tutorial = "Not all followers of Matthios take by force. Thieves, poachers, and ne'er-do-wells of all forms steal from others from the shadows, long gone before their marks realize their misfortune."
	outfit = /datum/outfit/bandit/knave
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_THIEF)

	jobstats = list(
		STATKEY_END = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 3,
	)

	skills = list(
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/craft/traps = 3,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/bandit/knave/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list(
		"Crossbow & Dagger" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, /obj/item/weapon/knife/dagger/steel),
		"Bow & Sword" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow, /obj/item/weapon/sword/short/iron),
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your weapon.", title = "TAKE UP ARMS.")

	switch(weapon_choice)
		if("Crossbow & Dagger")
			spawned.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/colored/mortus, ITEM_SLOT_CLOAK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/lockpickring/mundane, ITEM_SLOT_BACKPACK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)
		if("Bow & Sword")
			spawned.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_FORAGER, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_BRUSHWALK, TRAIT_GENERIC)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/leather/volfhelm, ITEM_SLOT_HEAD, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/restraints/legcuffs/beartrap, ITEM_SLOT_BACKPACK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/restraints/legcuffs/beartrap, ITEM_SLOT_BACKPACK, TRUE)

/datum/outfit/bandit/knave
	name = "Knave (Bandit)"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/boots
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1)
