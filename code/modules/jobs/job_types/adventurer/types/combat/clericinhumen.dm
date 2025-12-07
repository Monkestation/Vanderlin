//shield
/datum/job/advclass/combat/inhumencleric
	title = "Inhumen Cleric"
	tutorial = "Clerics are wandering warriors of the Inhumen Gods, zealots whom demonstrated martial talent.\
	Protected by stolen armor and unholy zeal, they are a force to be reckoned with."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/inhumencleric
	category_tags = list(CTAG_ADVENTURER)
	min_pq = 0
	total_positions = 4
	allowed_patrons = ALL_PROFANE_PATRONS

	exp_types_granted  = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

/datum/outfit/adventurer/inhumencleric/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/ironpot
	armor = /obj/item/clothing/armor/cuirass/iron // Adventurers are not supposed to have fricking steel, at all
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/chaincoif/iron // Everyone gets iron coif, instead of variable neck armor
	belt = /obj/item/storage/belt/leather
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/graggar)
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			head = /obj/item/clothing/head/helmet/horned	//barbarian adventurer reference
			beltl = /obj/item/weapon/axe/boneaxe
			beltr = /obj/item/weapon/axe/boneaxe
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/graggar_zizo)	//I assume this can only happen if a maniac rolls cleric
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			H.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			head = /obj/item/clothing/head/helmet/skullcap/cult
			H.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			backr = /obj/item/weapon/shield/heater
			beltl = /obj/item/weapon/sword/short/iron
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
			H.grant_language(/datum/language/undead)
		if(/datum/patron/inhumen/matthios)
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			H.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
			backr = /obj/item/weapon/pitchfork //weapon of the peasantry
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		if(/datum/patron/inhumen/baotha)
			head = /obj/item/clothing/head/crown/circlet
			mask = /obj/item/clothing/face/spectacles/sglasses
			cloak = /obj/item/clothing/cloak/raincloak/colored/purple
			backpack_contents = list(/obj/item/reagent_containers/glass/bottle/poison = 1, /obj/item/reagent_containers/glass/bottle/stampoison = 1) //Poison
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltl = /obj/item/ammo_holder/quiver/bolts
			beltr = /obj/item/weapon/knife/dagger/steel //meant as a backup weapon
			H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
		else // Failsafe
			cloak = /obj/item/clothing/cloak/tabard/crusader // Give us a generic crusade tabard
			wrists = /obj/item/clothing/neck/psycross/silver // Give us a silver psycross for protection against lickers
			H.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, -1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC) // Even if it has limited slots, it is a common drifter role available to anyone. Their armor also is not heavy, so medium armor training is enough
	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(H)
