/datum/job/advclass/combat/sfighter
	title = "Fighter"
	tutorial = "Wandering sellswords, foolhardy gloryhounds, deserters, armed peasants... many and varied folk turn to the path of the fighter. Very few meet anything greater than the bottom of a tankard or the wrong end of a noose. ¿why do you fight? Gold? Fame? Justice? or because all you got left are your hands and the will to use them?"
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/adventurer/sfighter
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/reading = 1,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_INT = -1, // Muscle brains
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/combat/sfighter/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.gender == FEMALE)
		spawned.underwear = "Femleotard"
		spawned.underwear_color = CLOTHING_SOOT_BLACK
		spawned.update_body()

	if(spawned.age == AGE_OLD) // old warriors get immunity to see gibs
		ADD_TRAIT(spawned, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	spawned.adjust_skillrank(/datum/skill/misc/riding, pick(1,1,2), TRUE)


/datum/outfit/adventurer/sfighter
	name = "Fighter (Adventurer)"
	belt = /obj/item/storage/belt/leather/adventurer // new belt
	r_hand = /obj/item/flashlight/flare/torch/prelit // they get back their missing torches
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
	)

/datum/outfit/adventurer/sfighter/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(visuals_only)
		return

	shoes = pick(/obj/item/clothing/shoes/boots, /obj/item/clothing/shoes/boots/furlinedboots) // no armored boots for common adventurers.
	gloves = pick(/obj/item/clothing/gloves/leather, /obj/item/clothing/gloves/leather/advanced, /obj/item/clothing/gloves/fingerless, /obj/item/clothing/gloves/chain/iron)
	pants = pick(/obj/item/clothing/pants/tights/colored/black, /obj/item/clothing/pants/trou/leather/splint, /obj/item/clothing/pants/trou/leather) // you will have a chance to start with hope on your legs.
	backl = pick(/obj/item/storage/backpack/satchel, /obj/item/storage/backpack/satchel/cloth)
	armor = pick(/obj/item/clothing/armor/chainmail/hauberk/iron, /obj/item/clothing/armor/leather/splint, /obj/item/clothing/armor/cuirass/iron)
	wrists = pick(/obj/item/clothing/wrists/bracers/leather, /obj/item/clothing/wrists/bracers/ironjackchain)
	neck = pick(/obj/item/clothing/neck/chaincoif/iron, /obj/item/clothing/neck/gorget, /obj/item/clothing/neck/highcollier/iron, /obj/item/clothing/neck/coif/cloth, /obj/item/clothing/neck/coif)
	head = pick(/obj/item/clothing/head/helmet/skullcap, /obj/item/clothing/head/helmet/ironpot, /obj/item/clothing/head/helmet/sallet/iron, /obj/item/clothing/head/helmet/leather/headscarf)
	shirt = pick(/obj/item/clothing/armor/gambeson, /obj/item/clothing/armor/gambeson/light)

/datum/outfit/adventurer/sfighter/post_equip(mob/living/carbon/human/H)
	. = ..()
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
	var/shield_path = null

	switch(weaponchoice)
		if("Sword")
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe", "Mace")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Spear")
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			grant_shield = new /obj/item/weapon/shield/tower/buckleriron
		if("Flail", "Great flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			if(weaponchoice == "Great flail")
				grant_shield = FALSE
		if("Goedendag", "Great axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
			grant_shield = FALSE

	if(grant_shield == TRUE) // TRUE boolean, not a path
		shield_path = pick(list(/obj/item/weapon/shield/heater, /obj/item/weapon/shield/wood))
		var/obj/item/shield = new shield_path()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
	else if(ispath(grant_shield)) // Spear gives specific buckler
		var/obj/item/shield = new grant_shield()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
