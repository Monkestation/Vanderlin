/turf
	icon = 'icons/turf/floors.dmi'
	level = 1
	hover_color = "#607d65"
	uses_integrity = TRUE
	luminosity = 1

	var/intact = 1

	// baseturfs can be either a list or a single turf type.
	// In class definition like here it should always be a single type.
	// A list will be created in initialization that figures out the baseturf's baseturf etc.
	// In the case of a list it is sorted from bottom layer to top.
	// This shouldn't be modified directly, use the helper procs.
	var/list/baseturfs = /turf/open/openspace

	var/temperature = 293.15
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

	var/blocks_air = FALSE

	flags_1 = CAN_BE_DIRTY_1
	var/turf_flags = NONE

	var/list/image/blueprint_data //for the station blueprints, images of objects eg: pipes

	var/explosion_level = 0	//for preventing explosion dodging
	var/explosion_id = 0

	var/changing_turf = FALSE

	var/bullet_bounce_sound = 'sound/blank.ogg' //sound played when a shell casing is ejected ontop of the turf.
	var/bullet_sizzle = FALSE //used by ammo_casing/bounce_away() to determine if the shell casing should make a sizzle sound when it's ejected over the turf
							//IE if the turf is supposed to be water, set TRUE.

	var/debris = null

	/// What we overlay onto turfs in our smoothing_list
	var/neighborlay
	/// If we were going to smooth with an Atom instead overlay this onto self
	var/neighborlay_self

	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

	/// Uses colours defined by the monarch roundstart see [lordcolor.dm]
	var/uses_lord_coloring = FALSE

	var/list/datum/automata_cell/autocells

	///The typepath we use for lazy fishing on turfs, to save on world init time.
	var/fish_source

	var/dynamic_lighting = TRUE

	var/tmp/lighting_corners_initialised = FALSE

	///List of light sources affecting this turf.
	var/tmp/list/datum/light_source/affecting_lights
	///Our lighting object.
	var/tmp/atom/movable/lighting_object/lighting_object
	var/tmp/list/datum/lighting_corner/corners

	///Which directions does this turf block the vision of, taking into account both the turf's opacity and the movable opacity_sources.
	var/directional_opacity = NONE
	///Lazylist of movable atoms providing opacity sources.
	var/list/atom/movable/opacity_sources

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

	for(var/atom/movable/AM as anything in src)
		Entered(AM)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if (light_power && (light_outer_range || light_inner_range))
		update_light()

	if(uses_integrity)
		atom_integrity = max_integrity
	TEST_ONLY_ASSERT((!armor || istype(armor)), "[type] has an armor that contains an invalid value at intialize")

	var/turf/T = GET_TURF_ABOVE(src)
	if(T)
		T.multiz_turf_new(src, DOWN)
	T = GET_TURF_BELOW(src)
	if(T)
		T.multiz_turf_new(src, UP)
	if(!mapload)
		reassess_stack()

	if (opacity)
		directional_opacity = ALL_CARDINALS

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

	for(var/obj/effect/temp_visual/daylight_orb/orb in range(4, src))
		return TRUE

	return FALSE

/turf/proc/can_cross_safely(atom/movable/traveler)
	return !HAS_TRAIT(src, TRAIT_AI_AVOID_TURF)

/// WARNING WARNING
/// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
/// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
/// We do it because moving signals over was needlessly expensive, and bloated a very commonly used bit of code
/turf/_clear_signal_refs()
	return

/turf/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	// user.Move_Pulled(src)

/turf/proc/multiz_turf_del(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, T, dir)
	reassess_stack()

/turf/proc/multiz_turf_new(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, T, dir)
	reassess_stack()


/**
 * the following are some fishing-related optimizations to shave off as much
 * time we spend implementing the fishing as possible, even if that means
 * hackier code, because we've hundreds of turfs like lava, water etc every round,
 */
/turf/proc/add_lazy_fishing(fish_source_path)
	RegisterSignal(src, COMSIG_FISHING_ROD_CAST, PROC_REF(add_fishing_spot_comp))
	RegisterSignal(src, COMSIG_NPC_FISHING, PROC_REF(on_npc_fishing))
	RegisterSignal(src, COMSIG_FISH_RELEASED_INTO, PROC_REF(on_fish_release_into))
	RegisterSignal(src, COMSIG_TURF_CHANGE, PROC_REF(remove_lazy_fishing))
	ADD_TRAIT(src, TRAIT_FISHING_SPOT, INNATE_TRAIT)
	fish_source = fish_source_path

