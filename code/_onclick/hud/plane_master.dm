/atom/movable/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/atom/movable/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/atom/movable/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/atom/movable/screen/plane_master/proc/backdrop(mob/mymob)

///Things rendered on "openspace"; holes in multi-z
/atom/movable/screen/plane_master/openspace_backdrop
	name = "open space backdrop plane master"
	plane = OPENSPACE_BACKDROP_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/atom/movable/screen/plane_master/openspace
	name = "open space plane master"
	plane = OPENSPACE_PLANE
	appearance_flags = PLANE_MASTER

/atom/movable/screen/plane_master/openspace/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("openspace_blur", 1, gauss_blur_filter(1))

/atom/movable/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/seethrough
	name = "Seethrough"
	plane = SEETHROUGH_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_target = GAME_PLANE_RENDER_TARGET

/atom/movable/screen/plane_master/area
	name = "area plane master"
	plane = AREA_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/massive_obj
	name = "massive object plane master"
	plane = MASSIVE_OBJ_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/ghost
	name = "ghost plane master"
	plane = GHOST_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/point
	name = "point plane master"
	plane = POINT_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/**
 * Plane master handling byond internal blackness
 * vars are set as to replicate behavior when rendering to other planes
 * do not touch this unless you know what you are doing
 */
/atom/movable/screen/plane_master/blackness
	name = "darkness plane master"
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE

/**
 * Plane master handling byond internal blackness
 * vars are set as to replicate behavior when rendering to other planes
 * do not touch this unless you know what you are doing
 */
/atom/movable/screen/plane_master/blackness
	name = "darkness plane master"
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE

/atom/movable/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/*!
 * This system works by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 */
/atom/movable/screen/plane_master/lighting/Initialize()
	. = ..()
	add_filter("emissives", 1, alpha_mask_filter(render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE))
	add_filter("object_lighting", 2, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE))

/atom/movable/screen/plane_master/lighting/backdrop(mob/mymob)
	mymob.overlay_fullscreen("lighting_backdrop_lit", /atom/movable/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /atom/movable/screen/fullscreen/lighting_backdrop/unlit)
	mymob.overlay_fullscreen("sunlight_backdrop",  /atom/movable/screen/fullscreen/lighting_backdrop/sunlight)

/**
 * Things placed on this mask the lighting plane. Doesn't render directly.
 *
 * Gets masked by blocking plane. Use for things that you want blocked by
 * mobs, items, etc.
 */
/atom/movable/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET

/atom/movable/screen/plane_master/emissive/Initialize()
	. = ..()
	add_filter("em_block_masking", 1, color_matrix_filter(GLOB.em_mask_matrix))

///Contains space parallax
/atom/movable/screen/plane_master/parallax
	name = "parallax plane master"
	plane = SPACE_PLANE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = SPACE_PLANE

/atom/movable/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/game_world_fov_hidden
	name = "game world fov hidden plane master"
	plane = GAME_PLANE_FOV_HIDDEN
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/game_world_fov_hidden/Initialize()
	. = ..()
	add_filter("FOV_hidden", 1, alpha_mask_filter(render_source = FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags = MASK_INVERSE))

/atom/movable/screen/plane_master/game_world_above
	name = "above game world plane master"
	plane = GAME_PLANE_UPPER
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/field_of_vision_blocker
	name = "field of vision blocker plane master"
	plane = FIELD_OF_VISION_BLOCKER_PLANE
	render_target = FIELD_OF_VISION_BLOCKER_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = PLANE_MASTER

/atom/movable/screen/plane_master/o_light_visual
	name = "overlight light visual plane master"
	plane = O_LIGHTING_VISUAL_PLANE
	render_target = O_LIGHTING_VISUAL_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/plane_master/fog_cutter
	name = "fog cutting plane master"
	plane = PLANE_FOG_CUTTER
	render_target = FOG_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY

//Contains all weather overlays
/atom/movable/screen/plane_master/weather_overlay
	name = "weather overlay master"
	plane = WEATHER_OVERLAY_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = WEATHER_RENDER_TARGET
	blend_mode = BLEND_MULTIPLY
	//render_relay_plane = null //Used as alpha filter for weather_effect fullscreen

//Contains the weather effect itself
/atom/movable/screen/plane_master/weather_effect
	name = "weather effect plane master"
	plane = WEATHER_EFFECT_PLANE
	blend_mode = BLEND_OVERLAY
	screen_loc = "CENTER-2:-16, CENTER"
	//render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/weather_effect/Initialize()
	. = ..()
	//add_filter("weather_effect", 1, alpha_mask_filter(render_source = WEATHER_RENDER_TARGET))
	SSoutdoor_effects.weather_planes_need_vis |= src

/atom/movable/screen/plane_master/weather_effect/Destroy()
	. = ..()
	SSoutdoor_effects.weather_planes_need_vis -= src

//Contains all sunlight overlays
/atom/movable/screen/plane_master/sunlight
	name = "sunlight plane master"
	plane = SUNLIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = SUNLIGHTING_RENDER_TARGET

/atom/movable/screen/plane_master/leylines
	name = "leyline plane master"
	plane = LEYLINE_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	//render_target = GAME_PLANE_RENDER_TARGET

/atom/movable/screen/plane_master/leylines/backdrop(mob/mymob)
	. = ..()
	alpha = 0
	var/client/client = mymob.client
	if(!client)
		return
	if(!isliving(mymob) && client.toggled_leylines)
		alpha = 255
	else if(HAS_TRAIT(mymob, TRAIT_SEE_LEYLINES))
		alpha = 255

/atom/movable/screen/plane_master/stategy_plane
	name = "stategy plane master"
	plane = STRATEGY_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	//render_target = GAME_PLANE_RENDER_TARGET

/atom/movable/screen/plane_master/stategy_plane/backdrop(mob/mymob)
	. = ..()
	if(!isliving(mymob))
		alpha = 255
	else if(!iscameramob(mymob))
		alpha = 0
	else
		alpha = 255

/atom/movable/screen/plane_master/reflective
	name = "reflective plane master"
	plane = REFLECTION_PLANE
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/reflective/Initialize(mapload)
	. = ..()
	add_filter("motion_blur", 1, motion_blur_filter(y = 0.7))
	add_filter("reflection", 2, alpha_mask_filter(render_source = REFLECTIVE_DISPLACEMENT_PLANE_RENDER_TARGET))

/atom/movable/screen/plane_master/reflective_cutter
	name = "reflective_cutting_plane"
	plane = REFLECTIVE_DISPLACEMENT_PLANE
	render_target = REFLECTIVE_DISPLACEMENT_PLANE_RENDER_TARGET
