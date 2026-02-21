/datum/migrant_role/jestertroupe
	name = "Buffoon"
	greet_text = "You were once part of a glorious circus from Heartfelt. Long gone are the days of mirth. The tent having been set ablaze so many years ago, you and your lot have been wandering. Here is the perfect town to start the next act. The circus is in town!"
	migrant_job = /datum/job/migrant/jestertroupe

/datum/job/migrant/jestertroupe
	title = "Buffoon"
	tutorial =  "You were once part of a glorious circus from Heartfelt. Long gone are the days of mirth. The tent having been set ablaze so many years ago, you and your lot have been wandering. Here is the perfect town to start the next act. The circus is in town!"
	outfit = /datum/outfit/jestertroupe
	allowed_races = RACES_PLAYER_ALL

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_CON = -1,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 3,
	)

	traits = list(
		TRAIT_EMPATH,
		TRAIT_ZJUMP,
	)

	spells = list(/datum/action/cooldown/spell/vicious_mockery)
	cmode_music = 'sound/music/cmode/nobility/CombatJester2.ogg'

/datum/job/migrant/jestertroupe/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	LAZYADDASSOC(skills, /datum/skill/combat/knives, pick(2,3))
	LAZYADDASSOC(skills, /datum/skill/combat/swords, pick(1,2))
	LAZYADDASSOC(skills, /datum/skill/misc/music, pick(4,5,5,6))
	LAZYADDASSOC(skills, /datum/skill/combat/wrestling, pick(1,2,2,2,3))
	LAZYADDASSOC(skills, /datum/skill/combat/unarmed, pick(1,2,2,2,3))
	LAZYADDASSOC(skills, /datum/skill/misc/sneaking, pick(2,3,4,5))
	LAZYADDASSOC(skills, /datum/skill/misc/stealing, pick(3,4))
	LAZYADDASSOC(skills, /datum/skill/misc/lockpicking, pick(2,2,3,3,4))
	LAZYADDASSOC(skills, /datum/skill/misc/climbing, pick(4,4,4,4,5))
	add_verb(spawned, /mob/living/carbon/human/proc/ventriloquate)

/datum/outfit/jestertroupe
	name = "Buffoon (Migrant Wave)"
	shoes = /obj/item/clothing/shoes/jester
	pants = /obj/item/clothing/pants/tights
	armor = /obj/item/clothing/shirt/jester
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/weapon/knife/villager
	backl = /obj/item/instrument/lute
	backr = /obj/item/instrument/viola
	head = /obj/item/clothing/head/jester
	neck = /obj/item/clothing/neck/coif
	mask = /obj/item/clothing/face/lordmask

/datum/migrant_wave/jestertroupe
	name = "The Circus"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/jestertroupe
	downgrade_wave = /datum/migrant_wave/jestertroupe_down
	weight = 10
	roles = list(
		/datum/migrant_role/jestertroupe = 3
	)
	greet_text = "Bread and Circuses. That's how little it takes to entertain the peasantry. You aren't funny for money, you're funny by nature."

/datum/migrant_wave/jestertroupe_down
	name = "The Comedian"
	shared_wave_type = /datum/migrant_wave/jestertroupe
	can_roll = FALSE
	weight = 35
	roles = list(
		/datum/migrant_role/jestertroupe = 1,
	)
	greet_text = "Bread and Circuses. That's how little it takes to entertain the peasantry. You aren't funny for money, you're funny by nature."
