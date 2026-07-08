/datum/attribute_holder/sheet/job/cadwyn
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
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20
	)

/datum/attribute_holder/sheet/job/cadwyn/patron/astrata
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 40
	)

/datum/attribute_holder/sheet/job/cadwyn/patron/ravox
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40
	)

/datum/attribute_holder/sheet/job/cadwyn/patron/necra
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/craft/masonry = 20 //For making graves.
	)

/datum/job/advclass/combat/cadwyn
	title = "Cadwyn Order Emissary"
	tutorial = "You are an Emissary of the Cadwyn Order. You have been sent away from Valoria in order to assist the local clergy with the growing threat of Z and find and recruit more members to the Order. \
	As the influence of Z grows and the Deadite hordes grow more numerous, so to does the need for strong and pious warriors to help combat this threat. \
	Lend them your aid, and find those who wish to dedicate themselves to the war against Z."
	allowed_races = RACES_TEMPLAR
	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/divine/necra, /datum/patron/divine/ravox)
	outfit = /datum/outfit/adventurer/cadwyn
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 1
	roll_chance = 10
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/cadwyn

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
	)

	languages = list(/datum/language/celestial)

/datum/job/advclass/combat/cadwyn/after_spawn(mob/living/carbon/human/spawned, client/player_client)
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
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/cadwyn/patron/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/ravox)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/cadwyn/patron/ravox)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/necra)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/cadwyn/patron/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'

/datum/outfit/adventurer/cadwyn
	name = "Cadwyn Order Emissary"
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

/datum/outfit/adventurer/cadwyn/pre_equip(mob/living/carbon/human/H, visuals_only)
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
