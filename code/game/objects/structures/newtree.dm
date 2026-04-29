/obj/structure/flora/newtree
	name = "tree"
	desc = "The thick core of a tree."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "treenew"
	base_icon_state = "tree"
	num_random_icons = 2
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = -100, "acid" = 50)
	blade_dulling = DULLING_CUT
	opacity = TRUE
	density = TRUE
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	climbable = FALSE
	static_debris = list(/obj/item/grown/log/tree = 1)
	obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP | BLOCK_Z_OUT_DOWN
	max_integrity = 300
	var/burnt = FALSE
	var/underlay_base = "center-leaf"
	var/num_underlay_icons = 2
	var/tree_initalized = FALSE

/obj/structure/flora/newtree/Initialize()
	. = ..()
	GenerateTree()
	AddElement(/datum/element/give_turf_traits, string_list(list(TRAIT_IMMERSE_STOPPED)))

/obj/structure/flora/newtree/Destroy()
	SStreesetup.initialize_me -= src
	return ..()

/obj/structure/flora/newtree/update_overlays()
	. = ..()
	if(!underlay_base)
		return
	var/mutable_appearance/mutable = mutable_appearance(icon, "[underlay_base][rand(1, num_underlay_icons)]", layer - 0.01)
	mutable.dir = dir
	. += mutable

/obj/structure/flora/newtree/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = browser_input_list(user, "What will I take?", "STASH", user.mind.special_items)
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/flora/newtree/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(isliving(user) && user.can_z_move(UP, get_turf(user), z_move_flags = Z_MOVE_CLIMBING_FLAGS|ZMOVE_FEEDBACK))
		INVOKE_ASYNC(src, PROC_REF(start_traveling), user, UP)
		return TRUE

/obj/structure/flora/newtree/proc/start_traveling(mob/living/user, direction)
	var/turf/target = get_step_multiz(user, direction)
	var/myskill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/climbing)
	if(locate(/obj/structure/table) in user.loc)
		myskill += 1
	if(locate(/obj/structure/chair) in user.loc)
		myskill += 1
	var/used_time = max(7 SECONDS - (myskill * 1 SECONDS) - (GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) * 3), 3 SECONDS)
	if(user.m_intent != MOVE_INTENT_SNEAK)
		playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
	user.visible_message(span_warning("[user] starts to climb [src]."), span_warning("I start to climb [src]..."))
	if(do_after(user, used_time, src, display_over_user = TRUE))
		user.zMove(target = target, z_move_flags = Z_MOVE_CLIMBING_FLAGS)
		if(user.m_intent != MOVE_INTENT_SNEAK)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		var/exp_to_gain = (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)/2) * user.get_learning_boon(/datum/attribute/skill/misc/climbing)
		user.adjust_experience(/datum/attribute/skill/misc/climbing, exp_to_gain, FALSE)
		var/turf/pitfall = user.loc
		pitfall?.zFall(user)

/obj/structure/flora/newtree/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(atom_integrity <= 0)
		record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
		record_round_statistic(STATS_TREES_CUT)

/obj/structure/flora/newtree/fire_act(added, maxstacks)
	. = ..()
	if(.)
		burn_tree()

/obj/structure/flora/newtree/deconstruct()
	FellTree()
	return ..()

/obj/structure/flora/newtree/proc/burn_tree()
	name = "burnt tree"
	icon_state = "burnt"
	burnt = TRUE

