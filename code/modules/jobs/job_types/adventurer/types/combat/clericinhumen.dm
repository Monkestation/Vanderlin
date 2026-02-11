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

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/shields = 2,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 2,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)

/datum/job/advclass/combat/inhumencleric/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)

	if(spawned.patron)
		switch(spawned.patron.type)
			if(/datum/patron/inhumen/graggar)
				spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
				ADD_TRAIT(spawned, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			if(/datum/patron/inhumen/graggar_zizo)
				spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			if(/datum/patron/inhumen/zizo)
				spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				spawned.grant_language(/datum/language/undead)
				spawned.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			if(/datum/patron/inhumen/matthios)
				spawned.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
				spawned.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
				spawned.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
				spawned.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
			if(/datum/patron/inhumen/baotha)
				spawned.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
				spawned.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
				spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
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
