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

	jobstats = list(
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_STR = 2
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/bows = 2,
		/datum/skill/craft/tanning = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR
	)

/datum/job/advclass/mercenary/verderer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

	spawned.adjust_skillrank(/datum/skill/combat/shields, pick(0,0,1))

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
