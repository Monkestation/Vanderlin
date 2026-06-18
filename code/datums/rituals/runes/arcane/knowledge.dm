/obj/effect/decal/cleanable/ritual_rune/arcyne/knowledge
	name = "Knowledge rune"
	desc = "Arcane symbols pulse upon the ground..."
	icon_state = "6"
	invocation = "Thal'miren vek'laris un'vethar!"
	color = "#3A0B61"
	spellbonus = 15
	scribe_damage = 10
	can_be_scribed = TRUE
	associated_ritual = /datum/runerituals/knowledge

/obj/effect/decal/cleanable/ritual_rune/arcyne/knowledge/invoke(list/invokers, datum/runerituals/runeritual)
	runeritual = associated_ritual
	if(!..())
		return
	var/mob/living/user = usr
	user.apply_status_effect(/datum/status_effect/buff/magicknowledge)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)

/datum/runerituals/knowledge
	name = "knowledge gain"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/mana_battery/mana_crystal/small = 1)

/datum/runerituals/knowledge/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE
