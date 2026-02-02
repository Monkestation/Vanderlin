#define LOCKPICK_MOUSEUP 0
#define LOCKPICK_MOUSEDOWN 1

//user is told its picking
/mob/living/proc/try_pick(obj/P, obj/item/L, list/obj/lockpicks, list/obj/wedges, difficulty)
	if(!isobj(P))
		return FALSE

	if(P.being_picked)
		to_chat(src, span_notice("Someone else is picking \the [P]."))
		return FALSE

	if(!P.can_be_picked())
		to_chat(src, span_notice("I cannot lockpick \the [P]."))
		return FALSE

	var/datum/lock/key/KL = P.lock
	if(!KL.locked)
		to_chat(src, span_notice("\The [P] is unlocked."))
		return FALSE

	var/obj/item/the_wedge = get_inactive_held_item()

	if(!is_type_in_list(the_wedge, wedges))
		to_chat(src, span_notice("I need a wedge in order to lockpick \the [P]."))
		return FALSE

	client.spawn_lockpicking_UI(P, src, L, the_wedge, difficulty, KL.get_string_difficulty(), get_skill_level(/datum/skill/misc/lockpicking))
	visible_message(span_warning("[src] starts to pick the lock of \the [P]!"), span_notice("I start to pick the lock of \the [P]..."))
	return TRUE

//obj is told its picked, theoretically can be used for any objects
/obj/proc/picked(mob/living/user, obj/lockpick_used, skill_level, difficulty)
	finish_lockpicking(user)

	//difficulty goes from 1 to 6, hence 6 - difficulty
	var/break_prob = clamp(60 - (skill_level * 10) + (6 - difficulty * 10), 0, 100)
	if(prob(break_prob))
		to_chat(user, span_notice("My \the [lockpick_used] broke!"))
		playsound(src, 'sound/items/LPBreak.ogg', min(100 - (15 * skill_level) + (10 * 6 - difficulty), 100), extrarange = SILENCED_SOUND_EXTRARANGE)
		qdel(lockpick_used)

	if(user.client?.prefs.showrolls)
		to_chat(user, span_notice("The chance to break was [break_prob]%!"))

	if(lock)
		lock.locked = FALSE
		lock.tampered = TRUE

	playsound(src, 'sound/items/LPWin.ogg', min(100 - (15 * skill_level) + (10 * 6 - difficulty), 100), extrarange = SILENCED_SOUND_EXTRARANGE)

	var/amt2raise = (user.STAINT / 2) * (20 / difficulty)
	var/boon = user.get_learning_boon(/datum/skill/misc/lockpicking)
	user.adjust_experience(/datum/skill/misc/lockpicking, amt2raise * boon)
	return TRUE

/obj/proc/finish_lockpicking(mob/living/user)
	if(!user)
		return FALSE
	user.visible_message(span_warning("[user] picks the lock of \the [src]!"), span_notice("I finish picking the lock of \the [src]."))
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LOCKS_PICKED)
	being_picked = FALSE
	return TRUE

/obj/proc/can_be_picked()
	if(!lock_check(TRUE))
		return FALSE
	var/datum/lock/key/KL = lock
	return KL.pickable

//ui is spawned, users screen is updated
/client/proc/spawn_lockpicking_UI(obj/lock, mob/living/user, obj/lockpick, obj/wedge, difficulty, shown_d, skill_level) //potentially different sprites for locks and picks, put here
	shown_d = uppertext(shown_d) //the haters one this one

	var/atom/movable/screen/movable/snap/lockpicking/imagery = new
	imagery.picking_object = lock
	imagery.picker = user
	imagery.sweet_spot = rand(1,179)
	imagery.clicker = src
	imagery.difficulty = difficulty
	imagery.maptext += MAPTEXT("<br><div align='center'><font color='#f0dd5f'> [shown_d] LOCK<br></div>")
	imagery.maptext += MAPTEXT("<br><div align='center'><font color='#f0dd5f'>       \[R Click) Exit\]</font></div><br>")
	imagery.maptext_width = 100
	imagery.maptext_x = 253
	imagery.maptext_y = 150
	imagery.the_lockpick = lockpick
	imagery.the_wedge = wedge
	imagery.skill_level = skill_level
	lock.being_picked = TRUE

	playsound(user, 'sound/items/LPstart.ogg', min(100 - (15 * skill_level) + (10 * 6 - difficulty), 100), extrarange = SILENCED_SOUND_EXTRARANGE)

	screen += imagery
	imagery.autofire_on(imagery.clicker)

//the lockpicking UI, everything contained on this

