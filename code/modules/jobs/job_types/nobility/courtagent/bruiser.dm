/datum/attribute_holder/sheet/job/courtagent/bruiser
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 3,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/courtagent/bruiser/barehanded
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/unarmed = list(35, 35),
		/datum/attribute/skill/combat/wrestling = list (35, 35)
	)

/datum/job/advclass/courtagent/bruiser
	title = "Bruiser"
	tutorial = "You are one of the Hand's loyal Agents. \
	From a very early age growing up on the streets, you learned the best ways to cause harm to people using nothing but your fists and your wits. \
	Eventually, you became employed by the Hand as personal muscle. When the Hand gives the order, you go and break some legs."
	outfit = /datum/outfit/courtagent/bruiser
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/bruiser

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/courtagent/bruiser
	name = "Bruiser (Court Agent)"
	cloak = /obj/item/clothing/cloak/raincloak/colored/black
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/leather/splint
	backr = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather/black/courtagent
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/darkboots
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/job/advclass/courtagent/bruiser/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Steel Knuckles" = /obj/item/weapon/knuckles,
		"Steel Katar" = /obj/item/weapon/katar,
		"Bare Handed" = /obj/item/clothing/gloves/bandages/pugilist,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Bare Handed")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/bruiser/barehanded)
			spawned.add_spell(/datum/action/innate/clench_fists, TRUE)
			ADD_TRAIT(spawned, TRAIT_CLOSECOMBAT, JOB_TRAIT)
