#define CENTERED_RENDER_SOURCE(img, atom, FoV) \
	atom.render_target = atom.render_target || ref(atom);\
	img.render_source = atom.render_target;\
	if(atom.icon){\
		var/_cached_sizes = FoV.width_n_height_offsets[atom.icon];\
		if(!_cached_sizes){\
			var/icon/_I = icon(atom.icon);\
			var/list/L = list();\
			L += (_I.Width() - world.icon_size)/2;\
			L += (_I.Height() - world.icon_size)/2;\
			_cached_sizes = FoV.width_n_height_offsets[atom.icon] = L\
		}\
		img.pixel_x = _cached_sizes[1];\
		img.pixel_y = _cached_sizes[2];\
		img.loc = atom\
	}

#define REGISTER_NESTED_LOCS(source, list, comsig, proc) \
	for(var/k in get_nested_locs(source)){\
		var/atom/_A = k;\
		RegisterSignal(_A, comsig, proc, override = TRUE);\
		list += _A\
	}

#define UNREGISTER_NESTED_LOCS(list, comsig, index) \
	for(var/k in list){\
		var/atom/_A = k;\
		UnregisterSignal(_A, comsig);\
		list -= _A\
	}

/**
  * The shadow cone's mask and visual images holder which can't locate inside the mob,
  * lest they inherit the mob opacity and cause a lot of hindrance
  */
/atom/movable/screen/fov_holder
	name = "field of vision holder"
	icon = 'icons/hud/fov_15x15.dmi'
	screen_loc = "1,1"
	plane = FIELD_OF_VISION_MASK_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/image/fov_image
	icon = 'icons/effects/fov/fov_effects.dmi'
	appearance_flags = RESET_COLOR | RESET_TRANSFORM
	plane = GAME_PLANE_OBJECT_PERMANENCE

/obj/effect/abstract/fov_object
	icon = 'icons/effects/fov/fov_effects.dmi'
	appearance_flags = RESET_COLOR | RESET_TRANSFORM
	plane = GAME_PLANE_OBJECT_PERMANENCE

/// Plays a visual effect representing a sound cue for people with vision obstructed by FOV or blindness
/// Simplified just creates an effect on the plane needed for a time then deletes it does no advanced checks like ignore_self or deafness
/proc/play_fov_effect(atom/center, range, icon_state, dir = SOUTH, ignore_self = FALSE, angle = 0, time = 1.5 SECONDS, list/override_list, simplified = FALSE)
	var/turf/anchor_point = get_turf(center)
	if(simplified)
		var/obj/effect/abstract/fov_object/fov_object = new(anchor_point)
		fov_object.icon_state = icon_state
		fov_object.dir = dir
		if(angle)
			var/matrix/matrix = new
			matrix.Turn(angle)
			fov_object.transform = matrix
		fov_object.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		QDEL_IN(fov_object, time)

	else
		var/image/fov_image/fov_image
		var/list/clients_shown

		for(var/mob/living/living_mob in override_list || fov_viewers(range, center))
			if(ignore_self && living_mob == center)
				continue
			var/client/mob_client = living_mob.client
			if(!mob_client)
				continue
			if(HAS_TRAIT(living_mob, TRAIT_DEAF)) //Deaf people can't hear sounds so no sound indicators
				continue
			if(!fov_image) //Make the image once we found one recipient to receive it
				fov_image = new()
				fov_image.loc = anchor_point
				fov_image.icon_state = icon_state
				fov_image.dir = dir
				fov_image.plane = GAME_PLANE_OBJECT_PERMANENCE
				if(angle)
					var/matrix/matrix = new
					matrix.Turn(angle)
					fov_image.transform = matrix
				fov_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			LAZYADD(clients_shown, mob_client)

			mob_client.images += fov_image
			//when added as an image mutable_appearances act identically. we just make it an MA becuase theyre faster to change appearance

		if(clients_shown)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_clients), fov_image, clients_shown), time)

/**
  * Field of Vision component. Does totally what you probably think it does,
  * ergo preventing players from seeing what's behind them.
  */
