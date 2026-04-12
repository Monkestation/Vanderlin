/datum/attribute_holder/sheet/job/duelist
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_SPEED = 2,
		STAT_PERCEPTION = 2,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/cooking = 30
	)

/datum/job/advclass/mercenary/duelist
	title = "Duelist"
	tutorial = "A swordsman from Valoria, wielding a rapier with deadly precision and driven by honor and a thirst for coin, they duel with unmatched precision, seeking glory and wealth."
	allowed_races = RACES_PLAYER_NO_KOBOLD
	outfit = /datum/outfit/mercenary/duelist
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg' //Placeholder music since apparently i can't use one from the internet...
	total_positions = 2

	attribute_sheet = /datum/attribute_holder/sheet/job/duelist

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/job/advclass/mercenary/duelist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 8

/datum/outfit/mercenary/duelist
	name = "Duelist (Mercenary)"
	head = /obj/item/clothing/head/leather/duelhat
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	belt = /obj/item/storage/belt/leather/mercenary
	beltl = /obj/item/weapon/sword/rapier/dec
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/belt/pouch/coins/mid
	scabbards = list(/obj/item/weapon/scabbard/sword)
