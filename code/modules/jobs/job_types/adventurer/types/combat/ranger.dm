/datum/attribute_holder/sheet/job/ranger
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/combat/ranger
	title = "Ranger"
	tutorial = "Humen and elf rangers often live among each other, as these bow-wielding \
	adventurers are often scouting the lands for the same purpose."
	outfit = /datum/outfit/adventurer/ranger
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)

	attribute_sheet = /datum/attribute_holder/sheet/job/ranger

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/job/advclass/combat/ranger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(25))
		if(!spawned.has_language(/datum/language/elvish))
			spawned.grant_language(/datum/language/elvish)
			to_chat(spawned, "<span class='info'>I can speak Elfish with ,e before my speech.</span>")

/datum/outfit/adventurer/ranger
	name = "Ranger (Adventurer)"
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/adventurer
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/wrists/bracers/leather
	pants = /obj/item/clothing/pants/trou/leather
	gloves = /obj/item/clothing/gloves/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backpack_contents = list(
		/obj/item/weapon/knife/hunting/kukri/iron = 1,
		/obj/item/flashlight/flare/torch/lantern = 1, //no more roundstart bait. you're a adventurer, not a hunter.
	)

/datum/job/advclass/combat/ranger/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list("Bow", "Longbow", "Crossbow")
	var/weapon_choice = tgui_input_list(player_client, "Take up arms", "Strike them from afar.", weapons)
	switch(weapon_choice)
		if("Bow") // worst choice, so you get some bonus stats/skills. bows are harder to make then real weapons.
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/bow, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/iron, ITEM_SLOT_BELT_L)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/gambeson, ITEM_SLOT_SHIRT)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 25)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/bows, 20)
			spawned.adjust_skill_level(/datum/attribute/skill/misc/athletics, 5) //slightly more athletics
		if("Longbow") // objectively strongest choice, no bonuses.
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/bow/long, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/shirt/undershirt, ITEM_SLOT_SHIRT)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/bows, 20)
		if("Crossbow")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/bow/cross, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/kettle/slit/iron, ITEM_SLOT_HEAD)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/short/iron, ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/shirt/undershirt, ITEM_SLOT_SHIRT)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 25)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/crossbows, 20)
			REMOVE_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