/datum/component/field_of_vision
	can_transfer = TRUE
	/// Our screen object
	var/atom/movable/screen/fov_holder/fov_holder
	/// The current screen size this field of vision is meant to fit for.
	var/current_fov_size = list(15, 15)
	/// How much is the cone rotated clockwise, purely backend. Please use rotate_shadow_cone() if you must.
	var/angle = 0
	/// The inner angle of this cone, right hardset to 90, 180, or 270 degrees, until someone figures out a way to make it dynamic.
	var/shadow_angle = FOV_90_DEGREES
	/// Used to scale the shadow cone when rotating it to fit over the edges of the screen.
	var/rot_scale = 1
	/// The mask portion of the cone, placed on a * render target plane so while not visible it still applies the filter.
	var/image/shadow_mask
	/// The visual portion of the cone, placed on the highest layer of the wall plane
	var/image/visual_shadow
	/// Extensions of the shadow mask, so that FoV always works as the player sees it
	var/list/image/shadow_mask_extensions
	/// Extensions of the visual shadow, so that FoV always works as the player sees it
	var/list/image/visual_shadow_extensions
	/**
	 * An image whose render_source is kept up to date to prevent the mob (or the topmost movable holding it) from being hidden by the mask.
	 * Will make it use vis_contents instead once a few byonds bugs with images and vis contents are fixed.
	 */
	var/image/owner_mask
	/**
	 * A circle image used to somewhat uncover the adjacent portion of the shadow cone, making mobs and objects behind us somewhat visible.
	 * The owner mask is still required for those mob going over the default 32x32 px size btw.
	 */
	var/image/adj_mask
	var/has_adj_mask = FALSE
	/**
	 * A list of nested locations the mob is in, to ensure the above image works correctly.
	 */
	var/list/nested_locs = list()
	/**
	 * A static list of offsets based on icon width and height, because render sources are centered unlike most other visuals,
	 * and that gives us some problems when the icon is larger or smaller than world.icon_size
	 */
	var/static/list/width_n_height_offsets = list()
	/**
	 * Stores object permanence images AKA ghosts of people that were in our view but are now hidden by FoV
	 */
	var/list/object_permanence_images = list()

/datum/component/field_of_vision/Initialize(fov_type = FOV_90_DEGREES, angle = 0, has_adj_mask = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.shadow_angle = fov_type
	src.angle = angle
	src.has_adj_mask = has_adj_mask

/datum/component/field_of_vision/RegisterWithParent()
	. = ..()
	var/mob/living/source = parent
	if(source.client)
		generate_fov_holder(source, shadow_angle, angle, delete_holder = TRUE, register = TRUE)
		SSfield_of_vision.processing |= src
	RegisterSignal(source, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_mob_login))
	RegisterSignal(source, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))
	RegisterSignal(source, COMSIG_MOB_VISIBLE_MESSAGE, PROC_REF(on_visible_message))
	RegisterSignal(source, COMSIG_MOB_EXAMINATE, PROC_REF(on_examinate))
	RegisterSignal(source, COMSIG_MOB_CLIENT_CHANGE_VIEW, PROC_REF(on_change_view))
	RegisterSignal(source, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_reset_perspective))
	RegisterSignal(source, COMSIG_MOB_FOV_VIEW, PROC_REF(in_fov_view))
	RegisterSignal(source, COMSIG_MOB_FOV_VIEWER, PROC_REF(is_fov_viewer))

/datum/component/field_of_vision/UnregisterFromParent()
	. = ..()
	var/mob/living/source = parent
	if(!QDELETED(fov_holder))
		source.hud_used?.fov_holder = null
		source.client?.screen -= fov_holder
		qdel(fov_holder, TRUE) // Forced.
		fov_holder = null
		source.client?.images -= owner_mask
		source.client?.images -= adj_mask
		QDEL_NULL(owner_mask)
		QDEL_NULL(adj_mask)
	UnregisterSignal(source, COMSIG_MOB_CLIENT_LOGIN)
	UnregisterSignal(source, COMSIG_MOB_LOGOUT)
	UnregisterSignal(source, COMSIG_MOB_VISIBLE_MESSAGE)
	UnregisterSignal(source, COMSIG_MOB_EXAMINATE)
	UnregisterSignal(source, COMSIG_MOB_CLIENT_CHANGE_VIEW)
	UnregisterSignal(source, COMSIG_MOB_RESET_PERSPECTIVE)
	UnregisterSignal(source, COMSIG_MOB_FOV_VIEW)
	UnregisterSignal(source, COMSIG_MOB_FOV_VIEWER)
	if(length(nested_locs))
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
	UnregisterSignal(source, COMSIG_FOV_HIDE)
	UnregisterSignal(source, COMSIG_FOV_SHOW)
	UnregisterSignal(source, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(source, COMSIG_ATOM_POST_DIR_CHANGE)
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_APPEARANCE)

