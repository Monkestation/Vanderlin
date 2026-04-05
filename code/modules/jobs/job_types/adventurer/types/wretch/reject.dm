/datum/attribute_holder/sheet/job/reject
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 2,
		STAT_FORTUNE = 1,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/advclass/wretch/reject
	title = "Rejected Royal"
	tutorial = "You were once a member of the royal family, but due to your actions, or the circumstances of your birth, you have been cast out to roam the wilds. \
	Now, you return, seeking redemption or perhaps... revenge."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_DWARF,\
		SPEC_ID_ELF,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_TIEFLING,\
	)
	allowed_ages = list(AGE_ADULT, AGE_CHILD)
	total_positions = 1
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	outfit = /datum/outfit/wretch/reject

	attribute_sheet = /datum/attribute_holder/sheet/job/reject

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_BEAUTIFUL,
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
	)

/datum/job/advclass/wretch/reject/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), spawned, FAMILY_PROGENY), 10 SECONDS)

	if(spawned.dna.species.id != SPEC_ID_TIEFLING)
		ADD_TRAIT(spawned, TRAIT_NOBLE_BLOOD, TRAIT_GENERIC)

/datum/job/advclass/wretch/reject/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(tgui_alert(usr, "Do you wish to be recognized as a non-foreigner?", "Foreigner", list("Yes", "No")) == "Yes")
		REMOVE_TRAIT(spawned, TRAIT_FOREIGNER, TRAIT_GENERIC)
		spawned.honorary = spawned.pronouns == SHE_HER ? "Rejected Princess" : "Rejected Prince"

/datum/outfit/wretch/reject
	name = "Rejected Royal (Wretch)"
	head = /obj/item/clothing/head/crown/circlet
	cloak = /obj/item/clothing/cloak/raincloak
	mask = /obj/item/clothing/face/shepherd/rag
	armor = /obj/item/clothing/armor/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/key/manor
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/ammo_holder/quiver/bolts
	neck = /obj/item/storage/belt/pouch/coins/rich
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/bow/cross
	pants = /obj/item/clothing/pants/trou/leather/advanced
	backpack_contents = list(
		/obj/item/reagent_containers/glass/cup/golden = 3,
		/obj/item/reagent_containers/glass/bottle/killersice = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/lockpickring/mundane = 1,
	)

/datum/outfit/wretch/reject/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/dress/royal/prince
	if(equipped_human.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/royal/princess
