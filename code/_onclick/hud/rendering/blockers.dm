/// Contains all shadow cone masks, whose image overrides are displayed only to their respective owners.
/atom/movable/screen/plane_master/field_of_vision_mask
	name = "field of vision mask plane master"
	plane = FIELD_OF_VISION_MASK_PLANE
	render_target = FIELD_OF_VISION_MASK_RENDER_TARGET
	blend_mode = BLEND_OVERLAY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_relay_plane = null

/atom/movable/screen/plane_master/field_of_vision_mask/Initialize()
	. = ..()
	add_filter("vision_cone_blocker", 100, alpha_mask_filter(render_source = FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags = MASK_INVERSE))

/// Used to display the owner through the FoV mask
/atom/movable/screen/plane_master/field_of_vision_blocker
	name = "field of vision blocker plane master"
	plane = FIELD_OF_VISION_BLOCKER_PLANE
	render_target = FIELD_OF_VISION_BLOCKER_RENDER_TARGET
	blend_mode = BLEND_OVERLAY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_relay_plane = null
