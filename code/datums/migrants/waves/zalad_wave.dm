/datum/migrant_role/zalad/emir
	name = "Zalad Emir"
	greet_text = "An Emir hailing from the Deshret, here on business for the Mercator's Guild."
	migrant_job = /datum/job/migrant/zalad_migration/emir

/datum/job/migrant/zalad_migration/emir
	title = "Zalad Emir"
	tutorial = "An Emir hailing from the Deshret, here on business for the Mercator's Guild."
	outfit = /datum/outfit/zalad_migration/emir
	allowed_sexes = list(MALE)
	allowed_races = RACES_PLAYER_ZALADIN
	is_recognized = TRUE

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/music = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/labor/mathematics = 3,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird/zalad
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE,
	)

	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/job/migrant/zalad_migration/emir/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	spawned.real_name = "Emir [prev_real_name]"
	spawned.name = "Emir [prev_name]"

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF && spawned.dna.species.native_language == "Imperial")
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/zalad_migration/emir
	name = "Zalad Emir (Migrant Wave)"
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/leather
	head = /obj/item/clothing/head/crown/circlet
	cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	armor = /obj/item/clothing/armor/gambeson/arming
	belt = /obj/item/storage/belt/leather/shalal
	beltl = /obj/item/weapon/sword/sabre/shalal
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/gold/guild_mercator
	shirt = /obj/item/clothing/shirt/tunic/colored/purple
	pants = /obj/item/clothing/pants/trou/leather
	neck = /obj/item/clothing/neck/shalal/emir
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/veryrich)

/datum/outfit/zalad_migration/emir/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/armor/leather/jacket/silk_coat
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/black

/datum/migrant_role/zalad/amirah
	name = "Zalad Amirah"
	greet_text = "An Amirah hailing from Deshret, here on business for the Mercator's Guild to the Isle of the Enigma."
	migrant_job = /datum/job/migrant/zalad_migration/amirah

/datum/job/migrant/zalad_migration/amirah
	title = "Zalad Amirah"
	tutorial = "An Amirah hailing from Deshret, here on business for the Mercator's Guild to the Isle of the Enigma."
	outfit = /datum/outfit/zalad_migration/amirah
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_PLAYER_ZALADIN
	is_recognized = TRUE

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/music = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/craft/cooking = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/labor/mathematics = 3,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird/zalad
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE,
	)

	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/job/migrant/zalad_migration/amirah/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name

	spawned.real_name = "Amirah [prev_real_name]"
	spawned.name = "Amirah [prev_name]"

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF && spawned.dna.species.native_language == "Imperial")
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/zalad_migration/amirah
	name = "Zalad Amirah (Migrant Wave)"
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/leather
	head = /obj/item/clothing/head/crown/nyle
	cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	armor = /obj/item/clothing/armor/leather/jacket/silk_coat
	belt = /obj/item/storage/belt/leather/shalal
	beltl = /obj/item/weapon/sword/sabre/shalal
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/gold/guild_mercator
	shirt = /obj/item/clothing/shirt/dress/silkdress/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	neck = /obj/item/clothing/neck/shalal/emir
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/veryrich = 1,
		/obj/item/reagent_containers/glass/bottle/wine = 1,
	)

/datum/migrant_role/zalad/furusiyya
	name = "Furusiyya"
	greet_text = "You are a furusiyya, pledged to the Emir and the Amirah. Make sure they come out alive of that place."
	migrant_job = /datum/job/migrant/zalad_migration/furusiyya

/datum/job/migrant/zalad_migration/furusiyya
	title = "Furusiyya"
	tutorial = "You are a furusiyya, pledged to the Emir and the Amirah. Make sure they come out alive of that place."
	outfit = /datum/outfit/zalad_migration/furusiyya
	allowed_sexes = list(MALE)
	allowed_races = RACES_PLAYER_ZALADIN
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
	)

	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/job/migrant/zalad_migration/furusiyya/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF && spawned.dna.species.native_language == "Imperial")
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/zalad_migration/furusiyya
	name = "Furusiyya (Migrant Wave)"
	pants = /obj/item/clothing/pants/tights/colored/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/zaladplate
	gloves = /obj/item/clothing/gloves/rare/zaladplate
	belt = /obj/item/storage/belt/leather/shalal
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	armor = /obj/item/clothing/armor/rare/zaladplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/zaladplate
	wrists = /obj/item/clothing/wrists/bracers
	neck = /obj/item/clothing/neck/chaincoif

