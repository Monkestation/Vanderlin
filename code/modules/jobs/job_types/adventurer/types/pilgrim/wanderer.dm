/datum/attribute_holder/sheet/job/pilgrim/wanderer
	raw_attribute_list = list(
		STAT_FORTUNE = 1,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/combat/polearms = 30, // have to be at least somewhat competent with one weapon to have traveled alot
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 20,
	)

/datum/job/advclass/pilgrim/wanderer
	title = "Wanderer"
	tutorial = "You are a member of the Merry Band, a humble guild of wanderers who have united under one common desire. Wandering for the sake of experiencing the beauty and diversity of Faience to the fullest extent. As the motto of the Merry Band goes, \"Make every step count and may your journeys be full of wonder\"."
	total_positions = 5
	category_tags = list(CTAG_PILGRIM)
	outfit = /datum/outfit/pilgrim/wanderingpilgrim

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/wanderer

/datum/job/advclass/pilgrim/wanderer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/datum/language/language = pick(list(/datum/language/orcish, /datum/language/celestial, /datum/language/hellspeak, /datum/language/dwarvish, /datum/language/elvish, /datum/language/newpsydonic, /datum/language/zalad))
	spawned.grant_language(language)
	to_chat(spawned, span_notice("I learned the tongue of [initial(language.name)] through my travels."))

/datum/outfit/pilgrim/wanderingpilgrim
	name = "Wandering Pilgrim"
	head = /obj/item/clothing/head/helmet/leather/headscarf
	shoes = /obj/item/clothing/shoes/sandals
	pants = /obj/item/clothing/pants/trou/leather/quiltedkilt/colored/linen
	armor = /obj/item/clothing/shirt/clothvest/colored/random
	shirt = /obj/item/clothing/shirt/undershirt/lowcut
	wrists = /obj/item/clothing/wrists/bracers/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/dagger
	neck = /obj/item/clothing/neck/shellamulet // was previously silver but then i realized, "wait if a vampire lord spawns as a wanderer they immediately get frenzied"
	backr = /obj/item/weapon/polearm/woodstaff/quarterstaff
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1)

