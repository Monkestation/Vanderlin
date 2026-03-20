/datum/attribute_holder/sheet/job/rthief
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/combat/firearms = 10,
		/datum/attribute/skill/craft/traps = 20
	)

// Reformed Thief, a class balanced to rogue. Axe and crossbow focus.
/datum/job/advclass/adept/rthief
	title = "Reformed Thief"
	tutorial = "You are a former thief who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your stealth and cunning."
	outfit = /datum/outfit/adept/rthief
	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/rthief

	traits = list(
		TRAIT_INQUISITION,
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	languages = list(/datum/language/thievescant)

/datum/job/advclass/adept/rthief/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", -10, "Reformed Thief")

/datum/outfit/adept/rthief
	name = "Reformed Thief (Adept)"
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/splint
	head = /obj/item/clothing/head/roguehood/leather
	neck = /obj/item/clothing/neck/gorget/explosive
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/weapon/mace/cudgel
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/shredded
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/storage/keyring/adept = 1,
		/obj/item/weapon/knife/dagger/silver/psydon = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
	)
