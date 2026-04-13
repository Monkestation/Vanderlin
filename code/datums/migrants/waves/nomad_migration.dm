/datum/migrant_role/khan
	name = "Khan"
	greet_text = "You are the khan of a horde of nomads, a warlord of the steppes, you have migrated to these lands with your horde"
	migrant_job = /datum/job/migrant/khan

/datum/attribute_holder/sheet/job/migrant/khan
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/taming = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/riding = 60,
	)

/datum/job/migrant/khan
	title = "Khan"
	tutorial = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"
	outfit = /datum/outfit/khan
	allowed_races = RACES_PLAYER_FOREIGNNOBLE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	honorary_suffix = "Khan"
	honorary_suffix_f = "Khatun"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/khan

	traits = list(
		TRAIT_HEAVYARMOR,
        TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
        TRAIT_DUALWIELDER,
        TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

/datum/job/migrant/khan/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(get_turf(spawned))

/datum/outfit/khan
	name = "Khan (Migrant Wave)"
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/steel
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/weapon/sword/long/rider/steppe // dual wielder warlord
	beltl= /obj/item/weapon/sword/long/rider/steppe
	shirt = /obj/item/clothing/armor/gambeson/light/steppe
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/storage/belt/pouch/coins/rich
	backl = /obj/item/gun/ballistic/bow/short
	backr = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/medium/scale/steppe
	head = /obj/item/clothing/head/helmet/bascinet/steppe
	scabbards = list(/obj/item/weapon/scabbard/sword, /obj/item/weapon/scabbard/sword)
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/tent_kit = 1, /obj/item/clothing/face/facemask/steel/steppe = 1, /obj/item/reagent_containers/glass/bottle/avarmead = 1)

/datum/migrant_role/nomadrider
	name = "Nomad Rider"
	greet_text = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"
	migrant_job = /datum/job/advclass/pilgrim/nomad

/datum/job/migrant/nomadrider
	title = "Nomad Rider"
	tutorial = "You are a nomad riding behind the khan, his voice a compass his will the unyielding law that guides your path to these unknown lands"
	outfit = /datum/outfit/pilgrim/nomad
	allowed_races = RACES_PLAYER_ALL

/datum/migrant_wave/nomad_migration
	name = "The Khan's Migration"
	max_spawns = 2
	shared_wave_type = /datum/migrant_wave/nomad_migration
	downgrade_wave = /datum/migrant_wave/nomad_migration_down
	weight = 30
	roles = list(
		/datum/migrant_role/khan = 1,
		/datum/migrant_role/nomadrider = 5,
	)
	greet_text = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up your tents"

/datum/migrant_wave/nomad_migration_down
	name = "The Khan's Migration"
	shared_wave_type = /datum/migrant_wave/nomad_migration
	downgrade_wave = /datum/migrant_wave/nomad_migration_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/khan = 1,
		/datum/migrant_role/nomadrider = 4,
	)
	greet_text = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"

/datum/migrant_wave/nomad_migration_down_one
	name = "The Khan's Migration"
	shared_wave_type = /datum/migrant_wave/nomad_migration
	downgrade_wave = /datum/migrant_wave/nomad_migration_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/khan = 1,
		/datum/migrant_role/nomadrider = 3,
	)
	greet_text = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"

/datum/migrant_wave/nomad_migration_down_two
	name = "The Khan's Migration"
	shared_wave_type = /datum/migrant_wave/nomad_migration
	downgrade_wave = /datum/migrant_wave/nomad_migration_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/khan = 1,
		/datum/migrant_role/nomadrider = 2,
	)
	greet_text = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"

/datum/migrant_wave/nomad_migration_down_three
	name = "The Khan's Migration"
	shared_wave_type = /datum/migrant_wave/nomad_migration
	downgrade_wave = /datum/migrant_wave/nomad_migration_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/khan = 1,
		/datum/migrant_role/nomadrider = 1,
	)
	greet_text = "The khan rides with his most trusted warrior, crossing into unfamiliar land in search of pasture and a place to set up tents"

/datum/migrant_wave/nomad_migration_down_four
	name = "The Khan's Migration"
	shared_wave_type = /datum/migrant_wave/nomad_migration
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/khan = 1,
	)
	greet_text = "The khan rides alone, crossing into unfamiliar land in search of pasture and a place to set up tents"
