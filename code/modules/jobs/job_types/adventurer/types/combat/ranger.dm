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

	var/static/list/selectable = list( \
		"Bow" = list(/obj/item/gun/ballistic/bow, /obj/item/ammo_holder/quiver/arrows, /obj/item/weapon/sword/iron, /obj/item/clothing/armor/gambeson), \
		"Longbow" = list(/obj/item/gun/ballistic/bow/long, /obj/item/ammo_holder/quiver/arrows, /obj/item/clothing/shirt/undershirt), \
		"Crossbow" = list(/obj/item/gun/ballistic/bow/cross, /obj/item/clothing/head/helmet/kettle/slit/iron, /obj/item/ammo_holder/quiver/bolts, /obj/item/weapon/sword/short/iron, /obj/item/clothing/shirt/undershirt), \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "Choose your weapon", title = "May your aim be true.")
	switch(choice)
		if("Bow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/bows, 20, 30)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 25, 25)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/misc/athletics, 5, 25)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, JOB_TRAIT)
		if("Longbow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/bows, 20, 30)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, JOB_TRAIT)
		if("Crossbow")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/crossbows, 20, 30)
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 25, 25)
