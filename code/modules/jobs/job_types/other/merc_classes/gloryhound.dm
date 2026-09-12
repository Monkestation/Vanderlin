/datum/attribute_holder/sheet/job/gloryhound
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/job/advclass/mercenary/gloryhound
	title = "Gloryhound"
	tutorial = "Once a traveling warrior of unknown origin, you found yourself in the spotlight after performing a impressive feat. You have joined the mercenary guild in search of this fame once more."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/gloryhound
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/gloryhound

	traits = list(
		TRAIT_MEDIUMARMOR
	)


/datum/outfit/mercenary/gloryhound
	name = "Gloryhound (Mercenary)"
	shoes = /obj/item/clothing/shoes/shortboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	head = /obj/item/clothing/head/helmet/visored/sallet
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/cuirass
	backl = /obj/item/storage/backpack/satchel
	shirt = /obj/item/clothing/armor/gambeson/arming
	pants = /obj/item/clothing/pants/trou/leather/splint
	wrists = /obj/item/clothing/wrists/bracers/leather
	neck = /obj/item/clothing/neck/chaincoif/iron
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/mercenary/gloryhound/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/mercenary/gloryhound/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectable = list( \
		"Sword" = list(/obj/item/weapon/scabbard/sword, /obj/item/weapon/sword/arming, /obj/item/weapon/shield/tower/buckleriron), \
		"Mace" = list(/obj/item/weapon/mace/steel, /obj/item/weapon/shield/tower/buckleriron), \
		"Polehammer" = /obj/item/weapon/polearm/eaglebeak, \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "CHOOSE YOUR WEAPON", title = "FOR FORTUNE AND GLORY!")
	switch(choice)
		if("Sword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 13, 33)
		if("Mace")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 13, 33)
		if("Polehammer")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/polearms, 13, 33)
