/datum/attribute_holder/sheet/job/courtagent/mystic
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/magic/arcane = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 30
	)

/datum/job/advclass/courtagent/mystic
	title = "Mystic Spy"
	tutorial = "You are one of the Hand's loyal Agents. \
	Before becoming an Agent, you were a Mage of the Mages Guild. However due to some complications with your colleagues, you were cast aside. \
	Now you work for the Hand, using your knowledge of Magic and the Arcane to more effectively spy on people. \
	You have been supplied with gadgets to aid in your work, along with the spells you already knew from your time with the Guild."
	outfit = /datum/outfit/courtagent/mystic
	category_tags = list(CTAG_COURTAGENT)
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/mystic
	traits = list(
		TRAIT_SORCERER
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/message,
		/datum/action/cooldown/spell/aoe/knock,
		/datum/action/cooldown/spell/undirected/feather_falling,
		/datum/action/cooldown/spell/undirected/longstrider,
		/datum/action/cooldown/spell/conjure/phantom_ear,
	)

/datum/job/advclass/courtagent/mystic/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_form_mastery_points(10)
	spawned.adjust_technique_mastery_points(5)

/datum/outfit/courtagent/mystic
	name = "Mystic Spy (Court Agent)"
	head = /obj/item/clothing/head/roguehood/colored/black
	gloves = /obj/item/clothing/gloves/fingerless
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/shirt/robe/colored/black
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel/black
	backl = /obj/item/weapon/polearm/woodstaff
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/manapot/labelled = 1,
		/obj/item/chalk = 1,
		/obj/item/speaker/agent = 1,
		/obj/item/listeningdevice/agent = 2
	)
