/datum/job/advclass/combat/swashbuckler
	title = "Swashbuckler"
	tutorial = "Woe the Sea King! You awake, dazed from a true festivity of revelry and feasting. The last thing you remember? Your mateys dumping you over the side of the boat as a joke. Now on some Gods-forsaken rock, Abyssor will present you with booty and fun, no doubt."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_AASIMAR,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_RAKSHARI,\
		SPEC_ID_TRITON,\
	)
	allowed_patrons = list(/datum/patron/divine/abyssor)
	outfit = /datum/outfit/folkhero/swashbuckler
	total_positions = 1
	category_tags = list(CTAG_FOLKHEROES)

	skills = list(
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/labor/fishing = 3,
		/datum/skill/misc/swimming = 4,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/stealing = 3,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/traps = 2,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_END = 3,
		STATKEY_SPD = 2,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/outfit/folkhero/swashbuckler
	name = "Swashbuckler (Folkhero)"
	head = /obj/item/clothing/head/helmet/leather/headscarf
	pants = /obj/item/clothing/pants/tights/sailor
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/jacket/sea
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/natural/worms/leech = 2,
		/obj/item/storage/belt/pouch/coins/mid = 1
	)
	backr = /obj/item/fishingrod/fisher
	beltl = /obj/item/weapon/sword/sabre/cutlass
	beltr = /obj/item/weapon/knife/dagger
	shoes = /obj/item/clothing/shoes/boots
	neck = /obj/item/clothing/neck/psycross/silver/abyssor

/datum/outfit/folkhero/swashbuckler/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/sailor, /obj/item/clothing/shirt/undershirt/sailor/red)
