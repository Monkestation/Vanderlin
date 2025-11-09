// Reformed Thief, a class balanced to rogue. Axe and crossbow focus.
/datum/job/advclass/adept/rthief
	title = "Reformed Thief"
	tutorial = "You are a former thief who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your stealth and cunning."
	outfit = /datum/outfit/adept/rthief

	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'

	skills = list(
		/datum/skill/combat/axesmaces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/firearms = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE
	)

	traits = list(
		TRAIT_INQUISITION,
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_KNOWBANDITS,
		TRAIT_BLACKBAGGER,
	)
	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_END = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
	)


/datum/outfit/adept/rthief/pre_equip(mob/living/carbon/human/H)
	..()
	//Armor for class
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/splint
	head = /obj/item/clothing/head/adeptcowl
	neck = /obj/item/clothing/neck/gorget
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/weapon/mace/cudgel
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/shredded
	backpack_contents = list(/obj/item/lockpick = 1, /obj/item/storage/keyring/adept = 1, /obj/item/weapon/knife/dagger/silver/psydon = 1, 	/obj/item/clothing/head/inqarticles/blackbag = 1,	/obj/item/inqarticles/garrote = 1,)
	H.grant_language(/datum/language/thievescant)
	to_chat(H, span_info("I can gesture in thieves' cant with ,t before my speech."))

/datum/outfit/adept/rthief/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_school(H, "Order of the Venatari", -10, "Reformed Thief")
