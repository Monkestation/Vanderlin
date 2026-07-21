/datum/migrant_role/cadwyncrusader
	name = "Cadwyn Order Crusader"
	greet_text = "You have been sent by the Cadwyn Order to assist the local clergy in dealing with the growing influence of Z. Let no unholy creature stop you in this holy mission."
	migrant_job = /datum/job/migrant/cadwyncrusader

/datum/attribute_holder/sheet/job/migrant/cadwyncrusader
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20
	)

/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/astrata
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 40
	)

/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/ravox
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40
	)

/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/necra
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/craft/masonry = 20 //For making graves.
	)

/datum/job/migrant/cadwyncrusader
	title = "Cadwyn Order Crusader"
	tutorial = "You have been sent by the Cadwyn Order to assist the local clergy in dealing with the growing influence of Z. Let no unholy creature stop you in this holy mission."
	outfit = /datum/outfit/cadwyncrusader
	allowed_races = RACES_TEMPLAR
	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/divine/necra, /datum/patron/divine/ravox)
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	honorary = "Brother"
	honorary_f = "Sister"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/cadwyncrusader

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
	)

	languages = list(/datum/language/celestial)

/datum/job/migrant/cadwyncrusader/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats)
	. = ..()
	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

	if(ishumannorthern(spawned) && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/ravox)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/necra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwyncrusader/patron/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'

/datum/outfit/cadwyncrusader
	name = "Cadwyn Order Crusader"
	armor = /obj/item/clothing/armor/plate/silver
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	gloves = /obj/item/clothing/gloves/plate/cadwyn
	wrists = /obj/item/clothing/wrists/bracers
	belt = /obj/item/storage/belt/leather/black
	ring = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/outfit/cadwyncrusader/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/cadwyn/astrata
			cloak = /obj/item/clothing/cloak/cadwyn/astrata
			backr = /obj/item/weapon/polearm/halberd/silver
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/divine/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/cadwyn/ravox
			cloak = /obj/item/clothing/cloak/cadwyn/ravox
			beltr = /obj/item/weapon/sword/long/silver
			backr = /obj/item/weapon/shield/tower/metal
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/psycross/silver/divine/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/cadwyn/necra
			cloak = /obj/item/clothing/cloak/cadwyn/necra
			beltr = /obj/item/weapon/mace/silver
			backr = /obj/item/weapon/shield/tower/metal

/datum/migrant_role/cadwynsentinel
	name = "Cadwyn Order Sentinel"
	greet_text = "You are one of the rank and file soldiers of the Cadwyn Order. You have sent with your brothers sisters to assist the local clergy in dealing with the growing influence of Z. \
	Protect your brothers and sisters, and let no unholy creature stop you in your mission."
	migrant_job = /datum/job/migrant/cadwynsentinel

/datum/attribute_holder/sheet/job/migrant/cadwynsentinel
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/astrata
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 30
	)

/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/ravox
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 30
	)

/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/necra
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/craft/masonry = 20 //For making graves.
	)

/datum/job/migrant/cadwynsentinel
	title = "Cadwyn Order Sentinel"
	tutorial = "You are one of the rank and file soldiers of the Cadwyn Order. You have sent with your brothers sisters to assist the local clergy in dealing with the growing influence of Z. \
	Protect your brothers and sisters, and let no unholy creature stop you in your mission."
	outfit = /datum/outfit/cadwynsentinel
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/divine/necra, /datum/patron/divine/ravox)
	is_recognized = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/cadwynsentinel

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DEADNOSE,
	)

	languages = list(/datum/language/celestial)

/datum/job/migrant/cadwynsentinel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/ravox)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/necra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/migrant/cadwynsentinel/patron/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'

/datum/outfit/cadwynsentinel
	name = "Cadwyn Order Sentinel"
	head = /obj/item/clothing/head/helmet/kettle/iron
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/armor/gambeson
	pants = /obj/item/clothing/pants/chainlegs/iron
	shoes = /obj/item/clothing/shoes/boots/armor/ironmaille
	gloves = /obj/item/clothing/gloves/chain/iron
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/outfit/cadwynsentinel/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/astrata
			cloak = /obj/item/clothing/cloak/cadwyn/astrata
			backr = /obj/item/weapon/polearm/halberd
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/ravox
			cloak = /obj/item/clothing/cloak/cadwyn/ravox
			beltr = /obj/item/weapon/sword/arming
			backr = /obj/item/weapon/shield/heater
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/divine/necra
			cloak = /obj/item/clothing/cloak/cadwyn/necra
			beltr = /obj/item/weapon/mace/steel
			backr = /obj/item/weapon/shield/heater

/datum/migrant_wave/cadwyncrusade
	name = "The Cadwyn Order Crusade"
	shared_wave_type = /datum/migrant_wave/cadwyncrusade
	downgrade_wave = /datum/migrant_wave/cadwyncrusade_down_one
	weight = 5
	max_spawns = 1
	roles = list(
		/datum/migrant_role/cadwyncrusader = 1,
		/datum/migrant_role/cadwynsentinel = 2
	)
	greet_text = "The influence of Z grows by the dae and more and more people fall victim to their foul deeds. The Cadwyn Order of Valoria has dispatched you and your brethren to quell these threats and recruit more members to the Order."

/datum/migrant_wave/cadwyncrusade_down_one
	name = "The Cadwyn Order Crusade"
	shared_wave_type = /datum/migrant_wave/cadwyncrusade
	downgrade_wave = /datum/migrant_wave/cadwyncrusade_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/cadwyncrusader = 1,
		/datum/migrant_role/cadwynsentinel = 1
	)
	greet_text = "The influence of Z grows by the dae and more and more people fall victim to their foul deeds. The Cadwyn Order of Valoria has dispatched you and one other to quell these threats and recruit more members to the Order."

/datum/migrant_wave/cadwyncrusade_down_two
	name = "The Lone Cadwyn Order Crusader"
	shared_wave_type = /datum/migrant_wave/cadwyncrusade
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/cadwyncrusader = 1
	)
	greet_text = "The influence of Z grows by the dae and more and more people fall victim to their foul deeds. The Cadwyn Order of Valoria cannot spare many members to assist in quelling the threat of Z outside of its own borders, so you have been sent alone to help the local clergy and perhaps recruit more able bodies to the Order"
