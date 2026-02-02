/**
 * # area
 *
 * A grouping of tiles into a logical space, mostly used by map editors
 */
/area
	level = null
	name = "unknown"
	icon = 'icons/turf/areas/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	//Keeping this on the default plane, GAME_PLANE, will make area overlays fail to render on FLOOR_PLANE.
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	flags_1 = CAN_BE_DIRTY_1 | CULT_PERMITTED_1

	/// List of all turfs currently inside this area as nested lists indexed by zlevel.
	/// Acts as a filtered bersion of area.contents For faster lookup
	/// (area.contents is actually a filtered loop over world)
	/// Semi fragile, but it prevents stupid so I think it's worth it
	var/list/list/turf/turfs_by_zlevel = list()
	/// turfs_by_z_level can become MASSIVE lists, so rather then adding/removing from it each time we have a problem turf
	/// We should instead store a list of turfs to REMOVE from it, then hook into a getter for it
	/// There is a risk of this and contained_turfs leaking, so a subsystem will run it down to 0 incrementally if it gets too large
	/// This uses the same nested list format as turfs_by_zlevel
	var/list/list/turf/turfs_to_uncontain_by_zlevel = list()

	var/area_flags = VALID_TERRITORY | UNIQUE_AREA

	var/totalbeauty = 0 //All beauty in this area combined, only includes indoor area.
	var/beauty = 0 // Beauty average per open turf in the area
	var/beauty_threshold = 150 //If a room is too big it doesn't have beauty.

	var/outdoors = FALSE //For space, the asteroid, lavaland, etc. Used with blueprints to determine if we are adding a new area (vs editing a station room)

	var/areasize = 0 //Size of the area in open turfs, only calculated for indoors areas.

	/// Bonus mood for being in this area
	var/mood_bonus = 0
	/// Mood message for being here, only shows up if mood_bonus != 0
	var/mood_message = "<span class='nicegreen'>This area is pretty nice!\n</span>"

	var/parallax_movedir = 0

	/// The background music that plays in this area
	/// This overrides the others if they are absent
	var/sound/background_track
	/// The background music that plays in this area at dusk
	var/sound/background_track_dusk
	/// The background music that plays in this area at night
	var/sound/background_track_night
	/// Alternative droning loops to replace the background music
	/// To make things more spooky
	/// Do not set directly on /area use the index
	var/list/alternative_droning
	var/droning_index
	/// Alternative droning loops for night
	/// Do not set directly on /area use the index
	var/list/alternative_droning_night
	var/droning_index_night
	/// Self explanatory
	var/uses_alt_droning = TRUE

	/// A list of sounds to pick from every so often to play to clients.
	/// Do not set directly on /area use the index
	var/list/ambientsounds
	var/ambient_index
	/// A list of sounds to pick but at night
	/// Do not set directly on /area use the index
	var/list/ambientnight
	var/ambient_index_night
	/// Does this area immediately play an ambience sound upon enter?
	var/forced_ambience = FALSE
	///Used to decide what the minimum time between ambience is
	var/min_ambience_cooldown = 25 SECONDS
	///Used to decide what the maximum time between ambience is
	var/max_ambience_cooldown = 35 SECONDS

	var/soundenv = 0

	var/first_time_text = null
	var/custom_area_sound = null

	var/list/ambush_types
	var/list/ambush_mobs
	var/list/ambush_times

	var/converted_type
	var/delver_restrictions = FALSE
	var/coven_protected = FALSE

/**
 * A list of teleport locations
 *
 * Adding a wizard area teleport list because motherfucking lag -- Urist
 * I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game
 */
GLOBAL_LIST_EMPTY(teleportlocs)

/**
 * Generate a list of turfs you can teleport to from the areas list
 *
 * Includes areas if they're not a shuttle or not not teleport or have no contents
 *
 * The chosen turf is the first item in the areas contents that is a station level
 *
 * The returned list of turfs is sorted by name
 */
