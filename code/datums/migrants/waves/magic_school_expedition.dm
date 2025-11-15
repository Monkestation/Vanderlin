/datum/migrant_role/magic_teacher
	name = "Magic School Teacher"
	greet_text = "Among the lofty spires of Kingsfield’s arcane academies, one school conceived a daring idea: a grand overland expedition, on foot, through untamed lands. \
	As fortune (or folly) would have it, you have been chosen as the guiding hand and watchful protector of your eager pupils. \
	Your task is to lead them safely across the wilds, through hardship and wonder alike, until at last the halls of learning they seek rise before you."
	migrant_job = /datum/job/migrant/magic_teacher

/datum/job/migrant/magic_teacher
	title = "Magic School Teacher"
	tutorial = "Among the lofty spires of Kingsfield’s arcane academies, one school conceived a daring idea: a grand overland expedition, on foot, through untamed lands. \
	As fortune (or folly) would have it, you have been chosen as the guiding hand and watchful protector of your eager pupils. \
	Your task is to lead them safely across the wilds, through hardship and wonder alike, until at last the halls of learning they seek rise before you."
	outfit = /datum/outfit/magic_teacher
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONEXOTIC
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 4,
		STATKEY_CON = -1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/misc/reading = 5,
		/datum/skill/magic/arcane = 4,
		/datum/skill/combat/polearms = 2,
		/datum/skill/craft/alchemy = 4,
		/datum/skill/labor/mathematics = 3,
	)

	spells = list(/datum/action/cooldown/spell/undirected/touch/prestidigitation)
	spell_points = 10

	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	voicepack_m = /datum/voicepack/male/wizard

/datum/job/migrant/magic_teacher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(prob(5))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'
	spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)

/datum/outfit/magic_teacher
	name = "Magic School Teacher"
	head = /obj/item/clothing/head/wizhat
	backr = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/shirt/robe/colored/black
	belt  =	/obj/item/storage/belt/leather
	beltr = /obj/item/storage/magebag/apprentice
	backl = /obj/item/weapon/polearm/woodstaff
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/mana_star
	backpack_contents = list(
		/obj/item/book/granter/spellbook/expert = 1,
		/obj/item/storage/belt/pouch/coins/rich = 1,
	)

/datum/migrant_role/magic_student
	name = "Magic School Student"
	greet_text = "When the call went out for daring pupils to join a great overland trek from Kingsfield, you eagerly volunteered, visions of adventure, discovery, and excitement dancing in your mind. \
	Of course, the creatures that lurk along the road seem just as eager... though perhaps for very different reasons."
	migrant_job = /datum/job/migrant/magic_student

/datum/job/migrant/magic_student
	title = "Magic School Student"
	tutorial = "When the call went out for daring pupils to join a great overland trek from Kingsfield, you eagerly volunteered, visions of adventure, discovery, and excitement dancing in your mind. \
	Of course, the creatures that lurk along the road seem just as eager... though perhaps for very different reasons."
	outfit = /datum/outfit/magic_student
	allowed_ages = list(AGE_CHILD)
	allowed_races = RACES_PLAYER_NONEXOTIC
	allowed_patrons = list(/datum/patron/divine/noc)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_SPD = -2,
	)

	skills = list(
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/combat/polearms = 1,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/labor/mathematics = 2,
	)

	spells = list(/datum/action/cooldown/spell/undirected/touch/prestidigitation)
	spell_points = 6

/datum/job/migrant/magic_student/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)

/datum/job/migrant/magic_student/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/magic/arcane, pick(2,2,2,3))
	if(prob(5))
		spawned.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

/datum/outfit/magic_student
	name = "Magic School Student"
	neck = /obj/item/clothing/neck/mana_star
	belt  =	/obj/item/storage/belt/leather
	beltl = /obj/item/book/granter/spellbook/adept
	beltr = /obj/item/storage/magebag/apprentice
	armor = /obj/item/clothing/shirt/robe/newmage/adept
	backr = /obj/item/storage/backpack/satchel
	pants = /obj/item/clothing/pants/tights/colored/random
	shoes = /obj/item/clothing/shoes/simpleshoes
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/chalk = 1,
	)

/datum/outfit/magic_student/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/shortshirt
		head = /obj/item/clothing/head/wizhat/gen
	else
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
		head = /obj/item/clothing/head/wizhat/witch

/datum/migrant_wave/magic_school_expedition
	name = "Magic School Expedition"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/magic_school_expedition
	downgrade_wave = /datum/migrant_wave/magic_school_expedition_down
	weight = 5
	roles = list(
		/datum/migrant_role/magic_teacher = 1,
		/datum/migrant_role/magic_student = 5
	)
	greet_text = "A teacher in travel-worn robes takes a seat, a cluster of young apprentices following close behind. Their satchels clink faintly with glass and metal, and the smell of old parchment drifts from their packs."

/datum/migrant_wave/magic_school_expedition_down
	name = "Magic School Expedition"
	shared_wave_type = /datum/migrant_wave/magic_school_expedition
	downgrade_wave = /datum/migrant_wave/magic_school_expedition_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/magic_teacher = 1,
		/datum/migrant_role/magic_student = 3
	)
	greet_text = "The door opens to a weary teacher and a smaller band of pupils. Their robes are torn at the hems, and one student’s hands are wrapped in singed cloth."

/datum/migrant_wave/magic_school_expedition_two
	name = "Magic School Expedition"
	shared_wave_type = /datum/migrant_wave/magic_school_expedition
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/magic_teacher = 1,
		/datum/migrant_role/magic_student = 1
	)
	greet_text = "Only a single student remains beside the teacher. They sit quietly, eyes fixed on the table, as dark stains dry on the cuffs of their robes."