/**
  * Generates the holder and images (if not generated yet) and adds them to client.images.
  * Run when the component is registered to a player mob, or upon login.
  */
/datum/component/field_of_vision/proc/generate_fov_holder(mob/living/source, shadow_angle = FOV_90_DEGREES, angle = 0, register = TRUE, delete_holder = FALSE)
	if(fov_holder && delete_holder)
		current_fov_size = list(15, 15)
		source.client?.screen -= fov_holder
		QDEL_NULL(source.hud_used?.fov_holder)
		QDEL_NULL(fov_holder)
	if(angle)
		src.angle = angle
	if(shadow_angle)
		src.shadow_angle = shadow_angle
	if(QDELETED(fov_holder))
		fov_holder = new(null, source.hud_used)
		fov_holder.dir = source.dir
		fov_holder.screen_loc = "1,1"
		shadow_mask = image('icons/hud/fov_15x15.dmi', fov_holder, "[shadow_angle]")
		shadow_mask.plane = FIELD_OF_VISION_MASK_PLANE
		shadow_mask.layer = FIELD_OF_VISION_MASK_LAYER
		fov_holder.add_overlay(shadow_mask)
		owner_mask = new()
		owner_mask.plane = FIELD_OF_VISION_BLOCKER_PLANE
		visual_shadow = image('icons/hud/fov_15x15.dmi', fov_holder, "[shadow_angle]")
		visual_shadow.plane = ABOVE_LIGHTING_PLANE
		visual_shadow.layer = FIELD_OF_VISION_MASK_LAYER
		visual_shadow.alpha = 89
		fov_holder.add_overlay(visual_shadow)
		if(has_adj_mask)
			adj_mask = image('icons/hud/fov_15x15.dmi', fov_holder, "adj_mask", FIELD_OF_VISION_MASK_LAYER)
			adj_mask.appearance_flags = RESET_TRANSFORM
			adj_mask.plane = FIELD_OF_VISION_BLOCKER_PLANE
	if(src.shadow_angle != shadow_angle)
		src.shadow_angle = shadow_angle
	if(src.angle != angle)
		rotate_shadow_cone(angle)
	fov_holder.alpha = (source.body_position == LYING_DOWN ? 0 : 255)
	fov_holder.icon_state = "[shadow_angle]"
	if(register)
		RegisterSignal(source, COMSIG_FOV_HIDE, PROC_REF(hide_fov), override = TRUE)
		RegisterSignal(source, COMSIG_FOV_SHOW, PROC_REF(show_fov), override = TRUE)
		RegisterSignal(source, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(update_body_position), override = TRUE)
		RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_moved), override = TRUE)
		RegisterSignal(source, COMSIG_ATOM_POST_DIR_CHANGE, PROC_REF(on_dir_change), override = TRUE)

	var/atom/A = source
	if(source.loc && !isturf(source.loc) && register)
		REGISTER_NESTED_LOCS(source, nested_locs, COMSIG_MOVABLE_MOVED, PROC_REF(on_loc_moved))
		A = nested_locs[nested_locs.len]
	CENTERED_RENDER_SOURCE(owner_mask, A, src)
	if(owner_mask)
		source.client?.images += owner_mask
	if(adj_mask)
		source.client?.images += adj_mask
	source.hud_used?.fov_holder = fov_holder
	source.hud_used?.show_hud(HUD_STYLE_STANDARD)
	if(source.client?.view && fov_holder && (source.client.view != "[current_fov_size[1]]x[current_fov_size[2]]"))
		//this is beyond fucking stupid i hate myself
		var/list/new_size = getviewsize(source.client.view)
		resize_fov(current_fov_size, new_size)

