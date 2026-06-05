/datum/attribute_holder/sheet/job/desert_pirate
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 10
	)

/datum/job/advclass/mercenary/desert_pirate
	title = "Desert Rider"
	tutorial = "A pirate of rakshari origin, hailing from the west dune-sea of Zaladin. Well-trained riders and experienced archers, these nomads live the life of marauders and raiders, taking what belongs to weaker settlements and caravans."
	allowed_races = list(SPEC_ID_RAKSHARI)
	outfit = /datum/outfit/mercenary/desert_pirate
	total_positions = 3
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/desert_pirate

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/mercenary/desert_pirate/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 1 //Desert Rider chain, 0 for Desert Rider Medal

/datum/outfit/mercenary/desert_pirate
	name = "Desert Rider (Mercenary)"
	pants = /obj/item/clothing/pants/trou/leather
	beltr = /obj/item/weapon/sword/sabre
	backl = /obj/item/gun/ballistic/bow/short
	beltl = /obj/item/ammo_holder/quiver/arrows
	shoes = /obj/item/clothing/shoes/ridingboots
	gloves = /obj/item/clothing/gloves/angle
	wrists = /obj/item/rope/chain //Seems fitting for slavers
	belt = /obj/item/storage/belt/leather/mercenary/shalal
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	armor = /obj/item/clothing/armor/leather/splint
	backr = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/neck/keffiyeh/colored/uncolored
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger = 1
	)
