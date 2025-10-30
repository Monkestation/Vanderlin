/datum/job/advclass/combat/assassin
	title = "Assassin"
	tutorial = "From a young age you have been drawn to blood, to hurting others. Eventually you found others like you, and a god who would bless your actions. Your cursed dagger has never led you astray, and with every stab you feel a little less empty."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/adventurer/assassin
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	roll_chance = 100
	inherit_parent_title = TRUE //this prevents advjob from being set back to "Assassin" in equipme
	min_pq = 6

/datum/outfit/adventurer/assassin/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 5)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE) // Used for leaving notes after your evil work.
		var/datum/antagonist/new_antag = new /datum/antagonist/assassin() // Adds the assassin antag label.
		H.ambushable = FALSE
		H.mind.add_antag_datum(new_antag)

	H.become_blind("TRAIT_GENERIC")
	// Assassin now spawns disguised as one of the non-combat drifters. You never know who will stab you in the back.
	var/disguises = list("Bard", "Beggar", "Fisher", "Hunter", "Miner", "Noble", "Peasant", "Carpenter", "Thief", "Ranger", "Servant", "Faceless One")
	var/disguisechoice = browser_input_list(H, "Choose your cover.", "Available disguises", disguises)
	if(disguisechoice)
		H.job = disguisechoice
	if(!disguisechoice)
		disguisechoice = pick(disguises)

	switch(disguisechoice)
		if("Bard")
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE) //Have to know to "PLAY" the part... Eh? Eh?
			head = /obj/item/clothing/head/bardhat
			shoes = /obj/item/clothing/shoes/boots
			pants = /obj/item/clothing/pants/tights/colored/random
			shirt = /obj/item/clothing/shirt/shortshirt
			belt = /obj/item/storage/belt/leather/assassin
			armor = /obj/item/clothing/armor/leather/vest
			cloak = /obj/item/clothing/cloak/raincloak/colored/red
			backl = /obj/item/storage/backpack/satchel
			beltr = /obj/item/weapon/knife/dagger/steel/special
			beltl = /obj/item/storage/belt/pouch/coins/poor
			backpack_contents = list(/obj/item/flint)
			if(H.dna?.species)
				if(ishuman(H))
					backr = /obj/item/instrument/lute
				else if(isdwarf(H))
					backr = /obj/item/instrument/accord
				else if(iself(H))
					backr = /obj/item/instrument/harp
				else if(istiefling(H))
					backr = /obj/item/instrument/guitar
		if("Beggar") //The sole "town" disguise available.
			H.job = "Beggar"
			belt = /obj/item/storage/belt/leather/assassin
			if(H.gender == FEMALE)
				armor = /obj/item/clothing/shirt/rags
			else
				pants = /obj/item/clothing/pants/tights/colored/vagrant
				shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
			REMOVE_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
		if("Fisher")
			H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE) //Have to know to play the part.
			if(H.gender == MALE)
				pants = /obj/item/clothing/pants/tights/colored/random
				shirt = /obj/item/clothing/shirt/shortshirt/colored/random
				shoes = /obj/item/clothing/shoes/boots/leather
				neck = /obj/item/storage/belt/pouch/coins/poor
				head = /obj/item/clothing/head/fisherhat
				mouth = /obj/item/weapon/knife/hunting
				armor = /obj/item/clothing/armor/gambeson/light/striped
				backl = /obj/item/storage/backpack/satchel
				belt = /obj/item/storage/belt/leather/assassin
				backr = /obj/item/fishingrod
				beltr = /obj/item/cooking/pan
				beltl = /obj/item/flint
				backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/natural/worms = 1, /obj/item/weapon/shovel/small = 1)
			else
				shirt = /obj/item/clothing/shirt/dress/gen/colored/random
				armor = /obj/item/clothing/armor/gambeson/light/striped
				shoes = /obj/item/clothing/shoes/boots/leather
				neck = /obj/item/storage/belt/pouch/coins/poor
				head = /obj/item/clothing/head/fisherhat
				backl = /obj/item/storage/backpack/satchel
				backr = /obj/item/fishingrod
				belt = /obj/item/storage/belt/leather/assassin
				beltr = /obj/item/cooking/pan
				beltl = /obj/item/flint
				backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/natural/worms = 1, /obj/item/weapon/shovel/small = 1)
		if("Hunter")
			H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE) //The assassin trades their crossbow abilities to match their disguise.
			H.adjust_skillrank(/datum/skill/combat/crossbows, -2, TRUE)
			pants = /obj/item/clothing/pants/tights/colored/random
			shirt = /obj/item/clothing/shirt/shortshirt/colored/random
			shoes = /obj/item/clothing/shoes/boots/leather
			neck = /obj/item/storage/belt/pouch/coins/poor
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
			backr = /obj/item/storage/backpack/satchel
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			belt = /obj/item/storage/belt/leather/assassin
			beltr = /obj/item/ammo_holder/quiver/arrows
			beltl = /obj/item/flashlight/flare/torch/lantern
			backpack_contents = list(/obj/item/flint = 1, /obj/item/bait = 1, /obj/item/weapon/knife/hunting = 1)
			gloves = /obj/item/clothing/gloves/leather
		if("Miner")
			H.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE) //Use the pickaxe...
			H.adjust_skillrank(/datum/skill/combat/swords, -2, TRUE)
			head = /obj/item/clothing/head/armingcap
			pants = /obj/item/clothing/pants/trou
			armor = /obj/item/clothing/armor/gambeson/light/striped
			shirt = /obj/item/clothing/shirt/undershirt/colored/random
			shoes = /obj/item/clothing/shoes/boots/leather
			belt = /obj/item/storage/belt/leather/assassin
			neck = /obj/item/storage/belt/pouch/coins/poor
			beltl = /obj/item/weapon/pick
			backr = /obj/item/weapon/shovel
			backl = /obj/item/storage/backpack/backpack
			backpack_contents = list(/obj/item/flint = 1, /obj/item/weapon/knife/hunting = 1)
		if("Noble")
			var/prev_real_name = H.real_name
			var/prev_name = H.name
			var/honorary = "Lord"
			if(H.gender == FEMALE)
				honorary = "Lady"
			H.real_name = "[honorary] [prev_real_name]"
			H.name = "[honorary] [prev_name]"

			shoes = /obj/item/clothing/shoes/boots
			backl = /obj/item/storage/backpack/satchel
			neck = /obj/item/storage/belt/pouch/coins/poor //Spent all their money on expensive clothing.
			belt = /obj/item/storage/belt/leather/assassin
			ring = /obj/item/clothing/ring/silver
			if(H.gender == MALE)
				H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE) //The male noble's sword is less useful than the female noble's bow, so no downside.
				pants = /obj/item/clothing/pants/tights/colored/black
				shirt = /obj/item/clothing/shirt/tunic/colored/random
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				head = /obj/item/clothing/head/fancyhat
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltr = /obj/item/weapon/sword/rapier/dec
				beltl = /obj/item/ammo_holder/quiver/arrows
				backpack_contents = list(/obj/item/reagent_containers/glass/bottle/wine = 1, /obj/item/reagent_containers/glass/cup/silver = 1)
			else
				H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE) //Female nobles get the male noble's bow, but are less trained than an Assassin disguising as a Hunter. Balance.
				H.adjust_skillrank(/datum/skill/combat/crossbows, -1, TRUE)
				shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
				head = /obj/item/clothing/head/fancyhat
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltr = /obj/item/weapon/knife/dagger/steel/special
				beltl = /obj/item/ammo_holder/quiver/arrows
				backpack_contents = list(/obj/item/reagent_containers/glass/bottle/wine = 1, /obj/item/reagent_containers/glass/cup/silver = 1)
		if("Peasant")
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			belt = /obj/item/storage/belt/leather/assassin
			shirt = /obj/item/clothing/shirt/undershirt/colored/random
			pants = /obj/item/clothing/pants/trou
			head = /obj/item/clothing/head/strawhat
			shoes = /obj/item/clothing/shoes/simpleshoes
			wrists = /obj/item/clothing/wrists/bracers/leather
			backr = /obj/item/weapon/hoe
			backl = /obj/item/storage/backpack/satchel
			neck = /obj/item/storage/belt/pouch/coins/poor
			armor = /obj/item/clothing/armor/gambeson/light/striped
			beltl = /obj/item/weapon/sickle
			beltr = /obj/item/flint
			var/obj/item/weapon/pitchfork/P = new()
			H.put_in_hands(P, forced = TRUE)
			if(H.gender == FEMALE)
				head = /obj/item/clothing/head/armingcap
				armor = /obj/item/clothing/shirt/dress/gen/colored/random
				shirt = /obj/item/clothing/shirt/undershirt
				pants = null
			backpack_contents = list(/obj/item/neuFarm/seed/wheat=1,/obj/item/neuFarm/seed/apple=1,/obj/item/fertilizer/ash=1,/obj/item/weapon/knife/villager=1)
		if("Carpenter")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE) //Use the axe...
			H.adjust_skillrank(/datum/skill/combat/swords, -2, TRUE)
			belt = /obj/item/storage/belt/leather/assassin
			shirt = /obj/item/clothing/shirt/undershirt/colored/random
			pants = /obj/item/clothing/pants/trou
			head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
			shoes = /obj/item/clothing/shoes/boots/leather
			backr = /obj/item/storage/backpack/satchel
			neck = /obj/item/clothing/neck/coif
			wrists = /obj/item/clothing/wrists/bracers/leather
			armor = /obj/item/clothing/armor/gambeson/light/striped
			beltr = /obj/item/storage/belt/pouch/coins/poor
			beltl = /obj/item/weapon/hammer/steel
			backr = /obj/item/weapon/axe/iron
			backl = /obj/item/storage/backpack/backpack
			backpack_contents = list(/obj/item/flint = 1, /obj/item/weapon/knife/villager = 1)
		if("Thief")
			shirt = /obj/item/clothing/shirt/undershirt/colored/black
			gloves = /obj/item/clothing/gloves/fingerless
			pants = /obj/item/clothing/pants/trou/leather
			shoes = /obj/item/clothing/shoes/boots
			backl = /obj/item/storage/backpack/satchel
			belt = /obj/item/storage/belt/leather/assassin
			beltr = /obj/item/weapon/mace/cudgel
			beltl = /obj/item/storage/belt/pouch/coins/poor
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
		if("Ranger")
			if(H.gender == MALE)
				pants = /obj/item/clothing/pants/trou/leather
				shirt = /obj/item/clothing/shirt/undershirt
			else
				pants = /obj/item/clothing/pants/tights
				if(prob(50))
					pants = /obj/item/clothing/pants/tights/colored/black
				shirt = /obj/item/clothing/shirt/undershirt
			if(prob(23))
				gloves = /obj/item/clothing/gloves/leather
			else
				gloves = /obj/item/clothing/gloves/fingerless
			wrists = /obj/item/clothing/wrists/bracers/leather
			belt = /obj/item/storage/belt/leather/assassin
			armor = /obj/item/clothing/armor/leather/hide
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			if(prob(33))
				cloak = /obj/item/clothing/cloak/raincloak/colored/green
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			backl = /obj/item/storage/backpack/satchel
			beltr = /obj/item/flashlight/flare/torch/lantern
			backpack_contents = list(/obj/item/bait = 1, /obj/item/weapon/knife/hunting = 1)
			beltl = /obj/item/ammo_holder/quiver/arrows
			shoes = /obj/item/clothing/shoes/boots/leather
			H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE) //Once more, the assassin trades their crossbow abilities to match their disguise.
			H.adjust_skillrank(/datum/skill/combat/crossbows, -2, TRUE)
		if("Servant") // You think you're safe? No keys to the keep though. Hopefully less people pick Noble with this in mind.
			H.job = "Servant"
			H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE) // Trustworthy poisoner.
			shoes = /obj/item/clothing/shoes/simpleshoes
			pants = /obj/item/clothing/pants/tights/colored/uncolored
			shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
			belt = /obj/item/storage/belt/leather/assassin
			beltl = /obj/item/storage/belt/pouch/coins/poor
			backl = /obj/item/storage/backpack/satchel
			if(H.gender == MALE)
				armor = /obj/item/clothing/armor/leather/vest/colored/black
			else
				cloak = /obj/item/clothing/cloak/apron
			backpack_contents = list(/obj/item/recipe_book/cooking = 1)
			REMOVE_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
		if("Faceless One") //Sacrifice the disguise and marked for valid for even more drip.
			head = /obj/item/clothing/head/faceless
			armor = /obj/item/clothing/shirt/robe/faceless
			gloves = /obj/item/clothing/gloves/leather/black
			pants = /obj/item/clothing/pants/trou/leather
			shoes = /obj/item/clothing/shoes/boots
			backl = /obj/item/storage/backpack/satchel
			beltl = /obj/item/storage/belt/pouch/coins/poor
			beltr = /obj/item/weapon/knife/dagger/steel
			cloak = /obj/item/clothing/cloak/faceless
			shirt = /obj/item/clothing/shirt/undershirt/colored/black
			mask = /obj/item/clothing/face/lordmask/faceless
			backpack_contents = list(/obj/item/reagent_containers/glass/bottle/poison, /obj/item/weapon/knife/dagger/steel/profane, /obj/item/lockpick, /obj/item/storage/fancy/cigarettes/zig, /obj/item/flint)
			ADD_TRAIT(H, TRAIT_FACELESS, TRAIT_GENERIC)
			H.real_name = get_faceless_name(H)
			var/list/belt_options = list("Leather Belt", "Toss Blade Belt")
			var/belt_pick = browser_input_list(H, "Select belt.", "BELT OPTION", belt_options)
			if(!belt_pick)
				belt_pick = pick(belt_options)
			switch(belt_pick)
				if("Leather Belt")
					belt = /obj/item/storage/belt/leather
				if("Toss Blade Belt")
					belt = /obj/item/storage/belt/leather/knifebelt/black/steel

	H.cure_blind("TRAIT_GENERIC")

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ASSASSIN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_VILLAIN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONG_GRABBER, TRAIT_GENERIC)

	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 2)
	if(H.dna.species.id == SPEC_ID_HUMEN)
		if(H.gender == "male")
			H.dna.species.soundpack_m = new /datum/voicepack/male/assassin()
		else
			H.dna.species.soundpack_f = new /datum/voicepack/female/assassin()

/datum/outfit/adventurer/assassin/proc/get_faceless_name(mob/living/carbon/human/H)
	if(is_species(H, /datum/species/rakshari) && prob(10))
		return "Furless One"
	else if(is_species(H, /datum/species/harpy) && prob(10))
		return "Featherless One"
	else if(is_species(H, /datum/species/kobold) && prob(10))
		return "Scaleless One"
	else if(prob(1))
		return pick("Friendless One", "Maidenless One", "Fatherless One", "Kinless One")
	else
		return "Faceless One"
