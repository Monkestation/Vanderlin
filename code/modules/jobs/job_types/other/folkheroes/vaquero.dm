/datum/attribute_holder/sheet/job/vaquero
	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 20, // Makes sense enough for an animal tamer
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 50,
		/datum/attribute/skill/labor/taming = 40, // How did they not have this skill before?!
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/vaquero
	title = "Vaquero"
	tutorial = "You have been taming beasts of burden all your life, and riding since you were old enough to walk. Perhaps these lands will have use for your skills?"
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/folkhero/vaquero
	cmode_music = 'sound/music/cmode/adventurer/combat_vaquero.ogg'
	category_tags = list(CTAG_FOLKHEROES)
	total_positions = 1

	attribute_sheet = /datum/attribute_holder/sheet/job/vaquero

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/combat/vaquero/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))

/datum/outfit/folkhero/vaquero
	name = "Vaquero (Folkhero)"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/half/colored/red
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/weapon/sword/rapier
	beltr = /obj/item/weapon/whip
	neck = /obj/item/clothing/neck/chaincoif
	mask = /obj/item/alch/herb/rosa
