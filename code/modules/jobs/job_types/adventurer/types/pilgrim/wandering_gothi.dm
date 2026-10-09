/datum/attribute_holder/sheet/job/pilgrim/wandering_gothi
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/craft/tanning/patching = 20,
		/datum/attribute/skill/craft/carpentry = 30,
		/datum/attribute/skill/labor/farming = 30,
		/datum/attribute/skill/magic/druidic = 40,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/lumberjacking = 10
	)


/datum/job/advclass/pilgrim/wandering_gothi
	title = "Wandering Gothi"
	tutorial = "Once a great prowler of Ossland, now an old preacher of The Great Hunt and blessed by its aspects, you wander the wooded lands and give the wisdom of The Hunt to those who would seek its natural plunder."
	total_positions = 1
	spawn_positions = 1

	allowed_ages = list(AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(SPEC_ID_HALFLING, SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG, SPEC_ID_HALF_SNOW_ELF, SPEC_ID_SNOW_ELF)

	exp_types_granted = list(EXP_TYPE_CLERIC)
	spells = list(/datum/action/cooldown/spell/diagnose/holy/hunt)
	allowed_patrons = list(/datum/patron/alternate/great_hunt)

	outfit = /datum/outfit/pilgrim/gothi
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/wandering_gothi

	traits = list(
		TRAIT_FORAGER
	)

	languages = list(/datum/language/gronnic)
	book_type = /obj/item/recipe_book/medical

/datum/job/advclass/pilgrim/wandering_gothi/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.set_patron(/datum/patron/alternate/great_hunt/proven)
	spawned.apply_status_effect(/datum/status_effect/buff/bone_ward)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

	var/datum/species/species = spawned.dna?.species
	if(species)
		species.native_language = "Osslandic"
		species.accent_language = species.get_accent(species.native_language)


/datum/outfit/pilgrim/gothi
	name = "Wandering Gothi"
	armor = /obj/item/clothing/armor/leather/shamancoat
	neck = /obj/item/clothing/neck/psycross/great_hunt
	pants = /obj/item/clothing/pants/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/boots/darkboots
	wrists = /obj/item/clothing/wrists/bracers/leather
	head = /obj/item/clothing/head/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/plate/beastclaws
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/spear
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/needle = 1,
	)
