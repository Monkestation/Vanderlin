/datum/job/advclass/mercenary/zalad
	title = "Red Sands"
	tutorial = "A cutthroat from Zalad lands, you've headed into foreign lands to make even greater coin than you had prior."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_RAKSHARI,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_DROW,\
		SPEC_ID_AASIMAR,\
		SPEC_ID_HALF_ORC,\
	)
	outfit = /datum/outfit/mercenary/zalad
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg' //Forgive me, Combat_DesertRider, I'm sorry, I'll miss you.
	languages = list(/datum/language/zalad)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2
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
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_DUALWIELDER
	)

/datum/job/advclass/mercenary/zalad/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 1
	spawned.adjust_skillrank(/datum/skill/combat/shields, pick(0,1,1))

	// Set native language for specific species
	if(spawned.dna?.species)
		var/datum/species/species = spawned.dna.species
		if(species.id == SPEC_ID_HUMEN)
			species.native_language = "Zalad"
			species.accent_language = species.get_accent(species.native_language)
		else if(species.id in list(SPEC_ID_HALF_ELF, SPEC_ID_HALF_DROW))
			if(species.native_language == "Imperial")
				species.native_language = "Zalad"
				species.accent_language = species.get_accent(species.native_language)

/datum/outfit/mercenary/zalad
	name = "Red Sands (Mercenary)"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/helmet/sallet/zalad
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/mercenary/shalal
	armor = /obj/item/clothing/armor/brigandine/coatplates
	beltr = /obj/item/weapon/sword/long/rider
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
