/datum/attribute_holder/sheet/job/bloodmage
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
		/datum/attribute/skill/magic/blood = 40,
	)
/*
/datum/job/advclass/wretch/bloodmage
	title = "Blood Mage"
	tutorial = "You have been ostracized and hunted by society for your use of forbidden Blood Magic."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/bloodmage
	cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	total_positions = 1
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	form_points = 5
	technique_points = 3
	factions = list(FACTION_NEUTRAL)

	attribute_sheet = /datum/attribute_holder/sheet/job/bloodmage

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_BLOOD_MAGE,
		TRAIT_DEADNOSE
	)

	spells = list(
		/datum/action/cooldown/spell/status/blood_sight,
		/datum/action/cooldown/spell/projectile/blood_steal,
		/datum/action/cooldown/spell/projectile/blood_bolt,
	)

/datum/job/advclass/wretch/bloodmage/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectablehat = list(
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
		"Ominous hood (skullcap)" = /obj/item/clothing/head/helmet/skullcap/cult,
	)
	spawned.select_equippable(player_client, selectablehat, message = "Choose your hat of choice", title = "BLOOD MAGE")

	var/static/list/selectablerobe = list(
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Necromancer robes" = /obj/item/clothing/shirt/robe/necromancer
	)
	spawned.select_equippable(player_client, selectablerobe, message = "Choose your robe of choice", title = "BLOOD MAGE")

	spawned.AddComponent(/datum/component/spell_modifier, list(), list(), list(FORM_BLOOD = 2))
	spawned.adjust_bloodpool()
	spawned.hud_used?.set_bloody_bloodpool()
*/
/datum/outfit/wretch/bloodmage
	name = "Blood Mage (Wretch)"
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/chaincoif
	shirt = /obj/item/clothing/shirt/tunic/colored
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/reagent_containers/glass/bottle/bloodpot
	r_hand = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/spellbook/expert/starter/blood = 1,
		/obj/item/chalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1
	)
