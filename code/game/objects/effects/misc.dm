//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = ""
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE

/obj/effect/beam
	name = "beam"
	var/def_zone
	pass_flags = PASSTABLE

/obj/effect/list_container
	name = "list container"

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/effect/overlay/thermite
	name = "thermite"
	desc = ""
	icon = 'icons/effects/fire.dmi'
	icon_state = "2" //what?
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	layer = FLY_LAYER

/obj/effect/supplypod_selector
	icon_state = "supplypod_selector"
	layer = FLY_LAYER

//Makes a tile fully lit no matter what
/obj/effect/fullbright
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_ADD

/obj/effect/abstract/marker
	name = "marker"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	icon_state = "wave3"
	layer = RIPPLE_LAYER

/obj/effect/abstract/marker/Initialize(mapload)
	. = ..()
	GLOB.all_abstract_markers += src

/obj/effect/abstract/marker/Destroy()
	GLOB.all_abstract_markers -= src
	. = ..()

/obj/effect/abstract/marker/at
	name = "active turf marker"


/**
 * Basically, a fake object that emits light.
 *
 * Why is this used sometimes instead of giving atoms light values directly?
 * Because using these, you can have multiple light sources in a single object.
 */
/obj/effect/dummy/lighting_obj
	name = "lighting"
	desc = "Tell a coder if you're seeing this."
	icon_state = "nothing"
	light_system = MOVABLE_LIGHT
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_color = COLOR_WHITE
	blocks_emissive = EMISSIVE_BLOCK_NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/dummy/lighting_obj/Initialize(mapload, range, power, color, duration)
	. = ..()
	if(!isnull(range))
		set_light_range(range)
	if(!isnull(power))
		set_light_power(power)
	if(!isnull(color))
		set_light_color(color)
	if(duration)
		QDEL_IN(src, duration)

/obj/effect/dummy/lighting_obj/moblight
	name = "mob lighting"

/obj/effect/dummy/lighting_obj/moblight/Initialize(mapload, range, power, color, duration)
	. = ..()
	if(!ismob(loc))
		return INITIALIZE_HINT_QDEL

/obj/effect/dummy/lighting_obj/moblight/fire
	name = "mob fire lighting"
	light_color = LIGHT_COLOR_FIRE
	light_range = LIGHT_RANGE_FIRE
	light_power = 2
