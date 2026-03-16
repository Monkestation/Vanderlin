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
	title = "Noble"
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
	apprentice_name = "Servant"
	give_bank_account = 60
	noble_income = 16
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	allowed_ages = ALL_AGES_LIST_CHILD
	spells = list(/datum/action/cooldown/spell/undirected/call_bird)
	job_bitflag = BITFLAG_ROYALTY

	honorary = "Lord"
	honorary_f = "Lady"

	exp_types_granted = list(EXP_TYPE_NOBLE)

	attribute_sheet = /datum/attribute_holder/sheet/job/minor_noble

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER
	)

/datum/job/minor_noble/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.patron, /datum/patron/inhumen/baotha))
		spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

	var/static/list/selectable = list( \
		"Dagger" = /obj/item/weapon/knife/dagger/silver, \
		"Rapier" = /obj/item/weapon/sword/rapier/dec, \
		"Cane Blade" = /obj/item/weapon/sword/rapier/caneblade, \
		)
	var/choice = spawned.select_equippable(player_client, selectable, time_limit = 1 MINUTES, message = "Choose your weapon", title = "NOBLE")
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
	name = "Noble"
	shoes = /obj/item/clothing/shoes/boots
	shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltl = /obj/item/ammo_holder/quiver/arrows
	head = /obj/item/clothing/head/fancyhat

/datum/outfit/noble/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/tunic/colored/random
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