///Rotates the shadow cone to a certain degree. Backend shenanigans.
/datum/component/field_of_vision/proc/rotate_shadow_cone(new_angle)
	var/simple_degrees = SIMPLIFY_DEGREES(new_angle - angle)
	var/to_scale = cos(simple_degrees) * sin(simple_degrees)
	if(to_scale)
		var/old_rot_scale = rot_scale
		rot_scale = 1 + to_scale
		if(old_rot_scale != rot_scale)
			fov_holder.transform = visual_shadow.transform = shadow_mask.transform = shadow_mask.transform.Scale(rot_scale/old_rot_scale)
	fov_holder.transform = visual_shadow.transform = shadow_mask.transform = shadow_mask.transform.Turn(fov_holder.transform, simple_degrees)

/**
  * Resizes the shadow to match the current screen size.
  * Run when the client view size is changed, or if the player has a viewsize different than "15x15" on login/comp registration.
  */
/datum/component/field_of_vision/proc/resize_fov(list/old_view, list/new_view)
	//Edges are still of the same length.
	if(old_view ~= new_view)
		return
	if(!fov_holder)
		return
	current_fov_size = new_view
	shadow_mask_extensions = list()
	visual_shadow_extensions = list()
	for(var/direction in GLOB.cardinals)
		var/image/mask_extension = image('icons/hud/fov_15x15.dmi', "darkness")
		mask_extension.plane = shadow_mask.plane
		switch(direction)
			if(NORTH)
				mask_extension.pixel_x = 0
				mask_extension.pixel_y = -480
			if(WEST)
				mask_extension.pixel_x = 480
				mask_extension.pixel_y = 0
			if(SOUTH)
				mask_extension.pixel_x = 0
				mask_extension.pixel_y = 480
			if(EAST)
				mask_extension.pixel_x = -480
				mask_extension.pixel_y = 0
		shadow_mask_extensions["[direction]"] = mask_extension
		var/image/visual_extension = image('icons/hud/fov_15x15.dmi', "darkness")
		visual_extension.plane = visual_shadow.plane
		visual_extension.alpha = visual_shadow.alpha
		visual_extension.pixel_x = mask_extension.pixel_x
		visual_extension.pixel_y = mask_extension.pixel_y
		visual_shadow_extensions["[direction]"] = visual_extension
	on_dir_change(parent, fov_holder.dir, fov_holder.dir)

/datum/component/field_of_vision/proc/on_mob_login(mob/living/source, client/client)
	SIGNAL_HANDLER

	generate_fov_holder(source, src.shadow_angle, src.angle, delete_holder = TRUE, register = TRUE)
	SSfield_of_vision.processing |= src

/datum/component/field_of_vision/proc/on_mob_logout(mob/living/source)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_FOV_HIDE)
	UnregisterSignal(source, COMSIG_FOV_SHOW)
	UnregisterSignal(source, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(source, COMSIG_ATOM_POST_DIR_CHANGE)
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_APPEARANCE)
	if(length(nested_locs))
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
	SSfield_of_vision.processing -= src
	shadow_mask_extensions = list()
	visual_shadow_extensions = list()
	object_permanence_images = list()