/proc/process_teleport_locs()
	for(var/area/AR as anything in get_sorted_areas())
		if(GLOB.teleportlocs[AR.name])
			continue
		if (!AR.has_contained_turfs())
			continue
		if (is_station_level(AR.z))
			GLOB.teleportlocs[AR.name] = AR


/**
 * Called when an area loads
 *
 *  Adds the item to the GLOB.areas_by_type list based on area type
 */
/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if(area_flags & UNIQUE_AREA)
		GLOB.areas_by_type[type] = src
	GLOB.areas += src
	return ..()

/area/proc/can_craft_here()
	return TRUE

/// Returns the highest zlevel that this area contains turfs for
/area/proc/get_highest_zlevel()
	for (var/area_zlevel in length(turfs_by_zlevel) to 1 step -1)
		if (length(turfs_to_uncontain_by_zlevel) >= area_zlevel)
			if (length(turfs_by_zlevel[area_zlevel]) - length(turfs_to_uncontain_by_zlevel[area_zlevel]) > 0)
				return area_zlevel
		else
			if (length(turfs_by_zlevel[area_zlevel]))
				return area_zlevel
	return 0

/// Returns a nested list of lists with all turfs split by zlevel.
/// only zlevels with turfs are returned. The order of the list is not guaranteed.
/area/proc/get_zlevel_turf_lists()
	if(length(turfs_to_uncontain_by_zlevel))
		cannonize_contained_turfs()

	var/list/zlevel_turf_lists = list()

	for (var/list/zlevel_turfs as anything in turfs_by_zlevel)
		if (length(zlevel_turfs))
			zlevel_turf_lists[++zlevel_turf_lists.len] = zlevel_turfs

	return zlevel_turf_lists

/// Returns a list with all turfs in this zlevel.
/area/proc/get_turfs_by_zlevel(zlevel)
	if (length(turfs_to_uncontain_by_zlevel) >= zlevel && length(turfs_to_uncontain_by_zlevel[zlevel]))
		cannonize_contained_turfs_by_zlevel(zlevel)

	if (length(turfs_by_zlevel) < zlevel)
		return list()

	return turfs_by_zlevel[zlevel]


/// Merges a list containing all of the turfs zlevel lists from get_zlevel_turf_lists inside one list. Use get_zlevel_turf_lists() or get_turfs_by_zlevel() unless you need all the turfs in one list to avoid generating large lists
/area/proc/get_turfs_from_all_zlevels()
	. = list()
	for (var/list/zlevel_turfs as anything in get_zlevel_turf_lists())
		. += zlevel_turfs

/// Ensures that the contained_turfs list properly represents the turfs actually inside us
/area/proc/cannonize_contained_turfs_by_zlevel(zlevel_to_clean, _autoclean = TRUE)
	// This is massively suboptimal for LARGE removal lists
	// Try and keep the mass removal as low as you can. We'll do this by ensuring
	// We only actually add to contained turfs after large changes (Also the management subsystem)
	// Do your damndest to keep turfs out of /area/space as a stepping stone
	// That sucker gets HUGE and will make this take actual seconds
	if (zlevel_to_clean <= length(turfs_by_zlevel) && zlevel_to_clean <= length(turfs_to_uncontain_by_zlevel))
		turfs_by_zlevel[zlevel_to_clean] -= turfs_to_uncontain_by_zlevel[zlevel_to_clean]

	if (_autoclean) // Removes empty lists from the end of this list
		var/new_length = length(turfs_to_uncontain_by_zlevel)
		// Walk backwards thru the list
		for (var/i in length(turfs_to_uncontain_by_zlevel) to 0 step -1)
			if (i && length(turfs_to_uncontain_by_zlevel[i]))
				break // Stop the moment we find a useful list
			new_length = i

		if (new_length < length(turfs_to_uncontain_by_zlevel))
			turfs_to_uncontain_by_zlevel.len = new_length

		if (new_length >= zlevel_to_clean)
			turfs_to_uncontain_by_zlevel[zlevel_to_clean] = list()
	else
		turfs_to_uncontain_by_zlevel[zlevel_to_clean] = list()