/turf/proc/remove_lazy_fishing()
	SIGNAL_HANDLER
	UnregisterSignal(src, list(
		COMSIG_FISHING_ROD_CAST,
		COMSIG_NPC_FISHING,
		COMSIG_FISH_RELEASED_INTO,
		COMSIG_TURF_CHANGE,
	))
	REMOVE_TRAIT(src, TRAIT_FISHING_SPOT, INNATE_TRAIT)
	fish_source = null

/turf/proc/add_fishing_spot_comp(datum/source, obj/item/fishingrod/rod, mob/user, automated)
	SIGNAL_HANDLER
	var/datum/component/fishing_spot/spot = source.AddComponent(/datum/component/fishing_spot, GLOB.preset_fish_sources[fish_source])
	remove_lazy_fishing()
	return spot.handle_cast(arglist(args))

/turf/proc/on_npc_fishing(datum/source, list/fish_spot_container)
	SIGNAL_HANDLER
	fish_spot_container[NPC_FISHING_SPOT] = GLOB.preset_fish_sources[fish_source]

/turf/proc/on_fish_release_into(datum/source, obj/item/reagent_containers/food/snacks/fish/fish, mob/living/releaser)
	SIGNAL_HANDLER
	GLOB.preset_fish_sources[fish_source].readd_fish(src, fish, releaser)

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

//The zpass procs exist to be overridden, not directly called
//use can_z_pass for that
///If we'd allow anything to travel into us
/turf/proc/zPassIn(direction)
	return FALSE

