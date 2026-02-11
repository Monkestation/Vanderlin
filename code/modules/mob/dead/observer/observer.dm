GLOBAL_LIST_EMPTY(ghost_images_default) //this is a list of the default (non-accessorized, non-dir) images of the ghosts themselves
GLOBAL_LIST_EMPTY(ghost_images_simple) //this is a list of all ghost images as the simple white ghost

GLOBAL_VAR_INIT(observer_default_invisibility, INVISIBILITY_OBSERVER)

GLOBAL_LIST_INIT(ghost_verbs, list(
	/mob/dead/observer/verb/ghost_upward,
	/mob/dead/observer/verb/ghost_downward,
	/mob/dead/observer/proc/reenter_corpse
))

/mob/dead/observer
	name = "ghost"
	desc = "" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	plane = GHOST_PLANE
	stat = DEAD
	density = FALSE
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	invisibility = INVISIBILITY_OBSERVER
	hud_type = /datum/hud/ghost
	movement_type = GROUND | FLYING
	var/draw_icon = FALSE
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage_default = null //this mobs ghost image without accessories and dirs
	var/image/ghostimage_simple = null //this mob with the simple white ghost sprite
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/mob/observetarget = null	//The target mob that the ghost is observing. Used as a reference in logout()
	var/ghost_hud_enabled = 1 //did this ghost disable the on-screen HUD?
	var/data_huds_on = 0 //Are data HUDs currently enabled?
	var/health_scan = FALSE //Are health scans currently enabled?
	var/gas_scan = FALSE //Are gas scans currently enabled?
	var/list/datahuds = list() //list of data HUDs shown to ghosts.
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	/// The POI we're orbiting
	var/orbiting_ref

	//These variables store hair data if the ghost originates from a species with head and/or facial hair.
	var/hairstyle
	var/hair_color
	var/mutable_appearance/hair_overlay
	var/facial_hairstyle
	var/facial_hair_color
	var/mutable_appearance/facial_hair_overlay
	var/ears
	var/mutable_appearance/ears_overlay

	var/updatedir = 1						//Do we have to update our dir as the ghost moves around?
	var/lastsetting = null	//Stores the last setting that ghost_others was set to, for a little more efficiency when we update ghost images. Null means no update is necessary

	//We store copies of the ghost display preferences locally so they can be referred to even if no client is connected.
	//If there's a bug with changing your ghost settings, it's probably related to this.
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	// Used for displaying in ghost chat, without changing the actual name
	// of the mob
	var/deadchat_name
	var/ghostize_time = 0
	var/isinhell
	var/last_helld = 0

/mob/dead/observer/rogue
//	see_invisible = SEE_INVISIBLE_LIVING
	sight = 0
	see_in_dark = 2
	var/next_gmove
	var/misting = 0
	draw_icon = TRUE
	invisibility = INVISIBILITY_GHOST
	see_invisible = SEE_INVISIBLE_GHOST
	icon_state = "ghost1"

/mob/dead/observer/rogue/nodraw
	draw_icon = FALSE
	icon = 'icons/roguetown/mob/misc.dmi'
	icon_state = "ghost"
	alpha = 100

/mob/dead/observer/rogue/Move(n, direct)
	if(world.time < next_gmove)
		return
	next_gmove = world.time + 2
	var/turf/T = n

	setDir(direct)

	if(!loc.Exit(src, T))
		return

	if(istype(T))
		if(T.density)
			return
		for(var/obj/item/reagent_containers/powder/salt/S in T)
//			go2hell()
//			next_gmove = world.time + 30
			return
	. = ..()

/mob/dead/observer/screye
//	see_invisible = SEE_INVISIBLE_LIVING
	sight = 0
	see_in_dark = 0
	hud_type = /datum/hud/obs
	can_reenter_corpse = FALSE
	invisibility = INVISIBILITY_GHOST
	see_invisible = SEE_INVISIBLE_GHOST

/mob/dead/observer/screye/blackmirror
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 100

/mob/dead/observer/screye/Move(n, direct)
	return

