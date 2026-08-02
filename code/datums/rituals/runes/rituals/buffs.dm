/datum/runerituals/buff
	blacklisted = TRUE
	tier = 1
	/// Status effect typepath applied to all invokers in range when the ritual fires
	var/buff

/datum/runerituals/buff/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runerituals/buff/lesserstrength
	name = "lesser arcane augmentation of strength"
	buff = /datum/status_effect/buff/magicstrength/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/elementalmote = 2, /obj/item/mana_battery/mana_crystal/small = 1)

/datum/runerituals/buff/lesserconstitution
	name = "lesser fortify constitution"
	buff = /datum/status_effect/buff/magicconstitution/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 1, /obj/item/natural/obsidian = 2)

/datum/runerituals/buff/lesserspeed
	name = "lesser haste"
	buff = /datum/status_effect/buff/magicspeed/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/artifact = 1, /obj/item/natural/leyline = 1)

/datum/runerituals/buff/lesserperception
	name = "lesser arcane eyes"
	buff = /datum/status_effect/buff/magicperception/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 1, /obj/item/natural/infernalash = 2)

/datum/runerituals/buff/lesserendurance
	name = "lesser vitalized endurance"
	buff = /datum/status_effect/buff/magicendurance/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/obsidian = 1, /obj/item/natural/fairydust = 2)

/datum/runerituals/buff/nightvision
	name = "darksight"
	buff = /datum/status_effect/buff/darkvision
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/iridescentscale = 1, /obj/item/natural/elementalshard = 1)

/datum/runerituals/buff/strength
	name = "arcane augmentation of strength"
	buff = /datum/status_effect/buff/magicstrength
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/elementalshard = 2)

/datum/runerituals/buff/constitution
	name = "fortify constitution"
	buff = /datum/status_effect/buff/magicconstitution
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 2, /obj/item/natural/obsidian = 4)

/datum/runerituals/buff/speed
	name = "haste"
	buff = /datum/status_effect/buff/magicspeed
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/artifact = 2, /obj/item/natural/leyline = 2)

/datum/runerituals/buff/perception
	name = "arcane eyes"
	buff = /datum/status_effect/buff/magicperception
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/produce/manabloom = 2, /obj/item/natural/hellhoundfang = 1)

/datum/runerituals/buff/endurance
	name = "vitalized endurance"
	buff = /datum/status_effect/buff/magicendurance
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/natural/obsidian = 2, /obj/item/natural/iridescentscale = 1)

