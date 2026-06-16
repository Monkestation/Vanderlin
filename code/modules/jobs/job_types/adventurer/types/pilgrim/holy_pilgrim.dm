/datum/attribute_holder/sheet/job/pilgrim/holy_pilgrim
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_FORTUNE = 1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/magic/holy = 30,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/eora
	raw_attribute_list = list(
		/datum/attribute/skill/misc/music = 20
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/noc
	raw_attribute_list = list(
		/datum/attribute/skill/labor/mathematics = 20
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/pestra
	raw_attribute_list = list(
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/alchemy = 10
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/dendor
	raw_attribute_list = list(
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/labor/taming = 10
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/abyssor
	raw_attribute_list = list(
		/datum/attribute/skill/labor/fishing = 20,
		/datum/attribute/skill/misc/swimming = 20
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/ravox
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(10, 20),
		/datum/attribute/skill/combat/whipsflails = list(10, 20),
		/datum/attribute/skill/combat/axesmaces = list(10, 20),
		/datum/attribute/skill/combat/polearms = list(10, 20)
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/xylix
	raw_attribute_list = list(
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/music = 30
	)

/datum/attribute_holder/sheet/job/holy_pilgrim/malum
	raw_attribute_list = list(
		/datum/attribute/skill/craft/blacksmithing = 20,
		/datum/attribute/skill/craft/smelting = 20,
		/datum/attribute/skill/craft/armorsmithing = 10,
		/datum/attribute/skill/craft/weaponsmithing = 10,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/craft/masonry = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/pilgrim/holy_pilgrim
	title = "Holy Pilgrim"
	tutorial = "You are a wandering pilgrim of the holy orders of the ten, you have been blessed with some miracles of your god and given divine purpose in the lands you travel to. You do not walk alone."
	category_tags = list(CTAG_PILGRIM)
	allowed_patrons = ALL_TEMPLE_PATRONS
	total_positions = 4
	outfit = /datum/outfit/pilgrim/holy_pilgrim
	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/holy_pilgrim
	exp_types_granted = list(EXP_TYPE_CLERIC)
	languages = list(/datum/language/celestial)

/datum/job/advclass/pilgrim/holy_pilgrim/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
		if(/datum/patron/divine/eora)
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_EMPATH, TRAIT_GENERIC)
			spawned.virginity = FALSE
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/eora)
			spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
		if(/datum/patron/divine/noc)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/noc)
			var/language = pickweight(list("Dwarvish" = 1, "Elvish" = 1, "Hellspeak" = 1, "Zaladin" = 1, "Orcish" = 1,))
			switch(language)
				if("Dwarvish")
					spawned.grant_language(/datum/language/dwarvish)
					to_chat(spawned,span_info("I learned the tongue of the mountain dwellers."))
				if("Elvish")
					spawned.grant_language(/datum/language/elvish)
					to_chat(spawned,span_info("I learned the tongue of the primordial species."))
				if("Hellspeak")
					spawned.grant_language(/datum/language/hellspeak)
					to_chat(spawned,span_info("I learned the tongue of the hellspawn."))
				if("Zaladin")
					spawned.grant_language(/datum/language/zalad)
					to_chat(spawned,span_info("I learned the tongue of Zaladin."))
				if("Orcish")
					spawned.grant_language(/datum/language/orcish)
					to_chat(spawned,span_info("I learned the tongue of the savages in my time."))
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/pestra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/pestra)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/dendor)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/dendor)
			ADD_TRAIT(spawned, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/church/CombatDendor.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/abyssor)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
		if(/datum/patron/divine/ravox)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/xylix)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/xylix)
			spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
		if(/datum/patron/divine/malum)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holy_pilgrim/malum)
			ADD_TRAIT(spawned, TRAIT_MALUMFIRE, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_cleric()
		devotion.grant_to(spawned)

/datum/outfit/pilgrim/holy_pilgrim
	name = "Holy Pilgrim (Pilgrim)"
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/hardtack = 1
	)

/datum/outfit/pilgrim/holy_pilgrim/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/robecolor = "#a1a17a"
	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
			robecolor = "#e7a962"
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/psycross/silver/divine/necra
			robecolor = "#2a2459"
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/psycross/silver/divine/eora
			robecolor = "#a95063"
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/silver/divine/noc
			robecolor = "#4e72a1"
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/divine/pestra
			robecolor = "#517b27"
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/divine/dendor
			robecolor = "#412938"
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/silver/divine/abyssor
			robecolor = "#50090f"
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/divine/ravox
			robecolor = "#2c232d"
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/psycross/silver/divine/xylix
			robecolor = "#7e632c"
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/psycross/silver/divine/malum
			robecolor = "#3d4139"
		else //Enlightened Centrist
			neck = /obj/item/clothing/neck/psycross/silver
	var/obj/item/clothing/shirt/robe/colored/pilgrimrobe = new(get_turf(equipped_human))
	pilgrimrobe.color = robecolor
	equipped_human.equip_to_slot(pilgrimrobe, ITEM_SLOT_ARMOR, TRUE)
