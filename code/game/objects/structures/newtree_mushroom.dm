
/obj/structure/flora/newtree/mushroom
	name = "mushtree"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "mushtree"
	base_icon_state = "mushtree"
	underlay_base = "center-mushroom"
	num_underlay_icons = 2
	num_random_icons = 0
	var/grow_height = 4
	var/tree_stem = /obj/structure/flora/newtree/mushroom
	var/tree_branch = /obj/structure/flora/newbranch/mushroom
	var/tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom
	var/leaf_corner = /obj/structure/flora/newleaf/corner/mushroom
	var/leaf_full = /obj/structure/flora/newleaf/mushroom
	var/glowcolour = "#f5ccb9"

/obj/structure/flora/newtree/mushroom/Initialize(mapload)
	. = ..()
	set_light(1.2, 1.2, 1.2, l_color = glowcolour)

/obj/structure/flora/newtree/mushroom/build_trees()
	grow_height = rand(4,6)
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if((istype(target, /turf/open/openspace)) && (target.z < grow_height))
		var/obj/T = new tree_stem(target)
		T.icon_state = icon_state
		T.update_appearance(UPDATE_OVERLAYS)
	else
		build_cap()

/obj/structure/flora/newtree/mushroom/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/T = new leaf_corner(NT)
				T.dir = D

