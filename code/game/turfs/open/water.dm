/turf/open/water
	gender = PLURAL
	name = "water"
	desc = "It's... well, water."
	icon = 'icons/turf/natural/liquids.dmi'
	icon_state = "water"
	baseturfs = /turf/open/water
	slowdown = 20
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_FLOOR_LIQUID
	smoothing_list = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_CLOSED_WALL
	neighborlay_self = "edge"

	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER
	force_footstep_sound = TRUE

	landsound = 'sound/foley/jumpland/waterland.ogg'
	shine = SHINE_SHINY
	no_over_text = FALSE
	spread_chance = 0
	burn_power = 0
	flags_1 = CONDUCT_1

	var/datum/reagent/water_reagent = /datum/reagent/water

	var/volume_status = WATER_VOLUME_INFINITE
	var/pre_dry_status
	/// 100 is 1 bucket. Minimum of 10 to count as a water tile
	var/water_volume = 100
	var/water_volume_maximum = 10000 //this is since water is stored in the originate

	var/wash_in = TRUE
	/// cant pick up with reagent containers
	var/notake = FALSE

	var/set_relationships_on_init = TRUE
	/// A bitflag of blocked directions. ONLY works because we only allow cardinal flow.
	var/blocked_flow_directions = 0
	var/cached_use = 0

	var/cleanliness_factor = 1 //related to hygiene for washing

	/// Fishing element for this specific water tile
	var/datum/fish_source/fishing_datum = /datum/fish_source/water

	/// Forces the water turf above to have an open bottom. Above water will set add_transparency = TRUE and water_height to be >= WATER_HEIGHT_DEEP
	var/force_open_above = FALSE
	/// If TRUE, the turf will not have a open bottom. Overrides force_open_above of the turf below it.
	var/force_close_bottom = FALSE
	/// icon_state of underlay applied to create the effect of the bottom of the water.
	var/underlay_icon_state = "rock"
	/// If TRUE, add turf transparency in LateInitialize() and disables underlay_icon_sate
	var/add_transparency = FALSE

	/// Whether the tile has a current and moves atoms that enter the tile
	var/river_current = FALSE
	/// The time between movements of the tile. Base of 0.5 seconds
	var/current_speed = 0.5 SECONDS
	/// The actual direction that stuff moves. Defaults to dir.
	var/movedir

	/// Whether people can examine to determine the depth. Note WATER_HEIGHT_FULL doesn't have examine text.
	var/can_examine_depth = TRUE

	/// Determines depth based behavior and which overlays to apply. Heights in order are ANKLE, SHALLOW, DEEP, FULL.
	var/water_height = WATER_HEIGHT_SHALLOW
	///The transparency of the immerse element's overlay
	var/immerse_overlay_alpha = 180
	///Icon state to use for the immersion mask. Overlays follow the format "immerse_overlay[water_height]"
	var/immerse_overlay = "immerse"
	/// Whether the immerse element has been added yet or not
	var/immerse_added = FALSE

	/**
	 * Variables used for the swimming tile element. If a value is null, water_height is used to assign variable values.
	 * - is_swimming_tile: Whether or not we add the element to this tile.
	 * - stamina_entry_cost: how much stamina it costs to enter the swimming tile, and for each move into a tile
	 * - ticking_stamina_cost: How much stamina is lost for staying in the water.
	 * - ticking_oxy_damage: How much oxygen is lost per tick when drowning in water. Also determines how many breathes are lost.
	 * - exhaust_swimmer_prob: The likelihood that someone suffers stamina damage when entering a swimming tile.
	 */
	var/is_swimming_tile = TRUE
	var/stamina_entry_cost
	var/ticking_stamina_cost
	var/ticking_oxy_damage = 4.2
	var/exhaust_swimmer_prob = 100

	/// Randomize direction when initializing
	var/randomize_dir = FALSE

/turf/open/water/Initialize(mapload)
	if(randomize_dir)
		dir = pick(GLOB.cardinals)

	. = ..()

	RegisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, PROC_REF(on_atom_inited))

	if(force_open_above)
		force_open_above()

	if(!isnull(fishing_datum))
		add_lazy_fishing(fishing_datum)
	ADD_TRAIT(src, TRAIT_CATCH_AND_RELEASE, INNATE_TRAIT)

	if(mapload)
		if(!rand(0, 999)) // 1/1000 chance
			new /obj/item/bottlemessage/ancient(src)
	else
		START_PROCESSING(SSobj, src)

	base_icon_state = icon_state // in case you want to override the icon_state when initializing
	handle_water()

	return INITIALIZE_HINT_LATELOAD

