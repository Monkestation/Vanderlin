/datum/job/advclass/pilgrim/wanderer
	title = "Wanderer"
	tutorial = "You are a member of the Merry Band, a humble guild of wanderers who have united under one common desire. Wandering for the sake of experiencing the beauty and diversity of Faience to the fullest extent. As the motto of the Merry Band goes, \"Make every step count and may your journeys be full of wonder\"."
	total_positions = 5
	min_pq = 0
	category_tags = list(CTAG_PILGRIM)
	outfit = /datum/outfit/adventurer/wanderingpilgrim

	jobstats = list(
		STATKEY_LCK = 1 //Wanderers are meant to be a blank slate, so they dont really have anything. But i think some bonus luck would be make sense for them.
	)

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/combat/polearms = 3, // have to be at least somewhat competent with one weapon to have traveled alot
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/reading = 2,
		/datum/skill/craft/cooking = 2,
	)

/datum/job/advclass/pilgrim/wanderer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/datum/language/language = pickweight(list(/datum/language/orcish = 1, /datum/language/celestial = 1, /datum/language/hellspeak = 1, /datum/language/dwarvish = 1, /datum/language/elvish = 1, /datum/language/oldpsydonic = 1, /datum/language/zalad = 1))
	spawned.grant_language(language)
	to_chat(spawned, span_notice("I learned the tongue of [initial(language.name)] through my travels."))

/datum/outfit/adventurer/wanderingpilgrim
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

