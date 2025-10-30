/datum/job/advclass/combat/lakkariancleric // terra was here! <3
	title = "Lakkarian Cleric"
	tutorial = "A cleric belonging to the Order of the Southern Sun. After years of martial training and rigorous theological study, your abbess has deemed you worthy of a grand task. You will root out the corruption spread by The Four across Faience, and deliver the gospel of the glorious Sun Queen."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/adventurer/lakkariancleric
	category_tags = list(CTAG_ADVENTURER)
	min_pq = 0
	roll_chance = 25
	total_positions = 2

/datum/outfit/adventurer/lakkariancleric/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'

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
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // years of martial training would make you quite athletic
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)

	if(!H.has_language(/datum/language/celestial))
		H.grant_language(/datum/language/celestial)

	if(H.patron != /datum/patron/divine/astrata)
		H.set_patron(/datum/patron/divine/astrata)

		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_END, 2)
		H.change_stat (STATKEY_INT, 1)
		H.change_stat(STATKEY_SPD, 2) // haha elves go nyoom
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	var/static/list/selectable = list( \
		"Silver Rungu" = /obj/item/weapon/mace/silver/rungu, \
		"Silver Sengese" = /obj/item/weapon/sword/scimitar/sengese/silver \
		)
	var/choice = H.select_equippable(H, selectable, message = "What is your weapon of choice?")
	if(!choice)
		return
	switch(choice)
		if("Silver Rungu")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		if("Silver Sengese")
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(H)