/mob/dead/observer/profane // Ghost type for souls trapped by the profane dagger. They can't move, but can talk to the dagger's wielder and other trapped souls.
	sight = 0
	invisibility = INVISIBILITY_GHOST
	see_invisible = SEE_INVISIBLE_GHOST

/mob/dead/observer/profane/Move(n, direct)
	return

/mob/dead/observer/profane/canZMove(direction, turf/target)
	return

/mob/dead/observer/Initialize()
	set_invisibility(GLOB.observer_default_invisibility)

	add_verb(src, /mob/dead/observer/proc/tray_view)

	if(icon_state in GLOB.ghost_forms_with_directions_list)
		ghostimage_default = image(src.icon,src,src.icon_state + "")
	else
		ghostimage_default = image(src.icon,src,src.icon_state)
	ghostimage_default.override = TRUE
	GLOB.ghost_images_default |= ghostimage_default

	ghostimage_simple = image(src.icon,src,"")
	ghostimage_simple.override = TRUE
	GLOB.ghost_images_simple |= ghostimage_simple

	updateallghostimages()

	var/turf/T
	var/mob/body = loc
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		if(!T)
			if(istype(body, /mob/living/brain))
				var/obj/Y = body.loc
				T = get_turf(Y)

		gender = body.gender
		if(body.mind && body.mind.name)
			if(body.mind.ghostname)
				name = body.mind.ghostname
			else
				name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.
		mind?.current_ghost = src

		set_suicide(body.suiciding) // Transfer whether they committed suicide.

		if(draw_icon)
			if(ishuman(body))
				var/image/MA = new(body)
				MA.transform = null //so we are standing
				appearance = MA
				plane = GHOST_PLANE
				pixel_x = base_pixel_x
				pixel_y = base_pixel_y
				invisibility = INVISIBILITY_OBSERVER
				alpha = 100

	if(!T)
		T = SSmapping.get_station_center()

	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	real_name = name

	if(!fun_verbs)
		add_verb(src, /mob/dead/observer/verb/boo)
		add_verb(src, /mob/dead/observer/verb/possess)

	GLOB.dead_mob_list += src

	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	. = ..()

	if(!istype(src, /mob/dead/observer/rogue/arcaneeye))
		if(!istype(src, /mob/dead/observer/screye))
			add_verb(src, GLOB.ghost_verbs)
			to_chat(src, span_danger("Click the <b>SKULL</b> on the left of your HUD to respawn."))

	grant_all_languages()

//	show_data_huds()
//	data_huds_on = 1

/mob/dead/observer/narsie_act()
	var/old_color = color
	color = "#960000"
	animate(src, color = old_color, time = 10, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 10)

/mob/dead/observer/Destroy()
	mind?.current_ghost = null

	GLOB.ghost_images_default -= ghostimage_default
	QDEL_NULL(ghostimage_default)

	GLOB.ghost_images_simple -= ghostimage_simple
	QDEL_NULL(ghostimage_simple)

	updateallghostimages()

	STOP_PROCESSING(SShaunting, src)

	return ..()

/*
 * Increase the brightness of a color by calculating the average distance between the R, G and B values,
 * and maximum brightness, then adding 30% of that average to R, G and B.
 *
 * I'll make this proc global and move it to its own file in a future update. |- Ricotez
 */
/mob/proc/brighten_color(input_color)
	var/r_val
	var/b_val
	var/g_val
	var/color_format = length(input_color)
	if(color_format == 3)
		r_val = hex2num(copytext(input_color, 1, 2))*16
		g_val = hex2num(copytext(input_color, 2, 3))*16
		b_val = hex2num(copytext(input_color, 3, 0))*16
	else if(color_format == 6)
		r_val = hex2num(copytext(input_color, 1, 3))
		g_val = hex2num(copytext(input_color, 3, 5))
		b_val = hex2num(copytext(input_color, 5, 0))
	else
		return 0 //If the color format is not 3 or 6, you're using an unexpected way to represent a color.

	r_val += (255 - r_val) * 0.4
	if(r_val > 255)
		r_val = 255
	g_val += (255 - g_val) * 0.4
	if(g_val > 255)
		g_val = 255
	b_val += (255 - b_val) * 0.4
	if(b_val > 255)
		b_val = 255

	return num2hex(r_val, 2) + num2hex(g_val, 2) + num2hex(b_val, 2)

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(can_reenter_corpse = 1, force_respawn = FALSE, drawskip)
	if(key)
		stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
		if(client)
			if(client.holder)
				var/mob/dead/observer/ghost = new(src)	// Transfer safety to observer spawning proc.
				SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
				ghost.can_reenter_corpse = can_reenter_corpse
				ghost.ghostize_time = world.time
				ghost.key = key
				return ghost