/atom/movable/screen/movable/snap/lockpicking
	name = "lock"
	icon = 'icons/hud/lockpicking.dmi'
	icon_state = "base"
	screen_loc = "1,1"
	locked = TRUE
	plane = HUD_PLANE
	layer = 1
	mouse_drag_pointer = null

	///Angle of the lock itself. Determined by holding down mouse1.
	var/lock_angle = 0
	///Angle of the wedge. Determined by the lock.
	var/wedge_angle = 0
	///Angle of the lockpick. Determined by mouse coordinates.
	var/pick_angle = 0
	///The angle of the sweet spot.
	var/sweet_spot = 0
	//How far are we, in angular units, are we from the sweet spot?
	var/angle_distance
	///Difficulty of the lock. Smaller is harder.
	var/difficulty
	///the mobs skill level at the start
	var/skill_level = 1
	///client clicking
	var/client/clicker
	//state of the mouse
	var/mouse_status = LOCKPICK_MOUSEUP

	//the lockpick being used
	var/the_lockpick
	//the wedge being used
	var/the_wedge

	var/obj/picking_object

	///Person picking the lock
	var/mob/picker

	///used for completed lock
	var/frozen = FALSE

	var/playing_lock_sound = FALSE

	///the cooldown for break checking
	var/break_checking_cooldown = 0

	///sprite tomfoolery
	var/image/linked_background
	var/obj/linked_lock
	var/obj/linked_pick
	var/obj/linked_wedge

/atom/movable/screen/movable/snap/lockpicking/Initialize()
	. = ..()
	QDEL_NULL(linked_lock)
	QDEL_NULL(linked_pick)
	QDEL_NULL(linked_wedge)

	if(!linked_background)
		linked_background = new /image()
		linked_background.icon_state = "dim"
		linked_background.layer = 0.9
		add_overlay(linked_background)

	linked_lock = new(src)
	linked_lock.icon = initial(icon)
	linked_lock.icon_state = "lock"
	linked_lock.plane = FLOAT_PLANE
	linked_lock.layer = 2
	linked_lock.mouse_opacity = 0
	vis_contents += linked_lock

	linked_wedge = new(src)
	linked_wedge.icon = initial(icon)
	linked_wedge.icon_state = "wedge"
	linked_wedge.plane = FLOAT_PLANE + 2
	linked_wedge.layer = 4
	linked_wedge.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_contents += linked_wedge

	linked_pick = new(src)
	linked_pick.icon = initial(icon)
	linked_pick.icon_state = "pick"
	linked_pick.plane = FLOAT_PLANE + 1
	linked_pick.layer = 3
	linked_pick.pixel_y = linked_pick.base_pixel_y + 6
	linked_pick.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_contents += linked_pick

/atom/movable/screen/movable/snap/lockpicking/MouseMove(location, control, params)
	. = ..()

	if(!frozen && linked_pick)
		var/list/modifiers = params2list(params)

		var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X)) - 240
		var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y)) - 240

		icon_y = max(1,icon_y)

		pick_angle = ATAN2(icon_x,icon_y)

		pick_angle = clamp(pick_angle,1,179)

		var/matrix/M = matrix()
		M.Turn(90 - pick_angle)
		linked_pick.transform = M

/atom/movable/screen/movable/snap/lockpicking/proc/autofire_on(client/usercli)
	SIGNAL_HANDLER

	clicker = usercli
	RegisterSignal(clicker, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down))
	RegisterSignal(clicker, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up))
	RegisterSignal(picker, COMSIG_MOVABLE_MOVED, PROC_REF(close_lockpick))
	RegisterSignal(picker, COMSIG_PARENT_EXAMINE, PROC_REF(mob_detection))

	//checks both for each just incase they switch hands for no reason mid lockpick
	var/obj/item/held_lockmain = picker.get_active_held_item()

	var/obj/item/held_wedgemain = picker.get_inactive_held_item()

	if(istype(held_lockmain, the_lockpick))
		RegisterSignal(the_lockpick, COMSIG_ITEM_DROPPED, PROC_REF(close_lockpick))
	if(istype(held_wedgemain, the_wedge))
		RegisterSignal(the_wedge, COMSIG_ITEM_DROPPED, PROC_REF(close_lockpick))

	START_PROCESSING(SSfastprocess, src)

