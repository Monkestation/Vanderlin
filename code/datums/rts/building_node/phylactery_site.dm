/obj/effect/building_node/phylactery_site
	name = "phylactery construction site"
	desc = "A site prepared for phylactery construction. Dark energy swirls here."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	work_template = "phylactery"

/obj/effect/building_node/phylactery_site/after_construction(list/turfs, atom/master)
	. = ..()
	if(!istype(master, /mob/camera/strategy_controller/overlord_controller))
		return
	var/mob/camera/strategy_controller/overlord_controller/controller = master
	for(var/turf/turf as anything in turfs)
		for(var/obj/structure/overlord_phylactery/new_phylactery in turf.contents)
			if(controller.linked_overlord)
				controller.linked_overlord.built_phylacteries += new_phylactery
				new_phylactery.linked_overlord = controller.linked_overlord
