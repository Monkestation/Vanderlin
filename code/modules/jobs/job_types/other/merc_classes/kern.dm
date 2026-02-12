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

	jobstats = list(
		STATKEY_SPD = 2,
		STATKEY_END = 1,
		STATKEY_STR = 1
	)

	skills = list(
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3
	)

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
