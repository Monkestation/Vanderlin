/datum/alch_cauldron_recipe
	abstract_type = /datum/alch_cauldron_recipe
	var/category = "Potions"
	var/recipe_name = ""
	var/smells_like = "nothing"
	var/list/output_reagents = list()
	var/list/output_items = list()
	var/list/required_essences = list()

/datum/alch_cauldron_recipe/proc/matches_essences(list/available_essences)
	for(var/essence_type in required_essences)
		var/required_amount = required_essences[essence_type]
		var/available_amount = available_essences[essence_type]

		if(!available_amount || available_amount < required_amount)
			return FALSE

	for(var/essence_type in available_essences)
		if(!(essence_type in required_essences))
			return FALSE // Recipe doesn't allow this essence

	return TRUE

/*
The general idea is:
The more complex the recipe and cost
the better the potion should be
and vice versa
the better the potion/reagent
the more complex the recipe and cost

Keep them reasonable to make
*/


//Weak/Normal potions/elixirs

/datum/alch_cauldron_recipe/berrypoison
	recipe_name = "Berry Poison"
	smells_like = "charcoal"
	output_reagents = list(/datum/reagent/berrypoison = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/water = 3,
		/datum/thaumaturgical_essence/poison = 2,
	)

/datum/alch_cauldron_recipe/stam_poison
	recipe_name = "Stamina Poison"
	smells_like = "kicked up dust"
	output_reagents = list(/datum/reagent/stampoison = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/air = 3,
		/datum/thaumaturgical_essence/poison = 2,
	)

/datum/alch_cauldron_recipe/health_potion
	recipe_name = "Lifeblood Potion"
	smells_like = "metal"
	output_reagents = list(/datum/reagent/medicine/healthpot = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/life = 3,
	)

/datum/alch_cauldron_recipe/mana_potion
	recipe_name = "Mana"
	smells_like = "dry air"
	output_reagents = list(/datum/reagent/medicine/manapot = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/water = 3,
		/datum/thaumaturgical_essence/energia = 3,
	)

/datum/alch_cauldron_recipe/stamina_potion
	recipe_name = "Stamina Potion"
	smells_like = "wet grass"
	output_reagents = list(/datum/reagent/medicine/stampot = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/air = 3,
		/datum/thaumaturgical_essence/motion = 2
	)

/datum/alch_cauldron_recipe/antidote
	recipe_name = "Antidote"
	smells_like = "rotten cheese"
	output_reagents = list(/datum/reagent/medicine/antidote = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/earth = 2,
		/datum/thaumaturgical_essence/life = 3,
	)

//Strong Potions/Elixirs

/datum/alch_cauldron_recipe/doompoison
	recipe_name = "Doom Poison"
	smells_like = "charcoal"
	output_reagents = list(/datum/reagent/strongpoison = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/void = 4,
		/datum/thaumaturgical_essence/poison = 7,
	)

/datum/alch_cauldron_recipe/big_stam_poison
	recipe_name = "Strong Stamina Poison"
	smells_like = "stagnant cold air"
	output_reagents = list(/datum/reagent/strongstampoison = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/frost = 4,
		/datum/thaumaturgical_essence/poison = 7,
	)

/datum/alch_cauldron_recipe/disease_cure
	recipe_name = "Disease Cure"
	smells_like = "saiga droppings"
	output_reagents = list(/datum/reagent/medicine/diseasecure = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/light = 2,
		/datum/thaumaturgical_essence/earth = 5,
		/datum/thaumaturgical_essence/life = 3,
	)

/datum/alch_cauldron_recipe/big_mana_potion
	recipe_name = "Strong Mana"
	smells_like = "crackling thunder"
	output_reagents = list(/datum/reagent/medicine/strongmana = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/energia = 2,
		/datum/thaumaturgical_essence/crystal = 2,
		/datum/thaumaturgical_essence/magic = 2,
	)

/datum/alch_cauldron_recipe/big_health_potion
	recipe_name = "Strong Lifeblood Potion"
	smells_like = "rich metal"
	output_reagents = list(/datum/reagent/medicine/stronghealth = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 4,
		/datum/thaumaturgical_essence/light = 3,
		/datum/thaumaturgical_essence/cycle = 3,
	)

