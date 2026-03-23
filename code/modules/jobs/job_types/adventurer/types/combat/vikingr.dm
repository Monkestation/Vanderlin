/datum/attribute_holder/sheet/job/vikingr
	attribute_variance = list(
		/datum/attribute/skill/combat/knives = list(10, 20)
	)
	raw_attribute_list = list(
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
	)

/datum/job/advclass/combat/vikingr
	title = "Elven Vikingr"
	tutorial = "A wandering searaider, a Vikingr from the Elven Clans of Kaledon. You are locked in a fierce rivalry with your other kin, those sea elves, those coastal elves, you hate whichever one is not you. You will see them die. Abyssor's bounty is what you seek, and you shall have it."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/adventurer/vikingr
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	total_positions = 0 //Kaledon isn't in
	attribute_sheet = /datum/attribute_holder/sheet/job/vikingr

/datum/outfit/adventurer/vikingr/pre_equip(mob/living/carbon/human/H)
	..()

	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	neck = /obj/item/clothing/neck/highcollier/iron
	armor = /obj/item/clothing/armor/chainmail/iron
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	backl = /obj/item/weapon/shield/wood
	head = /obj/item/clothing/head/helmet/nasal

/datum/outfit/adventurer/vikingr/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/weapontype = pickweight(list("Bow" = 2, "Axe" = 2, "Claymore" = 1))

	switch(weapontype)
		if("Bow")
			beltl = /obj/item/ammo_holder/quiver/arrows // womp womp, guess bow users cant have coins
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
			head = /obj/item/clothing/head/roguehood/colored/black
			beltr = /obj/item/weapon/sword/iron
		if("Axe")
			backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
			beltr = /obj/item/storage/belt/pouch/coins/poor
			head = /obj/item/clothing/head/helmet/nasal
			beltl = /obj/item/weapon/sword/iron
		if("Claymore")
			backr = /obj/item/weapon/sword/long/greatsword/claymore/iron
			beltl = /obj/item/weapon/axe/iron
			beltr = /obj/item/storage/belt/pouch/coins/poor
			head = /obj/item/clothing/head/helmet/nasal


