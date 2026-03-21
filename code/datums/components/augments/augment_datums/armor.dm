
/datum/augment/armor
	abstract_type = /datum/augment/armor
	incompatible_installations = list(/datum/augment/armor)
	var/list/armor_values
	var/finish
	var/melee_damage = 0
	color = COLOR_ASSEMBLY_YELLOW

/datum/augment/armor/on_install(mob/living/carbon/human/H)
	H.physiology?.armor = H.physiology.armor.attachArmor(getArmor(arglist(armor_values)))
	H.skin_tone = finish
	H.update_body()
	H.update_body_parts()
	H.dna.species.punch_damage += melee_damage
	H.dna.species.kick_damage += melee_damage
	H.potence_weapon_buff += melee_damage

/datum/augment/armor/on_remove(mob/living/carbon/human/H)
	H.physiology?.armor = H.physiology.armor.detachArmor(getArmor(arglist(armor_values)))
	H.skin_tone = null
	H.update_body()
	H.update_body_parts()
	H.dna.species.punch_damage -= melee_damage
	H.dna.species.kick_damage -= melee_damage
	H.potence_weapon_buff -= melee_damage

/datum/augment/armor/tin
	name = "tin plating"
	desc = "You might as well have lined it with thatch."
	armor_values = ARMOR_MAILLE_IRON
	finish = "D4AF37"
	stability_cost = 10
	engineering_difficulty = 0

/datum/augment/armor/copper
	name = "copper plating"
	desc = "Less durable than bronze, but more sturdy than tin."
	armor_values = ARMOR_MAILLE
	finish = "B87A3D"
	stability_cost = 10
	engineering_difficulty = 1

/datum/augment/armor/bronze
	name = "bronze plating"
	desc = "The tried-true standard. Mass-produced and mass-reduced."
	armor_values = ARMOR_MAILLE_GOOD
	finish = "89713B"
	engineering_difficulty = 2
	melee_damage = 5

/datum/augment/armor/iron
	name = "iron plating"
	desc = "Hearfelt was never known for its iron quality. An uncommon but nevertheless usable plating."
	armor_values = ARMOR_SCALE
	finish = "A6A695"
	stability_cost = -5
	engineering_difficulty = 2
	melee_damage = 7

/datum/augment/armor/steel
	name = "steel plating"
	desc = "Hearfelt was never known for its iron quality. An uncommon but nevertheless usable plating."
	armor_values = ARMOR_BRIGANDINE
	finish = "9EC0D3"
	stability_cost = -10
	engineering_difficulty = 2
	melee_damage = 10

/datum/augment/armor/gold
	name = "gold plating"
	desc = "Style over substance."
	armor_values = ARMOR_BRIGANDINE
	finish = "D4AF37"
	stability_cost = -15
	engineering_difficulty = 4
	melee_damage = 10

/datum/augment/armor/silver
	name = "silver plating"
	desc = "A blodsucker wouldn't stand a chance against this... if it was put inside of it or something."
	armor_values = ARMOR_PLATE_BAD
	finish = "98A4BD"
	stability_cost = -20
	engineering_difficulty = 3
	melee_damage = 12

/datum/augment/armor/blacksteel
	name = "blacksteel plating"
	desc = "You better be able to control this thing when its loaded."
	armor_values = ARMOR_PLATE_GOOD
	finish = "767B97"
	stability_cost = -30
	engineering_difficulty = 5
	melee_damage = 15
