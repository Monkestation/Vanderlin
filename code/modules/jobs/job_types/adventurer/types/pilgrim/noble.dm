/datum/job/advclass/pilgrim/noble
	title = "Noble"
	tutorial = "The blood of a noble family runs through your veins. Perhaps you are visiting from some place far away, \
	looking to enjoy the hospitality of the ruler. You have many mammons to your name, but with wealth comes \
	danger, so keep your wits and tread lightly..."
	allowed_races = RACES_PLAYER_FOREIGNNOBLE
	outfit = /datum/outfit/pilgrim/noble
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	apprentice_name = "Servant"
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird = 1,
	)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
	)

	skills = list(
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/bows = 2
	)

	traits = list(
		TRAIT_NOBLE
	)

/datum/job/advclass/pilgrim/noble/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(1, 2), TRUE)
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Lord"
	if(spawned.pronouns == SHE_HER)
		honorary = "Lady"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

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

/datum/outfit/pilgrim/noble
	name = "Noble (Pilgrim)"
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltl = /obj/item/ammo_holder/quiver/arrows
	head = /obj/item/clothing/head/fancyhat

/datum/outfit/pilgrim/noble/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/tunic/colored/random
	if(equipped_human.age == AGE_CHILD)
		backpack_contents = list(/obj/item/reagent_containers/glass/carafe/teapot/tea = 1, /obj/item/reagent_containers/glass/cup/teacup/fancy = 3)
	else
		backpack_contents = list(/obj/item/reagent_containers/glass/bottle/wine = 1, /obj/item/reagent_containers/glass/cup/silver = 1)

