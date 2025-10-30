/mob/proc/overlay_fullscreen(category, type, severity)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		screens[category] = screen = new type()
		screen.category = category
	else if ((!severity || severity == screen.severity) && (!client || screen.screen_loc != "CENTER-7,CENTER-7" || screen.view == client.view))
		// doesn't need to be updated
		return screen

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity
	if (client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.screen += screen

	return screen


/mob/proc/flash_fullscreen(state)
	var/atom/movable/screen/fullscreen/flashholder/screen = screens["flashholder"]

	if(!screen)
		screen = new /atom/movable/screen/fullscreen/flashholder()
		screens["flashholder"] = screen

	if(client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.screen += screen

	flick(state,screen)
	return screen

/mob/proc/update_fullscreen_alpha(category, alpha = 255, time = 1 SECONDS)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen)
		screens -= category
		return
	if (client)
		client.screen -= screen
		animate(screen, alpha = alpha, time = time)
		client.screen += screen

/mob/proc/clear_fullscreen(category, animated = 10)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen_after_animate), screen), animated, TIMER_CLIENT_TIME, flags = ANIMATION_PARALLEL)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreen_after_animate(atom/movable/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		var/atom/movable/screen/fullscreen/screen
		for(var/category in screens)
			screen = screens[category]
			if(screen.should_show_to(src))
				screen.update_for_view(client.view)
				client.screen |= screen
			else
				client.screen -= screen

/atom/movable/screen/fullscreen
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/view = 7
	var/severity = 0
	var/show_when_dead = FALSE

/atom/movable/screen/fullscreen/proc/update_for_view(client_view)
	if (screen_loc == "CENTER-7,CENTER-7" && view != client_view)
		var/list/actualview = getviewsize(client_view)
		view = client_view
		transform = matrix(actualview[1]/FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, actualview[2]/FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/atom/movable/screen/fullscreen/proc/should_show_to(mob/mymob)
	if(!show_when_dead && mymob.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	severity = 0
	. = ..()

/atom/movable/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/painflash
	icon_state = "painflash"
	layer = 20.19
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/love
	icon_state = "lovehud"
	layer = 20.509
	plane = FULLSCREEN_PLANE
	alpha = 0

/atom/movable/screen/fullscreen/love/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	animate(src, alpha = 255, time = 30)

/atom/movable/screen/fullscreen/crit
	icon_state = "passage"
	layer = 20.51
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit/uncon
	icon_state = "uncon"
	layer = 20.511
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/arcyne_eye
	icon_state = "curse1"
	layer = 20.49
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit/dying
	icon = 'icons/roguetown/underworld/charon_servant.dmi'
	icon_state = "servant"
	name = "REAPER"
//	layer = 20.09
	layer = 20.512
	plane = ABOVE_HUD_PLANE
	mouse_opacity = 1
	no_over_text = FALSE

/atom/movable/screen/fullscreen/crit/dying/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		if(L.stat != DEAD)
			if(alert("Are you done living?", "", "Yes", "No") == "Yes")
				L.succumb(reaper = TRUE)

/atom/movable/screen/fullscreen/crit/death
	icon_state = "DD"
	layer = 20.511
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit/cmode
	icon_state = "cmode"
	layer = 20.09
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit/vision
	icon_state = "oxydamageoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/inqvision
	icon_state = "inqvision"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/blackimageoverlay
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/blind
	icon_state = "blind"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/zezuspsyst
	icon_state = "hey"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/curse
	icon_state = "curse"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/flashholder
	icon_state = ""
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/impaired
	icon_state = "impairedoverlay"

/atom/movable/screen/fullscreen/flash
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/atom/movable/screen/fullscreen/flash/static
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/atom/movable/screen/fullscreen/high
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"
	alpha = 80

/atom/movable/screen/fullscreen/purest
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "purest"
	alpha = 100

/atom/movable/screen/fullscreen/fade
	icon = 'icons/mob/roguehudback2.dmi'
	screen_loc = ui_backhudl
	icon_state = "fade"
	layer = 50
	plane = 50
	alpha = 255

/atom/movable/screen/fullscreen/color_vision
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	alpha = 80

/atom/movable/screen/fullscreen/color_vision/green
	color = "#00ff00"

/atom/movable/screen/fullscreen/color_vision/red
	color = "#ff0000"

/atom/movable/screen/fullscreen/color_vision/blue
	color = "#0000ff"

/atom/movable/screen/fullscreen/lighting_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flash"
	transform = matrix(200, 0, 0, 0, 200, 0)
	plane = LIGHTING_PLANE
	blend_mode = BLEND_OVERLAY
	show_when_dead = TRUE

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/lit
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER+21
	color = "#000"

//Provides whiteness in case you don't see lights so everything is still visible
/atom/movable/screen/fullscreen/lighting_backdrop/unlit
	layer = BACKGROUND_LAYER+20

/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_ADD

/// Our sunlight planemaster mashes all of our sunlight overlays together into one
/// The fullscreen then grabs the plane_master with a layer filter, and colours it
/// We do this so the sunlight fullscreen acts as a big lighting object, in our lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/sunlight
	icon_state  = ""
	screen_loc = "CENTER-2:-16, CENTER"
	transform = null
	blend_mode = BLEND_ADD

/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/Initialize()
	. = ..()
	add_filter("sunlight", 1, layering_filter(render_source = SUNLIGHTING_RENDER_TARGET))
	SSoutdoor_effects.sunlighting_planes |= src
	SSoutdoor_effects.transition_sunlight_color(src)
	//color = SSoutdoor_effects.last_color

/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/Destroy()
	. = ..()
	SSoutdoor_effects.sunlighting_planes -= src

/atom/movable/screen/fullscreen/astral_border
	icon = 'icons/mob/screens/vampire.dmi'
	icon_state = "astraloverlay"
	alpha = 0

/atom/movable/screen/fullscreen/deafmute_border
	icon = 'icons/mob/screens/vampire.dmi'
	icon_state = "conversionoverlay"
	alpha = 0

/atom/movable/screen/fullscreen/confusion_border
	icon = 'icons/mob/screens/vampire.dmi'
	icon_state = "conversionoverlay"
	alpha = 0

/atom/movable/screen/fullscreen/black
	icon = 'icons/mob/screens/vampire.dmi'
	screen_loc = "WEST, SOUTH to EAST, NORTH"
	icon_state = "black"
	layer = BLIND_LAYER
	alpha = 0

/atom/movable/screen/fullscreen/white
	icon = 'icons/mob/screens/vampire.dmi'
	screen_loc = "WEST, SOUTH to EAST, NORTH"
	icon_state = "white"
	layer = BLIND_LAYER
	alpha = 0
