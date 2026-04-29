/datum/attribute_holder/sheet/job/spellsword
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/magic/arcane = 10,
		/datum/attribute/skill/craft/alchemy = 10
	)

/datum/job/advclass/mercenary/spellsword
	title = "Spellsword"
	tutorial = "A warrior who has dabbled in the arts of magic, you blend swordplay and spellcraft to earn your keep."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/spellsword
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	spell_points = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/spellsword

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation
	)

/datum/job/advclass/mercenary/spellsword/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/spellsword
	name = "Spellsword (Mercenary)"
	armor = /obj/item/clothing/armor/leather
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/shirt/tunic
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/storage/magebag/poor
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger = 1,
		/obj/item/reagent_containers/glass/bottle/manapot = 1,
		/obj/item/book/granter/spellbook/apprentice = 1,
		/obj/item/chalk = 1
	)