/turf/open/water/LateInitialize()
	. = ..()

	AddElement(/datum/element/watery_tile, water_height, cleanliness_factor)
	if(add_transparency)
		ADD_TURF_TRANSPARENCY(src, INNATE_TRAIT)
	else if(underlay_icon_state)
		underlays += mutable_appearance(icon, underlay_icon_state)

	if(set_relationships_on_init)
		check_surrounding_water()

/turf/open/water/Destroy()
	UnregisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON)
	dry_up(TRUE)
	return ..()

/turf/open/water/get_slowdown(mob/user)
	. = ..()
	if(. <= 0)
		return 0
	if(volume_status == WATER_VOLUME_DRY || HAS_TRAIT(user, TRAIT_SWIMMER))
		return 0
	if(is_swimming_tile)
		return max(0, . - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/swimming)))

/turf/open/water/update_icon(updates = ALL)
	. = ..()
	if(!(updates & UPDATE_SMOOTHING))
		return

	if(volume_status == WATER_VOLUME_DRY)
		smoothing_flags = NONE
		remove_neighborlays()
	else
		smoothing_flags = initial(smoothing_flags)
		QUEUE_SMOOTH(src)

/turf/open/water/update_icon_state()
	if(volume_status == WATER_VOLUME_DRY)
		icon_state = ""
	else
		icon_state = base_icon_state
	return ..()

/turf/open/water/proc/force_open_above()
	var/turf/open/water/water_turf = get_step_multiz(src, UP)
	if(iswaterturf(water_turf) && !water_turf.force_close_bottom)
		water_turf.underlay_icon_state = null
		water_turf.add_transparency = TRUE
		water_turf.water_height = max(water_turf.water_height, WATER_HEIGHT_DEEP)
		return

/turf/open/water/proc/toggle_transparency()
	if(istransparentturf(src))
		REMOVE_TURF_TRANSPARENCY(src, INNATE_TRAIT)
		underlays += mutable_appearance(icon, underlay_icon_state)
	else
		underlays = list()
		ADD_TURF_TRANSPARENCY(src, INNATE_TRAIT)

/turf/open/water/proc/set_watervolume(volume)
	water_volume = volume
	if(src in children)
		return
	handle_water()

	for(var/turf/open/water/river/water in children)
		water.set_watervolume(volume - 10)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/adjust_watervolume(volume)
	water_volume = min(water_volume + volume, water_volume_maximum)
	handle_water()

	for(var/turf/open/water/river/water in children)
		water.adjust_watervolume(volume)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/adjust_originate_watervolume(volume)
	var/turf/open/water/adjuster = source_originate
	if(!adjuster)
		adjuster = src
	if(volume < MINIMUM_WATER_VOLUME && volume_status == WATER_VOLUME_INFINITE)
		if(adjuster.water_volume + volume < initial(adjuster.water_volume))
			return
	adjuster.water_volume += volume
	handle_water()
	if(adjuster.volume_status == WATER_VOLUME_INFINITE) //means no changes downstream
		return
	for(var/turf/open/water/river/water in adjuster.children)
		water.adjust_watervolume(volume)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/toggle_block_state(dir, value)
	if(value)
		blocked_flow_directions |= dir
	else
		blocked_flow_directions &= ~dir
	if(blocked_flow_directions & dir)
		var/turf/open/water/river/water = get_step(src, dir)
		if(!istype(water))
			return
		if(water.volume_status == WATER_VOLUME_INFINITE)
			return
		water.set_watervolume(0)
		water.check_surrounding_water()
		for(var/turf/open/water/child in children)
			addtimer(CALLBACK(child, PROC_REF(recursive_clear_icon)), 0.25 SECONDS)
		for(var/turf/open/water/conflict as anything in conflicting_originate_turfs)
			conflict.check_surrounding_water(TRUE)
	else
		check_surrounding_water()

/turf/open/water/river/creatable
	volume_status = WATER_VOLUME_NORMAL
	icon_state = "rivermove"
	baseturfs = /turf/open/water/river/creatable

/turf/open/water/river/creatable/Initialize()
	var/list/viable_directions = list()
	for(var/direction in GLOB.cardinals)
		var/turf/open/water/water = get_step(src, direction)
		if(!istype(water))
			continue
		viable_directions |= direction
	if(length(viable_directions) == 4 || length(viable_directions) == 0)
		return ..()
	river_current = TRUE
	var/picked_dir = pick(viable_directions)
	dir = REVERSE_DIR(picked_dir)
	handle_water()
	return ..()