/datum/outfit/zalad_migration/furusiyya/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	var/randy = rand(1,5)
	switch(randy)
		if(1 to 2)
			backr = /obj/item/weapon/polearm/halberd/bardiche
		if(3 to 4)
			backr = /obj/item/weapon/polearm/eaglebeak
		if(5)
			backr = /obj/item/weapon/polearm/spear/billhook

/datum/migrant_role/zalad_guard
	name = "Zalad Soldier"
	greet_text = "You are a slave soldier from Deshret, sent as an escort to the emirs on a foreign land, do not fail them."
	migrant_job = /datum/job/migrant/zalad_migration/zalad_guard

/datum/job/migrant/zalad_migration/zalad_guard
	title = "Zalad Soldier"
	tutorial = "You are a slave soldier from Deshret, sent as an escort to the emirs on a foreign land, do not fail them."
	outfit = /datum/outfit/zalad_migration/zalad_guard
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/lockpicking = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)
	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/job/migrant/zalad_migration/zalad_guard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/shields, pick(0,1,1), TRUE)

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF && spawned.dna.species.native_language == "Imperial")
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/zalad_migration/zalad_guard
	name = "Zalad Soldier (Migrant Wave)"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/helmet/sallet/zalad
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	armor = /obj/item/clothing/armor/brigandine/coatplates
	beltr = /obj/item/weapon/sword/long/rider
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor)

/datum/migrant_role/qatil
	name = "Qatil"
	greet_text = "You are the Amirah's confident and most loyal protector, you shan't let them die in these wretched lands."
	migrant_job = /datum/job/migrant/zalad_migration/qatil

/datum/job/migrant/zalad_migration/qatil
	title = "Qatil"
	tutorial = "You are the Amirah's confident and most loyal protector, you shan't let them die in these wretched lands."
	outfit = /datum/outfit/zalad_migration/qatil
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	allowed_races = list(
		SPEC_ID_HUMEN,
		SPEC_ID_ELF,
		SPEC_ID_RAKSHARI,
		SPEC_ID_HALF_ELF,
		SPEC_ID_TIEFLING,
		SPEC_ID_DROW,
		SPEC_ID_HALF_DROW,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_END = 1,
	)

	skills = list(
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 2,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/craft/traps = 1,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)
	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

/datum/job/migrant/zalad_migration/qatil/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species)
		if(spawned.dna.species.id == SPEC_ID_HUMEN)
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)
		if(spawned.dna.species.id == SPEC_ID_HALF_ELF && spawned.dna.species.native_language == "Imperial")
			spawned.dna.species.native_language = "Zalad"
			spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/zalad_migration/qatil
	name = "Qatil (Migrant Wave)"
	pants = /obj/item/clothing/pants/trou/leather
	beltr = /obj/item/weapon/knife/dagger/steel/special
	shoes = /obj/item/clothing/shoes/shalal
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/neck/keffiyeh/colored/red
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor,
		/obj/item/lockpick,
	)

/datum/migrant_wave/zalad_wave
	name = "The Deshret Expedition"
	max_spawns = 1
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	weight = 25
	downgrade_wave = /datum/migrant_wave/zalad_wave_down
	roles = list(
		/datum/migrant_role/zalad/emir = 1,
		/datum/migrant_role/zalad/amirah = 1,
		/datum/migrant_role/zalad/furusiyya = 1,
		/datum/migrant_role/qatil = 1,
		/datum/migrant_role/zalad_guard = 2
	)
	greet_text = "The Mercator Guild sent you, respected Zaladins, to seek favorable business proposal within the Kingdom of Vanderlin."

/datum/migrant_wave/zalad_wave_down
	name = "The Deshret Expedition"
	max_spawns = 1
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/zalad/emir = 1,
		/datum/migrant_role/zalad/amirah = 1,
		/datum/migrant_role/zalad/furusiyya = 1,
		/datum/migrant_role/qatil = 1
	)
	greet_text = "The Mercator Guild sent you, respected Zaladins, to seek favorable business proposal within the Kingdom of Vanderlin. Unfortunately most of your guards died on the way here."
