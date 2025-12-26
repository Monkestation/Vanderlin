/datum/job/advclass/wretch/pyromaniac
	title = "Pyromaniac"
	tutorial = "A notorious arsonist with a penchant for fire, you wield your own personal vendetta against the chaotic forces within Faience. Bring mayhem and destruction with flame and misfortune! Just... try not to hit yourself with your explosives - you aren't fireproof, after all."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/pyromaniac
	total_positions = 2

	jobstats = list(
		STATKEY_END = 3,
		STATKEY_CON = 3,
		STATKEY_INT = 3
	)

	skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/reading = 2,
		/datum/skill/craft/traps = 4,
		/datum/skill/craft/alchemy = 4,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/engineering = 3,
		/datum/skill/labor/farming = 1,
		/datum/skill/craft/bombs = 4
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER
	)

/datum/job/advclass/wretch/pyromaniac/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectableweapon = list(
		"Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short,
		"Crossbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
	)
	var/weaponschoice = spawned.select_equippable(spawned, selectableweapon, message = "Choose Your Weapon of choice", title = "PYROMANIAC")
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

	wretch_select_bounty(spawned)

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