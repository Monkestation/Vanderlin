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

/datum/outfit/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'

	head = /obj/item/clothing/head/helmet/ironpot
	armor = /obj/item/clothing/armor/cuirass/iron // Adventurers are not supposed to have fricking steel, at all
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/chaincoif/iron // Everyone gets iron coif, instead of variable neck armor
	belt = /obj/item/storage/belt/leather
	backl = /obj/item/storage/backpack/satchel
	//I assume they were given something for the journey by another parish, or the one they departed from
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1)

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			backr = /obj/item/weapon/shield/heater
			if(iself(H) || ishalfelf(H))
				beltl = /obj/item/weapon/mace/elvenclub
			else
				beltl = /obj/item/weapon/mace
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
			backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)//accustomed to death
			backr = /obj/item/weapon/shield/heater
			if(iself(H) || ishalfelf(H))
				beltl = /obj/item/weapon/mace/elvenclub
			else
				beltl = /obj/item/weapon/mace
			beltr = /obj/item/weapon/shovel/small //so they can burry the dead
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			H.virginity = FALSE
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			//its a cupid joke, but in this case with a crossbow
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltl = /obj/item/ammo_holder/quiver/bolts
			beltr = /obj/item/weapon/knife/dagger //meant as a backup weapon
			H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			cloak =  /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			backr = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			backr = /obj/item/weapon/shield/heater
			beltl = /obj/item/weapon/whip/chain
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			backr = /obj/item/weapon/shield/heater
			beltl = /obj/item/weapon/sword/short
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/tabard/crusader
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			backr = /obj/item/weapon/polearm/spear //think fishing spear
			beltl = /obj/item/fishingrod //no attachements, cleric can either discard it or embrace abyssor and fish like man was made to do
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
			beltl = /obj/item/weapon/hammer/sledgehammer
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			backr = /obj/item/weapon/shield/heater
			beltl = /obj/item/weapon/flail
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		else // Failsafe
			cloak = /obj/item/clothing/cloak/tabard/crusader // Give us a generic crusade tabard
			wrists = /obj/item/clothing/neck/psycross/silver // Give us a silver psycross for protection against lickers
			H.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
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
