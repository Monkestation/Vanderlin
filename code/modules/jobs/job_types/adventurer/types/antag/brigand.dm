/datum/attribute_holder/sheet/job/
	raw_attribute_list = list(

	)

/datum/attribute_holder/sheet/job/brigand
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
	)

/datum/job/advclass/bandit/brigand //Strength class, starts with axe or flails and medium armor training
	title = "Brigand"
	tutorial = "Cast from society, you use your powerful physical might and endurance to take from those who are weaker from you."
	outfit = /datum/outfit/bandit/brigand
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_bandit_brigand.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/brigand

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/bandit/brigand/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Battleaxe & Cudgel" = list(/obj/item/weapon/axe/battle, /obj/item/weapon/mace/cudgel),
		"Flail & Shield" = list(/obj/item/weapon/shield/wood, /obj/item/weapon/flail),
	)

	spawned.select_equippable(player_client, weapons, message = "Choose your weapon.", title = "TAKE UP ARMS.")

/datum/outfit/bandit/brigand
	name = "Brigand (Bandit)"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/boots
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1)
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/chaincoif/iron
	head = /obj/item/clothing/head/helmet/leather/volfhelm
	armor = /obj/item/clothing/armor/cuirass/iron
