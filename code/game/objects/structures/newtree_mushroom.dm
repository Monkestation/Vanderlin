
/obj/structure/flora/newtree/mushroom
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "mushtree"
	base_icon_state = "mushtree"
	underlay_base = "center-mushroom"
	num_underlay_icons = 2
	num_random_icons = 0
	var/tree_stem = /obj/structure/flora/newtree/mushroom
	var/tree_branch = /obj/structure/flora/newbranch/mushroom
	var/tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom
	var/leaf_corner = /obj/structure/flora/newleaf/corner/mushroom
	var/leaf_full = /obj/structure/flora/newleaf/mushroom
	var/glowcolour = "#f5ccb9"

/obj/structure/flora/newtree/mushroom/New()
	..()
	set_light(1.5, 1.5, 1.5, l_color = glowcolour)

/obj/structure/flora/newtree/mushroom/build_trees()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if((istype(target, /turf/open/transparent/openspace)) && (target.z < 6))
		var/obj/T = new tree_stem(target)
		T.icon_state = icon_state
		T.update_appearance(UPDATE_OVERLAYS)
	else
		build_cap()

/obj/structure/flora/newtree/mushroom/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/T = new leaf_corner(NT)
				T.dir = D

/obj/structure/flora/newtree/mushroom/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/transparent/openspace) && prob(50))
				if(prob(50))
					if(!locate(/obj/structure) in NB)
						var/obj/T = new tree_branch(NB)
						T.dir = D
					if(!locate(/obj/structure) in NT)
						var/obj/TC = new tree_branch_connector(NT)
						TC.dir = D
				else
					if(!locate(/obj/structure) in NT)
						var/obj/TC = new tree_branch(NT)
						TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/TC = new tree_branch(NT)
					TC.dir = D

/obj/structure/flora/newtree/mushroom/proc/build_cap()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if(istype(target, /turf/open/transparent/openspace))
		new leaf_full(target)
	for(var/D in GLOB.diagonals)
		var/turf/NT = GET_TURF_ABOVE(get_step(src, D))
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/T = new leaf_corner(NT)
				T.dir = D
	for(var/D in GLOB.cardinals)
		var/turf/NT = GET_TURF_ABOVE(get_step(src, D))
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/T = new leaf_full(NT)
				T.dir = D


/obj/structure/flora/newbranch/connector/mushroom
	name = "shroom branch"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "mushbranch-extend"
	base_icon_state = "mushbranch-extend"
	underlay_base = "center-mushroom"
	num_underlay_icons = 2
	num_random_icons = 0
	var/glowcolour = "#f5ccb9"

/obj/structure/flora/newbranch/connector/mushroom/New()
	..()
	set_light(1.5, 1.5, 1.5, l_color = glowcolour)

/obj/structure/flora/newbranch/mushroom
	name = "shroom branch"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "mushbranch_end1"
	base_icon_state = "mushbranch-end"
	underlay_base = "center-mushroom"
	num_underlay_icons = 2
	num_random_icons = 2
	var/glowcolour = "#f5ccb9"

/obj/structure/flora/newbranch/mushroom/New()
	..()
	set_light(1.5, 1.5, 1.5, l_color = glowcolour)

/obj/structure/flora/newleaf/corner/mushroom
	name = "shroom cluster"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "corner-mushroom1"
	base_icon_state = "corner-mushroom"
	num_random_icons = 2
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/glowcolour = "#f5e7b9"

/obj/structure/flora/newleaf/corner/mushroom/New()
	..()
	set_light(1.5, 1.5, 1.5, l_color = glowcolour)

/obj/structure/flora/newleaf/mushroom
	name = "shroom cluster"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "center-mushroom1"
	base_icon_state = "center-mushroom"
	num_random_icons = 2
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/glowcolour = "#f5e7b9"

/obj/structure/flora/newleaf/mushroom/New()
	..()
	set_light(1.5, 1.5, 1.5, l_color = glowcolour)

/*
	COLOURS:
			*/

// Blue
/obj/structure/flora/newtree/mushroom/blue
	icon_state = "mushtreeb"
	base_icon_state = "mushtreeb"
	underlay_base = "center-mushroom-blue"
	num_underlay_icons = 1
	glowcolour = "#aee8ec"
	tree_stem = /obj/structure/flora/newtree/mushroom/blue
	tree_branch = /obj/structure/flora/newbranch/mushroom/blue
	tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom/blue
	leaf_corner = /obj/structure/flora/newleaf/corner/mushroom/blue
	leaf_full = /obj/structure/flora/newleaf/mushroom/blue

/obj/structure/flora/newbranch/connector/mushroom/blue
	icon_state = "mushbranchb-extend"
	base_icon_state = "mushbranchb-extend"
	glowcolour = "#aee8ec"
	underlay_base = "center-mushroom-blue"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/mushroom/blue
	icon_state = "mushbranchb-end1"
	base_icon_state = "mushbranchb-end"
	glowcolour = "#aee8ec"
	underlay_base = "center-mushroom-blue"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/mushroom/blue
	icon_state = "corner-mushroom-blue"
	base_icon_state = "corner-mushroom-blue"
	num_random_icons = 0
	glowcolour = "#799ece"

/obj/structure/flora/newleaf/mushroom/blue
	icon_state = "center-mushroom-blue"
	base_icon_state = "center-mushroom-blue"
	num_random_icons = 0
	glowcolour = "#799ece"