/turf/open/water/river/creatable/attackby(obj/item/C, mob/user, list/modifiers)
	if(istype(C, /obj/item/reagent_containers/glass/bucket/wooden) && user.used_intent.type == /datum/intent/splash)
		try_modify_water(user, C)
		return TRUE
	if(istype(C, /obj/item/weapon/shovel))
		if((user.used_intent.type == /datum/intent/shovelscoop))
			var/obj/item/weapon/shovel/shovel = C
			if(!shovel.heldclod)
				return
			user.visible_message("[user] starts filling in [src].", "I start filling in [src].")
			if(!do_after(user, 10 SECONDS * shovel.time_multiplier, src))
				return
			QDEL_NULL(shovel.heldclod)
			shovel.update_appearance(UPDATE_ICON_STATE)
			ScrapeAway()
			return TRUE
	. = ..()

/turf/open/water/river/creatable/proc/try_modify_water(mob/user, obj/item/reagent_containers/glass/bucket/wooden/bucket)
	if(user.used_intent.type == /datum/intent/splash)
		if(bucket.reagents?.total_volume)
			var/datum/reagent/container_reagent = bucket.reagents.get_master_reagent()
			var/water_count = bucket.reagents.get_reagent_amount(container_reagent.type)
			user.visible_message("[user] starts to fill [src].", "You start to fill [src].")
			if(do_after(user, 3 SECONDS, src))
				if(bucket.reagents.remove_reagent(container_reagent.type, clamp(container_reagent.volume, 1, 100)))
					playsound(src, 'sound/foley/waterenter.ogg', 100, FALSE)
					adjust_originate_watervolume(water_count)

///We lazily add the immerse element when something is spawned or crosses this turf and not before.
/turf/open/water/proc/on_atom_inited(datum/source, atom/movable/movable)
	SIGNAL_HANDLER
	if(make_immersed(movable))
		UnregisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON)

/**
 * turf/Initialize() calls Entered on its contents too, however
 * we need to wait for movables that still need to be initialized
 * before we add the immerse element.
 */
/turf/open/water/Entered(atom/movable/arrived)
	. = ..()
	make_immersed(arrived)
	conveyable_enter(arrived)

///Makes this turf immersable, return true if we actually did anything so child procs don't have to repeat our checks
/turf/open/water/proc/make_immersed(atom/movable/triggering_atom)
	if(immerse_added || is_type_in_typecache(triggering_atom, GLOB.immerse_ignored_movable))
		return FALSE
	if(water_height < WATER_HEIGHT_ANKLE)
		return FALSE

	AddElement(/datum/element/immerse, "[immerse_overlay][water_height]", immerse_overlay_alpha, water_height)
	immerse_added = TRUE

	if(is_swimming_tile)
		determine_swimming_properties()
		AddElement(/datum/element/swimming_tile, stamina_entry_cost, ticking_stamina_cost, ticking_oxy_damage, exhaust_swimmer_prob)
	return TRUE

/turf/open/water/proc/determine_swimming_properties()
	switch(water_height)
		if(WATER_HEIGHT_ANKLE)
			stamina_entry_cost = isnum(initial(stamina_entry_cost)) ? initial(stamina_entry_cost) : 2.5
			ticking_stamina_cost = isnum(initial(ticking_stamina_cost)) ? initial(ticking_stamina_cost) : 0
			ticking_oxy_damage = isnum(initial(ticking_oxy_damage)) ? initial(ticking_oxy_damage) : 4.2
		if(WATER_HEIGHT_SHALLOW)
			stamina_entry_cost = isnum(initial(stamina_entry_cost)) ? initial(stamina_entry_cost) : 5
			ticking_stamina_cost = isnum(initial(ticking_stamina_cost)) ? initial(ticking_stamina_cost) : 0
			ticking_oxy_damage = isnum(initial(ticking_oxy_damage)) ? initial(ticking_oxy_damage) : 4.2
		if(WATER_HEIGHT_DEEP)
			stamina_entry_cost = isnum(initial(stamina_entry_cost)) ? initial(stamina_entry_cost) : 7.5
			ticking_stamina_cost = isnum(initial(ticking_stamina_cost)) ? initial(ticking_stamina_cost) : 5
			ticking_oxy_damage = isnum(initial(ticking_oxy_damage)) ? initial(ticking_oxy_damage) : 4.2
		if(WATER_HEIGHT_FULL)
			stamina_entry_cost = isnum(initial(stamina_entry_cost)) ? initial(stamina_entry_cost) : 7.5
			ticking_stamina_cost = isnum(initial(ticking_stamina_cost)) ? initial(ticking_stamina_cost) : 10
			ticking_oxy_damage = isnum(initial(ticking_oxy_damage)) ? initial(ticking_oxy_damage) : 4.2
		else
			stamina_entry_cost = initial(stamina_entry_cost)
			ticking_stamina_cost = initial(ticking_stamina_cost)
			ticking_oxy_damage = initial(ticking_oxy_damage)
			exhaust_swimmer_prob = initial(exhaust_swimmer_prob)

