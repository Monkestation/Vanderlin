/datum/attribute_holder/sheet/job/argent
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		STAT_STRENGTH = 1,
		STAT_FORTUNE = -1,
		/datum/attribute/skill/combat/crossbows = 35,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/firearms = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/cooking = 20
	)

/datum/attribute_holder/sheet/job/argent/knives
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/knives = list(33, 33)
	)

/datum/attribute_holder/sheet/job/argent/axesmaces
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/axesmaces = list(33, 33)
	)

/datum/attribute_holder/sheet/job/argent/swords
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(33, 33)
	)

/datum/attribute_holder/sheet/job/argent/polearms
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(33, 33)
	)

/datum/attribute_holder/sheet/job/argent/whipsflails
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(33, 33)
	)

/datum/job/advclass/sacrestant/argent
	title = "Argent"
	tutorial = "A trained member of the Ordo Venatari, you have passed every test, prepared for every circumstance, and devoted your body and being alike to Psydon and his righteous cause. Enhanced with powers from the very monsters you are driven to vanquish, you are ready to face, and surpass, all those who would seek to hide in the nite."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/argent
	category_tags = list(CTAG_INQUISITION)

	attribute_sheet = /datum/attribute_holder/sheet/job/argent

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
	)

	languages = list(/datum/language/oldpsydonic)

/datum/job/advclass/sacrestant/argent/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", 0, "Argent")

/datum/job/advclass/sacrestant/argent/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/weapons = list("Blessed Psydonic Dagger", "Psydonic Handmace", "Psydonic Shortsword", "Psydonic Handaxe", "Psydonic Whip", "Psydonic Flail", "Psydonic Spear")
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR WEAPON.", "TAKE UP PSYDON'S ARMS.", weapons)

	switch(weapon_choice)
		if("Psydonic Dagger")
			spawned.put_in_hands(new /obj/item/weapon/knife/dagger/silver/psydon(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/knife, ITEM_SLOT_BACK_R, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/knives)
		if("Psydonic Handmace")
			spawned.put_in_hands(new /obj/item/weapon/mace/cudgel/psy(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/axesmaces)
		if("Psydonic Shortsword")
			spawned.put_in_hands(new /obj/item/weapon/sword/short/psy(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/scabbard/sword, ITEM_SLOT_BACK_R, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/swords)
		if("Psydonic Handaxe")
			spawned.put_in_hands(new /obj/item/weapon/axe/psydon(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/axesmaces)
		if("Psydonic Whip")
			spawned.put_in_hands(new /obj/item/weapon/whip/psydon(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/whipsflails)
		if("Psydonic Flail")
			spawned.put_in_hands(new /obj/item/weapon/flail/psydon(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/whipsflails)
		if("Psydonic Spear")
			spawned.put_in_hands(new /obj/item/weapon/polearm/spear/psydon/noblessing(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/argent/polearms)

	var/helmets = list("Barbute", "Sallet", "Armet", "Bucket Helm")
	var/helmet_choice = browser_input_list(spawned, "CHOOSE YOUR HELMET.", "TAKE UP PSYDON'S HELMS.", helmets)

	switch(helmet_choice)
		if("Barbute")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/heavy/psydonbarbute, ITEM_SLOT_HEAD, TRUE)
		if("Sallet")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/heavy/psysallet, ITEM_SLOT_HEAD, TRUE)
		if("Armet")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/heavy/psydonhelm, ITEM_SLOT_HEAD, TRUE)
		if("Bucket Helm")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/heavy/psybucket, ITEM_SLOT_HEAD, TRUE)

	// Armor/archetype selection
	var/armors = list("Cuir-Bouilli Armor", "Psydonian Cuirass")
	var/armor_choice = browser_input_list(spawned, "CHOOSE YOUR ARMOR.", "TAKE UP PSYDON'S MANTLE.", armors)

	switch(armor_choice)
		if("Cuir-Bouilli Armor")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather/advanced, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/leather/studded/psyaltrist, ITEM_SLOT_ARMOR, TRUE)
		if("Psydonian Cuirass")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/pants/trou/leather/splint, ITEM_SLOT_PANTS, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/cuirass/psydon, ITEM_SLOT_ARMOR, TRUE)

	// Bolt selection
	var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage")
	var/boltchoice = browser_input_list(spawned, "CHOOSE YOUR MUNITIONS.", "TAKE UP PSYDON'S MISSILES.", quivers)

	switch(boltchoice)
		if("Bolts - Steel-Tipped")
			spawned.equip_to_slot_if_possible(new /obj/item/ammo_holder/quiver/bolts(get_turf(spawned)), ITEM_SLOT_BELT_L)
		if("Sunderbolts - Silver-Tipped, Halved Damage")
			spawned.equip_to_slot_if_possible(new /obj/item/ammo_holder/quiver/bolt/holy(get_turf(spawned)), ITEM_SLOT_BELT_L)

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

/datum/outfit/argent
	name = "Argent (Sacrestants)"
	cloak = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/neck/psycross/silver
	gloves = /obj/item/clothing/gloves/leather/otavan
	neck = /obj/item/clothing/neck/gorget
	backr = /obj/item/storage/backpack/satchel/otavan
	backl = /obj/item/gun/ballistic/bow/cross
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/pouch/coins/mid
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/psydonboots
	ring = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/key/inquisition = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/collar_detonator = 1,
	)
