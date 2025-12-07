/datum/migrant_role/sweetshare
	name = "Candyman"
	greet_text = "Who can take a rainbow, wrap it in a sigh. Soak it in the sun, and make a groovy pie? The Candy Man can. \
	Sell your product to those who should imbibe - the poor, the downtrodden, the youth. Get them hooked; stay off of your \
	own supply. You are Baotha's strongest spice-addict."
	migrant_job = /datum/job/migrant/sweetshare

/datum/job/migrant/sweetshare
	title = "Candyman"
	tutorial = "Who can take a rainbow, wrap it in a sigh. Soak it in the sun, and make a groovy pie? The Candy Man can. \
	Sell your product to those who should imbibe - the poor, the downtrodden, the youth. Get them hooked; stay off of your \
	own supply. You are Baotha's strongest spice-addict."
	outfit = /datum/outfit/sweetshare
	allowed_patrons = list(/datum/patron/inhumen/baotha)

	jobstats = list(
		STATKEY_SPD = 2,
		STATKEY_END = 2,
		STATKEY_STR = -2,
		STATKEY_CON = -1,
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/climbing = 4,
	)

	traits = list(TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'

/datum/job/migrant/sweetshare/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Candyman"
	if(spawned.pronouns == SHE_HER)
		honorary = "Candywoman"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

/datum/outfit/sweetshare
	name = "Candyman"
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
