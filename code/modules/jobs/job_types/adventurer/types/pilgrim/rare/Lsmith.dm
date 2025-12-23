/datum/job/advclass/pilgrim/rare/masterblacksmith
	title = "Master Blacksmith"
	tutorial = "Dwarves, and humen who trained extensively under them in the art of smithing, \
	become the most legendary smiths at their craft, gaining reputation beyond compare."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/pilgrim/masterblacksmith
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/craft/masonry = 2,
		/datum/skill/craft/engineering = 4,
		/datum/skill/misc/sewing = 1,
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/lockpicking = 1,
		/datum/skill/craft/blacksmithing = 6,
		/datum/skill/craft/armorsmithing = 6,
		/datum/skill/craft/weaponsmithing = 6,
		/datum/skill/craft/smelting = 6,
		/datum/skill/labor/mathematics = 2
	)

	traits = list(
		TRAIT_MALUMFIRE
	)

/datum/job/advclass/pilgrim/rare/masterblacksmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/swimming, pick(0,1,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/climbing, pick(1,1,2,2,3,4), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/crafting, pick(2,2,3,3,4), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/carpentry, pick(1,2,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/cooking, pick(0, 1, 1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/reading, pick(1, 2, 2), TRUE)

	if(spawned.age == AGE_OLD)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, -2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, -2)
		spawned.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)

/datum/outfit/pilgrim/masterblacksmith
	name = "Master Blacksmith (Pilgrim)"
	beltr = /obj/item/weapon/hammer/iron
	backl = /obj/item/storage/backpack/backpack
	backr = /obj/item/weapon/hammer/sledgehammer
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	neck = /obj/item/storage/belt/pouch/coins/mid
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/hunting
	cloak = /obj/item/clothing/cloak/apron/brown
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/tongs = 1,
		/obj/item/ore/coal = 1,
		/obj/item/ore/iron = 1,
		/obj/item/mould/ingot = 1,
		/obj/item/storage/crucible/random = 1
	)

/datum/outfit/pilgrim/masterblacksmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/shortboots
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
