/datum/migrant_role/rockhill/mayor
	name = "Mayor of Rockhill"
	greet_text = "You are the mayor of Rockhill, you've come to Vanderlin to discuss important matters with their Monarch."
	migrant_job = /datum/job/migrant/rockhill/mayor

/datum/job/migrant/rockhill/mayor
	title = "Mayor of Rockhill"
	tutorial = "You are the mayor of Rockhill, you've come to Vanderlin to discuss important matters with their Monarch."
	outfit = /datum/outfit/rockhill/mayor
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/riding = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/rockhill/mayor
	name = "Mayor of Rockhill"
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather/black
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet
	shoes = /obj/item/clothing/shoes/nobleboot
	pants = /obj/item/clothing/pants/tights/colored/black
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/armor/cuirass
	beltr = /obj/item/storage/belt/pouch/coins/rich
	gloves = /obj/item/clothing/gloves/leather/black
	beltl = /obj/item/weapon/sword/long

/datum/outfit/rockhill/mayor/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == FEMALE)
		head = /obj/item/clothing/head/courtierhat
		neck = /obj/item/storage/belt/pouch/coins/rich
		cloak = /obj/item/clothing/cloak/raincloak/furcloak
		beltr = /obj/item/weapon/sword/rapier
		ring = /obj/item/clothing/ring/silver
		shoes = /obj/item/clothing/shoes/nobleboot
		backr = /obj/item/storage/backpack/satchel
		backpack_contents = list(
			/obj/item/storage/belt/pouch/coins/rich = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
		)
		if(prob(66))
			armor = /obj/item/clothing/armor/gambeson/heavy/dress/alt
		else
			armor = /obj/item/clothing/armor/gambeson/heavy/dress

/datum/migrant_role/rockhill_knight
	name = "Knight of Rockhill"
	greet_text = "You are a Knight of Rockhill, the notable of said town has taken the journey to your liege, you are to ensure their safety."
	migrant_job = /datum/job/migrant/rockhill/knight

/datum/job/migrant/rockhill/knight
	title = "Knight of Rockhill"
	tutorial = "You are a Knight of Rockhill, the notable of said town has taken the journey to your liege, you are to ensure their safety."
	outfit = /datum/outfit/rockhill/knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
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
		/datum/skill/combat/unarmed = 3,
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

	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/rockhill/knight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(istype(spawned.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
		var/obj/item/clothing/S = spawned.cloak
		var/index = findtext(spawned.real_name, " ")
		if(index)
			index = copytext(spawned.real_name, 1,index)
		if(!index)
			index = spawned.real_name
		S.name = "knight tabard ([index])"

	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Sir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Dame"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

/datum/outfit/rockhill/knight
	name = "Knight of Rockhill"
	head = /obj/item/clothing/head/helmet
	gloves = /obj/item/clothing/gloves/plate
	pants = /obj/item/clothing/pants/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	neck = /obj/item/clothing/neck/bevor
	shirt = /obj/item/clothing/armor/chainmail
	armor = /obj/item/clothing/armor/plate/full
	shoes = /obj/item/clothing/shoes/boots/armor
	beltr = /obj/item/weapon/sword/long
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel/black

/datum/outfit/rockhill/knight/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(50))
		r_hand = /obj/item/weapon/polearm/eaglebeak/lucerne
	else
		r_hand = /obj/item/weapon/mace/goden/steel

/datum/migrant_role/rockhill/sergeant_at_arms
	name = "Rockhill Serjeant"
	greet_text = "The Mayor of Rockhill has conscripted you and your mens to go see the rulers of Vanderlin."
	migrant_job = /datum/job/migrant/rockhill/serjeant_at_arms

/datum/job/migrant/rockhill/serjeant_at_arms
	title = "Rockhill Serjeant"
	tutorial = "The Mayor of Rockhill has conscripted you and your mens to go see the rulers of Vanderlin."
	outfit = /datum/outfit/rockhill/serjeant_at_arms
	allowed_races = RACES_PLAYER_NONDISCRIMINATED

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 3,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/migrant/rockhill/serjeant_at_arms/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		var/list/old_stats = list(
			STATKEY_STR = 3,
			STATKEY_INT = 2,
			STATKEY_END = 2,
			STATKEY_PER = 1,
			STATKEY_SPD = 1,
		)
		spawned.adjust_stat_modifier_list(STATMOD_JOB, old_stats)

/datum/outfit/rockhill/serjeant_at_arms
	name = "Rockhill Serjeant"
	head = /obj/item/clothing/head/helmet/leather
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/half/vet
	shirt = /obj/item/clothing/shirt/undershirt/colored/guardsecond
	armor = /obj/item/clothing/armor/medium/scale
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/signal_horn = 1,
	)

/datum/migrant_role/footman_guard
	name = "Guardsmen of Rockhill"
	greet_text = "Your Serjeant has been ordered by the mayor of Rockhill to guard them as they visit the rulers of Vanderlin. Ensure they live."
	migrant_job = /datum/job/migrant/footman_bannerman/rockhill

/datum/job/migrant/footman_bannerman/rockhill
	title = "Guardsmen of Rockhill"
	tutorial = "Your Serjeant has been ordered by the mayor of Rockhill to guard them as they visit the rulers of Vanderlin. Ensure they live."
	is_foreigner = TRUE

/datum/migrant_wave/rockhill_wave
	name = "The Mayor's Visit"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	downgrade_wave = /datum/migrant_wave/rockhill_wave_down
	max_spawns = 1
	weight = 30
	roles = list(
		/datum/migrant_role/rockhill/mayor = 1,
		/datum/migrant_role/rockhill_knight = 1,
		/datum/migrant_role/rockhill/sergeant_at_arms = 1,
		/datum/migrant_role/footman_guard = 4
	)
	greet_text = "The Mayor has it, something must be discussed with the rulers of Vanderlin which is why we're on our way over there."

/datum/migrant_wave/rockhill_wave_down
	name = "The Mayor's Visit"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	downgrade_wave = /datum/migrant_wave/rockhill_wave_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rockhill/mayor = 1,
		/datum/migrant_role/rockhill_knight = 1,
		/datum/migrant_role/rockhill/sergeant_at_arms = 1,
		/datum/migrant_role/footman_guard = 2
	)
	greet_text = "The Mayor has it, something must be discussed with the rulers of Vanderlin which is why we're on our way over there."

/datum/migrant_wave/rockhill_wave_down_one
	name = "The Mayor's visit"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rockhill/mayor = 1,
		/datum/migrant_role/rockhill_knight = 1,
		/datum/migrant_role/footman_guard = 2
	)
	greet_text = "The Mayor has it, something must be discussed with the rulers of Vanderlin which is why we're on our way over there."
