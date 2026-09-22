/datum/attribute_holder/sheet/job/courtagent/protector
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/attribute_holder/sheet/job/courtagent/protector/swordshield
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(30, 30),
		/datum/attribute/skill/combat/shields = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/rapier
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/axesmaces = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/spear
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(30, 30)
	)


/datum/job/advclass/courtagent/protector
	title = "Protector"
	tutorial = "You are one of the Hand's loyal Agents. \
	While your colleagues specialise in the more subtle arts, you specialise in sheer brute strength. \
	A born fighter from an early age, you are now tasked by the Hand to provide personal protection where the Hand deems it necessary. \
	Little do your charges know who you also report to. No one suspects their protector to hear all their dirty little secrets, surely."
	outfit = /datum/outfit/courtagent/protector
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/protector

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/outfit/courtagent/protector
	name = "Protector (Court Agent)"
	head = /obj/item/clothing/head/helmet/leather/headscarf
	gloves = /obj/item/clothing/gloves/leather
	shirt = /obj/item/clothing/armor/gambeson/light/colored/black
	armor = /obj/item/clothing/armor/brigandine/light
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/raincloak/colored/black
	wrists = /obj/item/clothing/wrists/bracers/leather
	belt = /obj/item/storage/belt/leather/black/courtagent
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/darkboots
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/job/advclass/courtagent/protector/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Sword & Shield" = /obj/item/weapon/sword/scimitar/messer,
		"Rapier" = /obj/item/weapon/sword/rapier,
		"Axe" = /obj/item/weapon/axe/iron,
		"Mace" = /obj/item/weapon/mace/spiked,
		"Spear" = /obj/item/weapon/polearm/spear,
		"Flail" = /obj/item/weapon/flail,
		"Whip" = /obj/item/weapon/whip,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Sword & Shield")
			spawned.put_in_hands(new /obj/item/weapon/shield/heater(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/swordshield)
		if("Rapier")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/rapier)
		if("Axe")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces)
		if("Mace")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces)
		if("Spear")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/spear)
		if("Flail")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails)
		if("Whip")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails)
