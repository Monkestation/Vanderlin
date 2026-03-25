/datum/attribute_holder/sheet/job/sentinel
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/riding = 50,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/rare/sentinel
	title = "Sentinel"
	tutorial = "Your overseers have sent you to this distant land as a scout. Your trusted steed, longbow, and spear will allow you to overcome any challenges on the road ahead."
	allowed_races = RACES_PLAYER_ELF_ALL
	outfit = /datum/outfit/adventurer/sentinel
	total_positions = 1
	roll_chance = 30
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/sentinel

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/combat/sentinel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))
	if(prob(33))
		if(!spawned.has_language(/datum/language/elvish))
			spawned.grant_language(/datum/language/elvish)
			to_chat(spawned, "<span class='info'>I can speak Elfish with ,e before my speech.</span>")

/datum/outfit/adventurer/sentinel
	name = "Sentinel (Adventurer)"
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
	beltl = /obj/item/ammo_holder/quiver/arrows
	shoes = /obj/item/clothing/shoes/ridingboots
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	armor = /obj/item/clothing/armor/chainmail/hauberk
	backl = /obj/item/weapon/polearm/spear
	head = /obj/item/clothing/head/helmet/leather
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/trou/leather

/datum/outfit/adventurer/sentinel/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(!visuals_only && H.gender == FEMALE)
		if(prob(50))
			pants = /obj/item/clothing/pants/tights/colored/black
		else
			pants = /obj/item/clothing/pants/tights
