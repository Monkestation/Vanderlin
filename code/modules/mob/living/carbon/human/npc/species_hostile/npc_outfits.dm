/datum/outfit/npc/light_gear/pre_equip(mob/living/carbon/human/H)
	..()
	// Cloak
	cloak = /obj/item/clothing/cloak/raincloak/colored/random

	// Belt
	belt = /obj/item/storage/belt/leather

	// Pants
	if(prob(80))
		pants = /obj/item/clothing/pants/trou/leather/splint
	else
		pants = /obj/item/clothing/pants/trou/leather/advanced

	// Head

	if(prob(80))
		head = /obj/item/clothing/head/helmet/leather
	else if(prob(5))
		head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	else
		head = /obj/item/clothing/head/helmet/leather/advanced

	// Gloves
	if(prob(80))
		gloves = /obj/item/clothing/gloves/leather
	else
		gloves = /obj/item/clothing/gloves/leather/advanced

	// Neck
	neck = /obj/item/clothing/neck/coif

	// Wrists
	if(prob(70))
		wrists = /obj/item/clothing/wrists/bracers/leather
	else
		wrists = /obj/item/clothing/wrists/bracers/leather/advanced

	// Shirt Armor
	if(prob(60))
		shirt = /obj/item/clothing/armor/gambeson/light
	else
		shirt = /obj/item/clothing/armor/gambeson/heavy

	// Shoes
	if(prob(60))
		shoes = /obj/item/clothing/shoes/boots
	else
		shoes = /obj/item/clothing/shoes/boots/leather

	// Loadout options
	var/loadout = rand(1,10)
	switch(loadout)
		if(1)
			armor = /obj/item/clothing/armor/leather/hide
			if(prob(90))
				l_hand = /obj/item/weapon/knife/dagger
				r_hand = /obj/item/weapon/knife/dagger
			else
				// Lucky bastard
				l_hand = /obj/item/weapon/knife
				r_hand = /obj/item/weapon/knife
		if(2)
			armor = /obj/item/clothing/armor/leather/hide
			l_hand = /obj/item/weapon/knife/dagger
		if(3)
			armor = /obj/item/clothing/armor/leather
			l_hand = /obj/item/weapon/sword/iron
		if(4)
			head = /obj/item/clothing/head/helmet/leather/volfhelm
			mask = /obj/item/clothing/face/facemask
			armor = /obj/item/clothing/armor/brigandine/light
			l_hand = /obj/item/weapon/knife/copper
			r_hand = /obj/item/weapon/knife/copper
		if(5)
			// A valorian dueslist perished and got their stuff stolen
			head = /obj/item/clothing/head/leather/duelhat
			armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
			l_hand = /obj/item/weapon/sword/rapier
			if(prob(1)) // Where did they got this other rapier from?
				r_hand = /obj/item/weapon/sword/rapier
		if(6)
			armor = /obj/item/clothing/armor/leather/splint
			l_hand = /obj/item/weapon/sword/long/shotel/iron
			if(prob(10))
				r_hand = /obj/item/weapon/sword/long/shotel/iron
		if(7)
			armor = /obj/item/clothing/armor/leather/heavy
			l_hand = /obj/item/weapon/sword
		if(8)
			l_hand = /obj/item/weapon/knife/dagger/steel/special
			armor = /obj/item/clothing/armor/leather/jacket
			head = /obj/item/clothing/head/bardhat
		if(9)
			armor = /obj/item/clothing/armor/leather/jacket/sea
			l_hand =  /obj/item/weapon/sword/sabre/cutlass
		if(10)
			armor = /obj/item/clothing/armor/leather/hide
			l_hand = /obj/item/weapon/sword/iron
			r_hand = /obj/item/weapon/sword/iron
			if(prob(1))
				l_hand = /obj/item/clothing/neck/psycross
				r_hand = /obj/item/weapon/sword/short/psy // He lives



