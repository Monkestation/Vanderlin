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
		/datum/attribute/skill/magic/arcane = 20, // Needed for book crafting and basic survivability.
		/datum/attribute/skill/misc/medicine = 30,
	)

/datum/job/advclass/wretch/bloodmage
	title = "Blood Mage"
	tutorial = "You have been ostracized and hunted by society for your use of forbidden Blood Magic."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/bloodmage
	cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	total_positions = 1
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	technique_points = 4 // This is mirrored by their form points manually, due to minimal technique-less spells. Do not increase either beyond 4.
	factions = list(FACTION_NEUTRAL, FACTION_BLOOD_MAGIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/bloodmage

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_BLOOD_MAGE,
		TRAIT_VITAE_USER,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
	)

	languages = list(
		/datum/language/sanguine
	)

	spells = list(
		/datum/action/cooldown/spell/status/blood_sight,
		/datum/action/cooldown/spell/projectile/blood_steal,
		/datum/action/cooldown/spell/projectile/blood_bolt,
	)
	book_type = /obj/item/recipe_book/arcyne

/datum/job/advclass/wretch/bloodmage/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectablehat = list(
		"Blood Red hood" = /obj/item/clothing/head/roguehood/colored/blood,
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
		"Magus hood (skullcap)" = /obj/item/clothing/head/helmet/skullcap/magus,
	)
	spawned.select_equippable(player_client, selectablehat, message = "Choose your hat of choice", title = "BLOOD MAGE")

	var/static/list/selectablerobe = list(
		"Blood Red robes" = /obj/item/clothing/shirt/robe/colored/blood,
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Magus robes" = /obj/item/clothing/shirt/robe/magus
	)
	spawned.select_equippable(player_client, selectablerobe, message = "Choose your robe of choice", title = "BLOOD MAGE")

	var/static/list/selectable_books = list(
		"Blazing Tome (Fire)" = /obj/item/spellbook/adept/starter/fire,
		"Frostbound Tome (Ice)" = /obj/item/spellbook/adept/starter/ice,
		"Storm-Charged Tome (Lightning)" = /obj/item/spellbook/adept/starter/lightning,
		"Stoneveined Tome (Earth)" = /obj/item/spellbook/adept/starter/earth,
		"Thrice-Warded Tome (Arcane)" = /obj/item/spellbook/adept/starter/arcane,
		"Grave-Touched Tome (Death)" = /obj/item/spellbook/adept/starter/death,
		"Verdant Tome (Life)" = /obj/item/spellbook/adept/starter/life,
		"Windswept Tome (Air)" = /obj/item/spellbook/adept/starter/air,
		"Tidebound Tome (Water)" = /obj/item/spellbook/adept/starter/water,
	)

	grant_selected_spellbooks(spawned, selectable_books, 1)

	spawned.hud_used?.set_bloody_bloodpool()
	spawned.adjust_bloodpool()
	spawned.adjust_form_mastery_points(technique_points, specific_form = FORM_BLOOD)

/datum/outfit/wretch/bloodmage
	name = "Blood Mage (Wretch)"
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/chaincoif
	shirt = /obj/item/clothing/shirt/tunic/colored
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/chain
	ring = /obj/item/clothing/ring/silver/rontz
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/reagent_containers/glass/bottle/bloodpot
	beltl = /obj/item/spellbook/expert/starter/blood
	r_hand = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger/silver/arcyne = 1,
		/obj/item/weapon/knife/dagger/bloodsteel = 1
	)
