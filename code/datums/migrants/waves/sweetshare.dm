/datum/migrant_role/sweetshare
	name = "Candyman"
	greet_text = "Who can take a rainbow, wrap it in a sigh. Soak it in the sun, and make a groovy pie? The Candy Man can. \
	Sell your product to those who should imbibe - the poor, the downtrodden, the youth. Get them hooked; stay off of your \
	own supply. You are Baotha's strongest spice-addict."
	migrant_job = /datum/job/migrant/sweetshare

/datum/attribute_holder/sheet/job/migrant/sweetshare
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/craft/alchemy = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/climbing = 40,
	)

/datum/job/migrant/sweetshare
	title = "Candyman"
	tutorial = "Who can take a rainbow, wrap it in a sigh. Soak it in the sun, and make a groovy pie? The Candy Man can. \
	Sell your product to those who should imbibe - the poor, the downtrodden, the youth. Get them hooked; stay off of your \
	own supply. You are Baotha's strongest spice-addict."
	outfit = /datum/outfit/sweetshare
	allowed_patrons = list(/datum/patron/inhumen/baotha)

	honorary_suffix = "the Candyman"
	honorary_suffix_f = "the Candywoman"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/sweetshare

	traits = list(TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'

/datum/outfit/sweetshare
	name = "Candyman (Migrant Wave)"
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	mask = /obj/item/clothing/face/spectacles/sglasses
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/backpack
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/cleaver
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(
		/obj/item/reagent_containers/powder/spice = 8,
		/obj/item/reagent_containers/powder/ozium = 8,
		/obj/item/reagent_containers/powder/moondust = 8,
	)

/datum/migrant_wave/sweetshare
	name = "The Candy Man"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/sweetshare
	weight = 7
	roles = list(
		/datum/migrant_role/sweetshare = 1,
	)
	greet_text = "A hooded man comes in, the only thing you can see is the stained teeth he flashes in his smile. He smells of unknown reagents."
