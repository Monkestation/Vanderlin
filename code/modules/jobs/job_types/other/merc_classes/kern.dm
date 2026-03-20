/datum/attribute_holder/sheet/job/kern
	raw_attribute_list = list(
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/job/advclass/mercenary/kern
	title = "Kern"
	tutorial = "A mercenary hailing from Kaledon, you fight under your Gallowglass or for your own coin, you fled with your fellow countrymen to escape the Grenzelhoftian Occupation of your homeland."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/mercenary/kern
	category_tags = list(CTAG_MERCENARY)
	total_positions = 0
	cmode_music = 'sound/music/cmode/Combat_Dwarf.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/kern

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/outfit/mercenary/kern
	name = "Kern (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/leather
	head = /obj/item/clothing/head/roguehood/colored/black
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/chainmail/iron
	cloak = /obj/item/clothing/shirt/undershirt/sash/colored/mageblue
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	neck = /obj/item/clothing/neck/gorget
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/ammo_holder/quiver/arrows
	shirt = /obj/item/clothing/armor/gambeson/light/striped
	pants = /obj/item/clothing/pants/skirt/patkilt/colored/mageblue
	backl = /obj/item/weapon/polearm/spear
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backpack_contents = list(/obj/item/weapon/knife/villager = 1)
