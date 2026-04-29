/datum/attribute_holder/sheet/job/sawbones
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_FORTUNE = 1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 20,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/misc/medicine = 50,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/craft/alchemy = 20,
	)

/datum/attribute_holder/sheet/job/sawbones/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 4,
		STAT_PERCEPTION = 1,
		STAT_FORTUNE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 20,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/misc/medicine = 50,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/craft/alchemy = 20,
	)
/datum/job/advclass/bandit/sawbones // doctor class. like the pilgrim, but more evil
	title = "Sawbones"
	tutorial = "It was an accident! Your patient wasn't using his second kidney, anyway. After an unfortunate 'misunderstanding' with the town and your medical practice, you know practice medicine on the run with your new associates. Business has never been better!"
	outfit = /datum/outfit/bandit/sawbones
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit3.ogg'
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MEDICAL)

	attribute_sheet = /datum/attribute_holder/sheet/job/sawbones
	attribute_sheet_old = /datum/attribute_holder/sheet/job/sawbones/old

	traits = list(
		TRAIT_FORAGER,
	)

	spells = list(
		/datum/action/cooldown/spell/diagnose
	)

/datum/outfit/bandit/sawbones
	name = "Sawbones (Bandit)"
	mask = /obj/item/clothing/face/facemask/steel
	head = /obj/item/clothing/head/tophat
	armor = /obj/item/clothing/armor/leather/vest
	shirt = /obj/item/clothing/shirt/shortshirt
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/knife/cleaver
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/simpleshoes
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/storage/backpack/satchel/surgbag
	backpack_contents = list(/obj/item/natural/worms/leech = 1, /obj/item/natural/cloth = 2)
