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
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	outfit = /datum/outfit/noble
	apprentice_name = "Servant"
	give_bank_account = 60
	noble_income = 16
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	allowed_ages = ALL_AGES_LIST_CHILD
	spells = list(/datum/action/cooldown/spell/undirected/call_bird)
	job_bitflag = BITFLAG_ROYALTY

	exp_types_granted = list(EXP_TYPE_NOBLE)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = 1
	)

	skills = list(
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/combat/bows = 2
	)

	traits = list(
		TRAIT_NOBLE
	)

/datum/job/minor_noble/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Lord"
	if(spawned.pronouns == SHE_HER)
		honorary = "Lady"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	spawned.adjust_skillrank(/datum/skill/misc/music, pick(1,2))

	if(istype(spawned.patron, /datum/patron/inhumen/baotha))
		spawned.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'

	var/static/list/selectable = list( \
		"Dagger" = /obj/item/weapon/knife/dagger/silver, \
		"Rapier" = /obj/item/weapon/sword/rapier/dec, \
		"Cane Blade" = /obj/item/weapon/sword/rapier/caneblade, \
		)
	var/choice = spawned.select_equippable(spawned, selectable, time_limit = 1 MINUTES, message = "Choose your weapon", title = "NOBLE")
	if(!choice)
		return
	switch(choice)
		if("Dagger")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			var/scabbard = new /obj/item/weapon/scabbard/knife/noble()
			if(!spawned.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Rapier")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			var/scabbard = new /obj/item/weapon/scabbard/sword/noble()
			if(!spawned.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Cane Blade")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
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
