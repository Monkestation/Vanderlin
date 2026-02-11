/datum/job/advclass/combat/vikingr
	title = "Elven Vikingr"
	tutorial = "A wandering searaider, a Vikingr from the Elven Clans of Kaledon. You are locked in a fierce rivalry with your other kin, those sea elves, those coastal elves, you hate whichever one is not you. You will see them die. Abyssor's bounty is what you seek, and you shall have it."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/adventurer/vikingr
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	total_positions = 0 //Kaledon isn't in

/datum/outfit/adventurer/vikingr/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)

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
			backr = /obj/item/weapon/sword/long/greatsword/ironclaymore
			beltl = /obj/item/weapon/axe/iron
			beltr = /obj/item/storage/belt/pouch/coins/poor
			head = /obj/item/clothing/head/helmet/nasal


