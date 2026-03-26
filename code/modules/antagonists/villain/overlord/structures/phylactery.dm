/obj/structure/overlord_phylactery
	name = "phylactery"
	desc = "A dark crystal pulsing with necromantic energy. It contains a fragment of the overlord's soul."
	icon = 'icons/roguetown/misc/altar.dmi'
	icon_state = "combined"
	density = TRUE
	anchored = TRUE
	max_integrity = 200
	var/datum/antagonist/overlord/linked_overlord
	light_system = MOVABLE_LIGHT
	light_outer_range = 2
	light_color = "#c92828"

/obj/structure/overlord_phylactery/Destroy()
	if(linked_overlord)
		linked_overlord.built_phylacteries -= src
		// If this was the last phylactery, the overlord dies permanently
		if(!length(linked_overlord.built_phylacteries))
			linked_overlord.on_fail()
	. = ..()
