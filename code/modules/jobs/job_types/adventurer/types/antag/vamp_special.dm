/datum/job/advclass/vampspecial
	category_tags = list(CTAG_VAMP_ADVENTURE)

// A caveat job to catch Vampire Spawn that are somehow children. Otherwise they're kicked back to the lobby and there's one less vampire in the round.
/datum/attribute_holder/sheet/job/young_vampire
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 5,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10
	)

/datum/job/advclass/vampspecial/rascal
	title= "Immortal Rascal"
	tutorial = "You were cursed when you were very young, growth stunted by immortality your physical age is a poor reflection of the centuries. Perhaps with your lord's ascension, you will finally age."
	outfit = /datum/outfit/vampspecial/vamp_rascal
	attribute_sheet = /datum/attribute_holder/sheet/job/young_vampire
	allowed_ages = list(AGE_CHILD)

/datum/outfit/vampspecial/vamp_rascal
	name = "Immortal Rascal (Vampire Spawn)"
	armor = /obj/item/clothing/shirt/rags
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/tights/colored/random
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/mace/woodclub

/datum/outfit/vampspecial/vamp_rascal/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	head = pick(
		/obj/item/clothing/head/helmet/kettle/iron,
		/obj/item/clothing/head/helmet/ironpot,
		/obj/item/clothing/head/helmet/winged,
		/obj/item/clothing/head/helmet/horned,
	)

//#####################################################################

/datum/attribute_holder/sheet/job/vampmage
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = -1,
		STAT_SPEED = -2,
		/datum/attribute/skill/educated/reading = 40,
		/datum/attribute/skill/magic/arcane = 30,
		/datum/attribute/skill/combat/polearms/staves = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/alchemy = 20,
	)

/datum/attribute_holder/sheet/job/vampmage/old
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_INTELLIGENCE = 4,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = -1,
		STAT_SPEED = -2,
		/datum/attribute/skill/educated/reading = 40,
		/datum/attribute/skill/magic/arcane = 40,
		/datum/attribute/skill/magic/blood = 10, //Already adjusted by being vampire spawn.
		/datum/attribute/skill/combat/polearms/staves = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/alchemy = 20,
	)

/datum/job/advclass/vampspecial/mage
	title = "Immortal Mage"
	tutorial = "You were sired by your lord shortly after graduating from arcyne studies and now put centuries of magical experience to use in furthering their goals."
	outfit = /datum/outfit/vampspecial/vampmage
	category_tags = list(CTAG_VAMP_ADVENTURE)
	total_positions = 4
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo, /datum/patron/archdevil/mephistopheles, /datum/patron/archdevil/abraxas, /datum/patron/archdevil/abaddon, /datum/patron/archdevil/leviathan)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	form_points = 4
	technique_points = 4
	factions = list(FACTION_NEUTRAL, FACTION_BLOOD_MAGIC)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/vampmage
	attribute_sheet_old = /datum/attribute_holder/sheet/job/vampmage/old
	book_type = /obj/item/recipe_book/arcyne


/datum/job/advclass/vampspecial/mage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.patron, /datum/patron/inhumen/zizo))
		spawned.grant_language(/datum/language/undead)

/datum/job/advclass/vampspecial/mage/on_roundstart(mob/living/spawned, client/player_client)
	. = ..()

	var/static/list/selectablehat = list(
		"Blood Red hood" = /obj/item/clothing/head/roguehood/colored/blood,
		"Witch hat" = /obj/item/clothing/head/wizhat/witch,
		"Random Wizard hat" = /obj/item/clothing/head/wizhat/random,
		"Generic Wizard hat" = /obj/item/clothing/head/wizhat/gen,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
	)
	spawned.select_equippable(player_client, selectablehat, message = "Choose your hat of choice", title = "BLOOD MAGE")

	var/static/list/selectablerobe = list(
		"Blood Red robes" = /obj/item/clothing/shirt/robe/colored/blood,
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
	)
	spawned.select_equippable(player_client, selectablerobe, message = "Choose your robe of choice", title = "BLOOD MAGE")

	var/static/list/selectable_books = list(
		"Blood-Soaked Tome (Blood)" = /obj/item/spellbook/expert/starter/blood,
		"Blazing Tome (Fire)" = /obj/item/spellbook/expert/starter/fire,
		"Frostbound Tome (Ice)" = /obj/item/spellbook/expert/starter/ice,
		"Storm-Charged Tome (Lightning)" = /obj/item/spellbook/expert/starter/lightning,
		"Stoneveined Tome (Earth)" = /obj/item/spellbook/expert/starter/earth,
		"Thrice-Warded Tome (Arcane)" = /obj/item/spellbook/expert/starter/arcane,
		"Grave-Touched Tome (Death)" = /obj/item/spellbook/expert/starter/death,
		"Verdant Tome (Life)" = /obj/item/spellbook/expert/starter/life,
		"Windswept Tome (Air)" = /obj/item/spellbook/expert/starter/air,
		"Tidebound Tome (Water)" = /obj/item/spellbook/expert/starter/water,
	)

	grant_selected_spellbooks(spawned, selectable_books, 2)

/datum/outfit/vampspecial/vampmage
	name = "Immortal Mage (Vampire Spawn)"
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather/black
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/magebag/apprentice
	beltl = /obj/item/reagent_containers/glass/bottle/manapot/labelled
	r_hand = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/chalk = 1,
	)

/datum/outfit/vampspecial/mage/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.age == AGE_OLD)
		backl = /obj/item/storage/backpack/backpack
