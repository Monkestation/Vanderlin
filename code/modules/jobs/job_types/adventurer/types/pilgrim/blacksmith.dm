/datum/job/advclass/pilgrim/blacksmith
	title = "Blacksmith"
	tutorial = "Hardy worksmen that are at home in the forge, dedicating their lives \
	to ceaselessly toil in dedication to Malum."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/blacksmith
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Blacksmith Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/craft/engineering = 3,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/craft/blacksmithing = 3,
		/datum/skill/craft/armorsmithing = 3,
		/datum/skill/craft/weaponsmithing = 3,
		/datum/skill/craft/smelting = 3
	)

	traits = list(
		TRAIT_MALUMFIRE
	)

/datum/job/advclass/pilgrim/blacksmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/swimming, pick(0,0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/crafting, pick(1,2,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/masonry, pick(1,1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/craft/carpentry, pick(1,1,2), TRUE)

	if(prob(50))
		spawned.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)

	if(spawned.age == AGE_OLD)
		for(var/i in 1 to rand(1, 3))
			var/datum/skill/craft/skillpicked = pick(
				/datum/skill/craft/weaponsmithing,
				/datum/skill/craft/armorsmithing,
				/datum/skill/craft/blacksmithing,
			)
			spawned.adjust_skillrank(skillpicked, 1, TRUE)

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
