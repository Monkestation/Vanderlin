/datum/attribute_holder/sheet/job/inhumencleric
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/attribute_holder/sheet/job/inhumencleric/old
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/advclass/combat/inhumencleric
	title = "Inhumen Cleric"
	tutorial = "Clerics are wandering warriors of the Inhumen Gods, zealots whom demonstrated martial talent.\
	Protected by stolen armor and unholy zeal, they are a force to be reckoned with."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/inhumencleric
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 4
	allowed_patrons = ALL_PROFANE_PATRONS

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/inhumencleric
	attribute_sheet_old = /datum/attribute_holder/sheet/job/inhumencleric/old

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/combat/inhumencleric/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.patron)
		switch(spawned.patron.type)
			if(/datum/patron/inhumen/graggar)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 30)
				ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			if(/datum/patron/inhumen/graggar_zizo)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 20)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/wrestling, 20)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			if(/datum/patron/inhumen/zizo)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 30)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/shields, 10)
				spawned.grant_language(/datum/language/undead)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			if(/datum/patron/inhumen/matthios)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/polearms, 30)
				spawned.adjust_skill_level(/datum/attribute/skill/misc/stealing, 20)
				spawned.adjust_skill_level(/datum/attribute/skill/misc/sneaking, 20)
				spawned.adjust_skill_level(/datum/attribute/skill/misc/lockpicking, 10)
				spawned.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
			if(/datum/patron/inhumen/baotha)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/crossbows, 30)
				spawned.adjust_skill_level(/datum/attribute/skill/combat/knives, 20)
				spawned.adjust_skill_level(/datum/attribute/skill/craft/alchemy, 20)
				spawned.adjust_skill_level(/datum/attribute/skill/craft/crafting, 10)
				spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
			else
				spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(spawned)

/datum/outfit/adventurer/inhumencleric
	name = "Inhumen Cleric (Adventurer)"
	head = /obj/item/clothing/head/helmet/ironpot
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/chaincoif/iron
	belt = /obj/item/storage/belt/leather
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
	cloak = /obj/item/clothing/cloak/tabard/crusader
	wrists = /obj/item/clothing/neck/psycross/silver

/datum/outfit/adventurer/inhumencleric/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.patron)
		switch(equipped_human.patron.type)
			if(/datum/patron/inhumen/graggar)
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
				head = /obj/item/clothing/head/helmet/horned
				beltl = /obj/item/weapon/axe/boneaxe
				beltr = /obj/item/weapon/axe/boneaxe
			if(/datum/patron/inhumen/graggar_zizo)
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			if(/datum/patron/inhumen/zizo)
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
				head = /obj/item/clothing/head/helmet/skullcap/cult
				backr = /obj/item/weapon/shield/heater
				beltl = /obj/item/weapon/sword/short/iron
			if(/datum/patron/inhumen/matthios)
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
				backr = /obj/item/weapon/pitchfork
			if(/datum/patron/inhumen/baotha)
				head = /obj/item/clothing/head/crown/circlet
				mask = /obj/item/clothing/face/spectacles/sglasses
				cloak = /obj/item/clothing/cloak/raincloak/colored/purple
				backpack_contents = list(/obj/item/reagent_containers/glass/bottle/poison = 1, /obj/item/reagent_containers/glass/bottle/stampoison = 1)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/ammo_holder/quiver/bolts
				beltr = /obj/item/weapon/knife/dagger/steel