//		if(client)
//			var/S = sound('sound/ambience/creepywind.ogg', repeat = 1, wait = 0, volume = client.prefs.musicvol, channel = CHANNEL_MUSIC)
//			play_priomusic(S)
		var/mob/dead/observer/rogue/ghost	// Transfer safety to observer spawning proc.
		if(drawskip)
			ghost = new /mob/dead/observer/rogue/nodraw(src)
		else
			ghost = new(src)
		ghost.ghostize_time = world.time
		var/bnw = TRUE
		if(client)
			if(client.holder)
				if(check_rights_for(client,R_WATCH))
					bnw = FALSE
		SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.key = key
		if(!bnw)
			return ghost
		ghost.add_client_colour(/datum/client_colour/monochrome)
		return ghost

/mob/living/carbon/human/ghostize(can_reenter_corpse = 1, force_respawn = FALSE, drawskip = FALSE)
	if(mind)
		if(mind.has_antag_datum(/datum/antagonist/zombie))
			if(force_respawn)
				mind.remove_antag_datum(/datum/antagonist/zombie)
				return ..()
			// if(!Z.revived)
			// 	if(!(world.time % 5))
			// 		to_chat(src, "<span class='warning'>I'm preparing to walk again.</span>")
			// 	return
	return ..()

/mob/proc/scry_ghost()
	if(key)
		stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
		var/mob/dead/observer/screye/ghost = new(src)	// Transfer safety to observer spawning proc.
		ghost.ghostize_time = world.time
		SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
		ghost.can_reenter_corpse = TRUE
		ghost.key = key
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = ""
	set hidden = 1
	if(!usr.client.holder)
		return
	if(stat != DEAD)
		succumb()
	if(stat == DEAD)
		ghostize(1)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
		if(response != "Ghost")
			return	//didn't want to ghost after-all
		ghostize(0)						//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3

/mob/camera/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = ""
	set hidden = 1
	if(!usr.client.holder)
		return
	var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
	if(response != "Ghost")
		return
	ghostize(0)

/mob/dead/observer/Move(NewLoc, direct)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	var/oldloc = loc

	if(NewLoc)
		forceMove(NewLoc)
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	Moved(oldloc, direct)

/mob/dead/observer/forceMove(atom/destination)
	abstract_move(destination) // move like the wind
	return TRUE

/mob/dead/observer/proc/reenter_corpse(forced = FALSE)
	set category = "Spirit"
	set name = "Re-enter Corpse"
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, "<span class='warning'>I have no body.</span>")
		return
	if(!forced && !can_reenter_corpse)
		to_chat(src, "<span class='warning'>I cannot re-enter my body.</span>")
		return
	if(istype(src, /mob/dead/observer/profane))
		to_chat(src, "<span class='warning'>My spirit has been snatched away by Graggar!</span>")
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, "<span class='warning'>Another consciousness is in your body... it is resisting you.</span>")
		return

	remove_client_colour(/datum/client_colour/monochrome)
	client.view_size.setDefault(getScreenSize())
	mind.current_ghost = null
	mind.current.ckey = ckey(key)
	return TRUE


/mob/dead/observer/returntolobby(modifier as num)
	set name = "{RETURN TO LOBBY}"
	set category = "Preferences.Options"
	set hidden = 1
	if (CONFIG_GET(flag/norespawn))
		return
	if ((stat != DEAD || !( SSticker )))
		to_chat(usr, "<span class='boldnotice'>I must be dead to use this!</span>")
		return

