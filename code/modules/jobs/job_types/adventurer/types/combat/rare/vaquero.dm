/datum/attribute_holder/sheet/job/vaquero
	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(30, 40)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/whipsflails = 40, // Makes sense enough for an animal tamer
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 10, //cowboys cant swim
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 50,
		/datum/attribute/skill/labor/taming = 40, // How did they not have this skill before?!
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/vaquero
	title = "Vaquero"
	tutorial = "You have been taming beasts of burden all your life, and riding since you were old enough to walk. Perhaps these lands will have use for your skills?"
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/vaquero
	cmode_music = 'sound/music/cmode/adventurer/combat_vaquero.ogg'
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 1
	roll_chance = 7

	attribute_sheet = /datum/attribute_holder/sheet/job/vaquero

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BARDIC_TRAINING,
	)

/datum/job/advclass/combat/vaquero/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.inspiration = new /datum/inspiration(spawned)
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))

/datum/outfit/vaquero
	name = "Vaquero"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/trou/leathertights
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/knife/cleaver/combat)
	backr = /obj/item/instrument/guitar
	beltl = /obj/item/weapon/whip/urumi
	beltr = /obj/item/rope
	neck = /obj/item/clothing/neck/chaincoif
	mask = /obj/item/alch/herb/rosa

/datum/outfit/vaquero/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(visuals_only)
		return

	var/list/colors = GLOB.peasant_dyes|GLOB.noble_dyes

	var/color_selection = tgui_input_list(H, "What color was my poncho?	", "The Poncho", colors, "Winestain Red")
	var/obj/item/clothing/cloak/poncho/ponck = new()
	ponck.color = colors[color_selection]
	H.equip_to_slot(ponck, ITEM_SLOT_CLOAK, TRUE)
