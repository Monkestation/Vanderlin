//shield
/datum/job/advclass/combat/cleric
	title = "Cleric"
	tutorial = "Clerics are wandering warriors of the Gods, \
	drawn from the ranks of temple acolytes who demonstrated martial talent. \
	Protected by armor and zeal, they are a force to be reckoned with."
	allowed_races = RACES_PLAYER_NONHERETICAL
	outfit = /datum/outfit/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER)
	min_pq = 0
	total_positions = 4
	allowed_patrons = ALL_CLERIC_PATRONS

	exp_types_granted  = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)


/datum/outfit/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'

	head = pick(/obj/item/clothing/head/helmet/skullcap, /obj/item/clothing/head/helmet/ironpot, /obj/item/clothing/head/helmet/sallet/iron, /obj/item/clothing/head/helmet/leather/headscarf)
	armor = pick(/obj/item/clothing/armor/chainmail/iron, /obj/item/clothing/armor/leather/splint, /obj/item/clothing/armor/cuirass/iron)
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = pick(/obj/item/clothing/neck/chaincoif/iron, /obj/item/clothing/neck/gorget, /obj/item/clothing/neck/highcollier/iron, /obj/item/clothing/neck/coif/cloth, /obj/item/clothing/neck/coif)
	belt = /obj/item/storage/belt/leather/adventurer
	backl = pick(/obj/item/storage/backpack/satchel, /obj/item/storage/backpack/satchel/cloth)
	r_hand = /obj/item/flashlight/flare/torch/prelit // they get back their missing torches
	//I assume they were given something for the journey by another parish, or the one they departed from
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1)

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)//accustomed to death
			beltr = /obj/item/weapon/shovel/small //so they can bury the dead
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			H.virginity = FALSE
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			cloak =  /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE) // the devouts of the god of war got hands
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			H.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
			H.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
			beltl = /obj/item/fishingrod //no attachements, cleric can either discard it or embrace abyssor and fish like man was made to do
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
		else // Failsafe
			cloak = /obj/item/clothing/cloak/tabard/crusader // Give us a generic crusade tabard
			wrists = /obj/item/clothing/neck/psycross/silver // Give us a silver psycross for protection against lickers
			H.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // old clerics aren't afraid of blood, inhumen or monsters, they have seen most of it and are old now
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, -1)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC) // Even if it has limited slots, it is a common drifter role available to anyone. Their armor also is not heavy, so medium armor training is enough
	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(H)

	H.adjust_blindness(-3)

/datum/outfit/adventurer/cleric/post_equip(mob/living/carbon/human/H)
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
	var/weaponchoice = H.select_equippable(H, selectableweapon, message = "Choose Your Specialisation", title = "Warrior of the ten!")
	if(!weaponchoice)
		return
	var/grant_shield = TRUE
	switch(weaponchoice)
		if("Sword")
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		if("Axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if("Mace")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if("Spear")
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			grant_shield = new /obj/item/weapon/shield/tower/buckleriron
		if("Flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		if("Great flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
			grant_shield = FALSE
		if("Goedendag")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			grant_shield = FALSE
		if("Great axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			grant_shield = FALSE
	if(grant_shield)
		var/shield_path = pick(list(/obj/item/weapon/shield/heater, /obj/item/weapon/shield/wood))
		var/obj/item/shield = new shield_path()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
