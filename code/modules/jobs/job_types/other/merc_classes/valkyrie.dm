/datum/attribute_holder/sheet/job/valkyrie
	attribute_variance = list(
		/datum/attribute/skill/craft/alchemy = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = 3,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/job/advclass/mercenary/valkyrie
	title = "Valkyrie"
	tutorial = "You've seen countless battles and earned your fair share of riches from them. \
	Flying above the battlefield, you seek those who are injured and come to their aid, for a price."
	allowed_races = list(SPEC_ID_HARPY)
	outfit = /datum/outfit/mercenary/valkyrie
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/valkyrie

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/mercenary/valkyrie/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

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
