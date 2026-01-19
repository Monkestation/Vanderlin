/datum/job/advclass/mercenary/sworddancer
	title = "Sword Dancer"
	tutorial = "You were a former bard, but when times got tough you picked up a blade to defend yourself. \
	Now you travel the lands of Psydonia, selling your sword and your songs to the highest bidder."
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/mercenary/sworddancer
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg' // Not a noble, but it fits really well


	spells = list(
		/datum/action/cooldown/spell/vicious_mockery,
		// /datum/action/cooldown/spell/bardic_inspiration
	)


	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_END = -1
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/music = 4,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 4
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BARDIC_TRAINING
	)

/datum/job/advclass/mercenary/sworddancer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

	spawned.select_equippable(player_client, list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola
		),
		message = "Choose your instrument.",
		title = "XYLIX"
	)

	spawned.inspiration = new /datum/inspiration(spawned)

/datum/outfit/mercenary/sworddancer
	name = "Sword Dancer (Mercenary)"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/leather/jacket
	cloak = /obj/item/clothing/cloak/cape
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/weapon/sword/rapier
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)


/datum/outfit/mercenary/sworddancer/post_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/obj/item/clothing/cloak/cape/C = equipped_human.get_item_by_slot(ITEM_SLOT_CLOAK)
	if(C)
		C.color = CLOTHING_MUSTARD_YELLOW
