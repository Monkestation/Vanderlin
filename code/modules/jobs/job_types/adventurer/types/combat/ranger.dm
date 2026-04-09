/datum/attribute_holder/sheet/job/ranger
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/combat/ranger
	title = "Ranger"
	tutorial = "Humen and elf rangers often live among each other, as these bow-wielding \
	adventurers are often scouting the lands for the same purpose."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_DROW,\
		SPEC_ID_AASIMAR,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_RAKSHARI,\
	)
	outfit = /datum/outfit/adventurer/ranger
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_LIVING, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)

	attribute_sheet = /datum/attribute_holder/sheet/job/ranger

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/job/advclass/combat/ranger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(25))
		if(!spawned.has_language(/datum/language/elvish))
			spawned.grant_language(/datum/language/elvish)
			to_chat(spawned, "<span class='info'>I can speak Elfish with ,e before my speech.</span>")

/datum/outfit/adventurer/ranger
	name = "Ranger (Adventurer)"
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/ammo_holder/quiver/arrows
	wrists = /obj/item/clothing/wrists/bracers/leather

	pants = /obj/item/clothing/pants/trou/leather  // Male default
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/fingerless  // 77% default
	cloak = /obj/item/clothing/cloak/raincloak/colored/brown  // 67% default

	backpack_contents = list(
		/obj/item/bait = 1,
		/obj/item/weapon/knife/hunting = 1,
	)

/datum/outfit/adventurer/ranger/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(H.gender == FEMALE)
		if(prob(50))
			pants = /obj/item/clothing/pants/tights/colored/black
		else
			pants = /obj/item/clothing/pants/tights

	if(prob(23))
		gloves = /obj/item/clothing/gloves/leather

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/colored/green