/datum/alch_cauldron_recipe/big_stamina_potion
	recipe_name = "Strong Stamina Potion"
	smells_like = "freshly cut grass"
	output_reagents = list(/datum/reagent/medicine/strongstam = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/air = 3,
		/datum/thaumaturgical_essence/energia = 2,
		/datum/thaumaturgical_essence/cycle = 3,
	)

//meant to be difficult to craft
/datum/alch_cauldron_recipe/dread_death
	recipe_name = "Dread Death"
	smells_like = "cold fire"
	output_reagents = list(/datum/reagent/dreaddeath = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/frost = 3,
		/datum/thaumaturgical_essence/life = 3,
		/datum/thaumaturgical_essence/magic = 2,
		/datum/thaumaturgical_essence/death = 6,
	)

// S.P.E.C.I.A.L. potions
/datum/alch_cauldron_recipe/str_potion
	recipe_name = "Strength of Troll Muscles"
	smells_like = "sour vomit"
	output_reagents = list(/datum/reagent/buff/strength = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/earth = 6,
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/crystal = 2,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/per_potion
	recipe_name = "Perception of Cat Eyes"
	smells_like = "cat urine"
	output_reagents = list(/datum/reagent/buff/perception = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/fire = 6,
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/light = 2,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/end_potion
	recipe_name = "Fortitude of Enduring Mountains"
	smells_like = "gote urine"
	output_reagents = list(/datum/reagent/buff/endurance = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/earth = 6,
		/datum/thaumaturgical_essence/fire = 3,
		/datum/thaumaturgical_essence/life = 3,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/con_potion
	recipe_name = "Constitution of Stone Flesh"
	smells_like = "petrichor"
	output_reagents = list(/datum/reagent/buff/constitution = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/earth = 9,
		/datum/thaumaturgical_essence/crystal = 4,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/int_potion
	recipe_name = "Intelligence of Ancient Minds"
	smells_like = "fresh moss"
	output_reagents = list(/datum/reagent/buff/intelligence = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/water = 6,
		/datum/thaumaturgical_essence/frost = 3,
		/datum/thaumaturgical_essence/order = 2,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/spd_potion
	recipe_name = "Speed of Fleeting Spirits"
	smells_like = "sea salt"
	output_reagents = list(/datum/reagent/buff/speed = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/water = 6,
		/datum/thaumaturgical_essence/air = 3,
		/datum/thaumaturgical_essence/motion = 3,
		/datum/thaumaturgical_essence/magic = 4,
	)

/datum/alch_cauldron_recipe/lck_potion
	recipe_name = "Luck of Seven Clovers"
	smells_like = "rich compost"
	output_reagents = list(/datum/reagent/buff/fortune = 5)
	required_essences = list(
		/datum/thaumaturgical_essence/chaos = 8,
		/datum/thaumaturgical_essence/energia = 6,
		/datum/thaumaturgical_essence/magic = 4,
	)

//Misc

/datum/alch_cauldron_recipe/gender_potion
	recipe_name = "Gender Potion"
	smells_like = "flowery nectars"
	output_reagents = list(/datum/reagent/medicine/gender_potion = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/chaos = 5,
		/datum/thaumaturgical_essence/order = 4,
		/datum/thaumaturgical_essence/life = 3,
		/datum/thaumaturgical_essence/poison = 2,
		/datum/thaumaturgical_essence/magic = 1,
	)

/datum/alch_cauldron_recipe/rosawater_potion
	recipe_name = "Artificial Rose Water"
	smells_like = "rosa"
	output_reagents = list(/datum/reagent/medicine/rosawater = 10)
	required_essences = list(
		/datum/thaumaturgical_essence/life = 3,
		/datum/thaumaturgical_essence/energia = 3,
		/datum/thaumaturgical_essence/order = 3,
		/datum/thaumaturgical_essence/light = 3,
		/datum/thaumaturgical_essence/water = 3,
	)
