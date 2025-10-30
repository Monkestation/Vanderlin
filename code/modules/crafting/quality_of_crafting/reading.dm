/datum/repeatable_crafting_recipe/reading
	abstract_type = /datum/repeatable_crafting_recipe/reading
	skillcraft = /datum/skill/misc/reading

	tool_usage = list(
		/obj/item/natural/feather = list("starts to write", "start writing", 'sound/items/wood_sharpen.ogg'),
	)
	requirements = list(
		/obj/item/paper = 1,
	)

	attacked_atom = /obj/item/natural/feather
	starting_atom = /obj/item/paper
	craftdiff = 0
	category = "Paperwork"
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/reading/confessional
	name = "confession"
	output = /obj/item/paper/inqslip/confession
	requires_learning = TRUE
	blacklisted_paths = list(/obj/item/paper/inqslip)

/datum/repeatable_crafting_recipe/reading/guide
	name = "blank textbook"
	requirements = list(
		/obj/item/paper/scroll = 3,
	)
	starting_atom = /obj/item/paper/scroll

	craftdiff = 2
	output = /obj/item/textbook
