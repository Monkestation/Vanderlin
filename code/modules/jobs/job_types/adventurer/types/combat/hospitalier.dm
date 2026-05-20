/datum/attribute_holder/sheet/job/hospitalier
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/advclass/combat/hospitalier
	title = "Hospitalier"
	tutorial = "Hospitaliers are selfless individuals who take it upon \
	themselves to aid those in need.  With only your mace, shield and wits \
	to keep you safe, you have set out on a journey to aid others."
	outfit = /datum/outfit/adventurer/hospitalier
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	attribute_sheet = /datum/attribute_holder/sheet/job/hospitalier

	traits = list(
		TRAIT_DEADNOSE,
	)

/datum/outfit/adventurer/hospitalier
	name = "Hospitalier (Adventurer)"
	armor = /obj/item/clothing/armor/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/clothing/neck/coif/cloth
	belt = /obj/item/storage/belt/leather/adventurer
	backl = /obj/item/storage/backpack/backpack
	backr = /obj/item/weapon/shield/wood
	beltl = /obj/item/weapon/mace/bludgeon
	wrists = /obj/item/clothing/wrists/bracers/jackchain
	cloak = /obj/item/clothing/cloak/apron
	backpack_contents = list(
		/obj/item/weapon/surgery/scalpel = 1,
		/obj/item/weapon/surgery/cautery= 1,
		/obj/item/weapon/surgery/hammer = 1,
		/obj/item/folding_table_stored = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/needle = 1
	)
