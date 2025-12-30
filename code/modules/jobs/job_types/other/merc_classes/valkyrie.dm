/datum/job/advclass/mercenary/valkyrie
	title = "Valkyrie"
	tutorial = "You've seen countless battles and earned your fair share of riches from them. \
	Flying above the battlefield, you seek those who are injured and come to their aid, for a price."
	allowed_races = list(SPEC_ID_HARPY)
	outfit = /datum/outfit/mercenary/valkyrie
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 3
	)

	skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/tanning = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/mercenary/valkyrie/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9
	spawned.adjust_skillrank(/datum/skill/craft/alchemy, pick(2,3))

/datum/outfit/mercenary/valkyrie
	name = "Valkyrie (Mercenary)"
	head = /obj/item/clothing/head/roguehood/colored/red
	mask = /obj/item/clothing/face/shepherd/rag
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather
	shirt = /obj/item/clothing/armor/gambeson/light
	gloves = /obj/item/clothing/gloves/leather
	cloak = /obj/item/clothing/cloak/raincloak/colored/red
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/reagent_containers/glass/bottle/stronghealthpot
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/healthpot = 3,
		/obj/item/weapon/knife/hunting = 1
	)
