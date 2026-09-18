/datum/attribute_holder/sheet/job/muscle_magos
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 3,
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/magic/arcane = 30,
		/datum/attribute/skill/craft/alchemy = 20
	)

/datum/job/advclass/combat/muscle_magos
	title = "Muscle Magos"
	tutorial = "A warrior who has dabbled in the arts of magic, you blend martial arts and spellcraft to earn your keep."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/combat/muscle_magos
	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	form_points = 5
	technique_points = 1

	traits = list(
		TRAIT_SORCERER,
		TRAIT_CLOSECOMBAT,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/muscle_magos

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/bind_weapon,
		/datum/action/cooldown/spell/recall_weapon,
		/datum/action/cooldown/spell/empower_weapon,
		/datum/action/cooldown/spell/essence/mend/spell,
		/datum/action/cooldown/spell/misty_step,
		/datum/action/cooldown/spell/rending_grasp,
		/datum/action/cooldown/spell/earthshock_fist,
		/datum/action/cooldown/spell/tempest_rush,
	)

/datum/job/advclass/combat/muscle_magos/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_technique_mastery_points(2, FALSE, TECHNIQUE_IMBUE)
	spawned.add_spell(/datum/action/innate/clench_fists, TRUE)

/datum/outfit/combat/muscle_magos
	name = "Muscle Magos (Wretch)"
	armor = /obj/item/clothing/armor/leather/jerkin
	neck = /obj/item/clothing/neck/coif
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/armor/gambeson
	gloves = /obj/item/clothing/gloves/bandages
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/rope
	beltr = /obj/item/weapon/knuckles/bronze
	beltl = /obj/item/storage/magebag/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger = 1,
		/obj/item/reagent_containers/glass/bottle/manapot/labelled = 1,
		/obj/item/chalk = 1
	)
