/datum/attribute_holder/sheet/job/chirurgeon
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_SPEED = 1,
		STAT_STRENGTH = -2,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/alchemy = 10,
	)

/datum/job/advclass/combat/chirurgeon
	title = "Chirurgeon"
	tutorial = "You've no acclaim to the tenures you say you have, and the history you recount is shoddy at best, and false at \
	worst. In a trade that is rife with charlatans, you are arguably a hand-picked example amongst them; but amongst the lies \
	there is one truth - your hands are indeed as steady as you claim them to be. Ensure you find an employer that won't stab \
	you in the back, and wait for an opportune moment to stab them in theirs. Make a fine practice far away from the eyes of \
	your competition, lest you find yourself dead and floating downstream."
	outfit = /datum/outfit/chirurgeon
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	attribute_sheet = /datum/attribute_holder/sheet/job/chirurgeon

	traits = list(
		TRAIT_EMPATH,
		TRAIT_DEADNOSE,
	)

/datum/outfit/chirurgeon
	name = "Chirurgeon (Migrant Wave)"
	mask = /obj/item/clothing/face/shepherd/clothmask
	head = /obj/item/clothing/head/brimmed
	cloak = /obj/item/clothing/cloak/apron/cook
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl = /obj/item/storage/backpack/satchel/surgbag/shit
	backr = /obj/item/storage/backpack/satchel/cloth
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/clothing/neck/phys
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/cleaver
	beltl = /obj/item/storage/belt/pouch/coins/poor
