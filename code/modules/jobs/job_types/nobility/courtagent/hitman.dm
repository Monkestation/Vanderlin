/datum/attribute_holder/sheet/job/courtagent/hitman
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 3,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/courtagent/hitman/shortbow
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/bows = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/hitman/crossbow
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/crossbows = list(30, 30)
	)

/datum/job/advclass/courtagent/hitman
	title = "Hitman"
	tutorial = "You are one of the Hand's loyal Agents. \
	Before finding yourself employed at the Court, you were an Assassin for hire. You took gold and killed without question. \
	Now for steady pay, you aid the Hand and the Court in matters that the public had best not know about. \
	Your targets are picked out, and you execute without question, as you always have done."
	outfit = /datum/outfit/courtagent/hitman
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/hitman

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/courtagent/hitman
	name = "Hitman (Court Agent)"
	cloak = /obj/item/clothing/cloak/raincloak
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/leather/splint
	gloves = /obj/item/clothing/gloves/fingerless
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard/stiletto
	belt = /obj/item/storage/belt/leather/black/courtagent
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/darkboots
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/reagent_containers/glass/bottle/stampoison = 1,
	)

/datum/job/advclass/courtagent/hitman/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Shortbow" = /obj/item/gun/ballistic/bow/short,
		"Crossbow" = /obj/item/gun/ballistic/bow/cross,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Shortbow")
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/hitman/shortbow)
		if("Crossbow")
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/hitman/crossbow)
