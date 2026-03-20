/datum/attribute_holder/sheet/job/gallowglass
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/gallowglass

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
	backl = /obj/item/weapon/sword/long/greatsword/claymore
	backr = /obj/item/storage/backpack/satchel
