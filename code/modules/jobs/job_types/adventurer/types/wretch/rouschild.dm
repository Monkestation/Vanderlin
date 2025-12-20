/datum/job/advclass/wretch/rouschild
	title = "Rouschild"
	tutorial = "A child of the sewers, abandoned at birth, you were taken in by a colony of rous and raised as one of their own."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/rouschild
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
	total_positions = 2

/datum/outfit/wretch/rouschild
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	mask = /obj/item/clothing/face/shepherd
	armor = /obj/item/clothing/armor/leather/advanced
	pants = /obj/item/clothing/pants/trou/leather/advanced
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/weapon/knife/hunting
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	wrists = /obj/item/rope/chain

/datum/outfit/wretch/rouschild/pre_equip(mob/living/carbon/human/H)
	..()
	// Barbarian statblock mostly
	H.add_spell(/datum/action/cooldown/spell/conjure/rous)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 4, TRUE)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, -3)
	ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC)

	H.faction = list(FACTION_RATS)

/datum/outfit/wretch/rouschild/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	wretch_select_bounty(H)