/datum/outfit/npc/medium_gear/pre_equip(mob/living/carbon/human/H)
	..()

	// Head
	var/helmet_rng = rand(1, 5)
	switch(helmet_rng)
		if(1)
			if(prob(40))
				head = /obj/item/clothing/head/helmet/skullcap
			else
				head = /obj/item/clothing/head/helmet/sallet
		if(2)
			if(prob(60))
				head = /obj/item/clothing/head/helmet/horned
			else
				head = /obj/item/clothing/head/helmet/visored/sallet
		if(3)
			if(prob(60))
				head = /obj/item/clothing/head/helmet/winged
			else
				head = /obj/item/clothing/head/helmet/sallet
		if(4)
			if(prob(60))
				head = /obj/item/clothing/head/helmet/kettle/iron
			else
				head = /obj/item/clothing/head/helmet/kettle/slit
		if(5)
			if(prob(40))
				head = /obj/item/clothing/head/helmet/ironpot
			else
				head = /obj/item/clothing/head/helmet/visored/sallet/iron

	// Shirt armor
	if(prob(60))
		shirt = /obj/item/clothing/armor/gambeson/heavy
	else if(prob(50))
		shirt = /obj/item/clothing/armor/chainmail/iron
	else
		shirt = /obj/item/clothing/armor/chainmail

	// Belt
	if(prob(70))
		belt = /obj/item/storage/belt/leather
	else
		belt = /obj/item/storage/belt/leather/black

	// Pants
	if(prob(70))
		if(prob(50))
			pants = /obj/item/clothing/pants/chainlegs/kilt/iron
		else
			pants = /obj/item/clothing/pants/chainlegs/iron
	else
		if(prob(50))
			pants = /obj/item/clothing/pants/chainlegs/kilt
		else
			pants = /obj/item/clothing/pants/chainlegs

	// Gloves
	if(prob(60))
		gloves = /obj/item/clothing/gloves/chain/iron
	else
		gloves = /obj/item/clothing/gloves/chain

	// Neck
	if(prob(70))
		neck = /obj/item/clothing/neck/chaincoif/iron
	else
		neck = /obj/item/clothing/neck/chaincoif

	// Wrists
	if(prob(60))
		wrists = /obj/item/clothing/wrists/bracers/ironjackchain
	else
		wrists = /obj/item/clothing/wrists/bracers/iron

	// Shoes
	if(prob(80))
		shoes = /obj/item/clothing/shoes/boots/armor/ironmaille
	else
		shoes = /obj/item/clothing/shoes/boots/armor/light

	// Loadout options
	var/loadout = rand(1, 10)
	switch(loadout)
		if(1)
			armor = /obj/item/clothing/armor/cuirass/iron
			if(prob(40))
				armor = /obj/item/clothing/armor/cuirass
			l_hand = /obj/item/weapon/sword/long
		if(2)
			armor = /obj/item/clothing/armor/cuirass/iron/rust
			l_hand = /obj/item/weapon/mace
			if(prob(40))
				l_hand = /obj/item/weapon/mace/steel
		if(3)
			armor = /obj/item/clothing/armor/chainmail/hauberk/iron
			if(prob(40))
				armor = /obj/item/clothing/armor/chainmail/hauberk
			l_hand = /obj/item/weapon/axe/battle
		if(4)
			armor = /obj/item/clothing/armor/medium/scale
			l_hand = /obj/item/weapon/shield/tower
			r_hand = /obj/item/weapon/sword/sabre
		if(5)
			// Abyssal Mercenary also died...
			head = /obj/item/clothing/head/helmet/winged
			armor = /obj/item/clothing/armor/medium/scale
			l_hand = /obj/item/weapon/polearm/spear/hoplite/abyssal
			r_hand = /obj/item/weapon/shield/tower/buckleriron
		if(6)
			armor = /obj/item/clothing/armor/cuirass/iron
			l_hand = /obj/item/weapon/sword/scimitar/falchion
		if(7)
			armor = /obj/item/clothing/armor/cuirass/iron
			l_hand = /obj/item/weapon/flail/sflail // They never expect the flail
			r_hand = /obj/item/weapon/shield/tower // Nor the shield
		if(8)
			armor = /obj/item/clothing/armor/cuirass
			l_hand = /obj/item/weapon/mace/goden/steel
		if(9)
			armor = /obj/item/clothing/armor/cuirass/iron/rust
			l_hand = /obj/item/weapon/polearm/spear/billhook
			if(prob(1))
				r_hand = /obj/item/weapon/polearm/spear/billhook // Twice as good
		if(10)
			armor = /obj/item/clothing/armor/cuirass/iron
			if(prob(40))
				armor = /obj/item/clothing/armor/cuirass
			l_hand = /obj/item/weapon/polearm/halberd/bardiche/warcutter

