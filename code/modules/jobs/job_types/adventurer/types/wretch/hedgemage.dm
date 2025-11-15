/datum/job/advclass/wretch/hedgemage
	title = "Hedge Mage"
	tutorial = "They reject your genius, they cast you out, they call you unethical. They do not understand the SACRIFICES you must make. But it does not matter anymore, your power eclipse any of those fools, save for the Court Magos themselves. Show them true magic."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/hedgemage

	cmode_music = 'sound/music/cmode/antag/CombatRogueMage.ogg'
	total_positions = 2

	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)

/datum/outfit/wretch/hedgemage/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(1))
		H.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/rope
	neck = /obj/item/clothing/neck/mana_star //Stolen from the academy, dude trust
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/magebag/apprentice
	beltl = /obj/item/reagent_containers/glass/bottle/manapot
	backpack_contents = list(
		/obj/item/book/granter/spellbook/adept = 1,
		/obj/item/chalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1
		)
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
	if(H.age == AGE_OLD)
		head = /obj/item/clothing/head/wizhat
		backl = /obj/item/storage/backpack/backpack
		H.change_stat(STATKEY_INT, 1)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.change_stat(STATKEY_INT, 4)
	H.change_stat(STATKEY_END, 1)
	H.adjust_spell_points(12)
	H.add_spell(/datum/action/cooldown/spell/undirected/touch/prestidigitation)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INHUMENCAMP, TRAIT_GENERIC)

/datum/outfit/wretch/hedgemage/post_equip(mob/living/carbon/human/H)
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
	wretch_select_bounty(H)
