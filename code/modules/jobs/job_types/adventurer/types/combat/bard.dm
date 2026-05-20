/datum/attribute_holder/sheet/job/adventurerbard
	clamped_adjustment = list(
		/datum/attribute/skill/misc/music = list(40, 40)
	)
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_SPEED = 2, // no more strength malus since more limited, +3 statline
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 10,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/job/advclass/combat/bard
	title = JOB_BARD
	tutorial = "Bards make up one of the largest populations of \
	registered adventurers in Vanderlin, mostly because they are \
	the last ones in a party to die. Their wish is to experience \
	the greatest adventures of the age and write amazing songs about them."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/bard
	category_tags = list(CTAG_ADVENTURER)
	apprentice_name = "Aspiring Bard"
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'
	exp_types_granted = list(EXP_TYPE_BARD)

	attribute_sheet = /datum/attribute_holder/sheet/job/adventurerbard

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BARDIC_TRAINING,
		TRAIT_FOREIGNER
	)

	spells = list(
		/datum/action/cooldown/spell/vicious_mockery,
		// /datum/action/cooldown/spell/bardic_inspiration
	)

/datum/job/advclass/combat/bard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.inspiration = new /datum/inspiration(spawned)

	if(spawned.dna?.species?.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/job/advclass/combat/bard/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/instruments = list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola
	)

	spawned.select_equippable(player_client, instruments, message = "Choose your instrument.", title = "XYLIX")

/datum/outfit/adventurer/bard
	name = "Bard (Adventurer)"
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/armor/gambeson/light // very, very shitty armor
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/shirt/tunic/noblecoat
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/weapon/sword/short/iron
	backpack_contents = list(/obj/item/flint = 1, /obj/item/storage/belt/pouch/coins/poor = 1)

/datum/outfit/combat/bard/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(prob(30))
		gloves = /obj/item/clothing/gloves/fingerless

	cloak = /obj/item/clothing/cloak/raincloak/colored/blue
	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/colored/red
