/datum/job/advclass/mercenary/exiled
	title = "Exiled Warrior"
	tutorial = "A barbarian - you're a brute, and you're a long way from home. You took more of a liking to the blade than your elders wanted - in truth, they did not have to even deliberate to banish you. You will drown in ale, and your enemies in blood."
	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/mercenary/exiled
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = -1,
		STATKEY_INT = 3
	)

	skills = list(
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/tanning = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/craft/traps = 3
	)

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
	var/weapons = list("Sword", "Axes")
	var/weapon_choice = tgui_input_list(player_client, "CHOOSE YOUR WEAPON.", "SPILL SOME BLOOD.", weapons)
	switch(weapon_choice)
		if("Sword")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/arming, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		if("Axes")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_L, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)

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