/datum/component/field_of_vision/proc/on_dir_change(mob/living/source, old_dir, new_dir)
	SIGNAL_HANDLER

	// Don't run this if new_dir is nonsense
	if(!new_dir)
		return

	// This is the greatest field of vision code of all time
	if(!(new_dir in GLOB.cardinals))
		switch(new_dir)
			if(NORTHEAST)
				new_dir = NORTH
			if(NORTHWEST)
				new_dir = WEST
			if(SOUTHWEST)
				new_dir = SOUTH
			if(SOUTHEAST)
				new_dir = EAST
			else
				new_dir = NORTH
	fov_holder.dir = new_dir
	if(LAZYLEN(shadow_mask_extensions))
		for(var/direction in shadow_mask_extensions)
			fov_holder.cut_overlay(shadow_mask_extensions["[direction]"])
			fov_holder.cut_overlay(visual_shadow_extensions["[direction]"])
		var/image/mask_extension = shadow_mask_extensions["[new_dir]"]
		var/image/visual_extension = visual_shadow_extensions["[new_dir]"]
		mask_extension.icon_state = "darkness"
		mask_extension.dir = new_dir
		visual_extension.icon_state = "darkness"
		visual_extension.dir = new_dir
		fov_holder.add_overlay(mask_extension)
		fov_holder.add_overlay(visual_extension)
		//Code gore below
		switch(shadow_angle)
			if(FOV_180PLUS45_DEGREES)
				var/extra_dir = angle2dir(dir2angle(new_dir)+90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "darkness"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "darkness"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)
			if(FOV_180MINUS45_DEGREES)
				var/extra_dir = angle2dir(dir2angle(new_dir)-90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "darkness"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "darkness"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)
			if(FOV_180_DEGREES)
				var/extra_dir = angle2dir(dir2angle(new_dir)+90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "[shadow_angle]"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "[shadow_angle]"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)

				extra_dir = angle2dir(dir2angle(new_dir)-90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "[shadow_angle]"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "[shadow_angle]"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)
			if(FOV_270_DEGREES)
				var/extra_dir = angle2dir(dir2angle(new_dir)+90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "darkness"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "darkness"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)

				extra_dir = angle2dir(dir2angle(new_dir)-90)
				mask_extension = shadow_mask_extensions["[extra_dir]"]
				visual_extension = visual_shadow_extensions["[extra_dir]"]
				mask_extension.icon_state = "darkness"
				mask_extension.dir = new_dir
				visual_extension.icon_state = "darkness"
				visual_extension.dir = new_dir
				fov_holder.add_overlay(mask_extension)
				fov_holder.add_overlay(visual_extension)

//Updates the alpha depending on whether or not we are lying
/datum/component/field_of_vision/proc/update_body_position(mob/living/source, new_value)
	SIGNAL_HANDLER

	if(source.body_position == LYING_DOWN)
		hide_fov(source)
	else
		show_fov(source)

/// Hides the shadow, other visibility comsig procs will take it into account. Called when the mob dies.
/datum/component/field_of_vision/proc/hide_fov(mob/living/source)
	SIGNAL_HANDLER

	fov_holder?.alpha = 0

/// Shows the shadow. Called when the mob is revived.
/datum/component/field_of_vision/proc/show_fov(mob/living/source)
	SIGNAL_HANDLER

	fov_holder?.alpha = 255
	on_dir_change(source, source.dir, source.dir)

/// Hides the shadow when looking through other items, shows it otherwise.
/datum/component/field_of_vision/proc/on_reset_perspective(mob/living/source, atom/target)
	SIGNAL_HANDLER

	if(source.client.eye == source || source.client.eye == source.loc)
		fov_holder?.alpha = 255
	else
		fov_holder?.alpha = 0

/// Called when the client view size is changed.
/datum/component/field_of_vision/proc/on_change_view(mob/living/source, client, list/old_view, list/view)
	SIGNAL_HANDLER

	if(fov_holder)
		resize_fov(old_view, view)

/**
  * Called when the owner mob moves around. Used to keep shadow located right behind us,
  * As well as modify the owner mask to match the topmost item.
  */
