/turf
	icon = 'icons/turf/floors.dmi'
	level = 1

	var/intact = 1

	// baseturfs can be either a list or a single turf type.
	// In class definition like here it should always be a single type.
	// A list will be created in initialization that figures out the baseturf's baseturf etc.
	// In the case of a list it is sorted from bottom layer to top.
	// This shouldn't be modified directly, use the helper procs.
	var/list/baseturfs = /turf/open/transparent/openspace

	var/temperature = 293.15
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

	var/blocks_air = FALSE

	flags_1 = CAN_BE_DIRTY_1

	var/list/image/blueprint_data //for the station blueprints, images of objects eg: pipes

	var/explosion_level = 0	//for preventing explosion dodging
	var/explosion_id = 0

	var/changing_turf = FALSE

	var/bullet_bounce_sound = 'sound/blank.ogg' //sound played when a shell casing is ejected ontop of the turf.
	var/bullet_sizzle = FALSE //used by ammo_casing/bounce_away() to determine if the shell casing should make a sizzle sound when it's ejected over the turf
							//IE if the turf is supposed to be water, set TRUE.

	var/turf_integrity	//defaults to max_integrity
	var/max_integrity = 500
	var/integrity_failure = 0 //0 if we have no special broken behavior, otherwise is a percentage of at what point the obj breaks. 0.5 being 50%
	///Damage under this value will be completely ignored
	var/damage_deflection = 5

	var/blade_dulling = DULLING_FLOOR
	var/attacked_sound

	var/break_sound = null //The sound played when a turf breaks
	var/debris = null
	var/break_message = null

	/// What we overlay onto turfs in our smoothing_list
	var/neighborlay
	/// If we were going to smooth with an Atom instead overlay this onto self
	var/neighborlay_self

	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list("x", "y", "z")
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
#ifdef TESTSERVER
	if(!icon_state)
		icon_state = "cantfind"
#endif
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.Cut()

	assemble_baseturfs()

	levelupdate()

	SETUP_SMOOTHING()

	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH(src)

	for(var/atom/movable/AM in src)
		Entered(AM)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if (light_power && (light_outer_range || light_inner_range))
		update_light()

	if(turf_integrity == null)
		turf_integrity = max_integrity

	var/turf/T = GET_TURF_ABOVE(src)
	if(T)
		T.multiz_turf_new(src, DOWN)
		SEND_SIGNAL(T, COMSIG_TURF_MULTIZ_NEW, src, DOWN)
	T = GET_TURF_BELOW(src)
	if(T)
		T.multiz_turf_new(src, UP)
		SEND_SIGNAL(T, COMSIG_TURF_MULTIZ_NEW, src, UP)
	if(!mapload)
		reassess_stack()

	if (opacity)
		has_opaque_atom = TRUE

	ComponentInitialize()

	QUEUE_SMOOTH_NEIGHBORS(src)

	if(shine)
		make_shiny(shine)

	return INITIALIZE_HINT_NORMAL

/turf/Destroy(force)
	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		stack_trace("Incorrect turf deletion")
	changing_turf = FALSE
	if(neighborlay_list)
		remove_neighborlays()
	var/turf/T = GET_TURF_ABOVE(src)
	if(T)
		T.multiz_turf_del(src, DOWN)
	T = GET_TURF_BELOW(src)
	if(T)
		T.multiz_turf_del(src, UP)
	if(force)
		..()
		//this will completely wipe turf state
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		for(var/I in B.vars)
			B.vars[I] = null
		return
	QDEL_LIST(blueprint_data)
	flags_1 &= ~INITIALIZED_1
	..()

/turf/proc/can_see_sky()
	if(!outdoor_effect)
		return FALSE
	if(outdoor_effect.state != SKY_BLOCKED)
		return TRUE
	return FALSE

/turf/proc/can_traverse_safely(atom/movable/traveler)
	return TRUE

