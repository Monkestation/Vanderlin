/datum/job/advclass/wretch/necromancer
	title = "Necromancer"
	tutorial = "You have been ostracized and hunted by society for your dark magics and perversion of life."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/necromancer
	cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	total_positions = 1
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)

/datum/outfit/wretch/necromancer/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(1))
		H.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'
	H.set_patron(/datum/patron/inhumen/zizo) //Zizo only, obviously.
	H.mind.current.faction += FACTION_CABAL
	H.mana_pool?.intrinsic_recharge_sources &= ~MANA_ALL_LEYLINES
	H.mana_pool?.set_intrinsic_recharge(MANA_SOULS)
	H.mana_pool?.ethereal_recharge_rate += 0.1
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/chaincoif
	shirt = /obj/item/clothing/shirt/tunic/colored
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/reagent_containers/glass/bottle/manapot
	r_hand = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/book/granter/spellbook/adept = 1,
		/obj/item/chalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1
	)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_INT, 4)
	H.adjust_spell_points(7)
	H.grant_language(/datum/language/undead)
	H.add_spell(/datum/action/cooldown/spell/undirected/touch/prestidigitation)
	H.add_spell(/datum/action/cooldown/spell/eyebite)
	H.add_spell(/datum/action/cooldown/spell/projectile/sickness)
	H.add_spell(/datum/action/cooldown/spell/conjure/raise_lesser_undead/necromancer)
	H.add_spell(/datum/action/cooldown/spell/gravemark)
	H.add_spell(/datum/action/cooldown/spell/control_undead)
	ADD_TRAIT(H, TRAIT_CABAL, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INHUMENCAMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	wretch_select_bounty(H)

/datum/outfit/wretch/necromancer/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
		"Ominous hood (skullcap)" = /obj/item/clothing/head/helmet/skullcap/cult,
	)
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "WIZARD")
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Necromancer robes" = /obj/item/clothing/shirt/robe/necromancer
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "WIZARD")