/datum/component/field_of_vision/proc/on_mob_moved(mob/living/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(!isturf(source.loc)) //Recalculate all nested locations.
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
		REGISTER_NESTED_LOCS(source, nested_locs, COMSIG_MOVABLE_MOVED, PROC_REF(on_loc_moved))
		var/atom/movable/screen/topmost = nested_locs[LAZYLEN(nested_locs)]
		CENTERED_RENDER_SOURCE(owner_mask, topmost, src)
	else
		if(length(nested_locs))
			UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
			CENTERED_RENDER_SOURCE(owner_mask, source, src)

/// Pretty much like the above, but meant for other movables the mob is stored in (bodybags, boxes, mechs etc).
/datum/component/field_of_vision/proc/on_loc_moved(atom/movable/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(isturf(source.loc) && isturf(oldloc)) //This is the case of the topmost movable loc moving around the world, skip.
		return
	var/atom/movable/screen/prev_topmost = nested_locs[nested_locs.len]
	if(prev_topmost != source)
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, nested_locs.Find(source) + 1)
	REGISTER_NESTED_LOCS(source, nested_locs, COMSIG_MOVABLE_MOVED, PROC_REF(on_loc_moved))
	var/atom/movable/screen/topmost = nested_locs[nested_locs.len]
	if(topmost != prev_topmost)
		CENTERED_RENDER_SOURCE(owner_mask, topmost, src)

/// A hacky comsig proc for things that somehow decide to change icon on the go. may make a change_icon_file() proc later but...
/datum/component/field_of_vision/proc/manual_centered_render_source(mob/living/source, old_icon)
	SIGNAL_HANDLER

	if(!isturf(source.loc))
		return
	CENTERED_RENDER_SOURCE(owner_mask, source, src)

#undef CENTERED_RENDER_SOURCE
#undef REGISTER_NESTED_LOCS
#undef UNREGISTER_NESTED_LOCS

/**
  * Byond doc is not entirely correct on the integrated arctan() proc.
  * When both x and y are negative, the output is also negative, cycling clockwise instead of counter-clockwise.
  * That's also why I am extensively using the SIMPLIFY_DEGREES macro here.
  *
  * Overall this is the main macro that calculates wheter a target is within the shadow cone angle or not.
  */
#define FOV_ANGLE_CHECK(mob, target, zero_x_y_statement, success_statement) \
	var/turf/T1 = get_turf(target);\
	var/turf/T2 = get_turf(mob);\
	if(!T1 || !T2){\
		zero_x_y_statement\
	}\
	var/_x = (T1.x - T2.x);\
	var/_y = (T1.y - T2.y);\
	if((has_adj_mask && ISINRANGE(_x, -1, 1) && ISINRANGE(_y, -1, 1) ) || ((_x == 0) && (_y == 0))){\
		zero_x_y_statement\
	}\
	var/dir = mob.dir;\
	var/_degree = -angle;\
	var/real_shadow_angle = shadow_angle;\
	var/after_shadow_angle = "0";\
	var/found_angle = findtext(real_shadow_angle, "_");\
	if(found_angle){\
		real_shadow_angle = copytext(real_shadow_angle, 1, found_angle);\
		after_shadow_angle = copytext(real_shadow_angle, found_angle + 1);\
	}\
	var/_half = text2num(shadow_angle)/2;\
	var/_offset = text2num(after_shadow_angle)/2;\
	switch(dir){\
		if(EAST){\
			_degree += 180;\
		}\
		if(WEST){\
			_degree += 0;\
		}\
		if(NORTH){\
			_degree += 270;\
		}\
		if(SOUTH){\
			_degree += 90;\
		}\
	}\
	var/_min = SIMPLIFY_DEGREES(_degree - _half - _offset);\
	var/_max = SIMPLIFY_DEGREES(_degree + _half - _offset);\
	if((_min > _max) ? !ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _max, _min) : ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _min, _max)){\
		success_statement;\
	}

/**
 * I ALWAYS FEEL LIKE
 *
 * SOMEBODY'S WATCHING ME
 *
 * WHOS PLAYING TRICKS ON ME
 */
/datum/component/field_of_vision/proc/object_permanence_update()
	return

/datum/component/field_of_vision/proc/on_examinate(mob/living/source, atom/target)
	SIGNAL_HANDLER
	if(fov_holder?.alpha)
		FOV_ANGLE_CHECK(source, target, return, return COMPONENT_EXAMINATE_BLIND)

/datum/component/field_of_vision/proc/on_visible_message(mob/living/source, atom/target, message, range, list/ignored_mobs)
	SIGNAL_HANDLER
	if(fov_holder?.alpha)
		FOV_ANGLE_CHECK(source, target, return, return COMPONENT_VISIBLE_MESSAGE_BLIND)

/datum/component/field_of_vision/proc/in_fov_view(mob/living/source, atom/center, dist, list/viewed_list)
	SIGNAL_HANDLER
	if(fov_holder?.alpha)
		for(var/atom/viewed as anything in viewed_list)
			FOV_ANGLE_CHECK(source, viewed, continue, viewed_list -= viewed)

/datum/component/field_of_vision/proc/is_fov_viewer(mob/living/source, atom/center, depth, list/viewers_list)
	SIGNAL_HANDLER
	if(fov_holder?.alpha)
		FOV_ANGLE_CHECK(source, center, return, viewers_list -= source)

#undef FOV_ANGLE_CHECK
