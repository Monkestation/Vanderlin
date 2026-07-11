// This file stores the outfits and loot tables for `grave_spawner.dm`

// OUTFITS
// Outfits will mostly be modifications of existing outfits, but with some items removed (keys, money, armor, weapons, valuable items like talkstones)
// Higher tier outfits start having money and/or other items on them
// Mouth will almost always have a zenny in it

/// Baseline for grave outfits, should not be used by itself.
/datum/outfit/grave
	name = "Naked (grave)"
	mouth = /obj/item/coin/copper

	/// Chance for this outfit to be selected, higher = more likely.
	var/weight = 1

/// Dead Beggar
/datum/outfit/grave/t1/vagrant
	name = "Vagrant (grave)"

	weight = 3

/datum/outfit/grave/t1/vagrant/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	if(prob(20))
		head = /obj/item/clothing/head/knitcap
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/colored/brown
	if(prob(10))
		gloves = /obj/item/clothing/gloves/fingerless

	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/shirt/rags
	else
		pants = /obj/item/clothing/pants/tights/colored/vagrant
		shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant

	neck = /obj/item/storage/belt/pouch

/// Dead Prisoner
/datum/outfit/grave/t1/prisoner
	name = "Prisoner (grave)"
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	mask = /obj/item/clothing/face/facemask/prisoner

	weight = 1

/// Dead Soldier
/datum/outfit/grave/t2/soldier
	name = "Soldier (grave)"
	shirt = /obj/item/clothing/armor/gambeson
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather

/// Dead Townsman
/datum/outfit/grave/t2/townsman
	name = "Townsman (grave)"
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	pants = /obj/item/clothing/pants/tights/colored/random
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather

	weight = 2

/datum/outfit/grave/t2/townsman/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()

	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/shirt/dress/gen/colored/random

/// Dead Merchant
/datum/outfit/grave/t3/merchant
	name = "Merchant (grave)"
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/rich = 1,
	)
	shirt = /obj/item/clothing/shirt/tunic/colored/blue
	shoes = /obj/item/clothing/shoes/gladiator
	beltr = /obj/item/weapon/sword/rapier
	belt = /obj/item/storage/belt/leather/plaquesilver
	armor = /obj/item/clothing/shirt/robe/merchant
	head = /obj/item/clothing/head/chaperon/colored/greyscale/silk/random
	ring = /obj/item/clothing/ring/gold/guild_mercator


/datum/outfit/grave/t3/merchant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/undershirt/sailor
		pants = /obj/item/clothing/pants/tights/sailor
		shoes = /obj/item/clothing/shoes/boots/leather

//// Dead Noble
/datum/outfit/grave/t3/noble
	name = "Noble (grave)"
	shoes = /obj/item/clothing/shoes/boots
	shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/rich
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	head = /obj/item/clothing/head/fancyhat

	weight = 2

/datum/outfit/grave/t3/noble/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/black
		shirt = /obj/item/clothing/shirt/tunic/colored/random


// SPECIAL OUTFITS, MAPPED IN ONLY!

/datum/outfit/grave/unique
	/// Potential names for the body
	var/list/mob_names
	/// Mob buried
	var/mob/living/carbon/human/mob_to_spawn = /mob/living/carbon/human/species/human/northern
	/// Potential messages engraved on their headstone, if they have one
	var/list/grave_messages
	/// Final words they can have
	var/list/final_words

/datum/outfit/grave/unique/ravox_saint
	name = "Ravox Saint (Deceased)"
	head = /obj/item/clothing/head/flowercrown/salvia
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/armor/plate/full/silver
	cloak = /obj/item/clothing/cloak/pantheon
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/platelegs/silver
	shoes = /obj/item/clothing/shoes/boots/armor/silver
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1, /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater = 1)
	backr = /obj/item/weapon/greataxe/steel/grandmaster
	belt = /obj/item/storage/belt/leather/black
	ring = /obj/item/clothing/ring/gold/ravox
	gloves = /obj/item/clothing/gloves/plate/silver
	wrists = /obj/item/clothing/neck/psycross/silver/divine/ravox

	mob_names = list("Saint Placida", "Saint Alexia", "Saint Paisley", "Saint Remington")
	mob_to_spawn = /mob/living/carbon/human/species/human/northern
	grave_messages = list("Served with distinction, died with honor.", "May their life be an example to all.", "Pledged to devote their life to justice, and kept it.", "Hero of the Goblin Wars, gave their life in service to these lands.")
	final_words = list(SPAN_GOD_RAVOX("May I serve justice in the lives to come..."), SPAN_GOD_RAVOX("I hope only that the virtues of Ravox live strong in the hearts of those who come after..."), SPAN_GOD_RAVOX("To those who gaze upon me now, know this; Justice shall always prevail in the end!"))
