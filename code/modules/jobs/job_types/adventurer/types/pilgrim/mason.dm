/datum/job/advclass/pilgrim/mason
	title = "Mason"
	tutorial = "Despite the lack of a formal guild in Vanderlin, you've traveled there to hone your stonemasonry. \
	You've known your entire life there are ancient secrets within stone, and now you must prove their value to others."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/pilgrim/mason
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Mason Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/masonry = 4,
		/datum/skill/craft/engineering = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1
	)

/datum/job/advclass/pilgrim/mason/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/labor/mining, rand(1,3), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/carpentry, pick(1,2), TRUE)

	if(spawned.dna?.species.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/outfit/pilgrim/mason
	name = "Mason (Pilgrim)"
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/apron/waist/colored/brown
	neck = /obj/item/storage/belt/pouch/coins/mid
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/hammer
	beltr = /obj/item/weapon/chisel
	backl = /obj/item/storage/backpack/backpack

/datum/outfit/pilgrim/mason/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu)
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/tunic/colored/random)

	if(equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
