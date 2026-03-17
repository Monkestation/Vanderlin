/datum/migrant_role/inquisitor
	name = "Episcopal Inquisitor"
	greet_text = "These lands have forfeited Psydon. You have come to restore the True faith to these people and tear out the rot festering within."
	migrant_job = /datum/job/migrant/specialinquisitor

/datum/attribute_holder/sheet/job/migrant/specialinquisitor
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 2,
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/combat/firearms = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/specialinquisitor
	title = "Episcopal Inquisitor"
	tutorial = "These lands have forfeited Psydon. You have come to restore the True faith to these people and tear out the rot festering within."
	outfit = /datum/outfit/specialinquisitor
	antag_role = /datum/antagonist/purishep
	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)
	allowed_races = list(SPEC_ID_HUMEN)
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/specialinquisitor

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
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

/datum/attribute_holder/sheet/job/migrant/inquisition_crusader
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/cooking = 10,
	)

/datum/job/migrant/inquisition_crusader
	title = "Episcopal Crusader"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft under the command of the Inquisitor. Obey them as they lead you to smite the heathens."
	allowed_races = RACES_PLAYER_GRENZ
	is_recognized = TRUE
	allowed_patrons = list(/datum/patron/psydon, /datum/patron/psydon/extremist)
	outfit = /datum/outfit/inquisition_crusader
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/inquisition_crusader

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
		spawned.adjust_skill_level(/datum/attribute/skill/combat/crossbows, 10)
		spawned.adjust_skill_level(/datum/attribute/skill/combat/knives, 10)
	else
		spawned.adjust_skill_level(/datum/attribute/skill/combat/swords, 10)
		spawned.adjust_skill_level(/datum/attribute/skill/combat/shields, 10)

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
