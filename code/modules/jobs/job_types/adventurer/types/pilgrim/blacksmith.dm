/datum/attribute_holder/sheet/job/pilgrim/blacksmith
	attribute_variance = list(
		/datum/attribute/skill/misc/swimming = list(0, 10),
		/datum/attribute/skill/craft/crafting = list(10, 20),
		/datum/attribute/skill/craft/masonry = list(10, 20),
		/datum/attribute/skill/craft/carpentry = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/blacksmithing = 30,
		/datum/attribute/skill/craft/armorsmithing = 30,
		/datum/attribute/skill/craft/weaponsmithing = 30,
		/datum/attribute/skill/craft/smelting = 30,
	)

/datum/attribute_holder/sheet/job/pilgrim/blacksmith/old
	attribute_variance = list(
		/datum/attribute/skill/misc/swimming = list(0, 10),
		/datum/attribute/skill/craft/crafting = list(10, 20),
		/datum/attribute/skill/craft/masonry = list(10, 20),
		/datum/attribute/skill/craft/carpentry = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 30,
		/datum/attribute/skill/craft/weaponsmithing = 30,
		/datum/attribute/skill/craft/smelting = 30,
	)

/datum/job/advclass/pilgrim/blacksmith
	title = "Blacksmith"
	tutorial = "Hardy worksmen that are at home in the forge, dedicating their lives \
	to ceaselessly toil in dedication to Malum."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/blacksmith
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Blacksmith Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/blacksmith
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/blacksmith/old

	traits = list(
		TRAIT_MALUMFIRE
	)

/datum/job/advclass/pilgrim/blacksmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/outfit/pilgrim/blacksmith
	name = "Blacksmith (Pilgrim)"
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/hammer/iron
	beltl = /obj/item/weapon/tongs
	neck = /obj/item/storage/belt/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/leather
	cloak = /obj/item/clothing/cloak/apron/brown
	pants = /obj/item/clothing/pants/trou
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/ore/coal = 1,
		/obj/item/ore/iron = 1,
		/obj/item/mould/ingot = 1,
		/obj/item/storage/crucible/random = 1
	)

/datum/outfit/pilgrim/blacksmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu)

	if(equipped_human.gender == MALE)
		shoes = /obj/item/clothing/shoes/boots/leather
		shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/tunic/colored/random)
	else
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shoes = /obj/item/clothing/shoes/shortboots

	if(equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
