/datum/attribute_holder/sheet/job/pyromaniac
	raw_attribute_list = list(
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/traps = 40,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/craft/bombs = 40,
	)

/datum/job/advclass/wretch/pyromaniac
	title = "Pyromaniac"
	tutorial = "A notorious arsonist with a penchant for fire, you wield your own personal vendetta against the chaotic forces within Faience. Bring mayhem and destruction with flame and misfortune! Just... try not to hit yourself with your explosives - you aren't fireproof, after all."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/pyromaniac
	total_positions = 2

	attribute_sheet = /datum/attribute_holder/sheet/job/pyromaniac

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER
	)

/datum/job/advclass/wretch/pyromaniac/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectableweapon = list(
		"Bow" = /obj/item/gun/ballistic/bow/short,
		"Crossbow" = /obj/item/gun/ballistic/bow/cross,
	)
	var/weaponschoice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Weapon of choice", title = "PYROMANIAC")
	if(!weaponschoice)
		return

	switch(weaponschoice)
		if("Bow")
			var/obj/item/ammo_holder/quiver/arrows/pyro/P = new(get_turf(spawned))
			spawned.equip_to_appropriate_slot(P)
			to_chat(spawned, span_info("You are able to make more bow ammunitions with iron, blast powder and some planks."))
		if("Crossbow")
			var/obj/item/ammo_holder/quiver/bolts/pyro/P = new(get_turf(spawned))
			spawned.equip_to_appropriate_slot(P)
			to_chat(spawned, span_info("You are able to make more crossbow ammunitions with iron, blast powder and some planks."))

/datum/outfit/wretch/pyromaniac
	name = "Pyromaniac (Wretch)"
	head = /obj/item/clothing/head/roguehood/colored/red
	mask = /obj/item/clothing/face/facemask
	neck = /obj/item/clothing/neck/chaincoif/iron
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/splint
	shirt = /obj/item/clothing/armor/chainmail
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/black
	gloves = /obj/item/clothing/gloves/plate
	shoes = /obj/item/clothing/shoes/boots/armor
	r_hand = /obj/item/explosive/bottle
	l_hand = /obj/item/explosive/bottle
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored
	backpack_contents = list(
		/obj/item/explosive/bottle = 2,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
