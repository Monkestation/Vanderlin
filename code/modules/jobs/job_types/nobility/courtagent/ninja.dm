/datum/attribute_holder/sheet/job/courtagent/ninja
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/advclass/courtagent/ninja
	title = "Eastern Assassin"
	tutorial = "You are one of the Hand's loyal Agents. \
	Hailing from the far eastern lands you were cast out from your home due to your flexible morality. \
	Now for steady pay, you aid the Hand and the Court in matters that the public had best not know about. \
	Your targets are picked out, and you execute without question, as you always have done."
	outfit = /datum/outfit/courtagent/ninja
	allowed_races = list(SPEC_ID_ELF, SPEC_ID_HUMEN, SPEC_ID_HALF_ELF)
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/ninja

	traits = list(
		TRAIT_BREADY,
		TRAIT_BLINDFIGHTING,
		TRAIT_EXPERT_PARRY
	)
	total_positions = 1
	cmode_music = 'sound/music/cmode/Combat_Weird.ogg'

/datum/outfit/courtagent/ninja
	name = "Eastern Assassin (Court Agent)"
	shirt = /obj/item/clothing/armor/regenerating/skin/easttats
	belt = /obj/item/storage/belt/leather/knifebelt/black/east_steel
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/storage/keyring/courtagent = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
	)

/datum/outfit/courtagent/ninja/pre_equip(mob/living/carbon/human/H)
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/trou/leather/eastpants2
		armor = /obj/item/clothing/shirt/undershirt/eastshirt1
		gloves = /obj/item/clothing/gloves/eastgloves2
		shoes = /obj/item/clothing/shoes/boots/darkboots
	else
		armor = /obj/item/clothing/armor/basiceast/captainrobe
		shoes = /obj/item/clothing/shoes/rumaclan

/datum/outfit/courtagent/ninja/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/obj/item/weapon/sword/katana/mulyeog/blade = new(get_turf(src))
	H.equip_to_appropriate_slot(blade)
	var/obj/item/weapon/scabbard/blackmeadow/scabbard = new(get_turf(src))
	H.equip_to_appropriate_slot(scabbard)
