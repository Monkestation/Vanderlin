/datum/animal_gene/hide
	abstract_type = /datum/animal_gene/hide
	exclusion_group = GENE_GROUP_HIDE
	var/list/armor_covered = list()

/datum/animal_gene/hide/apply_to(mob/living/simple_animal/hostile/target)
	if(..())
		return
	ADD_TRAIT(target, TRAIT_ANIMAL_NATURAL_ARMOR, GENETICS_TRAIT)

/datum/animal_gene/hide/remove_from(mob/living/simple_animal/hostile/target)
	if(!..())
		return
	REMOVE_TRAIT(target, TRAIT_ANIMAL_NATURAL_ARMOR, GENETICS_TRAIT)

/datum/animal_gene/hide/thick_hide
	name = "Thick Hide"
	desc = "Dense skin. Absorbs melee and slashing damage."
	rarity = 4
	intensity_min = 50
	intensity_max = 200
	armor_covered = list("stab", "slash")

/datum/animal_gene/hide/ironhide
	name = "Ironhide"
	desc = "Unnaturally dense flesh. Resists most physical damage types."
	rarity = 2
	intensity_min = 150
	intensity_max = 400
	armor_covered = list("stab", "slash", "piercing")