/datum/outfit/npc/heavy_gear/pre_equip(mob/living/carbon/human/H)
	..()
	// Head
	var/helmet_rng = rand(1, 5)
	switch(helmet_rng)
		if(1)
			if(prob(40))
				head = /obj/item/clothing/head/helmet/heavy/ironplate
			else
				head = /obj/item/clothing/head/helmet/heavy/frog
		if(2)
			head = /obj/item/clothing/head/helmet/graggar
		if(3)
			head = /obj/item/clothing/head/helmet/heavy/frog
		if(4)
			head = /obj/item/clothing/head/helmet/heavy/sinistar
		if(5)
			if(prob(40))
				head = /obj/item/clothing/head/helmet/visored/hounskull
			else
				head = /obj/item/clothing/head/helmet/visored/knight

	// Shirt armor
	if(prob(60))
		shirt = /obj/item/clothing/armor/chainmail/iron
	else if(prob(50))
		shirt = /obj/item/clothing/armor/chainmail
	else
		shirt = /obj/item/clothing/armor/brigandine

	// Belt
	belt = /obj/item/storage/belt/leather/steel

	// Pants
	if(prob(5))
		pants = /obj/item/clothing/pants/platelegs/graggar
	else if(prob(50))
		pants = /obj/item/clothing/pants/platelegs/iron
	else
		pants = /obj/item/clothing/pants/platelegs

	// Gloves
	if(prob(5))
		gloves = /obj/item/clothing/gloves/plate/graggar
	else if(prob(50))
		gloves = /obj/item/clothing/gloves/plate
	else
		gloves = /obj/item/clothing/gloves/plate/iron

	// Neck
	if(prob(50))
		neck = /obj/item/clothing/neck/bevor/iron
	else
		neck = /obj/item/clothing/neck/bevor

	// Wrists
	wrists = /obj/item/clothing/wrists/bracers


	// Shoes
	if(prob(5))
		shoes = /obj/item/clothing/shoes/boots/armor/graggar
	else
		shoes = /obj/item/clothing/shoes/boots/armor

	// Loadout options
	var/loadout = rand(1,10)
	switch(loadout)
		if(1)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/sword/long/greatsword/steelclaymore
		if(2)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/mace/warhammer
		if(3)
			armor =  /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/greataxe/steel/doublehead/graggar
		if(4)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/shield/tower/metal
			r_hand = /obj/item/weapon/sword/long/rider // Rest in peace for the Zaladian who died.

		if(5)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/sword/long/greatsword/gsclaymore

		if(6)// The pegasus knight didn't stand a chance...
			head = /obj/item/clothing/head/helmet/pegasusknight
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/shield/tower/buckleriron
			r_hand = /obj/item/weapon/sword/long/shotel

		if(7)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/flail/sflail // They never expect the flail
			r_hand = /obj/item/weapon/shield/tower/metal // Nor the shield

		if(8)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/polearm/halberd
		if(9)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/greataxe/steel/doublehead

		if(10)
			armor = /obj/item/clothing/armor/plate/full/iron
			if(prob(30))
				armor = /obj/item/clothing/armor/plate/full
			l_hand = /obj/item/weapon/axe/battle
			r_hand = /obj/item/weapon/axe/battle
	// For the very small chance, a npc can roll a fullset of graggar armor
	if(prob(5))
		armor = /obj/item/clothing/armor/plate/full/graggar