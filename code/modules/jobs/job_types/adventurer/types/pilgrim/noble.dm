/datum/job/advclass/pilgrim/noble
	title = "Noble"
	tutorial = "The blood of a noble family runs through your veins. Perhaps you are visiting from some place far away, \
	looking to enjoy the hospitality of the ruler. You have many mammons to your name, but with wealth comes \
	danger, so keep your wits and tread lightly..."
	allowed_races = RACES_PLAYER_FOREIGNNOBLE
	outfit = /datum/outfit/adventurer/noble
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	apprentice_name = "Servant"
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird = 1,
	)


/datum/outfit/adventurer/noble/pre_equip(mob/living/carbon/human/H)
	..()
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Lord"
	if(H.pronouns == SHE_HER)
		honorary = "Lady"
	H.real_name = "[honorary] [prev_real_name]"
	H.name = "[honorary] [prev_name]"

	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, rand(1,2), TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_INT, 1)

	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltl = /obj/item/ammo_holder/quiver/arrows
	head = /obj/item/clothing/head/fancyhat
	switch(H.patron?.type)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
	if(H.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/tunic/colored/random
	if(H.age == AGE_CHILD)
		backpack_contents = list(/obj/item/reagent_containers/glass/carafe/teapot/tea = 1, /obj/item/reagent_containers/glass/cup/teacup/fancy = 3)
	else
		backpack_contents = list(/obj/item/reagent_containers/glass/bottle/wine = 1, /obj/item/reagent_containers/glass/cup/silver = 1)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

/datum/outfit/adventurer/noble/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/static/list/selectable = list( \
		"Dagger" = /obj/item/weapon/knife/dagger/silver, \
		"Rapier" = /obj/item/weapon/sword/rapier/dec, \
		"Cane Blade" = /obj/item/weapon/sword/rapier/caneblade, \
		)
	var/choice = H.select_equippable(H, selectable, time_limit = 1 MINUTES, message = "Choose your weapon", title = "NOBLE")
	if(!choice)
		return
		//Yeah this is copied from how lieutenant does it which in turn was copied from how rk does it lmao
	switch(choice)
		if("Dagger")
			H.clamped_adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			var/scabbard = new /obj/item/weapon/scabbard/knife/noble()
			if(!H.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Rapier")
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			var/scabbard = new /obj/item/weapon/scabbard/sword/noble()
			if(!H.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
		if("Cane Blade")
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			var/scabbard = new /obj/item/weapon/scabbard/cane()
			if(!H.equip_to_appropriate_slot(scabbard))
				qdel(scabbard)
