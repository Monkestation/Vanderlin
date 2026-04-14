/datum/attribute_holder/sheet/job/exiled
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/traps = 30
	)

/datum/job/advclass/mercenary/exiled
	title = "Exiled Warrior"
	tutorial = "A barbarian - you're a brute, and you're a long way from home. You took more of a liking to the blade than your elders wanted - in truth, they did not have to even deliberate to banish you. You will drown in ale, and your enemies in blood."
	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/mercenary/exiled
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/exiled

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_DUALWIELDER
	)

	voicepack_m = /datum/voicepack/male/warrior

/datum/job/advclass/mercenary/exiled/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.gender == MALE && spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

/datum/job/advclass/mercenary/exiled/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list("Sword", "Axes")
	var/weapon_choice = tgui_input_list(player_client, "CHOOSE YOUR WEAPON.", "SPILL SOME BLOOD.", weapons)
	switch(weapon_choice)
		if("Sword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/arming, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 30)
		if("Axes")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_L, TRUE)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)

/datum/outfit/mercenary/exiled
	name = "Exiled Warrior (Mercenary)"
	neck = /obj/item/clothing/neck/coif
	pants = /obj/item/clothing/pants/trou/leather/advanced
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary
	head = /obj/item/clothing/head/helmet/leather
	armor = /obj/item/clothing/shirt/undershirt/easttats/tribal
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