/// Ensures that the contained_turfs list properly represents the turfs actually inside us
/area/proc/cannonize_contained_turfs()
	for (var/area_zlevel in 1 to length(turfs_to_uncontain_by_zlevel))
		cannonize_contained_turfs_by_zlevel(area_zlevel, _autoclean = FALSE)

	turfs_to_uncontain_by_zlevel = list()


/// Returns TRUE if we have contained turfs, FALSE otherwise
/area/proc/has_contained_turfs()
	for (var/area_zlevel in 1 to length(turfs_by_zlevel))
		if (length(turfs_to_uncontain_by_zlevel) >= area_zlevel)
			if (length(turfs_by_zlevel[area_zlevel]) - length(turfs_to_uncontain_by_zlevel[area_zlevel]) > 0)
				return TRUE
		else
			if (length(turfs_by_zlevel[area_zlevel]))
				return TRUE
	return FALSE

/**
 * Initalize this area
 *
 * intializes the dynamic area lighting and also registers the area with the z level via
 * reg_in_areas_in_z
 *
 * returns INITIALIZE_HINT_LATELOAD
 */
/area/Initialize()
	setup_ambience()
	if(!outdoors)
		plane = INDOOR_PLANE
		icon_state = "mask"
	else
		icon_state = ""
	first_time_text = uppertext(first_time_text) // Standardization

	if(dynamic_lighting == DYNAMIC_LIGHTING_FORCED)
		dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
		luminosity = 0
	else if(dynamic_lighting != DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	if(dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = CONFIG_GET(flag/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

	. = ..()

//	blend_mode = BLEND_MULTIPLY // Putting this in the constructor so that it stops the icons being screwed up in the map editor.

	if(!IS_DYNAMIC_LIGHTING(src))
		add_overlay(/obj/effect/fullbright)

	reg_in_areas_in_z()

	return INITIALIZE_HINT_LATELOAD

/area/LateInitialize()
	update_beauty()

/**
 * Register this area as belonging to a z level
 *
 * Ensures the item is added to the SSmapping.areas_in_z list for this z
 */
/area/proc/reg_in_areas_in_z()
	if(!has_contained_turfs())
		return
	var/list/areas_in_z = SSmapping.areas_in_z
	update_areasize()
	if(!z)
		WARNING("No z found for [src]")
		return
	if(!areas_in_z["[z]"])
		areas_in_z["[z]"] = list()
	areas_in_z["[z]"] += src

/// Setup all ambience tracks
/area/proc/setup_ambience()
	if(!ambientsounds && ambient_index)
		ambientsounds = GLOB.ambience_assoc_sounds[ambient_index]
	if(!ambientnight && ambient_index_night)
		ambientnight = GLOB.ambience_assoc_sounds[ambient_index_night]

	if(!alternative_droning && droning_index)
		alternative_droning = GLOB.ambience_assoc_droning[droning_index]
	if(!alternative_droning_night && droning_index_night)
		alternative_droning_night = GLOB.ambience_assoc_droning[droning_index_night]

/**
 * Destroy an area and clean it up
 *
 * Removes the area from GLOB.areas_by_type and also stops it processing on SSobj
 *
 * This is despite the fact that no code appears to put it on SSobj, but
 * who am I to argue with old coders
 */
/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	GLOB.sortedAreas -= src
	GLOB.areas -= src
	STOP_PROCESSING(SSobj, src)

	turfs_by_zlevel = null
	turfs_to_uncontain_by_zlevel = null
	return ..()

/**
 * Update the icon state of the area
 *
 * Im not sure what the heck this does, somethign to do with weather being able to set icon
 * states on areas?? where the heck would that even display?
 */
/area/update_icon_state()
//	var/weather_icon
///	for(var/V in SSweather.curweathers)
//	/	var/datum/weather/W = V
//		if(W.stage != END_STAGE && (src in W.impacted_areas))
//			W.update_areas()
//			weather_icon = TRUE
//	if(!weather_icon)
//		icon_state = null
	return ..()

/**
 * Call back when an atom enters an area
 *
 * Sends signals COMSIG_AREA_ENTERED and COMSIG_ENTER_AREA (to the atom)
 *
 * If the area has ambience, then it plays some ambience music to the ambience channel
 */
/area/Entered(atom/movable/M, atom/old_loc)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, M)
	SEND_SIGNAL(M, COMSIG_ENTER_AREA, src) //The atom that enters the area
	if(!isliving(M))
		return

	var/mob/living/L = M
	if(!L.ckey || L.stat == DEAD)
		return

	if(ismob(M))
		var/mob/mob = M
		mob.update_ambience_area(src)

	if(first_time_text)
		L.intro_area(src)

/client
	var/musicfading = 0

/mob/living/proc/intro_area(area/A)
	if(!mind)
		return
	if(A.first_time_text in mind.areas_entered)
		return
	if(!client)
		return
	mind.areas_entered += A.first_time_text
	var/atom/movable/screen/area_text/T = new()
	client.screen += T
	T.maptext = MAPTEXT_BLACKMOOR("<span class='center' style='vertical-align:top; color: #820000;\
		text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;'>[A.first_time_text]</span>")
	T.maptext_width = 230
	T.maptext_height = 209
	T.maptext_x = 12
	T.maptext_y = 64
	var/used_sound = 'sound/misc/stings/generic.ogg'
	var/map_sound = SSmapping.config.custom_area_sound
	var/area_sound = A.custom_area_sound
	if(area_sound)
		used_sound = area_sound
	else if(map_sound)
		used_sound = map_sound

	SEND_SOUND(src, sound(used_sound, repeat = 0, wait = 0, volume = 40))
	animate(T, alpha = 255, time = 10, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(clear_area_text), T), 35)

/mob/living/proc/clear_area_text(atom/movable/screen/A)
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 10, easing = EASE_OUT)
	sleep(11)
	if(client)
		if(client.screen && A)
			client.screen -= A
	qdel(A)