//	if(mind?.current && (world.time < mind.current.timeofdeath + RESPAWNTIME))
//		to_chat(usr, "<span class='warning'>I can return in [mind.current.timeofdeath + RESPAWNTIME - world.time].</span>")
//		return

	if(key)
		if(modifier)
			GLOB.respawntimes[key] = world.time + modifier
		else
			GLOB.respawntimes[key] = world.time

	log_game("[key_name(usr)] used abandon mob.")

	to_chat(src, "<span class='info'>Returned to lobby successfully.</span>")

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
//	M.Login()	//wat
	return


/mob/dead/observer/verb/stay_dead()
	set category = "Spirit"
	set name = "Do Not Resuscitate"
	set hidden = 1
	if(!check_rights(0))
		return
	if(!client)
		return
	if(!can_reenter_corpse)
		to_chat(usr, "<span class='warning'>You're already stuck out of your body!</span>")
		return FALSE

	var/response = alert(src, "Are you sure you want to prevent (almost) all means of resuscitation? This cannot be undone. ","Are you sure you want to stay dead?","DNR","Save Me")
	if(response != "DNR")
		return

	can_reenter_corpse = FALSE
	to_chat(src, "<span class='boldnotice'>I can no longer be brought back into your body.</span>")
	return TRUE

/mob/dead/observer/proc/notify_cloning(message, sound, atom/source, flashwindow = TRUE)
	if(flashwindow)
		window_flash(client)
	if(message)
		to_chat(src, "<span class='ghostalert'>[message]</span>")
		if(source)
			var/atom/movable/screen/alert/A = throw_alert("[REF(source)]_notify_cloning", /atom/movable/screen/alert/notify_cloning)
			if(A)
				if(client && client.prefs && client.prefs.UI_style)
					A.icon = ui_style2icon(client.prefs.UI_style)
				A.desc = message
				var/old_layer = source.layer
				var/old_plane = source.plane
				source.plane = FLOAT_PLANE
				A.add_overlay(source)
				source.layer = old_layer
				source.plane = old_plane
	to_chat(src, "<span class='ghostalert'><a href=?src=[REF(src)];reenter=1>(Click to re-enter)</a></span>")
	if(sound)
		SEND_SOUND(src, sound(sound))

/mob/dead/observer/verb/follow()
	set category = "Spirit"
	set name = "Orbit" // "Haunt"
	set desc = ""
	set hidden = 1
	var/list/mobs
	if(client.holder)
		if(check_rights(R_WATCH,0))
			mobs = getpois(mobs_only=1,skip_mindless=1)
		else
			mobs = gethaunt()
	else
		mobs = gethaunt()

	var/input = input("Who?!", "Haunt", null, null) as null|anything in mobs
	var/mob/target = mobs[input]
	ManualFollow(target)


#define HAUNTTIME (10 MINUTES)

/mob/dead/observer
	var/hauntexpire
	var/skipprocess = FALSE
/*
/mob/dead/observer/proc/jumptorandom()
	var/mob/living/carbon/human/target = pick(gethaunt())
	if(myfriends)
		for(var/A in myfriends)
			if(target.real_name && A == target.real_name)
				to_chat(src, "<span class='danger'>I can no longer haunt that person.</span>")
				ManualFollow(target)
				skipprocess = FALSE
				return TRUE
	if(attackedme)
		for(var/A in attackedme)
			if(target.real_name && A == target.real_name)
				to_chat(src, "<span class='danger'>I can no longer haunt that person.</span>")
				hauntexpire = world.time
				ManualFollow(target)
				skipprocess = FALSE
				return FALSE
	hauntexpire = null
	to_chat(src, "<span class='danger'>There is nobody left to haunt.</span>")
	if(!reenter_corpse())
		returntolobby(RESPAWNTIME*-1)*/

/datum/mind
	var/list/attackedme = list()
	var/list/myfriends = list()