///If we'd allow anything to travel out of us
/turf/proc/zPassOut(direction)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirIn(direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirOut(direction, turf/source)
	return FALSE

/// Precipitates a movable (plus whatever buckled to it) to lower z levels if possible and then calls zImpact()
/turf/proc/zFall(atom/movable/falling, levels = 1, force = FALSE, falling_from_move = FALSE)
	var/direction = DOWN
	var/turf/target = get_step_multiz(src, direction)
	if(!target)
		return FALSE
	var/isliving = isliving(falling)
	if(!isliving && !isobj(falling))
		return
	if(isliving)
		var/mob/living/falling_living = falling
		//relay this mess to whatever the mob is buckled to.
		if(falling_living.buckled)
			falling = falling_living.buckled
	if(!falling_from_move && falling.currently_z_moving)
		return
	if(!force && !falling.can_z_move(direction, src, target, ZMOVE_FALL_FLAGS))
		falling.set_currently_z_moving(FALSE, TRUE)
		return FALSE

	// So it doesn't trigger other zFall calls. Cleared on zMove.
	falling.set_currently_z_moving(CURRENTLY_Z_FALLING)

	falling.zMove(null, target, ZMOVE_CHECK_PULLEDBY)
	target.zImpact(falling, levels, src)
	return TRUE

///Called each time the target falls down a z level possibly making their trajectory come to a halt. see __DEFINES/movement.dm.
/turf/proc/zImpact(atom/movable/falling, levels = 1, turf/prev_turf, flags = NONE)
	var/list/falling_movables = falling.get_z_move_affected()
	var/list/falling_mov_names = list()
	for(var/atom/movable/falling_mov as anything in falling_movables)
		falling_mov_names += falling_mov.name
	for(var/i in contents)
		var/atom/thing = i
		flags |= thing.intercept_zImpact(falling_movables, levels)
		if(flags & FALL_STOP_INTERCEPTING)
			break

	if(prev_turf && !(flags & FALL_NO_MESSAGE))
		for(var/mov_name in falling_mov_names)
			prev_turf.visible_message(span_danger("\The [mov_name] falls through [prev_turf]!"))
	if(!(flags & FALL_INTERCEPTED) && zFall(falling, levels + 1))
		return FALSE
	for(var/atom/movable/falling_mov as anything in falling_movables)
		if(!(flags & FALL_RETAIN_PULL))
			falling_mov.stop_pulling()
		if(!(flags & FALL_INTERCEPTED))
			falling_mov.onZImpact(src, levels)
		if(falling_mov.pulledby && (falling_mov.z != falling_mov.pulledby.z || get_dist(falling_mov, falling_mov.pulledby) > 1))
			falling_mov.pulledby.stop_pulling()
	return TRUE

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
/turf/Enter(atom/movable/mover, atom/oldloc)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/canPassSelf = CanPass(mover, src)
	if(canPassSelf || CHECK_BITFIELD(mover.movement_type, PHASING))
		for(var/atom/movable/thing as anything in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(thing == mover || thing == mover.loc) // Multi tile objects and moving out of other objects
				continue
			if(!thing.Cross(mover))
				if(QDELETED(mover))		//Mover deleted from Cross/CanPass, do not proceed.
					return FALSE
				if(CHECK_BITFIELD(mover.movement_type, PHASING))
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
		return CHECK_BITFIELD(mover.movement_type, PHASING)
	return TRUE

/turf/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	SEND_SIGNAL(src, COMSIG_TURF_ENTERED, arrived)
	SEND_SIGNAL(arrived, COMSIG_MOVABLE_TURF_ENTERED, src)

	if(explosion_level && arrived.ex_check(explosion_id))
		arrived.ex_act(explosion_level)

/turf/open/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	//melting
	if(isobj(arrived) && temperature > 273.15)
		var/obj/O = arrived
		if(O.obj_flags & FROZEN)
			O.make_unfrozen()

// A proc in case it needs to be recreated or badmins want to change the baseturfs
/turf/proc/assemble_baseturfs(turf/fake_baseturf_type)
	var/static/list/created_baseturf_lists = list()
	var/turf/current_target
	if(fake_baseturf_type)
		if(length(fake_baseturf_type)) // We were given a list, just apply it and move on
			baseturfs = baseturfs_string_list(fake_baseturf_type, src)
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
			baseturfs = baseturfs_string_list(premade_baseturfs.Copy(), src)
		else
			baseturfs = baseturfs_string_list(premade_baseturfs, src)
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

	baseturfs = baseturfs_string_list(new_baseturfs, src)
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

/turf/proc/get_cell(type)
	for(var/datum/automata_cell/C in autocells)
		if(istype(C, type))
			return C
	return null

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

/// Checks if this turf is protected from an explosion by something
/// Return TRUE to stop the explosion from affecting this turf
/turf/proc/is_explosion_shielded(severity)
	return FALSE

/turf/contents_explosion(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/affecting_level
	if(severity == 1)
		affecting_level = 1
	else if(is_explosion_shielded(severity))
		affecting_level = 3
	else if(intact)
		affecting_level = 2
	else
		affecting_level = 1

	for(var/atom/A as anything in contents)
		if(!QDELETED(A) && A.level >= affecting_level)
			if(ismovableatom(A))
				var/atom/movable/AM = A
				if(!AM.ex_check(explosion_id))
					continue
			A.ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
			CHECK_TICK

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
	playsound(src, "bodyfall", 100, TRUE)
	faller.drop_all_held_items()

/turf/proc/photograph(limit=20)
	var/image/I = new()
	I.add_overlay(src)
	for(var/atom/A as anything in contents)
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
		V.icon_state = "vomitpurp_[rand(1,4)]"
	else if (toxvomit == VOMIT_TOXIC)
		V.icon_state = "vomittox_[rand(1,4)]"
	if (iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents)
			C.clear_reagents_to_vomit_pool(V)

/mob/living/carbon/proc/clear_reagents_to_vomit_pool(obj/effect/decal/cleanable/vomit/V, purge = FALSE)
	var/obj/item/organ/stomach/belly = getorganslot(ORGAN_SLOT_STOMACH)
	if(!belly)
		return
	var/chemicals_lost = belly.reagents.total_volume * 0.1
	if(purge)
		chemicals_lost = belly.reagents.total_volume * 0.67 //For detoxification surgery, we're manually pumping the stomach out of chemcials, so it's far more efficient.
	belly.reagents.trans_to(V, chemicals_lost, transfered_by = src)
	//clear the stomach of anything even not food
	for(var/datum/reagent/reagent as anything in belly.reagents.reagent_list)
		belly.reagents.remove_reagent(reagent.type, min(reagent.volume, 10))

//Whatever happens after high temperature fire dies out or thermite reaction works.
//Should return new turf
/turf/proc/Melt()
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/**
 * Called when this turf is being washed.
 */
/turf/wash(clean_types)
	. = ..()

	for(var/am in src)
		if(am == src)
			continue
		var/atom/movable/movable_content = am
		if(!is_cleanable(movable_content))
			continue
		movable_content.wash(clean_types)
