/datum/migrant_role/rockhill/mayor
	name = "Mayor of Rockhill"
	greet_text = "You are the mayor of Rockhill, you've come to Vanderlin to discuss important matters with their Monarch."
	migrant_job = /datum/job/migrant/rockhill/mayor

/datum/attribute_holder/sheet/job/migrant/mayor
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 2,
		STAT_FORTUNE = 2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/rockhill/mayor
	title = "Mayor of Rockhill"
	tutorial = "You are the mayor of Rockhill, you've come to Vanderlin to discuss important matters with their Monarch."
	outfit = /datum/outfit/rockhill/mayor
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE
	honorary = "Mayor"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/mayor

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/rockhill/mayor
	name = "Mayor of Rockhill (Migrant Wave)"
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

/datum/attribute_holder/sheet/job/migrant/knight
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/rockhill/knight
	title = "Knight of Rockhill"
	tutorial = "You are a Knight of Rockhill, the notable of said town has taken the journey to your liege, you are to ensure their safety."
	outfit = /datum/outfit/rockhill/knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	honorary = "Sir"
	honorary_f = "Dame"


	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/knight

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
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

/datum/outfit/rockhill/knight
	name = "Knight of Rockhill (Migrant Wave)"
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

/datum/attribute_holder/sheet/job/migrant/rockhill_serjeant_at_arms
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 30,
	)

/datum/attribute_holder/sheet/job/migrant/rockhill_serjeant_at_arms/old
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_INTELLIGENCE = 4,
		STAT_ENDURANCE = 4,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 30,
	)

/datum/job/migrant/rockhill/serjeant_at_arms
	title = "Rockhill Serjeant"
	tutorial = "The Mayor of Rockhill has conscripted you and your mens to go see the rulers of Vanderlin."
	outfit = /datum/outfit/rockhill/serjeant_at_arms
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	honorary = "Serjeant"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/rockhill_serjeant_at_arms
	attribute_sheet_old = /datum/attribute_holder/sheet/job/migrant/rockhill_serjeant_at_arms/old

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/outfit/rockhill/serjeant_at_arms
	name = "Rockhill Serjeant (Migrant Wave)"
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
