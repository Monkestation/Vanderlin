/datum/job/advclass/mercenary/desert_pirate
	title = "Desert Rider"
	tutorial = "A pirate of rakshari origin, hailing from the west dune-sea of Zaladin. Well-trained riders and experienced archers, these nomads live the life of marauders and raiders, taking what belongs to weaker settlements and caravans."
	allowed_races = list(SPEC_ID_RAKSHARI)
	outfit = /datum/outfit/mercenary/desert_pirate
	total_positions = 3
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/riding = 3,
		/datum/skill/labor/taming = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/traps = 1
	)

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
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
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