/turf/open/water/proc/conveyable_enter(atom/movable/conveyable)
	if(conveyable.loc != src) // If we are not on the same turf (order of operations memes) go to hell
		return
	if(!river_current)
		SSmove_manager.stop_looping(conveyable, SSconveyors)
		return
	start_conveying(conveyable)

/turf/open/water/proc/start_conveying(atom/movable/moving)
	if(QDELETED(moving))
		return
	var/datum/move_loop/move/moving_loop = SSmove_manager.processing_on(moving, SSconveyors)
	var/current_direction = movedir || dir
	var/speed = current_speed
	if(HAS_TRAIT(moving, TRAIT_SWIMMER)) // more time to swim against the current
		speed *= 2
	if(moving_loop)
		moving_loop.direction = current_direction
		moving_loop.delay = speed
		return

	var/static/list/unconveyables = GLOB.immerse_ignored_movable
	if(!istype(moving) || is_type_in_typecache(moving, unconveyables) || moving == src || isstructure(moving))
		return
	moving.AddComponent(/datum/component/convey/current, current_direction, speed)

/turf/open/water/Exited(atom/movable/gone, direction)
	. = ..()
	conveyable_exit(gone, direction)

/turf/open/water/proc/conveyable_exit(atom/conveyable, direction)
	var/turf/next_turf = get_step(src, direction)
	if(conveyable.z != z || !iswaterturf(next_turf) || !isturf(conveyable.loc)) //If you've entered something on us, stop moving
		SSmove_manager.stop_looping(conveyable, SSconveyors)

/turf/open/water/proc/stop_conveying(atom/movable/thing)
	if(!ismovable(thing))
		return
	SSmove_manager.stop_looping(thing, SSconveyors)

/turf/open/water/examine(mob/user)
	. = ..()
	if(volume_status == WATER_VOLUME_DRY)
		return
	if(!can_examine_depth)
		. += span_notice("I can't see the bottom...")
		return
	var/depth_message
	switch(water_height)
		if(WATER_HEIGHT_ANKLE)
			depth_message = "ankle deep."
		if(WATER_HEIGHT_SHALLOW)
			depth_message = "about waist high."
		if(WATER_HEIGHT_DEEP)
			depth_message = "rather deep."
		else
			return
	. += span_notice("It looks [depth_message]")

/turf/open/water/process()
	if(cached_use)
		adjust_originate_watervolume(cached_use)
		cached_use = 0

	handle_water()

/turf/open/water/proc/handle_water()
	if(water_volume < MINIMUM_WATER_VOLUME)
		dry_up()
		return
	color = sanitize_hexcolor(water_reagent.color)
	fill_up()

/turf/open/water/proc/fill_up()
	if(volume_status != WATER_VOLUME_DRY)
		return
	volume_status = pre_dry_status || initial(volume_status)
	update_appearance(UPDATE_SMOOTHING|UPDATE_ICON_STATE)
	if(shine)
		make_shiny(shine)
	REMOVE_TRAIT(src, TRAIT_IMMERSE_STOPPED, INNATE_TRAIT)
	footstep = initial(footstep)
	barefootstep = initial(barefootstep)
	clawfootstep = initial(clawfootstep)
	heavyfootstep = initial(heavyfootstep)
	if(river_current)
		for(var/atom/movable/movable in src)
			start_conveying(movable)

/turf/open/water/proc/dry_up(empty_volume = FALSE)
	if(volume_status == WATER_VOLUME_DRY)
		return
	pre_dry_status = volume_status
	volume_status = WATER_VOLUME_DRY
	if(empty_volume)
		water_volume = 0
	update_appearance(UPDATE_SMOOTHING|UPDATE_ICON_STATE)
	make_unshiny()
	for(var/obj/structure/waterwheel/rotator in contents)
		rotator.set_rotational_direction_and_speed(null, 0)
		rotator.set_stress_generation(0)
	ADD_TRAIT(src, TRAIT_IMMERSE_STOPPED, INNATE_TRAIT)
	if(river_current)
		for(var/atom/movable/movable in src)
			stop_conveying(movable)

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	..()
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg','sound/foley/water_land3.ogg'), 100, FALSE)