/obj/structure/flora/newtree/mushroom/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/openspace) && prob(50))
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
	if(istype(target, /turf/open/openspace))
		new leaf_full(target)
	for(var/D in GLOB.diagonals)
		var/turf/NT = GET_TURF_ABOVE(get_step(src, D))
		if(istype(NT, /turf/open/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/T = new leaf_corner(NT)
				T.dir = D
	for(var/D in GLOB.cardinals)
		var/turf/NT = GET_TURF_ABOVE(get_step(src, D))
		if(istype(NT, /turf/open/openspace))
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

/obj/structure/flora/newbranch/connector/mushroom/Initialize(mapload)
	. = ..()
	set_light(1.2, 1.2, 1.2, l_color = glowcolour)

/obj/structure/flora/newbranch/mushroom
	name = "shroom branch"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "mushbranch_end1"
	base_icon_state = "mushbranch-end"
	underlay_base = "center-mushroom"
	num_underlay_icons = 2
	num_random_icons = 2
	var/glowcolour = "#f5ccb9"

/obj/structure/flora/newbranch/mushroom/Initialize(mapload)
	. = ..()
	set_light(1.2, 1.2, 1.2, l_color = glowcolour)

/obj/structure/flora/newleaf/corner/mushroom
	name = "shroom cluster"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "corner-mushroom1"
	base_icon_state = "corner-mushroom"
	num_random_icons = 2
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/glowcolour = "#f5e7b9"

/obj/structure/flora/newleaf/corner/mushroom/Initialize(mapload)
	. = ..()
	set_light(1.2, 1.2, 1.2, l_color = glowcolour)

/obj/structure/flora/newleaf/mushroom
	name = "shroom cluster"
	icon = 'icons/roguetown/misc/tree_mushroom.dmi'
	icon_state = "center-mushroom1"
	base_icon_state = "center-mushroom"
	num_random_icons = 2
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/glowcolour = "#f5e7b9"

/obj/structure/flora/newleaf/mushroom/Initialize(mapload)
	. = ..()
	set_light(1.2, 1.2, 1.2, l_color = glowcolour)

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
	underlay_base = "center-mushroomb"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/mushroom/blue
	icon_state = "mushbranchb-end1"
	base_icon_state = "mushbranchb-end"
	glowcolour = "#aee8ec"
	underlay_base = "center-mushroomb"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/mushroom/blue
	icon_state = "corner-mushroomb1"
	base_icon_state = "corner-mushroomb1"
	num_random_icons = 0
	glowcolour = "#799ece"

/obj/structure/flora/newleaf/mushroom/blue
	icon_state = "center-mushroomb1"
	base_icon_state = "center-mushroomb1"
	num_random_icons = 0
	glowcolour = "#799ece"

// Green
/obj/structure/flora/newtree/mushroom/green
	icon_state = "mushtreeg"
	base_icon_state = "mushtreeg"
	underlay_base = "center-mushroom-green"
	num_underlay_icons = 1
	glowcolour = "#aee8ec"
	tree_stem = /obj/structure/flora/newtree/mushroom/green
	tree_branch = /obj/structure/flora/newbranch/mushroom/green
	tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom/green
	leaf_corner = /obj/structure/flora/newleaf/corner/mushroom/green
	leaf_full = /obj/structure/flora/newleaf/mushroom/green

/obj/structure/flora/newbranch/connector/mushroom/green
	icon_state = "mushbranchg-extend"
	base_icon_state = "mushbranchg-extend"
	glowcolour = "#c1f1d4"
	underlay_base = "center-mushroomg"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/mushroom/green
	icon_state = "mushbranchg-end1"
	base_icon_state = "mushbranchg-end"
	glowcolour = "#c1f1d4"
	underlay_base = "center-mushroomg"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/mushroom/green
	icon_state = "corner-mushroomg1"
	base_icon_state = "corner-mushroomg1"
	num_random_icons = 0
	glowcolour = "#79ceab"

/obj/structure/flora/newleaf/mushroom/green
	icon_state = "center-mushroomg1"
	base_icon_state = "center-mushroomg1"
	num_random_icons = 0
	glowcolour = "#79ceab"

// Yellow
/obj/structure/flora/newtree/mushroom/yellow
	icon_state = "mushtreey"
	base_icon_state = "mushtreey"
	underlay_base = "center-mushroom-yellow"
	num_underlay_icons = 1
	glowcolour = "#aee8ec"
	tree_stem = /obj/structure/flora/newtree/mushroom/yellow
	tree_branch = /obj/structure/flora/newbranch/mushroom/yellow
	tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom/yellow
	leaf_corner = /obj/structure/flora/newleaf/corner/mushroom/yellow
	leaf_full = /obj/structure/flora/newleaf/mushroom/yellow

/obj/structure/flora/newbranch/connector/mushroom/yellow
	icon_state = "mushbranchy-extend"
	base_icon_state = "mushbranchy-extend"
	glowcolour = "#edf0c8"
	underlay_base = "center-mushroomy"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/mushroom/yellow
	icon_state = "mushbranchy-end1"
	base_icon_state = "mushbranchy-end"
	glowcolour = "#edf0c8"
	underlay_base = "center-mushroomy"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/mushroom/yellow
	icon_state = "corner-mushroomy1"
	base_icon_state = "corner-mushroomy1"
	num_random_icons = 0
	glowcolour = "#ce9f79"

/obj/structure/flora/newleaf/mushroom/yellow
	icon_state = "center-mushroomy1"
	base_icon_state = "center-mushroomy1"
	num_random_icons = 0
	glowcolour = "#ce9f79"

// Red
/obj/structure/flora/newtree/mushroom/red
	icon_state = "mushtreer"
	base_icon_state = "mushtreer"
	underlay_base = "center-mushroom-red"
	num_underlay_icons = 1
	glowcolour = "#aee8ec"
	tree_stem = /obj/structure/flora/newtree/mushroom/red
	tree_branch = /obj/structure/flora/newbranch/mushroom/red
	tree_branch_connector = /obj/structure/flora/newbranch/connector/mushroom/red
	leaf_corner = /obj/structure/flora/newleaf/corner/mushroom/red
	leaf_full = /obj/structure/flora/newleaf/mushroom/red

/obj/structure/flora/newbranch/connector/mushroom/red
	icon_state = "mushbranchr-extend"
	base_icon_state = "mushbranchr-extend"
	glowcolour = "#edf0c8"
	underlay_base = "center-mushroomr"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/mushroom/red
	icon_state = "mushbranchr-end1"
	base_icon_state = "mushbranchr-end"
	glowcolour = "#edf0c8"
	underlay_base = "center-mushroomr"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/mushroom/red
	icon_state = "corner-mushroomr1"
	base_icon_state = "corner-mushroomr1"
	num_random_icons = 0
	glowcolour = "#ce9f79"

/obj/structure/flora/newleaf/mushroom/red
	icon_state = "center-mushroomr1"
	base_icon_state = "center-mushroomr1"
	num_random_icons = 0
	glowcolour = "#ce9f79"
