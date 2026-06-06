/datum/attribute_holder/sheet/job/knave
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 3,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/craft/traps = 30,
	)

/datum/job/advclass/bandit/knave //sneaky bastards - ranged classes of two flavors archers and rogues
	title = "Knave"
	tutorial = "Not all followers of Matthios take by force. Thieves, poachers, and ne'er-do-wells of all forms steal from others from the shadows, long gone before their marks realize their misfortune."
	outfit = /datum/outfit/bandit/knave
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_THIEF)

	attribute_sheet = /datum/attribute_holder/sheet/job/knave

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/bandit/knave/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Crossbow & Dagger" = list(/obj/item/gun/ballistic/bow/cross, /obj/item/weapon/knife/dagger/steel),
		"Bow & Sword" = list(/obj/item/gun/ballistic/bow, /obj/item/weapon/sword/short/iron),
	)

	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your weapon.", title = "TAKE UP ARMS.")

	switch(weapon_choice)
		if("Crossbow & Dagger")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/crossbows, 10)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/knives, 10)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/colored/mortus, ITEM_SLOT_CLOAK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/lockpickring/mundane, ITEM_SLOT_BACKPACK, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)
		if("Bow & Sword")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/bows, 10)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
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
