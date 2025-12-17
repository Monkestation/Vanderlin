/datum/job/rousman
	title = "Rousman"
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	allowed_races = RACES_PLAYER_ALL
	spawn_type = /mob/living/carbon/human/species/rousman
	outfit = /datum/outfit/rousman
	give_bank_account = FALSE

	traits = list(
		TRAIT_HEAVYARMOR
	)

/datum/job/rousman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.name = "Rousman"
	spawned.real_name = "Rousman"

	if(spawned.charflaw)
		QDEL_NULL(spawned.charflaw)

	spawned.remove_all_languages()
	spawned.grant_language(/datum/language/common)

/datum/outfit/rousman
	name = "Rousman"

/datum/outfit/rousman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	var/loadout = rand(1,4)
	switch(loadout)
		if(1)
			armor = /obj/item/clothing/armor/cuirass/iron/rousman
			head = /obj/item/clothing/head/helmet/rousman
		if(2)
			armor = /obj/item/clothing/armor/cuirass/iron/rousman
			if(prob(50))
				head = /obj/item/clothing/head/helmet/rousman
		if(3)
			if(prob(50))
				armor = /obj/item/clothing/armor/cuirass/iron/rousman
			else
				armor = /obj/item/clothing/armor/leather/hide/rousman
			head = /obj/item/clothing/head/helmet/rousman
		if(4)
			armor = /obj/item/clothing/armor/leather/hide/rousman

	var/weapons = rand(1,5)
	switch(weapons)
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/wood
		if(2)
			r_hand = /obj/item/weapon/knife/copper
			l_hand = /obj/item/weapon/knife/copper
		if(3)
			r_hand = /obj/item/weapon/polearm/spear
		if(4)
			r_hand = /obj/item/weapon/flail
		if(5)
			r_hand = /obj/item/weapon/mace/spiked
