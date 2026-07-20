/datum/migrant_role/gaoler
	name = "Gaoler"
	greet_text = "The lords of Vanderlin sent you to repatriate some prisoners that were in a distant prison, you are now on your way back."
	migrant_job = /datum/job/migrant/gaoler

/datum/attribute_holder/sheet/job/migrant/gaoler
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/traps = 30,
	)


/datum/job/migrant/gaoler
	title = "Gaoler"
	tutorial = "The lords of Vanderlin sent you to repatriate some prisoners that were in a distant prison, you are now on your way back."
	outfit = /datum/outfit/gaoler
	is_foreigner = FALSE
	allowed_races = list(
		SPEC_ID_HUMEN,
		SPEC_ID_ELF,
		SPEC_ID_HALF_ELF,
		SPEC_ID_DWARF,
		SPEC_ID_TIEFLING,
		SPEC_ID_DROW,
		SPEC_ID_HALF_DROW,
		SPEC_ID_AASIMAR,
		SPEC_ID_HALF_ORC,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/gaoler

	cmode_music = 'sound/music/cmode/nobility/CombatDungeoneer.ogg'
	voicepack_m = /datum/voicepack/male/warrior

/datum/job/migrant/gaoler/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

/datum/outfit/gaoler
	name = "Gaoler (Migrant Wave)"
	head = /obj/item/clothing/head/menacing
	neck = /obj/item/storage/belt/pouch/coins/poor
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/stabard/colored/dungeon
	armor = /obj/item/clothing/armor/cuirass/iron/rust
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/whip/antique
	beltl = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/keyring/dungeoneer = 1,
		/obj/item/rope/chain = 1,
	)

/datum/migrant_role/mig_prisoner
	name = JOB_PRISONER
	greet_text = "You fled Vanderlin and took refuge another kingdom, yet the lords over there caught you and thus handed you over to those who sought you before."
	migrant_job = /datum/job/migrant/mig_prisoner

/datum/attribute_holder/sheet/job/migrant/mig_prisoner
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = -1,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = -1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/misc/riding = 10,
	)

/datum/job/migrant/mig_prisoner
	title = "Prisoner (Migrant Wave)"
	tutorial = "You fled Vanderlin and took refuge another kingdom, yet the lords over there caught you and thus handed you over to those who sought you before."
	outfit = /datum/outfit/mig_prisoner
	is_foreigner = FALSE

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/mig_prisoner

	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/mig_prisoner
	name = "Convoy Prisoner"
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	mask = /obj/item/clothing/face/facemask/prisoner

/datum/migrant_role/prisoner_guard
	name = "Convoy Guard"
	greet_text = "You are a part of a convoy returning prisoners to Vanderlin. Obey the gaoler and ensure the prisoners get back to the dungeons."
	migrant_job = /datum/job/migrant/mig_guard

/datum/attribute_holder/sheet/job/migrant/mig_guard
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/migrant/mig_guard
	title = "Convoy Guard"
	tutorial = "You are a part of a convoy returning prisoners to Vanderlin. Obey the gaoler and ensure the prisoners get back to the dungeons."
	outfit = /datum/outfit/mig_guard
	is_foreigner = FALSE
	allowed_races = list(
		SPEC_ID_HUMEN,
		SPEC_ID_ELF,
		SPEC_ID_HALF_ELF,
		SPEC_ID_DWARF,
		SPEC_ID_TIEFLING,
		SPEC_ID_DROW,
		SPEC_ID_HALF_DROW,
		SPEC_ID_AASIMAR,
		SPEC_ID_HALF_ORC,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/mig_guard

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/migrant/mig_guard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/mig_guard
	name = "Convoy Guard"
	armor = /obj/item/clothing/armor/cuirass
	shirt = /obj/item/clothing/armor/chainmail
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/nasal
	backr = /obj/item/weapon/shield/wood
	beltr = /obj/item/weapon/sword/scimitar/messer
	beltl = /obj/item/weapon/mace
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	backpack_contents = list(
		/obj/item/storage/keyring/guard,
		/obj/item/rope/chain = 1,
	)

/datum/migrant_wave/prisoner_convoy
	name = "The Prisoners' Convoy"
	max_spawns = 3
	shared_wave_type = /datum/migrant_wave/prisoner_convoy
	downgrade_wave = /datum/migrant_wave/prisoner_convoy_down
	weight = 45
	roles = list(
		/datum/migrant_role/gaoler = 1,
		/datum/migrant_role/prisoner_guard = 2,
		/datum/migrant_role/mig_prisoner = 4,
	)
	greet_text = "Nobody escapes the rule of Vanderlin's monarchs. Some fled to another kingdom and got caught, they are now on their way back."

/datum/migrant_wave/prisoner_convoy_down
	name = "The Prisoners' Convoy"
	shared_wave_type = /datum/migrant_wave/prisoner_convoy
	downgrade_wave = /datum/migrant_wave/prisoner_convoy_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/gaoler = 1,
		/datum/migrant_role/prisoner_guard = 1,
		/datum/migrant_role/mig_prisoner = 3,
	)
	greet_text = "Nobody escapes the rule of Vanderlin's monarchs. Some fled to another kingdom and got caught, they are now on their way back."

/datum/migrant_wave/prisoner_convoy_down_two
	name = "The Prisoner Convoy"
	shared_wave_type = /datum/migrant_wave/prisoner_convoy
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/gaoler = 1,
		/datum/migrant_role/mig_prisoner = 1,
	)
	greet_text = "Nobody escapes the rule of Vanderlin's monarchs. Some fled to another kingdom and got caught, they are now on their way back."
