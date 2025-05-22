/obj/structure/flora/newtree
	name = "tree"
	desc = "The thick core of a tree."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "treenew"
	///The Log Type
	var/tree_type
	///If not null, bonus overlay ontop of normal log.
	var/base_state
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = -100, "acid" = 50)
	blade_dulling = DULLING_CUT
	opacity = 1
	density = 1
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	climbable = FALSE
	static_debris = list(/obj/item/grown/log/tree = 1)
	obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP | BLOCK_Z_OUT_DOWN
	max_integrity = 300
	//If the tree has been burn beforehand.
	var/burnt = FALSE

/obj/structure/flora/newtree/Initialize()
	. = ..()
	GenerateTree()

/obj/structure/flora/newtree/update_icon()
	if(burnt)
		icon_state = "burnt"
		cut_overlays()
		return
	icon_state = null
	cut_overlays()
	var/mutable_appearance/mutable
	if(base_state)
		mutable = mutable_appearance(icon, "[base_state]")
		add_overlay(mutable)
	mutable = mutable_appearance(icon, "tree[tree_type]")
	mutable.dir = dir
	add_overlay(mutable)

/*
* get_complex_damage comes from item_attack.dm
* Its purpose is to alter damage based on several
* factors and apply dulling to weapons.
*/

/obj/structure/flora/newtree/attack_right(mob/user)
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = input(user, "What will I take?", "STASH") as null|anything in user.mind.special_items
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
			return

/obj/structure/flora/newtree/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/turf/target = get_step_multiz(user, UP)
		if(!istype(target, /turf/open/transparent/openspace))
			to_chat(user, "<span class='warning'>I can't climb here.</span>")
			return
		if(!L.can_zTravel(target, UP))
			to_chat(user, "<span class='warning'>I can't climb there.</span>")
			return
		var/used_time = 0
		var/exp_to_gain = 0
		if(L.mind)
			var/myskill = L.get_skill_level(/datum/skill/misc/climbing)
			exp_to_gain = (L.STAINT/2) * L.get_learning_boon(/datum/skill/misc/climbing)
			var/obj/structure/table/TA = locate() in L.loc
			if(TA)
				myskill += 1
			else
				var/obj/structure/chair/CH = locate() in L.loc
				if(CH)
					myskill += 1
			used_time = max(7 SECONDS - (myskill * 1 SECONDS) - (L.STASPD * 3), 3 SECONDS)
		playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		user.visible_message("<span class='warning'>[user] starts to climb [src].</span>", "<span class='warning'>I start to climb [src]...</span>")
		if(do_after(L, used_time, src))
			var/pulling = user.pulling
			if(ismob(pulling))
				user.pulling.forceMove(target)
			user.forceMove(target)
			user.start_pulling(pulling,supress_message = TRUE)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
			if(L.mind)
				L.adjust_experience(/datum/skill/misc/climbing, exp_to_gain, FALSE)

/obj/structure/flora/newtree/attacked_by(obj/item/I, mob/living/user)
	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			GLOB.vanderlin_round_stats[STATS_TREES_CUT]++

/obj/structure/flora/newtree/fire_act(added, maxstacks)
	. = ..()
	if(.)
		burnt = TRUE
		if(icon_state != "burnt")
			name = "burnt tree"
			update_icon()

//The root of this is not very modular so i have to override it.
/obj/structure/flora/newtree/obj_destruction(damage_flag)
	obj_destroyed = TRUE
	//Sloppy code but it works.
	if(burnt)
		damage_flag = "fire"
	FellTree(damage_flag)
	if(damage_flag == "acid")
		acid_melt()
	else if(damage_flag == "fire")
		burn()
	else
		if(destroy_sound)
			playsound(src, destroy_sound, 100, TRUE)
		if(destroy_message)
			visible_message(destroy_message)
		//This right here? I had to change it to TRUE.
		deconstruct(TRUE)
	return TRUE

/*
* Okay so the root of this proc defines dissasemble
* but doesnt do anything with it. This means despite
* burn() calling deconstruct(FALSE) it will still
* spawn the debris.
*/
/obj/structure/flora/newtree/deconstruct(disassembled = TRUE)
	if(disassembled)
		return ..()
	qdel(src)