/mob/dead/observer/proc/gethaunt()
	var/list/mobs = sortmobs()
	var/list/namecounts = list()
	var/list/pois = list()
	for(var/mob/M in mobs)
		if((!M.mind || !M.ckey))
			continue
		if(M.client && M.client.holder && M.client.holder.fakekey) //stealthmins
			continue
		var/friendorfoe
		if(mind)
			if(mind.attackedme)
				for(var/A in mind.attackedme)
					if(M.real_name && A == M.real_name)
						if(mind.attackedme[A])
							if(world.time < mind.attackedme[A] + HAUNTTIME)
								friendorfoe = TRUE
			if(mind.myfriends)
				for(var/A in mind.myfriends)
					if(M.real_name && A == M.real_name)
						friendorfoe = TRUE
		if(!friendorfoe)
			continue
		var/name = avoid_assoc_duplicate_keys(M.name, namecounts)

		if(M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if(M.stat == DEAD)
			continue
/*			if(isobserver(M))
				name += " \[ghost\]"
			else
				name += " \[dead\]"*/
		pois[name] = M

	return pois

#undef HAUNTTIME

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if (!istype(target))
		return

	var/list/icon_dimensions = get_icon_dimensions(target.icon)
	var/orbitsize = (icon_dimensions["width"] + icon_dimensions["height"]) * 0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/orbit()
	setDir(2)//reset dir so the right directional sprites show up
	return ..()

/mob/dead/observer/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	//restart our floating animation after orbit is done.
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
//	animate(src, pixel_y = 2, time = 10, loop = -1)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Spirit"
	set name = "Jump to Mob"
	set desc = ""
	set hidden = 1

	if(!check_rights(0))
		return

	if(isobserver(usr))
		var/list/mobs = getpois(mobs_only = TRUE)
		var/target = browser_input_list(usr, "Mob to jump to", "Jump to Mob", mobs)

		if(!target)
			return

		var/mob/M = mobs[target]
		if(!M)
			return

		var/mob/A = src
		var/turf/T = get_turf(M)

		if(T && isturf(T))
			A.forceMove(T)
		else
			to_chat(A, span_warning("This mob is not located in the game world."))

/mob/dead/observer/verb/change_view_range()
	set category = "Spirit"
	set name = "View Range"
	set desc = "Change your view range."

	var/max_view = GHOST_MAX_VIEW_RANGE
	if(client.view_size.getView() == client.view_size.default)
		var/list/views = list()
		for(var/i in 7 to max_view)
			views |= i
		var/new_view = browser_input_list(src, "Choose your new view", "EYES OF NOC", views)
		if(new_view)
			client.view_size.setTo(clamp(new_view, 7, max_view) - 7)
	else
		client.view_size.resetToDefault()

/mob/dead/observer/verb/add_view_range(input as num)
	set name = "Add View Range"
	set hidden = TRUE
	var/max_view = GHOST_MAX_VIEW_RANGE
	if(input)
		client.rescale_view(input, 15, (max_view*2)+1)

/mob/dead/observer/verb/boo()
	set category = "Spirit"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time)
		return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = 1
	to_chat(src, "<span class='danger'>I am dead! I have no mind to store memory!</span>")

/mob/dead/observer/add_memory()
	set hidden = 1
	to_chat(src, "<span class='danger'>I am dead! I have no mind to store memory!</span>")

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = ""
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	ghostvision = !(ghostvision)
	update_sight()
	to_chat(usr, "<span class='boldnotice'>I [(ghostvision?"now":"no longer")] have ghost vision.</span>")

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	update_sight()

/mob/dead/observer/update_sight()
	if(client)
		ghost_others = client.prefs.ghost_others //A quick update just in case this setting was changed right before calling the proc

	if (!ghostvision)
		see_invisible = SEE_INVISIBLE_LIVING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER


	updateghostimages()
	..()

/proc/updateallghostimages()
	listclearnulls(GLOB.ghost_images_default)
	listclearnulls(GLOB.ghost_images_simple)

	for (var/mob/dead/observer/O in GLOB.player_list)
		O.updateghostimages()

/mob/dead/observer/proc/horde_respawn()
	if(istype(src, /mob/dead/observer/rogue/arcaneeye))
		return
	var/bt = world.time
	SEND_SOUND(src, sound('sound/misc/notice (2).ogg'))
	if(alert(src, "You have been summoned to destroy Vanderlin!", "Join the Horde", "Yes", "No") == "Yes")
		if(world.time > bt + 5 MINUTES)
			to_chat(src, "<span class='warning'>Too late.</span>")
			return FALSE
		returntolobby(RESPAWNTIME*-1)


