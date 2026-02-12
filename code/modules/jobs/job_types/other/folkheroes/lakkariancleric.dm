/datum/job/advclass/combat/lakkariancleric // terra was here! <3
	title = "Lakkarian Cleric"
	tutorial = "A cleric belonging to the Order of the Southern Sun. After years of martial training and rigorous theological study, your abbess has deemed you worthy of a grand task. You will root out the corruption spread by The Four across Faience, and deliver the gospel of the glorious Sun Queen."
	allowed_races = RACES_PLAYER_ELF
	allowed_patrons = list(/datum/patron/divine/astrata)
	outfit = /datum/outfit/folkhero/lakkariancleric
	category_tags = list(CTAG_FOLKHEROES)
	total_positions = 0 //Lakkari disabled

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/athletics = 4, // years of martial training would make you quite athletic
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/mathematics = 1,
	)

	jobstats = list(
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 2, // haha elves go nyoom
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT,
	)

	languages = list(/datum/language/celestial)

/datum/job/advclass/combat/lakkariancleric/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE

	var/static/list/selectable = list( \
		"Silver Rungu" = /obj/item/weapon/mace/rungu/silver, \
		"Silver Sengese" = /obj/item/weapon/sword/scimitar/sengese/silver \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "What is your weapon of choice?")
	if(!choice)
		return

	switch(choice)
		if("Silver Rungu")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		if("Silver Sengese")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(spawned)

/datum/outfit/folkhero/lakkariancleric
	name = "Lakkarian Cleric (Folkhero)"
	head = /obj/item/clothing/head/helmet/ironpot/lakkariancap
	armor = /obj/item/clothing/armor/gambeson/heavy/lakkarijupon
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/neck/psycross/silver/astrata
	pants = /obj/item/clothing/pants/trou/leather/quiltedkilt/colored/blue
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/coif/cloth // price to pay for being a speedy class, less neck protection
	belt = /obj/item/storage/belt/leather
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1
	)
