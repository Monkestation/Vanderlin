/datum/job/advclass/combat/hospitalier
	title = "Hospitalier"
	tutorial = "Across all species, there are those who seek to help others.  Whether you were a goblins wars veteran, a weary traveller, a failed cleric, or an adventurous noble, you decided that saving lives was your calling in life.  Go forth, noble hero, and minister to these desperate lands."
	outfit = /datum/outfit/adventurer/hospitalier
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/sewing = 2,
		/datum/skill/misc/medicine = 3,
		/datum/skill/labor/mathematics = 2,
	)

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
	r_hand = /obj/item/flashlight/flare/torch/prelit
	cloak = /obj/item/clothing/cloak/apron
	backpack_contents = list(
		/obj/item/weapon/surgery/scalpel/ = 1,
		/obj/item/weapon/surgery/cautery/ = 1,
		/obj/item/weapon/surgery/hammer/ = 1,
		/obj/item/folding_table_stored = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/needle = 1
	)
