/datum/attribute_holder/sheet/job/steppesman
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/riding = 50, // I don't think riding skill has that big of an effect
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/labor/taming = 30,
	)

/datum/job/advclass/mercenary/steppesman
	title = "Steppesman"
	tutorial = "A mercenary hailing from the wild frontier steppes. There are three things you value most; saigas, freedom, and coin."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/steppesman
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/steppesman

	traits = list(
		TRAIT_DUALWIELDER,
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/mercenary/steppesman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))

/datum/outfit/mercenary/steppesman
	name = "Steppesman (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary/black
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/weapon/sword/long/rider/steppe
	beltl = /obj/item/ammo_holder/quiver/arrows
	shirt = /obj/item/clothing/armor/gambeson/light/steppe
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	backr = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather/hide/steppe
	head = /obj/item/clothing/head/papakha
	mask = /obj/item/clothing/face/facemask/steel/steppe
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/tent_kit = 1
	)

/datum/outfit/mercenary/steppesman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna?.species?.id in RACES_PLAYER_HERETICAL_RACE)
		mask = /obj/item/clothing/face/facemask/steel/steppebeast
