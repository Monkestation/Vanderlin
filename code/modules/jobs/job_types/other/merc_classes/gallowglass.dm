/datum/job/advclass/mercenary/gallowglass
	title = "Gallowglass"
	tutorial = "A claymore-wielding mercenary hailing from the land of Kaledon, you are a fighter for coin, having fled the Grenzelhoftian occupation of your homeland. Your Kerns fight under you."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/mercenary/gallowglass
	category_tags = list(CTAG_MERCENARY)
	total_positions = 0 //Kaledon isn't in
	cmode_music = 'sound/music/cmode/Combat_Dwarf.ogg'

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_HEAVYARMOR
	)

/datum/outfit/mercenary/gallowglass
	name = "Gallowglass (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	head = /obj/item/clothing/head/helmet/gallowglass
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/chainmail/iron
	cloak = /obj/item/clothing/shirt/undershirt/sash/colored/mageblue
	neck = /obj/item/clothing/neck/chaincoif/iron
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/mace/cudgel
	shirt = /obj/item/clothing/armor/gambeson/light/striped
	pants = /obj/item/clothing/pants/skirt/patkilt/colored/mageblue
	backl = /obj/item/weapon/sword/long/greatsword/steelclaymore
	backr = /obj/item/storage/backpack/satchel