//Used to be at initialize but i want to override it for burnt trees
/obj/structure/flora/newtree/proc/GenerateTree()
	dir = pick(GLOB.cardinals)
	SStreesetup.initialize_me |= src
	build_trees()
	if(istype(loc, /turf/open/floor/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/dirt)

/obj/structure/flora/newtree/proc/FellTree(transformation = FALSE)
	var/turf/NT = get_turf(src)
	var/turf/UPNT = GET_TURF_ABOVE(NT)
	src.obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP //so the logs actually fall when pulled by zfall

	for(var/obj/structure/flora/newtree/D in UPNT) //theoretically you'd be able to break trees through a floor but no one is building floors under a tree so this is probably fine
		if(!transformation)
			D.deconstruct()
		else
			D.FellTree(TRUE)
			qdel(D)
	for(var/obj/item/grown/log/tree/I in UPNT)
		if(!transformation)
			UPNT.zFall(I)
		else
			qdel(I)

	for(var/DI in GLOB.cardinals)
		var/turf/B = get_step(src, DI)
		for(var/obj/structure/flora/newbranch/BRANCH in B) //i straight up can't use locate here, it does not work
			if(BRANCH.dir == DI)
				var/turf/BI = get_step(B, DI)
				for(var/obj/structure/flora/newbranch/bi in BI) //2 tile end branch
					if(bi.dir == DI)
						if(!transformation)
							bi.obj_flags = CAN_BE_HIT
							bi.deconstruct()
						else
							qdel(bi)
					for(var/atom/bio in BI)
						BI.zFall(bio)
				for(var/obj/structure/flora/newleaf/bil in BI) //2 tile end leaf
					if(!transformation)
						bil.deconstruct()
					else
						qdel(bil)
				if(!transformation)
					BRANCH.obj_flags = CAN_BE_HIT
					BRANCH.deconstruct()
				else
					qdel(BRANCH)
			for(var/atom/BRA in B) //unload a sack of rocks on a branch and stand under it, it'll be funny bro
				B.zFall(BRA)

	for(var/turf/DIA in block(get_step(src, SOUTHWEST), get_step(src, NORTHEAST)))
		for(var/obj/structure/flora/newleaf/LEAF in DIA)
			if(!transformation)
				LEAF.deconstruct()
			else
				qdel(LEAF)

	if(!transformation)
		if(!istype(NT, /turf/open/openspace) && !(locate(/obj/structure/table/wood/treestump) in NT)) //if i don't add the stump check it spawns however many zlevels it goes up because of src recursion
			new /obj/structure/table/wood/treestump(NT)
		playsound(src, 'sound/misc/treefall.ogg', 100, FALSE)

/obj/structure/flora/newtree/proc/build_trees()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if(istype(target, /turf/open/openspace))
		var/obj/structure/flora/newtree/T = new(target)
		T.icon_state = icon_state
		T.update_appearance(UPDATE_OVERLAYS)

/obj/structure/flora/newtree/proc/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleaf/corner/T = new(NT)
				T.dir = D

/obj/structure/flora/newtree/proc/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(locate(/obj/structure/stairs) in get_step_multiz(NT, DOWN))
			continue
		if(istype(NT, /turf/open/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/openspace) && prob(50))//make an ending branch
				if(prob(50))
					if(!(locate(/obj/structure) in NB) && !(locate(/obj/structure/stairs) in get_step_multiz(NB, DOWN)))
						var/obj/structure/flora/newbranch/T = new(NB)
						T.dir = D
					if(!(locate(/obj/structure) in NT))
						var/obj/structure/flora/newbranch/connector/TC = new(NT)
						TC.dir = D
				else
					if(!(locate(/obj/structure) in NB))
						new /obj/structure/flora/newleaf(NB)
					if(!(locate(/obj/structure) in NT))
						var/obj/structure/flora/newbranch/TC = new(NT)
						TC.dir = D
			else
				if(!(locate(/obj/structure) in NT))
					var/obj/structure/flora/newbranch/TC = new(NT)
					TC.dir = D
		else
			if(prob(70))
				if(isopenturf(NT))
					if(!istype(loc, /turf/open/openspace)) //must be lowest
						if(!(locate(/obj/structure) in NT))
							var/obj/structure/flora/newbranch/leafless/T = new(NT)
							T.dir = D


/*
	START SNOW
				*/

///Tree, but snow leaves
/obj/structure/flora/newtree/snow
	icon_state = "treesnow"
	underlay_base = "center-leaf-cold"
	num_underlay_icons = 1

/obj/structure/flora/newtree/snow/build_trees()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if(istype(target, /turf/open/openspace))
		var/obj/structure/flora/newtree/snow/T = new(target)
		T.icon_state = icon_state
		T.update_appearance(UPDATE_OVERLAYS)

/obj/structure/flora/newtree/snow/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleaf/corner/snow/T = new(NT)
				T.dir = D

/obj/structure/flora/newtree/snow/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(locate(/obj/structure/stairs) in get_step_multiz(NT, DOWN))
			continue
		if(istype(NT, /turf/open/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/openspace) && prob(50))
				if(prob(50))
					if(!(locate(/obj/structure) in NB) && !(locate(/obj/structure/stairs) in get_step_multiz(NB, DOWN)))
						var/obj/structure/flora/newbranch/snow/T = new(NB)
						T.dir = D
					if(!(locate(/obj/structure) in NT))
						var/obj/structure/flora/newbranch/connector/snow/TC = new(NT)
						TC.dir = D
				else
					if(!(locate(/obj/structure) in NT))
						var/obj/structure/flora/newbranch/snow/TC = new(NT)
						TC.dir = D
			else
				if(!(locate(/obj/structure) in NT))
					var/obj/structure/flora/newbranch/snow/TC = new(NT)
					TC.dir = D

/*
	END SNOW
				*/

/obj/structure/flora/newtree/palm
	icon_state = "treepalm"
	underlay_base = "center-leaf-palm"
	num_underlay_icons = 1

/obj/structure/flora/newtree/palm/build_trees()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if(istype(target, /turf/open/openspace))
		var/obj/structure/flora/newtree/palm/T = new(target)
		T.icon_state = icon_state
		T.update_appearance(UPDATE_OVERLAYS)

/obj/structure/flora/newtree/palm/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleaf/corner/palm/T = new(NT)
				T.dir = D

/obj/structure/flora/newtree/palm/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/openspace) && prob(50))
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranch/palm/TC = new(NT)
					TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranch/palm/TC = new(NT)
					TC.dir = D


