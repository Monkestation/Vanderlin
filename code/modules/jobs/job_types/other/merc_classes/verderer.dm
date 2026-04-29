/datum/attribute_holder/sheet/job/verderer
	attribute_variance = list(
		/datum/attribute/skill/combat/shields = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/job/advclass/mercenary/verderer
	title = "Hollow Verderer"
	tutorial = "A halberd expert that has for one reason or another, forsaken Amber Hollow in favor of pursuing coin and glory in wider parts of Psydonia."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(\
		SPEC_ID_HOLLOWKIN,\
		SPEC_ID_HUMEN,\
	)
	outfit = /datum/outfit/mercenary/verderer
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/verderer

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR
	)

/datum/job/advclass/mercenary/verderer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/verderer
	name = "Hollow Verderer (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/armor/light/rust
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	head = /obj/item/clothing/head/helmet/leather/advanced
	gloves = /obj/item/clothing/gloves/plate/rust
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/cuirass/iron/rust
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin
	beltl = /obj/item/flashlight/flare/torch/lantern/copper
	backr = /obj/item/weapon/polearm/halberd/bardiche
	backl = /obj/item/storage/backpack/satchel
	shirt = /obj/item/clothing/shirt/tribalrag
	pants = /obj/item/clothing/pants/platelegs/rust
	neck = /obj/item/clothing/neck/chaincoif
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/needle = 1
	)