/// WARNING WARNING
/// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
/// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
/// We do it because moving signals over was needlessly expensive, and bloated a very commonly used bit of code
/turf/clear_signal_refs()
	return

/turf/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.Move_Pulled(src)

/turf/proc/multiz_turf_del(turf/T, dir)
	reassess_stack()

/turf/proc/multiz_turf_new(turf/T, dir)
	reassess_stack()


/turf/proc/is_blocked_turf(exclude_mobs = FALSE, source_atom = null, list/ignore_atoms, type_list = FALSE)
	if((!isnull(source_atom) && !CanPass(source_atom, get_dir(src, source_atom))) || density)
		return TRUE

	for(var/atom/movable/movable_content as anything in contents)
		// We don't want to block ourselves
		if((movable_content == source_atom))
			continue
		// don't consider ignored atoms or their types
		if(length(ignore_atoms))
			if(!type_list && (movable_content in ignore_atoms))
				continue
			else if(type_list && is_type_in_list(movable_content, ignore_atoms))
				continue

		// If the thing is dense AND we're including mobs or the thing isn't a mob AND if there's a source atom and
		// it cannot pass through the thing on the turf,  we consider the turf blocked.
		if(movable_content.density && (!exclude_mobs || !ismob(movable_content)))
			if(source_atom && movable_content.CanPass(source_atom, get_dir(src, source_atom)))
				continue
			return TRUE
	return FALSE

