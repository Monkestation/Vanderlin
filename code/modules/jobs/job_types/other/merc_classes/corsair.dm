/datum/attribute_holder/sheet/job/corsair
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 30
	)

/datum/job/advclass/mercenary/corsair
	title = "Corsair"
	tutorial = "Driven away from a typical life, you once found kin with privateers, working adjacent to a royal navy. After the Red Flag battered itself in the wind one last time, your purse was still not satisfied... And yet he complained that his belly was not full."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/corsair
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/corsair

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/adventurer/corsair
	name = "Corsair (Mercenary)"
	head = /obj/item/clothing/head/helmet/leather/headscarf
	pants = /obj/item/clothing/pants/tights/sailor
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/leather/jacket/sea
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/natural/worms/leech = 2,
		/obj/item/storage/belt/pouch/coins/mid = 1
	)
	backr = /obj/item/fishingrod/fisher
	beltl = /obj/item/weapon/sword/sabre/cutlass
	beltr = /obj/item/weapon/knife/dagger
	scabbards = list(/obj/item/weapon/scabbard/sword, /obj/item/weapon/scabbard/knife)
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/adventurer/corsair/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/sailor, /obj/item/clothing/shirt/undershirt/sailor/red)
