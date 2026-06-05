/datum/runerituals/wall
	name = "lesser arcyne wall"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(
		/obj/item/natural/elementalmote = 2,
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/natural/melded/t1 = 1
	)

/datum/runerituals/wall/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return 1	// Return value used by wall rune to determine single vs double row

/datum/runerituals/wall/t2
	name = "greater arcyne wall"
	tier = 2
	required_atoms = list(
		/obj/item/natural/elementalmote = 4,
		/obj/item/mana_battery/mana_crystal/small = 2,
		/obj/item/natural/melded/t1 = 1
	)

/datum/runerituals/wall/t2/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return 2

/datum/runerituals/wall/t3
	name = "arcyne fortress"
	tier = 3
	required_atoms = list(
		/obj/item/natural/artifact = 3,
		/obj/item/mana_battery/mana_crystal/small = 3,
		/obj/item/natural/melded/t3 = 1
	)
