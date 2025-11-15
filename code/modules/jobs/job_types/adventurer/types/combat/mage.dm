/datum/job/advclass/combat/mage
	title = "Mage"
	tutorial = "A wandering graduate of the many colleges of magick across Psydonia, you search for a job to put your degree to use. And they say school was hard..."

	outfit = /datum/outfit/adventurer/mage
	category_tags = list(CTAG_ADVENTURER)
	min_pq = 0
	total_positions = 4
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)

/datum/outfit/adventurer/mage/pre_equip(mob/living/carbon/human/H)
	..()
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/magebag/poor
	beltl = /obj/item/reagent_containers/glass/bottle/manapot
	backpack_contents = list(/obj/item/book/granter/spellbook/apprentice = 1, /obj/item/chalk = 1)
	r_hand = /obj/item/weapon/polearm/woodstaff
	if(H.patron.type == /datum/patron/inhumen/zizo)
		H.grant_language(/datum/language/undead)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	if(H.age == AGE_OLD)
		backl = /obj/item/storage/backpack/backpack
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_END, -1)
	H.change_stat(STATKEY_SPD, -2)
	H.adjust_spell_points(5)
	H.add_spell(/datum/action/cooldown/spell/undirected/touch/prestidigitation)

/datum/outfit/adventurer/mage/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "WIZARD")
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
