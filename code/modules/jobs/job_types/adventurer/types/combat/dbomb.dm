/datum/attribute_holder/sheet/job/dbomb
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/labor/mining = 10,
		/datum/attribute/skill/craft/engineering = 50,
		/datum/attribute/skill/craft/bombs = 40,
		/datum/attribute/skill/craft/smelting = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/alchemy = 20,
	)

/datum/job/advclass/combat/dbomb
	title = "Dwarven Bombardier"
	tutorial = "Wandering tinkerers from the Blackpowder clan that specialize in the production of explosives."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/dbomb
	category_tags = list(CTAG_ADVENTURER)

	attribute_sheet = /datum/attribute_holder/sheet/job/dbomb

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/combat/dbomb/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.culture = GLOB.culture_singletons[/datum/culture/species/dwarf/blackpowder]

/datum/outfit/adventurer/dbomb
	name = "Dwarven Bombardier (Adventurer)"
	head = /obj/item/clothing/head/helmet/horned
	pants = /obj/item/clothing/pants/trou
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/leather
	backl = /obj/item/storage/backpack/backpack
	beltl = /obj/item/weapon/pick
	beltr = /obj/item/weapon/hammer/sledgehammer
	backpack_contents = list(
		/obj/item/explosive/bottle = 1,
		/obj/item/flint = 1,
		/obj/item/pestle = 1,
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/recipe_book/underworld = 1,
		/obj/item/reagent_containers/powder/blastpowder = 2,
		)

/datum/outfit/adventurer/dbomb/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(pick(1,2))
		if(1)
			shoes = /obj/item/clothing/shoes/boots/leather
		if(2)
			shoes = /obj/item/clothing/shoes/simpleshoes
