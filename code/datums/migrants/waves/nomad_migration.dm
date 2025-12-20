/datum/migrant_role/khan
	name = "Khan"
	greet_text = "You are the khan of a horde of nomads, a warlord of the steppes, you have migrated to these lands with your horde"
	migrant_job = /datum/job/migrant/khan

/datum/job/migrant/khan
	title = "khan"
	tutorial = "The khan rides at the head of a small horde of nomads, crossing into unfamiliar land in search of pasture and a place to set up tents"
	outfit = /datum/outfit/khan
	allowed_races = RACES_PLAYER_FOREIGNNOBLE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_PER = 2,
	)

	skills = list(
		/datum/skill/combat/swords = 4,
        /datum/skill/craft/crafting = 2,
		/datum/skill/craft/tanning = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/butchering = 2,
		/datum/skill/labor/taming = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/riding = 6,
    )

	traits = list(
		TRAIT_HEAVYARMOR,
        TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
        TRAIT_DUALWIELDER,
        TRAIT_NOBLE,
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

/datum/job/migrant/khan/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Khan"
	if(spawned.pronouns == SHE_HER)
		honorary = "Khatun"
	spawned.real_name = "[prev_real_name] [honorary]"
	spawned.name = "[prev_name] [honorary]"
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(get_turf(spawned))

/datum/outfit/khan
	name = "khan"
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/steel
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/weapon/sword/long/rider/steppe // dual wielder warlord
	beltl= /obj/item/weapon/sword/long/rider/steppe
	shirt = /obj/item/clothing/armor/gambeson/light/steppe
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/storage/belt/pouch/coins/rich
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
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
	outfit = /datum/outfit/adventurer/nomad
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
