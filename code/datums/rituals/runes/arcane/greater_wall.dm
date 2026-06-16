/obj/effect/decal/cleanable/ritual_rune/arcyne/wallgreater
	name = "fortress accession matrix"
	desc = "A massive sigil — is that a wall in the center?"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "wall"
	tier = 3
	invocation = "Thar'morak dul'vorr keth'alor!"
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	can_be_scribed = TRUE
	associated_ritual = /datum/runerituals/wall/t3
	var/datum/map_template/template
	var/fortress_template_type = /datum/map_template/arcyne_fortress

/obj/effect/decal/cleanable/ritual_rune/arcyne/wallgreater/proc/load_fortress_template()
	var/datum/map_template/temp = new fortress_template_type()
	template = SSmapping.map_templates[temp.id]
	if(!template)
		WARNING("Fortress template ([temp.id]) not found!")
		qdel(src)

/obj/effect/decal/cleanable/ritual_rune/arcyne/wallgreater/invoke(list/invokers, datum/runerituals/runeritual)
	runeritual = associated_ritual
	if(!..())
		return
	if(QDELETED(src))
		return
	load_fortress_template()
	template.load(get_turf(src), centered = TRUE)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)
