
/datum/augment/armor
	abstract_type = /datum/augment/armor
	incompatible_installations = list(/datum/augment/armor)
	color = COLOR_ASSEMBLY_YELLOW
	var/list/armor_values
	var/finish
	var/melee_damage = 0
	var/shutdown_bonus = 0

/datum/augment/armor/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	H.physiology?.armor = H.physiology.armor.attachArmor(getArmor(arglist(armor_values)))
	H.skin_tone = finish
	H.update_body()
	H.update_body_parts()
	H.dna.species.punch_damage += melee_damage
	H.dna.species.kick_damage += melee_damage
	H.potence_weapon_buff += melee_damage
	var/datum/component/damage_shutdown/sd = H.GetComponent(/datum/component/damage_shutdown)
	sd?.shutdown_threshold += shutdown_bonus
	H.updatehealth()

/datum/augment/armor/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	H.physiology?.armor = H.physiology.armor.detachArmor(getArmor(arglist(armor_values)))
	H.skin_tone = null
	H.update_body()
	H.update_body_parts()
	H.dna.species.punch_damage -= melee_damage
	H.dna.species.kick_damage -= melee_damage
	H.potence_weapon_buff -= melee_damage
	var/datum/component/damage_shutdown/sd = H.GetComponent(/datum/component/damage_shutdown)
	sd?.shutdown_threshold -= shutdown_bonus
	H.updatehealth()


/datum/augment/armor/tin
	name = "tin plating"
	desc = "You might as well have lined it with thatch."
	engineering_difficulty = SKILL_RANK_NONE
	armor_values = ARMOR_MAILLE_IRON
	finish = "ABE8E6"
	stability_cost = 15
	engineering_difficulty = 0
	shutdown_bonus = -25

/datum/augment/armor/copper
	name = "copper plating"
	desc = "Less durable than bronze, but more sturdy than tin."
	engineering_difficulty = SKILL_RANK_NOVICE
	armor_values = ARMOR_MAILLE_IRON
	finish = "B87A3D"
	stability_cost = 10
	engineering_difficulty = 1
	melee_damage = 1
	shutdown_bonus = -10

/datum/augment/armor/bronze
	name = "bronze plating"
	desc = "The tried-true standard. Mass-produced and mass-reduced."
	engineering_difficulty = SKILL_RANK_APPRENTICE
	armor_values = ARMOR_MAILLE
	finish = "89713B"
	melee_damage = 2
	shutdown_bonus = 10

/datum/augment/armor/iron
	name = "iron plating"
	desc = "Hearfelt was never known for its iron quality. An uncommon but nevertheless usable plating."
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	armor_values = ARMOR_MAILLE_GOOD
	finish = "A6A695"
	stability_cost = -5
	melee_damage = 3
	shutdown_bonus = 25

/datum/augment/armor/steel
	name = "steel plating"
	desc = "Hearfelt was never known for its iron quality. An uncommon but nevertheless usable plating."
	engineering_difficulty = SKILL_RANK_EXPERT
	armor_values = ARMOR_SCALE
	finish = "9EC0D3"
	stability_cost = -10
	melee_damage = 5
	shutdown_bonus = 50

/datum/augment/armor/gold
	name = "gold plating"
	desc = "Style over substance."
	engineering_difficulty = SKILL_RANK_MASTER
	armor_values = ARMOR_SCALE
	finish = "DBC70C"
	stability_cost = -15
	melee_damage = 7
	shutdown_bonus = 50

/datum/augment/armor/silver
	name = "silver plating"
	desc = "A blodsucker wouldn't stand a chance against this... if it was put inside of it or something."
	engineering_difficulty = SKILL_RANK_MASTER
	armor_values = ARMOR_SCALE
	finish = "CBD6D4"
	stability_cost = -20
	melee_damage = 7
	shutdown_bonus = 50

/datum/augment/armor/blacksteel
	name = "blacksteel plating"
	desc = "You better be able to control this thing when it's loaded."
	engineering_difficulty = SKILL_RANK_LEGENDARY
	armor_values = ARMOR_PLATE_BSTEEL
	finish = "767B97"
	stability_cost = -25
	melee_damage = 10
	shutdown_bonus = 75
