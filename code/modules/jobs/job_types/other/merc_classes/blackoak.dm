/datum/attribute_holder/sheet/job/blackoak
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/crafting = 10,
	)

/datum/job/advclass/mercenary/blackoak
	title = "Black Oak's Guardian"
	tutorial = "A shady guardian of the Black Oaks, a mercenary band in all but official name. Commonly taking caravan contracts through the thickest of forests."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/mercenary/blackoak
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/disciple

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT,
	)

	exp_type = list(EXP_TYPE_LIVING)
	exp_requirements = list(EXP_TYPE_LIVING = 600)


/datum/job/advclass/mercenary/blackoak/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectableweapon = list( \
		"Spear" = /obj/item/weapon/polearm/spear, \
		"Regal Elven Club" = /obj/item/weapon/mace/elvenclub/steel \
		)
	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Weapon", title = "Black Oak's Guardian")
	if(!choice)
		return
	switch(choice)
		if("Spear")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/polearms, 30)
		if("Regal Elven Club")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 30)
	spawned.merctype = 4


/datum/outfit/mercenary/blackoak
	name = "Black Oak's Guardian (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	cloak = /obj/item/clothing/cloak/half/colored/red
	head = /obj/item/clothing/head/helmet/sallet/elven
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/cuirass/rare/elven
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/weapon/knife/dagger/steel/special
	scabbards = list(/obj/item/weapon/scabbard/knife)
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor
	)