//Used to be at initialize but i want to override it for burnt trees
/obj/structure/flora/newtree/proc/GenerateTree()
	if(isnull(tree_type))
		tree_type = pick(list(1,2))
	dir = pick(GLOB.cardinals)
	SStreesetup.initialize_me |= src
	build_trees()
	update_icon()
	if(istype(loc, /turf/open/floor/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/dirt)

/obj/structure/flora/newtree/proc/FellTree(damage_type)
	var/turf/NT = get_turf(src)
	var/turf/UPNT = get_step_multiz(src, UP)
	src.obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP //so the logs actually fall when pulled by zfall

	for(var/obj/structure/flora/newtree/D in UPNT)//theoretically you'd be able to break trees through a floor but no one is building floors under a tree so this is probably fine
		D.obj_destruction(damage_type)
	for(var/obj/item/grown/log/tree/I in UPNT)
		UPNT.zFall(I)

	for(var/DI in GLOB.cardinals)
		var/turf/B = get_step(src, DI)
		for(var/obj/structure/flora/newbranch/BRANCH in B)//i straight up can't use locate here, it does not work
			if(BRANCH.dir == DI)
				var/turf/BI = get_step(B, DI)
				for(var/obj/structure/flora/newbranch/bi in BI)//2 tile end branch
					if(bi.dir == DI)
						bi.obj_flags = CAN_BE_HIT
						bi.obj_destruction(damage_type)
					for(var/atom/bio in BI)
						BI.zFall(bio)
				for(var/obj/structure/flora/newleaf/bil in BI)//2 tile end leaf
					bil.obj_destruction(damage_type)
				BRANCH.obj_flags = CAN_BE_HIT
				BRANCH.obj_destruction(damage_type)
			for(var/atom/BRA in B)//unload a sack of rocks on a branch and stand under it, it'll be funny bro
				B.zFall(BRA)

	for(var/turf/DIA in block(get_step(src, SOUTHWEST), get_step(src, NORTHEAST)))
		for(var/obj/structure/flora/newleaf/LEAF in DIA)
			LEAF.obj_destruction(damage_type)

	if(!istype(NT, /turf/open/transparent/openspace) && !(locate(/obj/structure/table/wood/treestump) in NT))//if i don't add the stump check it spawns however many zlevels it goes up because of src recursion
		new /obj/structure/table/wood/treestump(NT)
	playsound(src, 'sound/misc/treefall.ogg', 100, FALSE)

/obj/structure/flora/newtree/proc/build_trees()
	var/turf/target = get_step_multiz(src, UP)
	if(istype(target, /turf/open/transparent/openspace))
		var/obj/structure/flora/newtree/T = new(target)
		T.base_state = "center-leaf[rand(1,2)]"
		T.tree_type = src.tree_type
		T.update_icon()

/obj/structure/flora/newtree/proc/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleaf/corner/T = new(NT)
				T.dir = D

/obj/structure/flora/newtree/proc/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/transparent/openspace) && prob(50))//make an ending branch
				if(prob(50))
					if(!locate(/obj/structure) in NB)
						var/obj/structure/flora/newbranch/T = new(NB)
						T.dir = D
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/connector/TC = new(NT)
						TC.dir = D
				else
					if(!locate(/obj/structure) in NB)
						new /obj/structure/flora/newleaf(NB)
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/TC = new(NT)
						TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranch/TC = new(NT)
					TC.dir = D
		else
			if(prob(70))
				if(isopenturf(NT))
					if(!istype(loc, /turf/open/transparent/openspace)) //must be lowest
						if(!locate(/obj/structure) in NT)
							var/obj/structure/flora/newbranch/leafless/T = new(NT)
							T.dir = D


/*
	START SNOW
				*/

///Tree, but snow leaves
/obj/structure/flora/newtree/snow
	icon_state = "treesnow"
/obj/structure/flora/newtree/snow/build_trees()
	var/turf/target = get_step_multiz(src, UP)
	if(istype(target, /turf/open/transparent/openspace))
		var/obj/structure/flora/newtree/snow/T = new(target)
		T.base_state = "center-leaf-cold1"
		T.update_icon()

/obj/structure/flora/newtree/snow/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleaf/corner/snow/T = new(NT)
				T.dir = D

