
/obj/effect/decal/cleanable/ritual_rune/arcyne/attunement
	name = "arcyne attunement matrix"
	desc = "A large matrix designed to imbue the energies of materials."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 2
	req_invokers = 2
	invocation = "Xel'thix un'oral!"
	req_keyword = TRUE
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	can_be_scribed = TRUE
	associated_ritual = /datum/runerituals/attunement
	takes_all_items = TRUE

/obj/effect/decal/cleanable/ritual_rune/arcyne/attunement/invoke(list/invokers, datum/runerituals/runeritual)
	runeritual = associated_ritual
	if(!..())
		return
	var/mob/living/user = invokers[1]
	var/datum/runerituals/attunement/attune = pickritual
	for(var/datum/attunement/att as anything in attune.attunement_modifiers)
		user.mana_pool?.adjust_attunement(att, attune.attunement_modifiers[att])
	pickritual.cleanup_atoms(selected_atoms)
	do_invoke_glow()

/datum/runerituals/attunement
	name = "arcyne attunement"
	blacklisted = FALSE
	required_atoms = list(
		/obj/item/reagent_containers/food/snacks/produce/manabloom = 1,
		/obj/item/natural/melded/t1 = 1
	)
	/// Assoc list of [/datum/attunement] = modifier value, accumulated from attuned items
	var/list/attunement_modifiers = list()

/datum/runerituals/attunement/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	for(var/obj/item/item in selected_atoms)
		if(!length(item.attunement_values))
			continue
		for(var/datum/attunement/att in item.attunement_values)
			attunement_modifiers |= att
			attunement_modifiers[att] += item.attunement_values[att]
	return TRUE
