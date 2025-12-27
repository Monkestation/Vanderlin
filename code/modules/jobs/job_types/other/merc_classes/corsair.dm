/datum/job/advclass/mercenary/corsair
	title = "Corsair"
	tutorial = "Driven away from a typical life, you once found kin with privateers, working adjacent to a royal navy. After the Red Flag battered itself in the wind one last time, your purse was still not satisfied... And yet he complained that his belly was not full."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/corsair
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
	total_positions = 5

	jobstats = list(
		STATKEY_END = 2,
		STATKEY_SPD = 3
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/labor/fishing = 3,
		/datum/skill/misc/swimming = 4,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3
	)

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