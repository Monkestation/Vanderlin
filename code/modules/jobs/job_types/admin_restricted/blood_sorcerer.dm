/datum/attribute_holder/sheet/job/blood_sorcerer
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 5,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/magic/blood = 60,
		/datum/attribute/skill/misc/medicine = 40,
	)

/datum/job/admin/blood_sorcerer
	title = JOB_ADMIN_BLOOD_SORCERER
	tutorial = "You have been ostracized and hunted by society for your use of forbidden Blood Magic."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = list(/datum/patron/godless/dystheist, /datum/patron/godless/autotheist, /datum/patron/godless/godless, /datum/patron/godless/defiant, /datum/patron/godless/galadros)
	outfit = /datum/outfit/admin/blood_sorcerer
	cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	technique_points = 14
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	factions = list(FACTION_NEUTRAL, FACTION_BLOOD_MAGIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/bloodmage

	magic_user = TRUE
	knows_the_town = TRUE
	known_by_the_town = FALSE

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_BREADY,
		TRAIT_BLINDFIGHTING,
		TRAIT_DUALWIELDER,
		TRAIT_BLOOD_SORCERER,
		TRAIT_BLOOD_SENSE,
		TRAIT_VITAE_USER,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
		TRAIT_NOHYGIENE,
	)

	languages = list(
		/datum/language/sanguine,
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/zalad,
		/datum/language/hellspeak,
		/datum/language/newpsydonic,
		/datum/language/orcish,
		/datum/language/thievescant,
	)

	spells = list(
		/datum/action/cooldown/spell/status/blood_sight,
		/datum/action/cooldown/spell/projectile/blood_steal,
		/datum/action/cooldown/spell/projectile/blood_bolt,
	)
	book_type = /obj/item/recipe_book/arcyne

/datum/job/admin/blood_sorcerer/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectablehat = list(
		"Blood Red hood (Discreet)" = /obj/item/clothing/head/roguehood/colored/blood,
		"Enhanced Blood Red hood (Obvious)" = /obj/item/clothing/head/roguehood/colored/blood/enhanced,
		"Black hood" = /obj/item/clothing/head/roguehood/colored/black,
		"Mage hood" = /obj/item/clothing/head/roguehood/colored/mage,
		"Magus hood (skullcap)" = /obj/item/clothing/head/helmet/skullcap/magus,
	)
	spawned.select_equippable(player_client, selectablehat, message = "Choose your hat of choice", title = "BLOOD SORCERER")

	var/static/list/selectablerobe = list(
		"Blood Red robes (Discreet)" = /obj/item/clothing/shirt/robe/colored/blood,
		"Enhanced Blood Red robes (Obvious)" = /obj/item/clothing/shirt/robe/colored/blood/enhanced,
		"Black robes" = /obj/item/clothing/shirt/robe/colored/black,
		"Mage robes" = /obj/item/clothing/shirt/robe/colored/mage,
		"Magus robes" = /obj/item/clothing/shirt/robe/magus
	)
	spawned.select_equippable(player_client, selectablerobe, message = "Choose your robe of choice", title = "BLOOD SORCERER")

	spawned.hud_used?.set_bloody_bloodpool()
	spawned.adjust_form_mastery_points(20, specific_form = FORM_BLOOD)
	spawned.maxbloodpool += 1000
	spawned.set_bloodpool(2500)

/datum/outfit/admin/blood_sorcerer
	name = "Blood Sorcerer"
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/hunter
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/half/colored/blood
	shirt = /obj/item/clothing/shirt/tunic/colored
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	gloves = /obj/item/clothing/gloves/leather/advanced
	ring = /obj/item/clothing/ring/gold/rontz
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel/black
	beltr = /obj/item/reagent_containers/glass/bottle/strongbloodpot
	backr = /obj/item/weapon/polearm/woodstaff/quarterstaff/bloodsteel
	r_hand = /obj/item/weapon/knife/dagger/bloodsteel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
		/obj/item/reagent_containers/glass/bottle/strongbloodpot = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
	)
