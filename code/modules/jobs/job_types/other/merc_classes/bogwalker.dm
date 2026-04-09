/datum/attribute_holder/sheet/job/bogwalker
	attribute_variance = list(
		/datum/attribute/skill/misc/reading = list(0, 10),
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 3,
		STAT_SPEED = 1,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/labor/taming = 10,
		/datum/attribute/skill/labor/lumberjacking = 30
	)


/datum/job/advclass/mercenary/bogwalker
	title = "Bogwalker"
	tutorial = "You've spent your years wandering the bogs of Psydonia, eking out a living a hunter of both men and beast. \
	Your axe has claimed many a head and the bog has hardened your body and mind against all threats."
	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/mercenary/bogwalker
	category_tags = list(CTAG_MERCENARY)

	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/bogwalker

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_DEADNOSE,
		TRAIT_NASTY_EATER,
		TRAIT_STEELHEARTED
	)

/datum/job/advclass/mercenary/bogwalker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/bogwalker
	name = "Bogwalker (Mercenary)"
	head = /obj/item/clothing/head/helmet/kettle
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/shirt/tunic/colored/green
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/knife/villager
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
