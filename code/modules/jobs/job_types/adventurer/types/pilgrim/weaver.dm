/datum/attribute_holder/sheet/job/pilgrim/weaver
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/misc/sewing = 40,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/craft/carpentry = 10,
	)

/datum/job/advclass/pilgrim/weaver
	title = "Weaver"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/seamstress
	apprentice_name = "Weaver"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/weaver

/datum/outfit/pilgrim/seamstress
	name = "Weaver (Pilgrim)"
	belt = /obj/item/storage/belt/leather/cloth/lady
	pants = /obj/item/clothing/pants/tights/colored/random
	shoes = /obj/item/clothing/shoes/shortboots
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/mid
	shirt = /obj/item/clothing/shirt/undershirt
	beltr = /obj/item/weapon/knife/scissors
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backpack_contents = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/natural/bundle/fibers = 1,
		/obj/item/needle = 1
	)
