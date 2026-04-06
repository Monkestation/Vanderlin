/datum/attribute_holder/sheet/job/necromancer
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_CONSTITUTION = -1,
		STAT_INTELLIGENCE = 4,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/magic/arcane = 40,
	)

/datum/job/advclass/wretch/necromancer
	title = "Necromancer"
	tutorial = "You have been ostracized and hunted by society for your dark magics and perversion of life."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/necromancer
	cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	total_positions = 1
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	spell_points = 7
	languages = list(/datum/language/undead)
	faction = FACTION_CABAL

	attribute_sheet = /datum/attribute_holder/sheet/job/necromancer

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_CABAL,
		TRAIT_GRAVEROBBER,
		TRAIT_DEADNOSE
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/eyebite,
		/datum/action/cooldown/spell/projectile/sickness,
		/datum/action/cooldown/spell/conjure/raise_lesser_undead/necromancer,
		/datum/action/cooldown/spell/gravemark,
		/datum/action/cooldown/spell/control_undead
	)

/datum/job/advclass/wretch/necromancer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(1))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	spawned.mana_pool?.intrinsic_recharge_sources &= ~MANA_ALL_LEYLINES
	spawned.mana_pool?.set_intrinsic_recharge(MANA_SOULS)
	spawned.mana_pool?.ethereal_recharge_rate += 0.1

/datum/outfit/wretch/necromancer
	name = "Necromancer (Wretch)"
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

/datum/outfit/wretch/necromancer/post_equip(mob/living/carbon/human/H, visuals_only)
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
	H.select_equippable(H, selectablehat, message = "Choose your hat of choice", title = "NECROMANCER")
	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Necromancer robes" = /obj/item/clothing/shirt/robe/necromancer
	)
	H.select_equippable(H, selectablerobe, message = "Choose your robe of choice", title = "NECROMANCER")