/turf/open/water/proc/try_z_swim(mob/swimming_mob, going_up, forced)
	if(!HAS_TRAIT(swimming_mob, TRAIT_MOVE_SWIMMING))
		return

	var/direction = going_up ? UP : DOWN

	// determine valid travel directions
	switch(water_height)
		if(WATER_HEIGHT_DEEP)
			if(direction != DOWN)
				return
		if(WATER_HEIGHT_FULL)
			EMPTY_BLOCK_GUARD
		else
			return

	if(direction == UP && HAS_TRAIT(swimming_mob, TRAIT_SINKING))
		to_chat(swimming_mob, span_warningbig("I'm sinking and can't swim upwards!"))
		return

	if(!swimming_mob.can_z_move(direction, src, null, ZMOVE_SWIM_FLAGS|ZMOVE_FEEDBACK))
		return
	var/swim_time = 3 SECONDS - ((1 DECISECONDS * GET_MOB_SKILL_VALUE_OLD(swimming_mob, /datum/attribute/skill/misc/swimming)) + (1 SECONDS * HAS_TRAIT(swimming_mob, TRAIT_SWIMMER)))
	if(!forced && !do_after(swimming_mob, swim_time, hidden = TRUE))
		return
	if(swimming_mob.zMove(direction, z_move_flags = ZMOVE_SWIM_FLAGS|ZMOVE_FEEDBACK))
		if(direction == UP)
			to_chat(swimming_mob, forced ? span_warningbig("A strong current pushes you upward!") : span_notice("You swim upward."))
		else
			to_chat(swimming_mob, forced ? span_warningbig("You sink downwards!") : span_notice("You swim downward."))

/**
 * Prepares a moving movable to be precipitated if Move() is successful.
 * This is done in Enter() and not Entered() because there's no easy way to tell
 * if the latter was called by Move() or forceMove() while the former is only called by Move().
 */
/turf/open/water/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_IMMERSE_STOPPED))
		return
	if(.)
		//higher priority than CURRENTLY_Z_FALLING so the movable doesn't fall on Entered()
		movable.set_currently_z_moving(CURRENTLY_Z_FALLING_FROM_MOVE)

///Makes movables fall when forceMove()'d to this turf.
/turf/open/openspace/Entered(atom/movable/movable)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_IMMERSE_STOPPED))
		return
	if(movable.set_currently_z_moving(CURRENTLY_Z_FALLING))
		zFall(movable, falling_from_move = TRUE)

/turf/open/water/zPassIn(direction)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP && istransparentturf(src))
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/water/zPassOut(direction)
	if(direction == DOWN && istransparentturf(src))
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/water/attackby(obj/item/C, mob/user, list/modifiers)
	if(user.used_intent.type == /datum/intent/fill)
		if(C.reagents)
			if(C.reagents.holder_full())
				to_chat(user, "<span class='warning'>[C] is full.</span>")
				return
			if(notake)
				return
			if(volume_status == WATER_VOLUME_DRY)
				return
			if(do_after(user, 8 DECISECONDS, src))
				user.changeNext_move(CLICK_CD_MELEE)
				playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
				if(volume_status != WATER_VOLUME_INFINITE && C.reagents.add_reagent(water_reagent, 10))
					adjust_originate_watervolume(-10)

				else
					C.reagents.add_reagent(water_reagent, 100)
				to_chat(user, "<span class='notice'>I fill [C] from [src].</span>")
			return
	if(user.used_intent.type == /datum/intent/food)
		if(volume_status == WATER_VOLUME_INFINITE)
			return
		if(C.reagents)
			if(water_volume >= water_volume_maximum)
				to_chat(user, "<span class='warning'>\The [src] is full.</span>")
				return
			if(do_after(user, 8 DECISECONDS, src))
				user.changeNext_move(CLICK_CD_MELEE)
				playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
				var/water_count = C.reagents.get_reagent_amount(water_reagent.type)
				if(volume_status != WATER_VOLUME_INFINITE && C.reagents.remove_reagent(water_reagent,  C.reagents.total_volume))
					set_watervolume(clamp(water_volume + water_count, 1, water_volume_maximum))
				to_chat(user, "<span class='notice'>I pour the contents of [C] into [src].</span>")
			return
	. = ..()