/obj/structure/flora/newtree/snow/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/transparent/openspace) && prob(50))
				if(prob(50))
					if(!locate(/obj/structure) in NB)
						var/obj/structure/flora/newbranch/snow/T = new(NB)
						T.dir = D
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/connector/snow/TC = new(NT)
						TC.dir = D
				else
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranch/snow/TC = new(NT)
						TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranch/snow/TC = new(NT)
					TC.dir = D

/*
	END SNOW
				*/

/*
	START BURNT
				*/
/obj/structure/flora/newtree/scorched
	name = "scorched tree"
	desc = "A tree trunk scorched to ruin."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "burnt"
	burnt = TRUE

//I dont really understand the purpose of adding a duplicate icon overlay ontop of the overlay.
/obj/structure/flora/newtree/scorched/update_icon()
	icon_state = "burnt"
	cut_overlays()

/obj/structure/flora/newtree/scorched/build_trees()
	var/turf/target = get_step_multiz(src, UP)
	if(istype(target, /turf/open/transparent/openspace))
		new /obj/structure/flora/newtree/scorched(target)

//Naught but ash remains.
/obj/structure/flora/newtree/scorched/build_leafs()
	return

/obj/structure/flora/newtree/scorched/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/transparent/openspace) && prob(50))//make an ending branch
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
					if(!istype(loc, /turf/open/transparent/openspace)) //must be lowest
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
	attacked_sound = 'sound/misc/woodhit.ogg'
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	static_debris = list(/obj/item/grown/log/tree/stick = 1)
	///The leaves[If any]
	var/base_state
	density = FALSE
	max_integrity = 30

/obj/structure/flora/newbranch/update_icon()
	cut_overlays()
	var/mutable_appearance/mutable
	if(isnull(base_state))
		mutable = mutable_appearance(icon, "center-leaf[rand(1,2)]")
	else
		mutable = mutable_appearance(icon,base_state)
	mutable.dir = dir
	add_overlay(mutable)
	if(isnull(icon_state))
		mutable = mutable_appearance(icon, "branch-end[rand(1,2)]")
	else
		mutable = mutable_appearance(icon,icon_state)
	mutable.dir = dir
	add_overlay(mutable)
/obj/structure/flora/newbranch/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg'), 100)
	update_icon()

/obj/structure/flora/newbranch/connector
	icon_state = "branch-extend"
//Snow
/obj/structure/flora/newbranch/connector/snow
	base_state = "center-leaf-cold1"
/obj/structure/flora/newbranch/snow
	base_state = "center-leaf-cold1"
//BURNT SUBTYPE
/obj/structure/flora/newbranch/connector/scorched
	name = "burnt branch"
	desc = "Cracked and hardened from a terrible fire."
	icon_state = "branchburnt-extend"
//Normal
/obj/structure/flora/newbranch/leafless

/obj/structure/flora/newbranch/leafless/update_icon()
	cut_overlays()
	var/mutable_appearance/mutable = mutable_appearance(icon, "branch-end[rand(1,2)]")
	mutable.dir = dir
	add_overlay(mutable)

//BURNT SUBTYPE
/obj/structure/flora/newbranch/leafless/scorched
	name = "burnt branch"
	desc = "Cracked and hardened from a terrible fire."
	static_debris = list()

/obj/structure/flora/newbranch/leafless/scorched/Initialize()
	. = ..()
	icon_state = "branchburnt-end[rand(1,2)]"

/// LEAF

/obj/structure/flora/newleaf
	name = "leaves"
	icon = 'icons/roguetown/misc/tree.dmi'
	density = FALSE
	max_integrity = 10

/obj/structure/flora/newleaf/attack_hand(mob/user)
	if(isopenspace(loc))
		loc.attack_hand(user) // so clicking leaves with an empty hand lets you climb down.
	. = ..()

/obj/structure/flora/newleaf/Initialize()
	. = ..()
	if(isnull(icon_state))
		icon_state = "center-leaf[rand(1,2)]"
	update_icon()

/obj/structure/flora/newleaf/corner

/obj/structure/flora/newleaf/corner/Initialize()
	. = ..()
	if(isnull(icon_state))
		icon_state = "corner-leaf[rand(1,2)]"
	update_icon()

/obj/structure/flora/newleaf/corner/snow
	icon_state = "corner-leaf-cold1"

/obj/structure/flora/newleaf/snow
	icon_state = "center-leaf-cold1"
	density = FALSE
	max_integrity = 10