/mob/living/proc/clear_time_icon(atom/movable/screen/A)
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 20, easing = EASE_OUT)
	sleep(21)
	if(client)
		if(client.screen && A)
			client.screen -= A
			qdel(A)

///Divides total beauty in the room by roomsize to allow us to get an average beauty per tile.
/area/proc/update_beauty()
	if(!areasize)
		beauty = 0
		return FALSE
	if(areasize >= beauty_threshold)
		beauty = 0
		return FALSE //Too big
	beauty = totalbeauty / areasize


/**
 * Called when an atom exits an area
 *
 * Sends signals COMSIG_AREA_EXITED and COMSIG_EXIT_AREA (to the atom)
 */
/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_EXIT_AREA, src) //The atom that exits the area

/**
 * Reset the played var to false on the client
 */

/**
 * Setup an area (with the given name)
 *
 * Sets the area name, sets all status var's to false and adds the area to the sorted area list
 */
/area/proc/setup(a_name)
	name = a_name
	area_flags &= ~VALID_TERRITORY
	require_area_resort()

/**
 * Set the area size of the area
 *
 * This is the number of open turfs in the area contents, or FALSE if the outdoors var is set
 *
 */
/area/proc/update_areasize()
	if(outdoors)
		return FALSE
	areasize = 0
	for (var/list/zlevel_turfs as anything in get_zlevel_turf_lists())
		for(var/turf/open/thisvarisunused in zlevel_turfs)
			areasize++

/**
 * Causes a runtime error
 */
/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/**
 * Causes a runtime error
 */
/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

/// A hook so areas can modify the incoming args (of what??)
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags

/area/proc/on_joining_game(mob/living/boarder)
	return

/area/proc/reconnect_game(mob/living/boarder)
	return

/area/on_joining_game(mob/living/boarder)
	. = ..()
	if(istype(boarder) && boarder.client)
		boarder.client.update_ambience_pref()
		boarder.refresh_looping_ambience()

/area/reconnect_game(mob/living/boarder)
	. = ..()
	if(istype(boarder) && boarder.client)
		boarder.refresh_looping_ambience()
