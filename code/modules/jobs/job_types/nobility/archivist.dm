/datum/job/archivist
	title = "Archivist"
	tutorial = "A well-traveled and well-learned seeker of wisdom, the Archivist bears the mark of Noc's influence.\
	Tasked with recording the court's events and educating the ungrateful whelps the monarch calls heirs.\
	Your work may go unappreciated now, but one dae historians will sing of your dedication and insight."
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = 19 //lol?
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'
	advclass_cat_rolls = list(CTAG_ARCHIVIST = 20)
	give_bank_account = 100

	job_bitflag = BITFLAG_ROYALTY
	allowed_patrons = list(/datum/patron/divine/noc)

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_MAGICK, EXP_TYPE_NOBLE)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)

	languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/zalad,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/oldpsydonic,
		/datum/language/orcish,
		/datum/language/deepspeak
	)

	mind_traits = list(
		TRAIT_KNOW_KEEP_DOORS
	)
	traits = list(
		TRAIT_NOBLE
	)

/datum/job/archivist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE

/datum/job/advclass/archivist/chronicler
	title = "Chronicler"
	tutorial = "With endless papers and dripping ink, you record the tales of both the mundane and magickal. Simple magicks at your means as a tool to aid your true talent. Let us write the books of the next generation. "
	outfit = /datum/outfit/archivist/chronicler
	category_tags = list(CTAG_ARCHIVIST)
	magic_user = TRUE
	spells = list(
		/datum/action/cooldown/spell/undirected/learn,
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment,
		/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment/scroll,
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 8,
		STATKEY_CON = -1,
		STATKEY_END = -1,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/misc/reading = 6,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/magic/arcane = 3,
		/datum/skill/labor/mathematics = 6
	)

/datum/job/advclass/archivist/chronicler/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)

/datum/outfit/archivist/chronicler
	name = "Chronicler (Archivist)"
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/storage/keyring/archivist
	beltr = /obj/item/book/granter/spellbook/apprentice
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/silver/noc
	backpack_contents = list(
		/obj/item/textbook = 1,
		/obj/item/natural/feather = 1
	)

/datum/outfit/archivist/chronicler/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.dna?.species?.id == SPEC_ID_DWARF)
		shirt = /obj/item/clothing/shirt/tunic/colored/blue
		pants = /obj/item/clothing/pants/tights/colored/black
	else
		if(equipped_human.gender == FEMALE)
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black
		else
			shirt = /obj/item/clothing/shirt/undershirt/puritan
			armor = /obj/item/clothing/shirt/robe/archivist
			pants = /obj/item/clothing/pants/tights/colored/black

/datum/job/advclass/archivist/dreamwatcher //Not a Magician nor an Acolyte, but something more, blessed by Noc since they were born, being capable of Visions and Feelings through dreams, they can feel the highest god influence or and get a hint about any of the active antags.
	title = "Dreamwatcher"
	tutorial = "Your dreams have always been vivid, filled with colors, voices, and shadows that seemed to watch. As a child, you feared them. As an adult, you began to listen. The Church speaks of Noc as the keeper of magic, but to you, he is something deeper: a silent guide whose truths are not written in scripture, but in sleep. Over time, you learned to echo those truths in your own way, through murmured lullabies, whispered verses, and songs shaped from silence."
	outfit = /datum/outfit/archivist/dreamwatcher
	category_tags = list(CTAG_ARCHIVIST)

	jobstats = list(
		STATKEY_INT = 4, //Nocblessed status bonus already grants +3 int and +2 perception
		STATKEY_PER = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)

	skills = list(
		/datum/skill/misc/reading = 6,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/labor/mathematics = 4
	)

	traits = list(
		TRAIT_DREAM_WATCHER,
		TRAIT_EMPATH
	)

/datum/job/advclass/archivist/dreamwatcher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.apply_status_effect(/datum/status_effect/buff/nocblessed)

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)

/datum/outfit/archivist/dreamwatcher
	name = "Dreamwatcher (Archivist)"
	armor = /obj/item/clothing/shirt/robe/colored/black
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/archivist
	wrists = /obj/item/clothing/wrists/nocwrappings
	neck = /obj/item/clothing/neck/psycross/silver/noc
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
	)