/mob/dead/observer/proc/updateghostimages()
	if (!client)
		return

	if(lastsetting)
		switch(lastsetting) //checks the setting we last came from, for a little efficiency so we don't try to delete images from the client that it doesn't have anyway
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images -= GLOB.ghost_images_default
			if(GHOST_OTHERS_SIMPLE)
				client.images -= GLOB.ghost_images_simple
	lastsetting = client.prefs.ghost_others
	if(!ghostvision)
		return
	if(client.prefs.ghost_others != GHOST_OTHERS_THEIR_SETTING)
		switch(client.prefs.ghost_others)
			if(GHOST_OTHERS_DEFAULT_SPRITE)
				client.images |= (GLOB.ghost_images_default-ghostimage_default)
			if(GHOST_OTHERS_SIMPLE)
				client.images |= (GLOB.ghost_images_simple-ghostimage_simple)

/mob/dead/observer/verb/possess()
	set category = "Spirit"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	if(!check_rights(R_ADMIN))
		return FALSE
	var/list/possessible = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(istype(L,/mob/living/carbon/human/dummy) || !get_turf(L)) //Haha no.
			continue
		if(!(L in GLOB.player_list) && !L.mind)
			possessible += L

	var/mob/living/target = input("Your new life begins today!", "Possess Mob", null, null) as null|anything in sortNames(possessible)

	if(!target)
		return FALSE

	if(can_reenter_corpse && mind && mind.current)
		if(alert(src, "Your soul is still tied to your former life as [mind.current.name], if you go forward there is no going back to that life. Are you sure you wish to continue?", "Move On", "Yes", "No") == "No")
			return FALSE
	if(target.key)
		to_chat(src, "<span class='warning'>Someone has taken this body while you were choosing!</span>")
		return FALSE

	target.key = key
	target.faction = list(FACTION_NEUTRAL)
	return TRUE

//this is a mob verb instead of atom for performance reasons
//see /mob/verb/examinate() in mob.dm for more info
//overridden here and in /mob/living for different point span classes and sanity checks
/mob/dead/observer/pointed(atom/A as mob|obj|turf in view(client.view, src))
	set category = "Spirit"
	if(!..())
		return FALSE
	usr.visible_message("<span class='deadsay'><b>[src]</b> points to [A].</span>")
	return TRUE

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over)
		return
	if (isobserver(usr) && usr.client.holder && (isliving(over) || iscameramob(over)) )
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
				return
		if(href_list["x"] && href_list["y"] && href_list["z"])
			var/tx = text2num(href_list["x"])
			var/ty = text2num(href_list["y"])
			var/tz = text2num(href_list["z"])
			var/turf/target = locate(tx, ty, tz)
			if(istype(target))
				forceMove(target)
				return
		if(href_list["reenter"])
			reenter_corpse()
			return

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return

/mob/dead/observer/proc/show_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.add_hud_to(src)

/mob/dead/observer/proc/remove_data_huds()
	for(var/hudtype in datahuds)
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		H.remove_hud_from(src)

/mob/dead/observer/verb/toggle_data_huds()
	set name = "Toggle Sec/Med/Diag HUD"
	set desc = ""
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	if(data_huds_on) //remove old huds
		remove_data_huds()
		to_chat(src, "<span class='notice'>Data HUDs disabled.</span>")
		data_huds_on = 0
	else
		show_data_huds()
		to_chat(src, "<span class='notice'>Data HUDs enabled.</span>")
		data_huds_on = 1

/mob/dead/observer/verb/toggle_health_scan()
	set name = "Toggle Health Scan"
	set desc = ""
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	if(health_scan) //remove old huds
		to_chat(src, "<span class='notice'>Health scan disabled.</span>")
		health_scan = FALSE
	else
		to_chat(src, "<span class='notice'>Health scan enabled.</span>")
		health_scan = TRUE

/mob/dead/observer/verb/toggle_gas_scan()
	set name = "Toggle Gas Scan"
	set desc = ""
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	if(gas_scan)
		to_chat(src, "<span class='notice'>Gas scan disabled.</span>")
		gas_scan = FALSE
	else
		to_chat(src, "<span class='notice'>Gas scan enabled.</span>")
		gas_scan = TRUE