//zPassIn doesn't necessarily pass an atom!
//direction is direction of travel of air
/turf/proc/zPassIn(atom/movable/A, direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zPassOut(atom/movable/A, direction, turf/destination)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirIn(direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirOut(direction, turf/source)
	return FALSE

/turf/proc/zImpact(atom/movable/A, levels = 1, turf/prev_turf)
	if(levels == 1 && A.ai_controller)
		for(var/obj/structure/stairs/S in contents)
			return FALSE

	var/flags = NONE
	var/mov_name = A.name
	for(var/i in contents)
		var/atom/thing = i
		flags |= thing.intercept_zImpact(A, levels)
		if(flags & FALL_STOP_INTERCEPTING)
			break
	if(prev_turf && !(flags & FALL_NO_MESSAGE))
		prev_turf.visible_message("<span class='danger'>\The [mov_name] falls through [prev_turf]!</span>")
	if(flags & FALL_INTERCEPTED)
		return
	if(zFall(A, ++levels))
		return FALSE
	if(isliving(A))
		var/mob/living/O = A
		var/dex_save = O.get_skill_level(/datum/skill/misc/climbing)
		if(dex_save >= 5)
			if(O.m_intent != MOVE_INTENT_SNEAK) // If we're sneaking, don't show a message to anybody, shhh!
				O.visible_message("<span class='danger'>[A] gracefully lands on top of [src]!</span>")
		else
			A.visible_message("<span class='danger'>[A] crashes into [src]!</span>")
			if(A.fall_damage())
				for(var/mob/living/M in contents)
					visible_message("<span class='danger'>\The [src] falls on \the [M.name]!</span>")
					M.Stun(1)
					M.take_overall_damage(A.fall_damage()*2)
	if(A.fall_damage())
		for(var/mob/living/M in contents)
			visible_message("<span class='danger'>\The [src] falls on \the [M.name]!</span>")
			M.Stun(1)
			M.take_overall_damage(A.fall_damage()*2)
	A.onZImpact(src, levels)
	if(isobj(A))
		for(var/mob/living/mob in contents)
			A:on_fall_impact(mob, levels * 0.75)
	return TRUE

/atom/movable/proc/fall_damage()
	return 0

/obj/item/fall_damage()
	if(w_class == WEIGHT_CLASS_TINY)
		return 0
	if(w_class == WEIGHT_CLASS_GIGANTIC)
		return 300
	var/bsc = 3**(w_class-1)
	return bsc

/obj/structure/fall_damage()
	if(w_class == WEIGHT_CLASS_TINY)
		return 0
	if(w_class == WEIGHT_CLASS_GIGANTIC)
		return 300
	var/bsc = 3**(w_class-1)
	return bsc

/turf/proc/can_zFall(atom/movable/A, levels = 1, turf/target)
	return zPassOut(A, DOWN, target) && target.zPassIn(A, DOWN, src)

/turf/proc/zFall(atom/movable/A, levels = 1, force = FALSE)
	var/turf/target = get_step_multiz(src, DOWN)
	if(!target || (!isobj(A) && !ismob(A)))
		return FALSE
	if(!force && (!can_zFall(A, levels, target) || !A.can_zFall(src, levels, target, DOWN)))
		return FALSE
	A.atom_flags |= Z_FALLING
	A.forceMove(target)
	A.atom_flags &= ~Z_FALLING
	target.zImpact(A, levels, src)
	return TRUE

/turf/CanPass(atom/movable/mover, turf/target)
	if(!target)
		return FALSE
	if(iscameramob(mover))
		return TRUE
	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	stack_trace("Non movable passed to turf CanPass : [mover]")
	return FALSE

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
/turf/Enter(atom/movable/mover, atom/oldloc)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/canPassSelf = CanPass(mover, src)
	if(canPassSelf || CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
		for(var/atom/movable/thing as anything in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(thing == mover || thing == mover.loc) // Multi tile objects and moving out of other objects
				continue
			if(!thing.Cross(mover))
				if(QDELETED(mover))		//Mover deleted from Cross/CanPass, do not proceed.
					return FALSE
				if(CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags_1 & ON_BORDER_1) && !(firstbump.flags_1 & ON_BORDER_1)))
						firstbump = thing
	if(QDELETED(mover))					//Mover deleted from Cross/CanPass/Bump, do not proceed.
		return FALSE
	if(!canPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE)
	return TRUE

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!. || QDELETED(mover))
		return FALSE
	for(var/i in contents)
		if(i == mover)
			continue
		if(QDELETED(mover))
			return FALSE		//We were deleted.

/turf/Entered(atom/movable/AM)
	..()
	SEND_SIGNAL(src, COMSIG_TURF_ENTERED, AM)
	SEND_SIGNAL(AM, COMSIG_MOVABLE_TURF_ENTERED, src)

	if(explosion_level && AM.ex_check(explosion_id))
		AM.ex_act(explosion_level)

	// If an opaque movable atom moves around we need to potentially update visibility.
	if (AM.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

/turf/open/Entered(atom/movable/AM)
	..()
	//melting
	if(isobj(AM) && temperature > 273.15)
		var/obj/O = AM
		if(O.obj_flags & FROZEN)
			O.make_unfrozen()
	if(!(AM.atom_flags & Z_FALLING))
		zFall(AM)

/turf/proc/is_plasteel_floor()
	return FALSE

// A proc in case it needs to be recreated or badmins want to change the baseturfs
/turf/proc/assemble_baseturfs(turf/fake_baseturf_type)
	var/static/list/created_baseturf_lists = list()
	var/turf/current_target
	if(fake_baseturf_type)
		if(length(fake_baseturf_type)) // We were given a list, just apply it and move on
			baseturfs = fake_baseturf_type
			return
		current_target = fake_baseturf_type
	else
		if(length(baseturfs))
			return // No replacement baseturf has been given and the current baseturfs value is already a list/assembled
		if(!baseturfs)
			current_target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [current_target].")
		else
			current_target = baseturfs

	// If we've made the output before we don't need to regenerate it
	if(created_baseturf_lists[current_target])
		var/list/premade_baseturfs = created_baseturf_lists[current_target]
		if(length(premade_baseturfs))
			baseturfs = premade_baseturfs.Copy()
		else
			baseturfs = premade_baseturfs
		return baseturfs

	var/turf/next_target = initial(current_target.baseturfs)
	//Most things only have 1 baseturf so this loop won't run in most cases
	if(current_target == next_target)
		baseturfs = current_target
		created_baseturf_lists[current_target] = current_target
		return current_target
	var/list/new_baseturfs = list(current_target)
	for(var/i=0;current_target != next_target;i++)
		if(i > 100)
			// A baseturfs list over 100 members long is silly
			// Because of how this is all structured it will only runtime/message once per type
			stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			break
		new_baseturfs.Insert(1, next_target)
		current_target = next_target
		next_target = initial(current_target.baseturfs)

	baseturfs = new_baseturfs
	created_baseturf_lists[new_baseturfs[new_baseturfs.len]] = new_baseturfs.Copy()
	return new_baseturfs

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1 && (O.flags_1 & INITIALIZED_1))
			O.hide(src.intact)

/turf/proc/phase_damage_creatures(damage,mob/U = null)//>Ninja Code. Hurts and knocks out creatures on this turf //NINJACODE
	for(var/mob/living/M in src)
		if(M==U)
			continue//Will not harm U. Since null != M, can be excluded to kill everyone.
		M.adjustBruteLoss(damage)
		M.Unconscious(damage * 4)

/turf/proc/Bless()
	new /obj/effect/blessing(src)

/turf/storage_contents_dump_act(datum/component/storage/src_object, mob/user)
	. = ..()
	if(.)
		return
	if(length(src_object.contents()))
		to_chat(usr, "<span class='notice'>I start dumping out the contents...</span>")
		if(!do_after(usr, 2 SECONDS, src_object.parent))
			return FALSE

	var/list/things = src_object.contents()
	var/datum/progressbar/progress = new(user, things.len, src)
	while (do_after(usr, 1 SECONDS, src, NONE, FALSE, CALLBACK(src_object, TYPE_PROC_REF(/datum/component/storage, mass_remove_from_storage), src, things, progress)))
		stoplag(1)
	progress.end_progress()

	return TRUE

//////////////////////////////
//Distance procs
//////////////////////////////

/// Returns an additional distance factor based on slowdown and other factors.
/turf/proc/get_heuristic_slowdown(mob/traverser, travel_dir)
	. = get_slowdown(traverser)
	// add cost from climbable obstacles
	for(var/obj/structure/some_object in src)
		if(some_object.density && some_object.climbable)
			. += 1 // extra tile penalty
			break
	var/obj/structure/door/door = locate() in src
	if(door && door.density && !door.locked() && door.anchored) // door will have to be opened
		. += 2 // try to avoid closed doors where possible

	for(var/obj/structure/O in contents)
		if(O.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	. += path_weight

// Like Distance_cardinal, but includes additional weighting to make A* prefer turfs that are easier to pass through.
/turf/proc/Heuristic_cardinal(turf/T, mob/traverser)
	var/travel_dir = get_dir(src, T)
	. = Distance_cardinal(T, traverser) + get_heuristic_slowdown(traverser, travel_dir) + T.get_heuristic_slowdown(traverser, travel_dir)

/// A 3d-aware version of Heuristic_cardinal that just... adds the Z-axis distance with a multiplier.
/turf/proc/Heuristic_cardinal_3d(turf/T, mob/traverser)
	return Heuristic_cardinal(T, traverser) + abs(z - T.z) * 5 // Weight z-level differences higher so that we try to change Z-level sooner

//Distance associates with all directions movement
/turf/proc/Distance(turf/T, mob/traverser)
	while(T.z != z)
		if(T.z > z)
			T = GET_TURF_BELOW(T)
		else
			T = GET_TURF_ABOVE(T)
	return get_dist(src,T)

//  This Distance proc assumes that only cardinal movement is
//  possible. It results in more efficient (CPU-wise) pathing
//  for bots and anything else that only moves in cardinal dirs.
/turf/proc/Distance_cardinal(turf/T, mob/traverser)
	if(!src || !T)
		return FALSE
	return abs(x - T.x) + abs(y - T.y)

////////////////////////////////////////////////////

/turf/proc/burn_tile()

/turf/proc/is_shielded()

/turf/contents_explosion(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/affecting_level
	if(severity == 1)
		affecting_level = 1
	else if(is_shielded())
		affecting_level = 3
	else if(intact)
		affecting_level = 2
	else
		affecting_level = 1

	for(var/V in contents)
		var/atom/A = V
		if(!QDELETED(A) && A.level >= affecting_level)
			if(ismovableatom(A))
				var/atom/movable/AM = A
				if(!AM.ex_check(explosion_id))
					continue
			A.ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
			CHECK_TICK

/turf/narsie_act(force, ignore_mobs, probability = 20)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.narsie_act()

/turf/proc/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = icon
	underlay_appearance.icon_state = icon_state
	underlay_appearance.dir = adjacency_dir
	return TRUE

/turf/proc/is_transition_turf()
	return

/turf/acid_act(acidpwr, acid_volume)
	. = 1
	var/acid_type = /obj/effect/acid
	var/has_acid_effect = FALSE
	for(var/obj/O in src)
		if(intact && O.level == 1) //hidden under the floor
			continue
		if(istype(O, acid_type))
			var/obj/effect/acid/A = O
			A.acid_level = min(A.level + acid_volume * acidpwr, 12000)//capping acid level to limit power of the acid
			has_acid_effect = 1
			continue
		O.acid_act(acidpwr, acid_volume)
	if(!has_acid_effect)
		new acid_type(src, acidpwr, acid_volume)

/turf/proc/acid_melt()
	return

/turf/handle_fall(mob/faller)
	if(has_gravity(src))
		playsound(src, "bodyfall", 100, TRUE)
	faller.drop_all_held_items()

/turf/proc/photograph(limit=20)
	var/image/I = new()
	I.add_overlay(src)
	for(var/V in contents)
		var/atom/A = V
		if(A.invisibility)
			continue
		I.add_overlay(A)
		if(limit)
			limit--
		else
			return I
	return I

/turf/AllowDrop()
	return TRUE

/turf/proc/add_vomit_floor(mob/living/M, toxvomit = NONE)

	var/obj/effect/decal/cleanable/vomit/V = new /obj/effect/decal/cleanable/vomit(src)

	//if the vomit combined, apply toxicity and reagents to the old vomit
	if (QDELETED(V))
		V = locate() in src
	if(!V)
		return
	// Make toxins and blazaam vomit look different
	if(toxvomit == VOMIT_PURPLE)
		V.icon_state = "vomitpurp_[pick(1,4)]"
	else if (toxvomit == VOMIT_TOXIC)
		V.icon_state = "vomittox_[pick(1,4)]"
	if (iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents)
			clear_reagents_to_vomit_pool(C,V)

/proc/clear_reagents_to_vomit_pool(mob/living/carbon/M, obj/effect/decal/cleanable/vomit/V)
	M.reagents.trans_to(V, M.reagents.total_volume / 10, transfered_by = M)
	for(var/datum/reagent/R in M.reagents.reagent_list)                //clears the stomach of anything that might be digested as food
		if(istype(R, /datum/reagent/consumable))
			var/datum/reagent/consumable/nutri_check = R
			if(nutri_check.nutriment_factor >0)
				M.reagents.remove_reagent(R.type, min(R.volume, 10))

//Whatever happens after high temperature fire dies out or thermite reaction works.
//Should return new turf
/turf/proc/Melt()
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

// When our turf is washed, we may wash everything on top of the turf
// By default we will only wash mopable things (like blood or vomit)
// but you may optionally pass in all_contents = TRUE to wash everything
/turf/wash(clean_types, all_contents = FALSE)
	. = ..()
	for(var/atom/movable/to_clean as anything in src)
		if(all_contents)
			to_clean.wash(clean_types)
