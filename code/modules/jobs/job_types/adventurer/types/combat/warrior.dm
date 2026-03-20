/datum/attribute_holder/sheet/job/sfighter
	attribute_variance = list(
		/datum/attribute/skill/misc/riding = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_INTELLIGENCE = -1, // Muscle brains
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/combat/sfighter
	title = "Fighter"
	tutorial = "Wandering sellswords, foolhardy gloryhounds, deserters, armed peasants... many and varied folk turn to the path of the fighter. Very few meet anything greater than the bottom of a tankard or the wrong end of a noose. ¿why do you fight? Gold? Fame? Justice? or because all you got left are your hands and the will to use them?"
	allowed_races = RACES_PLAYER_NONEXOTIC
	outfit = /datum/outfit/adventurer/sfighter
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sfighter

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
			H.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
		if("Axe", "Mace")
			H.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
		if("Spear")
			H.adjust_skill_level(/datum/attribute/skill/combat/polearms, 10)
			grant_shield = new /obj/item/weapon/shield/tower/buckleriron
		if("Flail", "Great flail")
			H.adjust_skill_level(/datum/attribute/skill/combat/whipsflails, 10)
			if(weaponchoice == "Great flail")
				grant_shield = FALSE
		if("Goedendag", "Great axe")
			H.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 10)
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
