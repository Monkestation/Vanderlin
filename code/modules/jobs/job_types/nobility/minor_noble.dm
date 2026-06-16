/datum/attribute_holder/sheet/job/minor_noble
	attribute_variance = list(
		/datum/attribute/skill/misc/music = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_SPEED = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/attribute_holder/sheet/job/minor_dagger
	clamped_adjustment = list(
		/datum/attribute/skill/combat/knives = list(20, 40)
	)

/datum/attribute_holder/sheet/job/minor_swords
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(20, 40)
	)


/datum/job/minor_noble
	title = JOB_MINOR_NOBLE
	tutorial = "The blood of a noble family runs through your veins. You are the living proof that the minor houses \
	still exist in spite of the Monarch. You have many mammons to your name, but with wealth comes \
	danger, so keep your wits and tread lightly..."
	display_order = JDO_MINOR_NOBLE
	department_flag = NOBLEMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/noble
	advclass_cat_rolls = list(CTAG_MINOR_NOBLE = 20)
	apprentice_name = JOB_SERVANT
	noble_income = 16
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	allowed_ages = ALL_AGES_LIST
	spells = list(/datum/action/cooldown/spell/undirected/call_bird)
	job_bitflag = BITFLAG_ROYALTY

/datum/job/advclass/minornoble
	inherit_parent_title = TRUE
	exp_types_granted = list(EXP_TYPE_NOBLE)

	attribute_sheet = /datum/attribute_holder/sheet/job/minor_noble

/datum/attribute_holder/sheet/job/former_commander
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/minornoble/former_commander
	title = "Former Commander"
	tutorial = "Through merit or inheritance, you once served as a lieutenant in the Royal army, leading your forces to victory. Though your military daes are behind you, and your skills rusty, you still keep your old armour and arrogance."
	outfit = /datum/outfit/minornoble/former_commander
	category_tags = list(CTAG_MINOR_NOBLE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	give_bank_account = 40
	honorary = "Baronet"
	honorary_f = "Baronetess"

	attribute_sheet = /datum/attribute_holder/sheet/job/former_commander

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)


/datum/outfit/minornoble/former_commander
	name = "Former Commander (noble)"
	head = /obj/item/clothing/head/helmet/heavy/decorated/bascinet
	cloak = /obj/item/clothing/cloak/cape
	shirt = /obj/item/clothing/armor/gambeson/arming
	armor = /obj/item/clothing/armor/cuirass/fluted
	gloves = /obj/item/clothing/gloves/plate
	backr = /obj/item/storage/backpack/satchel

/datum/attribute_holder/sheet/job/magnate
	raw_attribute_list = list(
		STAT_STRENGTH = -3,
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -3,
		/datum/attribute/skill/labor/mathematics = 60,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/minornoble/magnate
	title = "Magnate"
	tutorial = "Through years of careful investment or plain old nepotism, you have managed to gather a large fortune. You have not had much in the way of physical exercise, however, so it would be wise to put your wealth to use in this regard."
	outfit = /datum/outfit/minornoble/magnate
	category_tags = list(CTAG_MINOR_NOBLE)
	give_bank_account = 300
	honorary = "Lord"
	honorary_f = "Lady"

	attribute_sheet = /datum/attribute_holder/sheet/job/magnate

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_FAT,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)


/datum/outfit/minornoble/magnate
	name = "Magnate (noble)"
	shirt = /obj/item/clothing/shirt/undershirt/formal
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/armor/leather/jacket/tailcoat/lord
	backr = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/chaperon/colored/greyscale/silk
	mask = /obj/item/clothing/face/spectacles/monocle

/datum/attribute_holder/sheet/job/magickal_graduate
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_INTELLIGENCE = 3,
		STAT_ENDURANCE = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/magic/arcane = 25,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sneaking = 25,
		/datum/attribute/skill/misc/athletics = 25,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/minornoble/magickal_graduate
	title = "Magickal Graduate"
	tutorial = "You've spent a large portion of your inheritance on magickal tuition in Kingsfield, though you spent much of that time drinking. As a consequence, you only took in a basic education though that still sets you above the rest of the uneducated masses."
	outfit = /datum/outfit/minornoble/magickal_graduate
	category_tags = list(CTAG_MINOR_NOBLE)
	give_bank_account = 20
	honorary = "Lord"
	honorary_f = "Lady"

	attribute_sheet = /datum/attribute_holder/sheet/job/magickal_graduate

