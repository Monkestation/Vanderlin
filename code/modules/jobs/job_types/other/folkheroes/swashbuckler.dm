/datum/attribute_holder/sheet/job/swashbuckler
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 3,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/traps = 20,
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/swashbuckler

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
	neck = /obj/item/clothing/neck/psycross/silver/divine/abyssor

/datum/outfit/folkhero/swashbuckler/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/sailor, /obj/item/clothing/shirt/undershirt/sailor/red)