/atom/movable/screen/movable/snap/lockpicking/proc/on_mouse_down(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //right click to close
		close_lockpick()
		return
	if(source.mob.in_throw_mode)
		return
	if(!isturf(source.mob.loc))
		return
	if(get_dist(source.mob, _target) < 2) //Adjacent clicking.
		return

	if(SEND_SIGNAL(src, COMSIG_LOCKPICK_ONMOUSEDOWN, source, _target, location, control, params) & COMPONENT_LOCKPICK_ONMOUSEDOWN_BYPASS)
		return

	source.click_intercept_time = world.time //From this point onwards Click() will no longer be triggered

	INVOKE_ASYNC(src, PROC_REF(move_pick_forward))

/atom/movable/screen/movable/snap/lockpicking/proc/mob_detection(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("They are picking \the [picking_object]'s lock!")

/atom/movable/screen/movable/snap/lockpicking/proc/close_lockpick(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER
	qdel(src)
	picking_object.being_picked = FALSE

	to_chat(picker, span_notice("I stop picking the lock of \the [picking_object]."))

/atom/movable/screen/movable/snap/lockpicking/proc/on_mouse_up(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	mouse_status = LOCKPICK_MOUSEUP
	lock_angle -= 10
	process()

/atom/movable/screen/movable/snap/lockpicking/proc/move_pick_forward(control, params)
	SIGNAL_HANDLER
	mouse_status = LOCKPICK_MOUSEDOWN
	lock_angle += 10
	process()

//compilcated circle mathematics about rotations and shit, signals and the like
/atom/movable/screen/movable/snap/lockpicking/process()
	if(!linked_lock || !picker)
		lock_angle = 0
		return FALSE

	switch(mouse_status)
		if(LOCKPICK_MOUSEDOWN)
			lock_angle += 10
		if(LOCKPICK_MOUSEUP)
			lock_angle -= 10

	lock_angle = clamp(lock_angle,0,90)

	var/complete_multiplier = lock_angle/90 // 1 means we've unlocked it.
	angle_distance = abs(sweet_spot-pick_angle) //How far are we, in angular units, are we from the sweet spot?
	//The larger the angle distance, the easier it is to fail.

	var/failing = (angle_distance * complete_multiplier) > (difficulty + (skill_level))

	var/matrix/M = matrix()
	M.Turn(lock_angle)
	animate(linked_lock,transform = M,time=1)

	var/wedge_x = -sin(lock_angle)*8
	var/wedge_y = -cos(lock_angle)*8 + 8

	var/matrix/W = matrix()
	W.Turn(wedge_angle)
	animate(linked_wedge,pixel_x = wedge_x, pixel_y = wedge_y,time=1)
	animate(linked_wedge,transform = M,time=1)

	var/pick_x = sin(lock_angle)*6
	var/pick_y = 6 + cos(lock_angle)*6 - 6
	if(failing)
		if(break_checking_cooldown <= world.time)
			var/break_prob = clamp(10 - skill_level + (6 - difficulty) * 2, 0, 100)
			if(prob(break_prob))
				to_chat(picker, span_notice("My \the [the_lockpick] broke!"))
				playsound(src, 'sound/items/LPBreak.ogg', min(100 - (15 * skill_level) + (10 * 6 - difficulty), 100), extrarange = SILENCED_SOUND_EXTRARANGE)
				qdel(the_lockpick)
				//one tenth of the usual boost for picking a lock
				if(isliving(picker))
					var/mob/living/picker_real = picker
					var/amt2raise = ((picker_real.STAINT / 2) * (20 / difficulty)) / 10
					var/boon = picker_real.get_learning_boon(/datum/skill/misc/lockpicking)
					picker_real.adjust_experience(/datum/skill/misc/lockpicking, amt2raise * boon)
			if(picker.client?.prefs.showrolls)
				to_chat(picker, span_notice("The chance to break was [break_prob]%!"))
			break_checking_cooldown = world.time + (9 - (7 - difficulty)) SECONDS
			//break check cooldown at highest difficulty is 3 seconds, at lowest its 8

		lock_angle -= 20
		playsound(picker, pick('sound/items/LPtry.ogg', 'sound/items/LPtry2.ogg'), min(100 - (15 * skill_level) + (10 * 6 - difficulty), 100), extrarange = SILENCED_SOUND_EXTRARANGE)
	if(lock_angle >= 1 && !failing && !playing_lock_sound)
		play_turn_sound()
		playing_lock_sound = TRUE

	animate(linked_pick,pixel_x = pick_x, pixel_y = pick_y,time= failing ? 0.1 : 1)

	if(complete_multiplier <= 0)
		lock_angle = 0
		return FALSE

	if(complete_multiplier >= 1)
		frozen = TRUE
		if(picking_object)
			picking_object.picked(picker, the_lockpick, skill_level, difficulty)
			qdel(src)
		return FALSE
	return TRUE

/atom/movable/screen/movable/snap/lockpicking/proc/play_turn_sound(timerd)
	//playsound(picker, pick('sound/items/LPTurn1.ogg', 'sound/items/LPTurn2.ogg'), (100 - (15 * skill_level)) * 0.5)
	addtimer(CALLBACK(src, PROC_REF(turn_sound_reset)), 0.7 SECONDS) //stops the spam

/atom/movable/screen/movable/snap/lockpicking/proc/turn_sound_reset()
	playing_lock_sound = FALSE

#undef LOCKPICK_MOUSEUP
#undef LOCKPICK_MOUSEDOWN
