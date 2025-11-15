//shield sword
/datum/job/advclass/combat/sfighter
	title = "Fighter"
	tutorial = "Wandering sellswords, foolhardy gloryhounds, deserters, armed peasants... many and varied folk turn to the path of the fighter. Very few meet anything greater than the bottom of a tankard or the wrong end of a noose. ¿why do you fight? Gold? Fame? Justice? or because all you got left are your hands and the will to use them?"
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/adventurer/sfighter
	category_tags = list(CTAG_ADVENTURER)
	min_pq = 0
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'


/datum/outfit/adventurer/sfighter/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)//sidearm skill
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, pick(0,1,1), TRUE)

//UNIVERSAL GEAR
	shoes = pick(/obj/item/clothing/shoes/boots, /obj/item/clothing/shoes/boots/furlinedboots) // no armored boots for common adventurers.
	gloves = pick(/obj/item/clothing/gloves/leather, /obj/item/clothing/gloves/leather/advanced, /obj/item/clothing/gloves/fingerless, /obj/item/clothing/gloves/chain/iron)
	belt = /obj/item/storage/belt/leather/adventurer // new belt
	pants = pick(/obj/item/clothing/pants/tights/colored/black, /obj/item/clothing/pants/trou/leather/splint, /obj/item/clothing/pants/trou/leather) // you will have a chance to start with hope on your legs.
	backl = pick(/obj/item/storage/backpack/satchel, /obj/item/storage/backpack/satchel/cloth)
	armor = pick(/obj/item/clothing/armor/chainmail/hauberk/iron, /obj/item/clothing/armor/leather/splint, /obj/item/clothing/armor/cuirass/iron)
	wrists = pick(/obj/item/clothing/wrists/bracers/leather, /obj/item/clothing/wrists/bracers/ironjackchain)
	neck = pick(/obj/item/clothing/neck/chaincoif/iron, /obj/item/clothing/neck/gorget, /obj/item/clothing/neck/highcollier/iron, /obj/item/clothing/neck/coif/cloth, /obj/item/clothing/neck/coif)
	head = pick(/obj/item/clothing/head/helmet/skullcap, /obj/item/clothing/head/helmet/ironpot, /obj/item/clothing/head/helmet/sallet/iron, /obj/item/clothing/head/helmet/leather/headscarf)
	shirt = pick(/obj/item/clothing/armor/gambeson, /obj/item/clothing/armor/gambeson/light)
	r_hand = /obj/item/flashlight/flare/torch/prelit // they get back their missing torches

	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_INT, -1) // Muscle brains
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	if(H.age == AGE_OLD)// old warriors get inmunity to see gibs
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
	)

	H.adjust_blindness(-3)


/datum/outfit/adventurer/sfighter/post_equip(mob/living/carbon/human/H)
	var/list/selectableweapon = list(
		"Sword" = pick(list(/obj/item/weapon/sword/iron, /obj/item/weapon/sword/scimitar/messer, /obj/item/weapon/sword/sabre/scythe)), \
		"Axe" = /obj/item/weapon/axe/iron, \
		"Mace" = pick(list(/obj/item/weapon/mace/bludgeon, /obj/item/weapon/mace/warhammer, /obj/item/weapon/mace/spiked, /obj/item/weapon/hammer/sledgehammer)), \
		"Spear" = /obj/item/weapon/polearm/spear, \
		"Flail" = pick(list(/obj/item/weapon/flail, /obj/item/weapon/flail/militia)), \
		"Great flail" = /obj/item/weapon/flail/peasant, \
		"Goedendag" = /obj/item/weapon/mace/goden, \
		"Great axe" = /obj/item/weapon/polearm/halberd/bardiche/woodcutter, \
		)
	var/weaponchoice = H.select_equippable(H, selectableweapon, message = "Choose Your Specialisation", title = "Fighter!")
	if(!weaponchoice)
		return
	var/grant_shield = TRUE
	switch(weaponchoice)
		if("Sword")
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Mace")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Spear")
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			grant_shield = new /obj/item/weapon/shield/tower/buckleriron
		if("Flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		if("Great flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			grant_shield = FALSE
		if("Goedendag")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
			grant_shield = FALSE
		if("Great axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
			grant_shield = FALSE
	if(grant_shield)
		var/shield_path = pick(list(/obj/item/weapon/shield/heater, /obj/item/weapon/shield/wood))
		var/obj/item/shield = new shield_path()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
