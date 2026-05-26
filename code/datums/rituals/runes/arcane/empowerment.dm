/obj/effect/decal/cleanable/ritual_rune/arcyne/empowerment
	name = "empowerment array"
	desc = "Arcane symbols pulse upon the ground..."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "empowerment"
	tier = 2
	SET_BASE_PIXEL(-32, -32)
	pixel_z = 0
	invocation = "Thal'miren vek'laris un'vethar!"
	layer = SIGIL_LAYER
	color = "#3A0B61"
	can_be_scribed = TRUE
	ritual_number = TRUE

/obj/effect/decal/cleanable/ritual_rune/arcyne/empowerment/get_ritual_list_for_rune()
	return tier >= 2 ? GLOB.t2buffrunerituallist : GLOB.buffrunerituallist

/obj/effect/decal/cleanable/ritual_rune/arcyne/empowerment/invoke(list/invokers, datum/runerituals/buff/runeritual)
	if(!..())
		return
	for(var/mob/living/nearby_mob in range(runesize, src))
		nearby_mob.apply_status_effect(runeritual.buff)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)
