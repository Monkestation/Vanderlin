/datum/migrant_role/inquisitor
	name = "Episcopal Inquisitor"
	greet_text = "These lands have forfeited Psydon. You have come to restore the True faith to these people and tear out the rot festering within."
	migrant_job = /datum/job/migrant/specialinquisitor

/datum/job/migrant/specialinquisitor
	title = "Episcopal Inquisitor"
	tutorial = "These lands have forfeited Psydon. You have come to restore the True faith to these people and tear out the rot festering within."
	outfit = /datum/outfit/specialinquisitor
	antag_role = /datum/antagonist/purishep
	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)
	allowed_races = list(SPEC_ID_HUMEN)
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	jobstats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_END = 1,
	)

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/riding = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/combat/firearms = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_NOBLE,
		TRAIT_MEDIUMARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_INQUISITION,
	)

	languages = list(/datum/language/oldpsydonic)

/datum/job/migrant/specialinquisitor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
	add_verb(spawned, /mob/living/carbon/human/proc/faith_test)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/reading/confessional)
	spawned.add_spell(/datum/action/cooldown/spell/undirected/call_bird/inquisitor)

	var/datum/species/species = spawned.dna?.species
	if(!species)
		return
	species.native_language = "Old Psydonic"
	species.accent_language = species.get_accent(species.native_language)

/datum/outfit/specialinquisitor
	name = "Episcopal Inquisitor (Migrant Wave)"
	wrists = /obj/item/clothing/neck/psycross/silver
	neck = /obj/item/clothing/neck/bevor
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	shoes = /obj/item/clothing/shoes/otavan/inqboots
	pants = /obj/item/clothing/pants/trou/leather
	backr = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/leather/inqhat
	gloves = /obj/item/clothing/gloves/leather/otavan/inqgloves
	beltr = /obj/item/storage/belt/pouch/coins/rich
	beltl = /obj/item/weapon/sword/rapier
	mask = /obj/item/clothing/face/spectacles/inqglasses
	armor = /obj/item/clothing/armor/medium/scale/inqcoat

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/silver,
		/obj/item/flashlight/flare/torch/lantern/copper,
	)

/datum/migrant_role/crusader
	name = "Episcopal Crusader"
	greet_text = "Crusader of the true faith, you came from Grenzelhoft under the command of the Inquisitor. Obey them as they lead you to smite the heathens."
	migrant_job = /datum/job/migrant/inquisition_crusader

/datum/job/migrant/inquisition_crusader
	title = "Episcopal Crusader"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft under the command of the Inquisitor. Obey them as they lead you to smite the heathens."
	allowed_races = RACES_PLAYER_GRENZ
	is_recognized = TRUE
	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)
	outfit = /datum/outfit/inquisition_crusader
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	jobstats = list(
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1,
	)

	skills = list(
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/shields = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/craft/cooking = 1,
	)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_INQUISITION,
	)

	languages = list(/datum/language/oldpsydonic)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/inquisition_crusader/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.gender == FEMALE)
		spawned.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	else
		spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)

	if(!istype(spawned.patron, /datum/patron/psydon)) // don't overwrite extremist psydon
		spawned.set_patron(/datum/patron/psydon)

	var/datum/species/species = spawned.dna?.species
	if(!species)
		return
	species.native_language = "Old Psydonic"
	species.accent_language = species.get_accent(species.native_language)

/datum/outfit/inquisition_crusader
	name = "Episcopal Crusader (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/heavy/crusader
	neck = /obj/item/clothing/neck/coif/cloth
	armor = /obj/item/clothing/armor/chainmail/hauberk
	cloak = /obj/item/clothing/cloak/cape/crusader
	gloves = /obj/item/clothing/gloves/chain
	shirt = /obj/item/clothing/shirt/tunic/colored/random
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/silver
	wrists = /obj/item/clothing/neck/psycross/silver
	cloak = /obj/item/clothing/cloak/stabard/crusader
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1)

/datum/outfit/inquisition_crusader/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == FEMALE)
		head = /obj/item/clothing/head/helmet/heavy/crusader/t
		cloak = /obj/item/clothing/cloak/stabard/crusader/t
		backl = /obj/item/storage/backpack/satchel/black
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		beltl = /obj/item/weapon/knife/dagger/silver
		beltr = /obj/item/ammo_holder/quiver/bolts

/datum/migrant_wave/crusade
	name = "The Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_one
	weight = 5
	max_spawns = 1
	roles = list(
		/datum/migrant_role/inquisitor = 1,
		/datum/migrant_role/crusader = 4)
	greet_text = "These heathens, they have forsaken the teaching of everything that is good. We shan't let them insults the true God no more. The Inquisitor will lead us to make sure of that."

/datum/migrant_wave/crusade_down_one
	name = "The Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/inquisitor = 1,
		/datum/migrant_role/crusader = 3)
	greet_text = "These heathens, they have forsaken the teaching of everything that is good. We shan't let them insults the true God no more. The Inquisitor will lead us to make sure of that."

/datum/migrant_wave/crusade_down_two
	name = "The Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/inquisitor = 1,
		/datum/migrant_role/crusader = 2)
	greet_text = "These heathens, they have forsaken the teaching of everything that is good. We shan't let them insults the true God no more. The Inquisitor will lead us to make sure of that."

/datum/migrant_wave/crusade_down_three
	name = "The Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/inquisitor = 1,
		/datum/migrant_role/crusader = 1)
	greet_text = "These heathens, they have forsaken the teaching of everything that is good. We shan't let them insults the true God no more. The Inquisitor will lead us to make sure of that."

/datum/migrant_wave/crusade_down_four
	name = "The One-Man Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/inquisitor = 1)
	greet_text = "These heathens, they have forsaken the teaching of everything that is good. I shan't let them insult the true God no more. I will make sure of that."