/mob/dead/observer/verb/restore_ghost_appearance()
	set name = "Restore Ghost Character"
	set desc = "Sets your deadchat name and ghost appearance to your \
		roundstart character."
	set category = "Spirit"
	set hidden = 1
	if(!check_rights(0))
		return
	set_ghost_appearance()
	if(client && client.prefs)
		deadchat_name = client.prefs.real_name
		mind.ghostname = client.prefs.real_name
		name = client.prefs.real_name

/mob/dead/observer/proc/set_ghost_appearance()
	if(!client?.prefs)
		return

	if(client?.holder && (type == /mob/dead/observer)) //subtypes begone!
		icon_state = client?.prefs.admin_ghost_icon

	client.prefs.apply_character_randomization_prefs()

/mob/dead/observer/can_perform_action(atom/movable/target, action_bitflags)
	return IsAdminGhost(usr)

/mob/dead/observer/is_literate()
	return TRUE

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if("icon")
			ghostimage_default.icon = icon
			ghostimage_simple.icon = icon
		if("icon_state")
			ghostimage_default.icon_state = icon_state
			ghostimage_simple.icon_state = icon_state
		if("fun_verbs")
			if(fun_verbs)
				add_verb(src, /mob/dead/observer/verb/boo)
				add_verb(src, /mob/dead/observer/verb/possess)
			else
				add_verb(src, /mob/dead/observer/verb/boo)
				add_verb(src, /mob/dead/observer/verb/possess)

/mob/dead/observer/reset_perspective(atom/A)
	if(client)
		if(ismob(client.eye) && (client.eye != src))
			var/mob/target = client.eye
			observetarget = null
			if(target.observers)
				target.observers -= src
				UNSETEMPTY(target.observers)
	if(..())
		if(hud_used)
			client.screen = list()
			hud_used.show_hud(hud_used.hud_version)

/mob/dead/observer/verb/observe()
	set name = "Observe"
	set category = "OOC"
	set hidden = 1
	if(!check_rights(0))
		return
	var/list/creatures = getpois()

	reset_perspective(null)

	var/eye_name = null

	eye_name = input("Please, select a player!", "Observe", null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]
	//Istype so we filter out points of interest that are not mobs
	if(client && mob_eye && istype(mob_eye))
		client.eye = mob_eye
		if(mob_eye.hud_used)
			client.screen = list()
			LAZYINITLIST(mob_eye.observers)
			mob_eye.observers |= src
			mob_eye.hud_used.show_hud(mob_eye.hud_used.hud_version, src)
			observetarget = mob_eye

/mob/dead/observer/CtrlShiftClick(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		change_mob_type( /mob/living/carbon/human , null, null, TRUE) //always delmob, ghosts shouldn't be left lingering

/mob/dead/observer/examine(mob/user)
	. = ..()
	if(!invisibility)
		. += "It seems extremely obvious."

/mob/dead/observer/proc/set_invisibility(value)
	invisibility = value
	if(!value)
		set_light(1, 1, 2)
	else
		set_light(0, 0, 0)

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == "invisibility")
		set_invisibility(invisibility) // updates light

/proc/set_observer_default_invisibility(amount, message=null)
	for(var/mob/dead/observer/G in GLOB.player_list)
		G.set_invisibility(amount)
		if(message)
			to_chat(G, message)
	GLOB.observer_default_invisibility = amount

/mob/dead/observer/proc/tray_view()
	set category = "Spirit"
	set name = "T-ray view"
	set desc = ""
	set hidden = 1
	if(!check_rights(0))
		return
	var/static/t_ray_view = FALSE
	t_ray_view = !t_ray_view

	var/list/t_ray_images = list()
	var/static/list/stored_t_ray_images = list()
	for(var/obj/O in orange(client.view, src) )
		if(O.level != 1)
			continue

		if(O.invisibility == INVISIBILITY_MAXIMUM)
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	stored_t_ray_images += t_ray_images
	if(t_ray_images.len)
		if(t_ray_view)
			client.images += t_ray_images
		else
			client.images -= stored_t_ray_images