/datum/outfit/minornoble/magickal_graduate
	name = "Magical Graduate (noble)"
	head = /obj/item/clothing/head/wizhat/gen
	shirt = /obj/item/clothing/shirt/tunic/colored/random
	armor = /obj/item/clothing/armor/basiceast/crafteast
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/book/granter/spellbook/apprentice = 1,
		/obj/item/chalk = 1
	)

/datum/attribute_holder/sheet/job/herald
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_INTELLIGENCE = 3,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/music = 25,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/minornoble/herald
	title = "Lord Herald"
	tutorial = "Through an aptitude for words, or politicking, you’ve managed to become the Sovereign’s loyal herald. Make sure their word is known by the commoners, and act as their mouthpiece, for surely they still have use for you despite their throne…"
	outfit = /datum/outfit/minornoble/herald
	category_tags = list(CTAG_MINOR_NOBLE)
	give_bank_account = 60
	honorary = "Lord Herald"
	honorary_f = "Lady Herald"

	attribute_sheet = /datum/attribute_holder/sheet/job/herald

	traits = list(
		TRAIT_BARDIC_TRAINING,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)

/datum/outfit/minornoble/herald
	name = "Lord Herald (noble)"
	head = /obj/item/clothing/head/chaperon
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	shirt = /obj/item/clothing/shirt/dress/silkdress/loudmouth
	backr = /obj/item/storage/backpack/satchel

/datum/attribute_holder/sheet/job/vassal
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/minornoble/vassal
	title = "Vassal"
	tutorial = "A jack of all trades, in a field with no masters. You are the very ideal of a nobleman, not excelling in any area except your ego. Perhaps your mediocrity will inspire an ambition to push yourself above your peers, or just keep you sitting on your estate."
	outfit = /datum/outfit/minornoble/vassal
	category_tags = list(CTAG_MINOR_NOBLE)
	give_bank_account = 100
	honorary = "Lord"
	honorary_f = "Lady"

	attribute_sheet = /datum/attribute_holder/sheet/job/vassal

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)

/datum/outfit/minornoble/vassal
	name = "Vassal (noble)"
	shoes = /obj/item/clothing/shoes/boots
	shirt = /obj/item/clothing/shirt/tunic/colored/random
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backr = /obj/item/gun/ballistic/bow
	beltl = /obj/item/ammo_holder/quiver/arrows
	head = /obj/item/clothing/head/fancyhat
	backl = /obj/item/storage/backpack/satchel

/datum/job/minor_noble/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.patron, /datum/patron/inhumen/baotha))
		spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

/datum/job/minor_noble/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectable = list(
		"Dagger" = /obj/item/weapon/knife/dagger/silver,
		"Rapier" = /obj/item/weapon/sword/rapier/dec,
		"Cane Blade" = /obj/item/weapon/sword/rapier/caneblade,
	)
	var/choice = spawned.select_equippable(player_client, selectable, time_limit = 1 MINUTES, message = "Choose your weapon", title = JOB_MINOR_NOBLE)
	if(!choice)
		return
	switch(choice)
		if("Dagger")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/minor_dagger)
			var/scabbard = new /obj/item/weapon/scabbard/knife/noble()
			if(!spawned.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Rapier")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/minor_swords)
			var/scabbard = new /obj/item/weapon/scabbard/sword/noble()
			if(!spawned.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Cane Blade")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/minor_swords)
			var/scabbard = new /obj/item/weapon/scabbard/cane()
			if(!spawned.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)

/datum/outfit/noble
	name = "Noble Base"
	shoes = /obj/item/clothing/shoes/boots
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver

/datum/outfit/noble/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
	if(equipped_human.age == AGE_CHILD)
		backpack_contents = list(
			/obj/item/reagent_containers/glass/carafe/teapot/tea = 1,
			/obj/item/reagent_containers/glass/cup/teacup/fancy = 3
		)
	else
		backpack_contents = list(
			/obj/item/reagent_containers/glass/bottle/wine = 1,
			/obj/item/reagent_containers/glass/cup/silver = 1
		)
