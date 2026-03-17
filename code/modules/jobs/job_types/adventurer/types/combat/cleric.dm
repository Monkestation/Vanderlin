/datum/attribute_holder/sheet/job/cleric
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/magic/holy = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/attribute_holder/sheet/job/cleric/old
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/advclass/combat/cleric
	title = "Cleric"
	tutorial = "Clerics are wandering warriors of the Gods, \
	drawn from the ranks of temple acolytes who demonstrated martial talent. \
	Protected by armor and zeal, they are a force to be reckoned with."
	allowed_races = RACES_PLAYER_NONHERETICAL
	outfit = /datum/outfit/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 4
	allowed_patrons = ALL_CLERIC_PATRONS

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/cleric
	attribute_sheet_old = /datum/attribute_holder/sheet/job/cleric/old

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

	languages = list(/datum/language/celestial)

	cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'

/datum/job/advclass/combat/cleric/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		ADD_TRAIT(spawned, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	spawned.virginity = TRUE

	if(spawned.patron)
		switch(spawned.patron.type)
			if(/datum/patron/divine/astrata)
				spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			if(/datum/patron/divine/dendor)
				spawned.cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
			if(/datum/patron/divine/necra)
				spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
				ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
				ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
			if(/datum/patron/divine/eora)
				spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
				spawned.virginity = FALSE
				ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			if(/datum/patron/divine/ravox)
				spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
				spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 10)
			if(/datum/patron/divine/noc)
				spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
			if(/datum/patron/divine/pestra)
				spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			if(/datum/patron/divine/abyssor)
				spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
				spawned.adjust_skill_level(/datum/attribute/skill/labor/fishing, 20)
			if(/datum/patron/divine/malum)
				spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
			if(/datum/patron/divine/xylix)
				spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			else
				spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(spawned)

	var/list/selectableweapon = list(
		"Sword" = pick(list(/obj/item/weapon/sword/iron, /obj/item/weapon/sword/scimitar/messer, /obj/item/weapon/sword/sabre/scythe)),
		"Axe" = /obj/item/weapon/axe/iron,
		"Mace" = pick(list(/obj/item/weapon/mace/bludgeon, /obj/item/weapon/mace/warhammer, /obj/item/weapon/mace/spiked, /obj/item/weapon/hammer/sledgehammer)),
		"Spear" = /obj/item/weapon/polearm/spear,
		"Flail" = pick(list(/obj/item/weapon/flail, /obj/item/weapon/flail/militia)),
		"Great flail" = /obj/item/weapon/flail/peasant,
		"Goedendag" = /obj/item/weapon/mace/goden,
		"Great axe" = /obj/item/weapon/polearm/halberd/bardiche/woodcutter,
	)

	var/weaponchoice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Specialisation", title = "Warrior of the ten!")
	if(!weaponchoice)
		return

	var/grant_shield = TRUE
	var/weapon_skill_path

	switch(weaponchoice)
		if("Sword")
			weapon_skill_path = /datum/attribute/skill/combat/swords
		if("Axe", "Mace", "Goedendag", "Great axe")
			weapon_skill_path = /datum/attribute/skill/combat/axesmaces
		if("Spear")
			weapon_skill_path = /datum/attribute/skill/combat/polearms
		if("Flail", "Great flail")
			weapon_skill_path = /datum/attribute/skill/combat/whipsflails

	if(weapon_skill_path)
		spawned.adjust_skill_level(weapon_skill_path, 30)

	switch(weaponchoice)
		if("Great flail", "Goedendag", "Great axe")
			grant_shield = FALSE
		if("Spear")
			var/obj/item/weapon/shield/tower/buckleriron/buckler = new /obj/item/weapon/shield/tower/buckleriron()
			if(!spawned.equip_to_appropriate_slot(buckler))
				qdel(buckler)
			grant_shield = FALSE

	if(grant_shield)
		var/shield_path = pick(list(/obj/item/weapon/shield/heater, /obj/item/weapon/shield/wood))
		var/obj/item/shield = new shield_path()
		if(!spawned.equip_to_appropriate_slot(shield))
			qdel(shield)


/datum/outfit/adventurer/cleric
	name = "Cleric (Adventurer)"
	head = /obj/item/clothing/head/helmet/skullcap
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/chaincoif/iron
	belt = /obj/item/storage/belt/leather/adventurer
	backl = /obj/item/storage/backpack/satchel
	r_hand = /obj/item/flashlight/flare/torch/prelit
	cloak = /obj/item/clothing/cloak/tabard/crusader
	wrists = /obj/item/clothing/neck/psycross/silver
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1)

/datum/outfit/adventurer/cleric/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/helmet/skullcap, /obj/item/clothing/head/helmet/ironpot, /obj/item/clothing/head/helmet/sallet/iron, /obj/item/clothing/head/helmet/leather/headscarf)
	armor = pick(/obj/item/clothing/armor/chainmail/iron, /obj/item/clothing/armor/leather/splint, /obj/item/clothing/armor/cuirass/iron)
	neck = pick(/obj/item/clothing/neck/chaincoif/iron, /obj/item/clothing/neck/gorget, /obj/item/clothing/neck/highcollier/iron, /obj/item/clothing/neck/coif/cloth, /obj/item/clothing/neck/coif)
	backl = pick(/obj/item/storage/backpack/satchel, /obj/item/storage/backpack/satchel/cloth)

	if(equipped_human.patron)
		switch(equipped_human.patron.type)
			if(/datum/patron/divine/astrata)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/astrata
				cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			if(/datum/patron/divine/dendor)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/dendor
				cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			if(/datum/patron/divine/necra)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/necra
				cloak = /obj/item/clothing/cloak/stabard/templar/necra
				beltr = /obj/item/weapon/shovel/small
			if(/datum/patron/divine/eora)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/eora
				cloak = /obj/item/clothing/cloak/stabard/templar/eora
			if(/datum/patron/divine/ravox)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/ravox
				cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			if(/datum/patron/divine/noc)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/noc
				cloak = /obj/item/clothing/cloak/stabard/templar/noc
			if(/datum/patron/divine/pestra)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/pestra
				cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			if(/datum/patron/divine/abyssor)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/abyssor
				cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
				beltl = /obj/item/fishingrod
			if(/datum/patron/divine/malum)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/malum
				cloak = /obj/item/clothing/cloak/stabard/templar/malum
			if(/datum/patron/divine/xylix)
				wrists = /obj/item/clothing/neck/psycross/silver/divine/xylix
				cloak = /obj/item/clothing/cloak/stabard/templar/xylix