/turf/open/water/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(volume_status == WATER_VOLUME_DRY)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
	if(isliving(user))
		var/mob/living/L = user
		user.visible_message("<span class='info'>[user] starts to wash in [src].</span>")
		if(do_after(L, 3 SECONDS, src))
			if(wash_in)
				user.wash(CLEAN_WASH)
			var/datum/reagents/reagents = new()
			reagents.add_reagent(water_reagent, 4)
			reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = TOUCH)
			if(volume_status != WATER_VOLUME_INFINITE)
				adjust_originate_watervolume(-2)
			playsound(user, pick(wash), 100, FALSE)

			L.ExtinguishMob()
			//handle hygiene and clean off alcohol
			var/list/equipped_items = L.get_equipped_items()
			if(length(equipped_items) > 0)
				to_chat(user, span_notice("I could probably clean myself faster if I weren't wearing clothes..."))
				L.adjust_hygiene(HYGIENE_GAIN_CLOTHED * cleanliness_factor)
				L.adjust_fire_stacks(-4)
			else
				L.adjust_hygiene(HYGIENE_GAIN_UNCLOTHED * cleanliness_factor)
				L.adjust_fire_stacks(-2)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/turf/open/water/attackby_secondary(obj/item/item2wash, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.cmode)
		return
	var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
	playsound(user, pick_n_take(wash), 100, FALSE)
	user.visible_message("<span class='info'>[user] starts to wash [item2wash] in [src].</span>")
	if(do_after(user, 3 SECONDS, src))
		if(wash_in)
			item2wash.wash(CLEAN_WASH)
		if(istype(item2wash, /obj/item/clothing))
			var/obj/item/clothing/item2wash_cloth = item2wash
			if(item2wash_cloth && item2wash_cloth.wetable)
				if(cleanliness_factor > 0)
					item2wash_cloth.wet.add_water(20, dirty = FALSE, washed_properly = TRUE)
				else
					item2wash_cloth.wet.add_water(20, dirty = TRUE, washed_properly = TRUE)
		user.nobles_seen_servant_work()
		playsound(user, pick(wash), 100, FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/turf/open/water/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	if(volume_status == WATER_VOLUME_DRY)
		return TRUE
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	user.visible_message(span_info("[user] starts to drink from [src]."))
	if(!do_after(user, 2.5 SECONDS, src))
		return TRUE
	var/datum/reagents/reagents = new()
	reagents.add_reagent(water_reagent, 2)
	reagents.trans_to(user, reagents.total_volume, transfered_by = user, method = INGEST)
	if(volume_status != WATER_VOLUME_INFINITE)
		adjust_originate_watervolume(-2)
	playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
	return TRUE

/*	..................   Bath & Pool   ................... */
/turf/open/water/bath
	name = "water"
	desc = "Faintly yellow colored. Suspicious."
	icon_state = MAP_SWITCH("water", "bathtileW")
	underlay_icon_state = "bathtile"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 15
	cleanliness_factor = 5
	footstep = FOOTSTEP_SHALLOW
	barefootstep = FOOTSTEP_SHALLOW
	clawfootstep = FOOTSTEP_SHALLOW
	heavyfootstep = FOOTSTEP_SHALLOW
	water_reagent = /datum/reagent/water
	stamina_entry_cost = 1
	ticking_stamina_cost = 0
	exhaust_swimmer_prob = 0

/datum/reagent/water/gross/sewer
	color = "#705a43"

/turf/open/water/sewer
	name = "sewage"
	desc = "This dark water smells of dead rats."
	icon_state = MAP_SWITCH("water", "pavingW")
	underlay_icon_state = "paving"
	water_height = WATER_HEIGHT_ANKLE
	slowdown = 1
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewer
	footstep = FOOTSTEP_MUD
	barefootstep = FOOTSTEP_MUD
	clawfootstep = FOOTSTEP_MUD
	heavyfootstep = FOOTSTEP_MUD
	cleanliness_factor = -5
	fishing_datum = /datum/fish_source/sewer
	var/leech_chance = 3

/turf/open/water/sewer/Initialize(mapload)
	if(prob(10))
		icon_state = "yuckwater"
	. = ..()

/turf/open/water/sewer/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isliving(arrived) && !arrived.throwing && !(arrived.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
		var/mob/living/living = arrived
		var/chance = leech_chance
		if(living.m_intent == MOVE_INTENT_RUN)
			chance *= 2
		else if(living.m_intent == MOVE_INTENT_SNEAK)
			chance /= 2
		if(!prob(chance))
			return
		if(iscarbon(arrived))
			var/mob/living/carbon/C = arrived
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG,BODY_ZONE_L_LEG)
			for(var/i = 1, i <= zonee.len, i++)
				var/obj/item/bodypart/BP = C.get_bodypart(pick_n_take(zonee))
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				if(!BP.is_organic_limb())
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/sewer/under
	icon_state = MAP_SWITCH("yuckwater", "pavinggwf")
	water_height = WATER_HEIGHT_FULL
	shine = SHINE_MATTE
	leech_chance = 8
	force_open_above = TRUE

/turf/open/water/swamp
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	icon = 'icons/turf/natural/liquids.dmi'
	icon_state = MAP_SWITCH("water", "dirtW2")
	underlay_icon_state = "dirt"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 20
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewer
	cleanliness_factor = -5
	fishing_datum = /datum/fish_source/swamp
	randomize_dir = TRUE
	var/leech_chance = 3

/turf/open/water/swamp/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isliving(arrived) && !arrived.throwing && !(arrived.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
		var/mob/living/living = arrived
		var/chance = leech_chance
		if(living.m_intent == MOVE_INTENT_RUN)
			chance *= 2
		else if(living.m_intent == MOVE_INTENT_SNEAK)
			chance /= 2
		if(!prob(chance))
			return
		if(iscarbon(arrived))
			var/mob/living/carbon/C = arrived
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG,BODY_ZONE_L_LEG)
			for(var/i = 1, i <= zonee.len, i++)
				var/obj/item/bodypart/BP = C.get_bodypart(pick_n_take(zonee))
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				if(!BP.is_organic_limb())
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/swamp/deep
	name = "murk"
	desc = "Deep water with several weeds and algae on the surface."
	icon_state = MAP_SWITCH("water", "dirtW")
	water_height = WATER_HEIGHT_DEEP
	slowdown = 20
	fishing_datum = /datum/fish_source/swamp/deep
	leech_chance = 8

/datum/reagent/water/gross/marshy
	color = "#60b17b"

/turf/open/water/marsh
	name = "marshwater"
	desc = "A heavy layer of weeds and algae cover the surface of the water."
	icon = 'icons/turf/natural/liquids.dmi'
	icon_state = MAP_SWITCH("water", "dirtW3")
	underlay_icon_state = "dirt"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 15
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/marshy
	cleanliness_factor = -3
	fishing_datum = /datum/fish_source/swamp
	randomize_dir = TRUE

/turf/open/water/marsh/deep
	name = "marshwater"
	desc = "A heavy layer of weeds and algae cover the surface of the deep water."
	icon_state = MAP_SWITCH("water", "dirtW4")
	underlay_icon_state = "dirt"
	water_height = WATER_HEIGHT_DEEP
	slowdown = 20
	fishing_datum = /datum/fish_source/swamp/deep

/turf/open/water/clean
	name = "water"
	desc = "Crystal clear water, what a blessing!"
	icon_state = MAP_SWITCH("water", "rockw2")
	underlay_icon_state = "rock"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 15
	water_reagent = /datum/reagent/water
	fishing_datum = /datum/fish_source/cleanshallow
	randomize_dir = TRUE

/turf/open/water/clean/under
	icon_state = MAP_SWITCH("water", "rockcwf")
	underlay_icon_state = "rock"
	water_height = WATER_HEIGHT_FULL
	shine = SHINE_MATTE
	force_open_above = TRUE

/turf/open/water/clean/dirt
	name = "water"
	desc = "Fairly clear water, mostly untainted by surrounding soil."
	icon_state = MAP_SWITCH("water", "dirtW5")
	underlay_icon_state = "dirt"
	cleanliness_factor = -1

/turf/open/water/clean/dirt/under
	icon_state = MAP_SWITCH("dirt", "dirtcwf")
	water_height = WATER_HEIGHT_FULL
	shine = SHINE_MATTE
	force_open_above = TRUE

/turf/open/water/blood
	name = "blood"
	desc = "A pool of sanguine liquid."
	icon = 'icons/turf/natural/liquids.dmi'
	icon_state = MAP_SWITCH("water", "rockb")
	underlay_icon_state = "rock"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 15
	cleanliness_factor = -5
	water_reagent = /datum/reagent/blood
	randomize_dir = TRUE

/turf/open/water/river
	name = "water"
	desc = "Crystal clear water! Flowing swiftly along the river."
	icon_state = MAP_SWITCH("rivermove", "rivermove-dir")
	underlay_icon_state = "rock"
	water_height = WATER_HEIGHT_DEEP
	slowdown = 20
	set_relationships_on_init = FALSE
	fishing_datum = /datum/fish_source/river
	river_current = TRUE

/turf/open/water/river/get_heuristic_slowdown(mob/traverser, travel_dir)
	. = ..()
	if(travel_dir & dir) // downriver
		. -= 2 // faster!
	else // upriver
		. += 2 // slower

/turf/open/water/river/LateInitialize()
	. = ..()
	var/turf/open/water/river/water = get_step(src, dir)
	if(!istype(water))
		return
	if(water.parent?.water_volume > water_volume)
		return
	water.try_set_parent(src)

/turf/open/water/river/under
	icon_state = MAP_SWITCH("riverbotdeep", "rivermoveF-dir")
	water_height = WATER_HEIGHT_FULL
	immerse_overlay = null
	shine = SHINE_MATTE
	force_open_above = TRUE

/turf/open/water/river/dirt
	desc = "Murky water, churning along the river."
	icon_state = MAP_SWITCH("rivermove", "rivermovealt-dir")
	underlay_icon_state = "dirt"
	water_reagent = /datum/reagent/water/gross
	cleanliness_factor = -5
	slowdown = 5
	slowdown = 1
	current_speed = 1 SECONDS

/turf/open/water/river/dirt/under
	icon_state = MAP_SWITCH("riverbotdeep", "rivermovealtF-dir")
	water_height = WATER_HEIGHT_FULL
	immerse_overlay = null
	shine = SHINE_MATTE
	force_open_above = TRUE

/turf/open/water/river/blood
	name = "blood"
	desc = "This river flows a viscous red."
	icon_state = MAP_SWITCH("rivermove", "rivermovealt2-dir")
	underlay_icon_state = "rock"
	water_reagent = /datum/reagent/blood
	cleanliness_factor = -5

/turf/open/water/acid // holy SHIT
	name = "acid pool"
	desc = "Well... how did THIS get here?"
	underlay_icon_state = null
	water_reagent = /datum/reagent/rogueacid
	cleanliness_factor = -100
	is_swimming_tile = FALSE
	immerse_overlay = null

/turf/open/water/acid/mapped
	desc = "You know how this got here. You think."
	notake = TRUE

/turf/open/water/ocean
	name = "salt water"
	desc = "The waves lap at the coast, hungry to swallow the land."
	icon_state = MAP_SWITCH("water", "gravelW")
	underlay_icon_state = "gravel"
	neighborlay_self = "edgesalt"
	water_height = WATER_HEIGHT_SHALLOW
	slowdown = 2
	water_reagent = /datum/reagent/water/salty
	fishing_datum = /datum/fish_source/ocean

/turf/open/water/ocean/abyss
	name = "salt water"
	desc = "Deceptively deep, be careful not to find yourself this far out."
	icon = 'icons/turf/natural/liquids.dmi'
	icon_state = MAP_SWITCH("water", "ashW")
	underlay_icon_state = null // to give the impression the water is deeper than there are actual z levels
	can_examine_depth = FALSE
	water_height = WATER_HEIGHT_DEEP
	slowdown = 4
	fishing_datum = /datum/fish_source/ocean/deep

/turf/open/water/ocean/abyss/under
	desc = "Down in the abyssal depths, there is only loneliness and wrath."
	icon_state = MAP_SWITCH("water", "gravelswf")
	underlay_icon_state = "ash"
	water_height = WATER_HEIGHT_FULL
	shine = SHINE_MATTE
	force_open_above = TRUE

/datum/reagent/water/salty
	taste_description = "salt"
	color = "#3e7459"

/datum/reagent/water/salty/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(method & INGEST) // Make sure you DRANK the salty water before losing hydration
		..()

/datum/reagent/water/salty/on_mob_life(mob/living/carbon/M, efficiency)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(-hydration * efficiency)  //saltwater dehydrates more than it hydrates
		M.adjustToxLoss(0.25 * efficiency) // Slightly toxic
		M.add_nausea(2 * efficiency)
	..()

/// Piss
/turf/open/water/river/sewer
	desc = "Piss-laden water! Flowing swiftly along the river."
	icon_state = MAP_SWITCH("rivermove", "rivermovealt-dir")
	underlay_icon_state = "paving"
	water_reagent = /datum/reagent/water/gross/sewer
	cleanliness_factor = -5
	slowdown = 5
	water_height = WATER_HEIGHT_ANKLE
	footstep = FOOTSTEP_SHALLOW
	barefootstep = FOOTSTEP_SHALLOW
	clawfootstep = FOOTSTEP_SHALLOW
	heavyfootstep = FOOTSTEP_SHALLOW
	slowdown = 5
	current_speed = 1 SECONDS

/turf/open/water/river/sewer/roofflow
	underlay_icon_state = "roof"

/turf/open/water/river/sewer/floorflow
	underlay_icon_state = "wooden_floort"
