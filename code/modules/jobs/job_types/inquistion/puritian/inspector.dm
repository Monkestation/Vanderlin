/datum/attribute_holder/sheet/job/inspector
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_SPEED = 3,
		STAT_INTELLIGENCE = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/combat/firearms = 40,
	)

/datum/attribute_holder/sheet/job/retribution
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40)
	)

/datum/attribute_holder/sheet/job/daybreak
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(40, 40)
	)

/datum/attribute_holder/sheet/job/sanctum
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(40, 40)
	)

/datum/attribute_holder/sheet/job/retribution
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40)
	)
/datum/job/advclass/puritan/inspector
	title = "Inquisitor"
	tutorial = "The head of the Ordo Venatari, your lessons are of a subtle touch and a light step. A silver dagger in the right place at the right time is all that is needed. Preparation is key, and this is something you impart on your students. Be always ready, be always waiting, and always be vigilant."
	outfit = /datum/outfit/inquisitor/inspector
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/adept)
	category_tags = list(CTAG_PURITAN)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_MEDIUMARMOR,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PURITAN,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
		TRAIT_RECOGNIZED,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/inspector

/datum/job/advclass/puritan/inspector/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	GLOB.inquisition.add_member_to_position(spawned, GLOB.inquisition.venatari, 100)

/datum/job/advclass/puritan/inspector/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/gear = list(
		"Retribution (Rapier)",
		"Daybreak (Whip)",
		"Sanctum (Halberd)",
		"Remembrance (Long Sword)",
	)
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.", gear)
	switch(weapon_choice)
		if("Retribution (Rapier)")
			spawned.put_in_hands(new /obj/item/weapon/sword/rapier/psy/relic(spawned), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/retribution)

		if("Daybreak (Whip)")
			spawned.put_in_hands(new /obj/item/weapon/whip/psydon/relic(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/daybreak)

		if("Sanctum (Halberd)")
			spawned.put_in_hands(new /obj/item/weapon/polearm/halberd/psydon/relic(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/sanctum)

		if("Remembrance (Long Sword)")
			spawned.put_in_hands(new /obj/item/weapon/sword/long/psydon/relic(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/retribution)

	// Enhancement selection
	var/list/enhancements = list(
		"Auxiliary Adrenal Glands - Pain Resist",
		"Controlled Atrophy - Rapid Movement",
		"Formikrag Liver - Reversed Toxin Damage",
		"Goblin Eyes - Nightvision",
		"Greenskin Hands - Strong Grip",
		"Inhumen Stomach - Enhanced Endurance",
		"Leviathanian Membrane - No Terrain Slowdown",
		"Nerve Staple - No Mood",
		"Nightmare Ward - No Sleep and Anti-Scrying",
		"Serpentine Glands - Thermal Vision and Venom")
	//only four options
	enhancements = shuffle(enhancements)
	enhancements.Cut(4, 0)
	enhancements += "Disguise Kit - Deceiving Meekness" //Always give this option
	var/enhancement_choice = browser_input_list(spawned, "CHOOSE YOUR ENHANCEMENT.", "IN THE NAME OF PSYDON.", enhancements)

	switch(enhancement_choice)
		if("Auxiliary Adrenal Glands - Pain Resist")
			ADD_TRAIT(spawned, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/adrenal)
		if("Controlled Atrophy - Rapid Movement")
			ADD_TRAIT(spawned, TRAIT_HOLLOWBONES, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/atrophy)
		if("Formikrag Liver - Reversed Toxin Damage")
			ADD_TRAIT(spawned, TRAIT_TOXINLOVER, TRAIT_GENERIC)
			var/obj/item/organ/stomach/stomach = spawned.getorganslot(ORGAN_SLOT_STOMACH)
			if(stomach)
				stomach.Remove(spawned,1)
				QDEL_NULL(stomach)
			stomach = new /obj/item/organ/stomach/acid_spit
			stomach.Insert(spawned)
		if("Goblin Eyes - Nightvision")
			var/obj/item/organ/eyes/eyes = spawned.getorganslot(ORGAN_SLOT_EYES)
			if(eyes)
				eyes.Remove(spawned,1)
				QDEL_NULL(eyes)
			eyes = new /obj/item/organ/eyes/night_vision/nightmare
			eyes.Insert(spawned)
		if("Greenskin Hands - Strong Grip")
			ADD_TRAIT(spawned, TRAIT_STRONG_GRABBER, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/greenskin)
		if("Inhumen Stomach - Enhanced Endurance")
			ADD_TRAIT(spawned, TRAIT_NASTY_EATER, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/stomach)
		if("Leviathanian Membrane - No Terrain Slowdown")
			ADD_TRAIT(spawned, TRAIT_WEBWALK, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_BRUSHWALK, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_SWIMMER, TRAIT_GENERIC)
		if("Nerve Staple - No Mood")
			ADD_TRAIT(spawned, TRAIT_NOMOOD, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/nerve)
		if("Nightmare Ward - No Sleep and Anti-Scrying")
			ADD_TRAIT(spawned, TRAIT_NOSLEEP, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_NOENERGY, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_ANTISCRYING, TRAIT_GENERIC)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/confessor/nightmare)
		if("Disguise Kit - Deceiving Meekness")
			ADD_TRAIT(spawned, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
			var/obj/item/harlequin_disguise_kit/kit = new(get_turf(spawned))
			spawned.put_in_hands(kit)
		if("Serpentine Glands - Thermal Vision and Venom")
			ADD_TRAIT(spawned, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_POISONBITE, TRAIT_GENERIC)


/datum/outfit/inquisitor/inspector
	name = "Inspector (Herr Prafekt)"
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/otavan/inqboots
	pants = /obj/item/clothing/pants/tights/colored/black
	backr =  /obj/item/storage/backpack/satchel/otavan
	backl = /obj/item/gun/ballistic/bow/cross
	beltr = /obj/item/ammo_holder/quiver/bolts
	head = /obj/item/clothing/head/leather/inqhat
	mask = /obj/item/clothing/face/spectacles/inq/spawnpair
	gloves = /obj/item/clothing/gloves/leather/otavan
	wrists = /obj/item/clothing/neck/psycross/silver
	ring = /obj/item/clothing/ring/signet/silver
	armor = /obj/item/clothing/armor/medium/scale/inqcoat/armored
	backpack_contents = list(
		/obj/item/storage/keyring/inquisitor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/weapon/knife/dagger/silver/psydon,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
	)