/obj/structure/flora/newbranch/palm
	icon_state = "branchpalm_end1"
	base_icon_state = "branchpalm_end"
	underlay_base = "center-leaf-palm"
	num_underlay_icons = 1

/obj/structure/flora/newleaf/corner/palm
	icon_state = "edge-leaf-palm"
	num_random_icons = 0

/*
	START BURNT
				*/
/obj/structure/flora/newtree/scorched
	name = "scorched tree"
	desc = "A tree trunk scorched to ruin."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "treeburnt"
	num_random_icons = 0
	burnt = TRUE
	underlay_base = null

/obj/structure/flora/newtree/scorched/build_trees()
	var/turf/target = GET_TURF_ABOVE(get_turf(src))
	if(istype(target, /turf/open/openspace))
		new /obj/structure/flora/newtree/scorched(target)

//Naught but ash remains.
/obj/structure/flora/newtree/scorched/build_leafs()
	return

/obj/structure/flora/newtree/scorched/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/openspace) && prob(50))//make an ending branch
				if(prob(50))
					if(!locate(/obj/structure) in NB)
						var/obj/structure/flora/newbranch/leafless/scorched/T = new(NB)
						T.dir = D
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/connector/scorched/TC = new(NT)
						TC.dir = D
				else
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/leafless/scorched/TC = new(NT)
						TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranch/leafless/scorched/TC = new(NT)
					TC.dir = D
		else
			if(prob(70))
				if(isopenturf(NT))
					if(!istype(loc, /turf/open/openspace)) //must be lowest
						if(!locate(/obj/structure) in NT)
							var/obj/structure/flora/newbranch/leafless/scorched/T = new(NT)
							T.dir = D

/*
	END BURNT
				*/

///BRANCHES

/obj/structure/flora/newbranch
	name = "branch"
	desc = "A stable branch, should be safe to walk on."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "branch-end1"
	base_icon_state = "branch-end"
	attacked_sound = 'sound/misc/woodhit.ogg'
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	static_debris = list(/obj/item/grown/log/tree/stick = 1)
	max_integrity = 30
	num_random_icons = 2
	var/underlay_base = "center-leaf"
	var/num_underlay_icons = 2
	layer = LATTICE_LAYER
	plane = FLOOR_PLANE

/obj/structure/flora/newbranch/Initialize(mapload, ...)
	. = ..()
	AddComponent(\
		/datum/component/squeak,\
		list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg'),\
		100,\
		extrarange = SHORT_RANGE_SOUND_EXTRARANGE,\
	)
	AddElement(/datum/element/give_turf_traits, string_list(list(TRAIT_IMMERSE_STOPPED)))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/flora/newbranch/update_overlays()
	. = ..()
	if(!underlay_base)
		return
	var/mutable_appearance/mutable = mutable_appearance(icon, "[underlay_base][rand(1, num_underlay_icons)]", layer - 0.01)
	mutable.dir = dir
	. += mutable

/obj/structure/flora/newbranch/snow
	underlay_base = "center-leaf-cold"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/leafless
	underlay_base = null

/obj/structure/flora/newbranch/leafless/scorched
	name = "burnt branch"
	icon_state = "branchburnt-end1"
	base_icon_state = "branchburnt-end"
	desc = "Cracked and hardened from a terrible fire."
	static_debris = null

/obj/structure/flora/newbranch/connector
	icon_state = "branch-extend"
	num_underlay_icons = 2
	num_random_icons = 0

/obj/structure/flora/newbranch/connector/snow
	underlay_base = "center-leaf-cold"
	num_underlay_icons = 1

/obj/structure/flora/newbranch/connector/scorched
	name = "burnt branch"
	desc = "Cracked and hardened from a terrible fire."
	icon_state = "branchburnt-extend"
	underlay_base = null
	num_underlay_icons = 0

/obj/structure/flora/newleaf
	name = "leaves"
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "center-leaf1"
	base_icon_state = "center-leaf"
	num_random_icons = 2
	max_integrity = 10
	layer = LATTICE_LAYER
	plane = FLOOR_PLANE

/obj/structure/flora/newleaf/attack_hand(mob/user)
	if(isopenspace(loc))
		loc.attack_hand(user) // so clicking leaves with an empty hand lets you climb down.
	return ..()

/obj/structure/flora/newleaf/corner
	icon_state = "corner-leaf1"
	base_icon_state = "corner-leaf"

/obj/structure/flora/newleaf/corner/snow
	icon_state = "corner-leaf-cold1"
	num_random_icons = 0

/obj/structure/flora/newleaf/snow
	icon_state = "center-leaf-cold1"
	num_random_icons = 0
