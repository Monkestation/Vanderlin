/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!usr || !over)
		return
	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, usr) & COMPONENT_NO_MOUSEDROP)	//Whatever is receiving will verify themselves for adjacency.
		return
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows
	var/list/modifiers = params2list(params)
	if (LAZYACCESS(modifiers, MIDDLE_CLICK))
		over.MiddleMouseDrop_T(src,usr)
	else
		if(over == src)
			return usr.client.Click(src, src_location, src_control, params)
		over.MouseDrop_T(src,usr)
	if(isitem(src) && ((isturf(over) && loc == over) || ((istype(over, /obj/structure/table) || istype(over, /obj/structure/rack)) && loc == over.loc)) && (isliving(usr) || prob(10)))
		var/modifier = 1
		var/obj/item/I = src
		if(isdead(usr))
			modifier = 16
		if(!(I.item_flags & ABSTRACT))
			if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
				return
			I.pixel_x = I.base_pixel_x + round(CLAMP(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)/modifier, 1)
			I.pixel_y = I.base_pixel_y + round(CLAMP(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)/modifier, 1)
			return
	return

// receive a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user)
	return

/atom/proc/MiddleMouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user)
	return

/client
	var/list/atom/selected_target[2]
	var/obj/item/active_mousedown_item = null
	var/mouseParams = ""
	///Used in MouseDrag to preserve the last mouse-entered location. Weakref
	var/datum/weakref/mouse_location_ref = null
	///Used in MouseDrag to preserve the last mouse-entered object. Weakref
	var/datum/weakref/mouse_object_ref
	//Middle-mouse-button click dragtime control for aimbot exploit detection.
	var/middragtime = 0
	//Middle-mouse-button clicked object control for aimbot exploit detection. Weakref
	var/datum/weakref/middle_drag_atom_ref
	var/tcompare
	var/charging = 0
	var/chargedprog = 0
	var/sections
	var/lastplayed
	var/part
	var/goal
	var/progress
	var/doneset
	var/aghost_toggle
	var/last_charge_process
	var/datum/patreon_data/patreon
	var/datum/twitch_data/twitch
	var/toggled_leylines = FALSE
	/// The DPI scale of the client. 1 is equivalent to 100% window scaling, 2 will be 200% window scaling
	var/window_scaling

/atom/movable/screen
	blockscharging = TRUE

///setter used to set our new hud
/atom/movable/screen/proc/set_new_hud(datum/hud/hud_owner)
	if(hud)
		UnregisterSignal(hud, COMSIG_PARENT_QDELETING)
	if(isnull(hud_owner))
		hud = null
		return
	hud = hud_owner
	RegisterSignal(hud, COMSIG_PARENT_QDELETING, PROC_REF(on_hud_delete))

/atom/movable/screen/proc/on_hud_delete(datum/source)
	SIGNAL_HANDLER

	set_new_hud(hud_owner = null)

/client/MouseDown(datum/object, location, control, params)
	if(!control || QDELETED(object))
		return
	if(mob.incapacitated(IGNORE_GRAB))
		return
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEDOWN, object, location, control, params)
	if(istype(object, /obj/abstract/visual_ui_element/hoverable/movable))
		var/obj/abstract/visual_ui_element/hoverable/movable/ui_object = object
		ui_object.MouseDown(location, control, params)

	tcompare = object

	var/atom/AD = object

	if(mob.uses_intents)
		if(mob.used_intent && istype(mob.used_intent))
			mob.used_intent.on_mouse_up()

	if(mob.stat != CONSCIOUS)
		mob.atkswinging = null
		charging = null
		return

	if(mouse_down_icon)
		mouse_pointer_icon = mouse_down_icon
	var/delay = mob.CanMobAutoclick(object, location, params)

	mob.atkswinging = null

	charging = 0
	last_charge_process = 0
	chargedprog = 0

	if(!mob.fixedeye) //If fixedeye isn't already enabled, we need to set this var
		mob.tempfixeye = TRUE //Change icon to 'target' red eye
		mob.atom_flags |= NO_DIR_CHANGE_ON_MOVE

	for(var/atom/movable/screen/eye_intent/eyet in mob.hud_used.static_inventory)
		eyet.update_appearance(UPDATE_ICON)

	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)
	active_mousedown_item = mob.canMobMousedown(object, location, params)
	if(active_mousedown_item)
		active_mousedown_item.onMouseDown(object, location, params, mob)

	mob.face_atom(object)

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(!mouse_override_icon)
			mouse_pointer_icon = 'icons/effects/mousemice/human_looking.dmi'

	if(LAZYACCESS(modifiers, MIDDLE_CLICK)) //start charging a spell or readying a mmb intent
		if(mob.next_move > world.time)
			return
		mob.atkswinging = "middle"
		if(mob.mmb_intent)
			mob.cast_move = 0
			mob.used_intent = mob.mmb_intent
		if(!mob.mmb_intent)
			return
		if(mob.mmb_intent.get_chargetime() && !AD.blockscharging)
			updateprogbar()
		else
			mouse_pointer_icon = mob.mmb_intent.pointer
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK)) //start charging a lmb intent
		if(mob.active_hand_index == 1)
			if(mob.next_lmove > world.time)
				return
		else
			if(mob.next_rmove > world.time)
				return
		mob.atkswinging = "left"
		mob.cast_move = 0
		mob.used_intent = mob.a_intent
		if(mob.uses_intents)
			if(!ispath(mob.used_intent) && mob.used_intent.get_chargetime() && !AD.blockscharging && !mob.in_throw_mode)
				updateprogbar()
			else
				mouse_pointer_icon = 'icons/effects/mousemice/human_attack.dmi'

/client/MouseUp(object, location, control, params)
	if(!control)
		return
	if(SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEUP, object, location, control, params) & COMPONENT_CLIENT_MOUSEUP_INTERCEPT)
		click_intercept_time = world.time
	if(mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	else
		mob?.update_mouse_pointer()
	var/mob/living/L = mob
	if(L)
		update_to_mob(L)
	charging = 0
	last_charge_process = 0

	if(istype(object, /obj/abstract/visual_ui_element/hoverable/movable))
		var/obj/abstract/visual_ui_element/hoverable/movable/ui_object = object
		ui_object.MouseUp(location, control, params)

	if(mob.curplaying)
		mob.curplaying.on_mouse_up()

	if(!mob.fixedeye)
		mob.tempfixeye = FALSE
		mob.atom_flags &= ~NO_DIR_CHANGE_ON_MOVE

	if(mob.hud_used)
		for(var/atom/movable/screen/eye_intent/eyet in mob.hud_used.static_inventory)
			eyet.update_appearance(UPDATE_ICON) //Update eye icon

	if(!mob.atkswinging)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(mob.atkswinging != "left")
			mob.atkswinging = null
			return

	if(mob.stat != CONSCIOUS)
		chargedprog = 0
		mob.atkswinging = null
		return

	if (mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	selected_target[1] = null

//	var/list/L = params2list(params)

	if(tcompare)
		if(object)
			if(isatom(object) && object != tcompare && mob.atkswinging && tcompare != mob && (mob.cmode || chargedprog))
				var/atom/N = object
				N.Click(location, control, params)
		tcompare = null

//	mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'

	if(active_mousedown_item)
		active_mousedown_item.onMouseUp(object, location, params, mob)
		active_mousedown_item = null

	if(!isliving(mob))
		return

/client/proc/updateprogbar()
	if(!mob)
		return
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	if(!L.used_intent.can_charge())
		return
	L.used_intent.prewarning()
	if(!charging)
		charging = TRUE
		L.used_intent.on_charge_start()
		L.update_charging_movespeed(L.used_intent)
		progress = 0
		sections = null //commented
		goal = L.used_intent.get_chargetime()
		part = 1
		lastplayed = 0
		doneset = FALSE
		chargedprog = 0
		START_PROCESSING(SSmousecharge, src)

/client/process()
	if(!mob || !isliving(mob))
		return PROCESS_KILL
	var/mob/living/L = mob
	if(!L.client)
		return PROCESS_KILL
	if(update_to_mob(L))
		L.update_mouse_pointer()
		return
	if(L.curplaying)
		L.curplaying.on_mouse_up()
	L.update_charging_movespeed()
	mouse_override_icon = null
	L.update_mouse_pointer()
	return PROCESS_KILL

/client/proc/update_to_mob(mob/living/L)
	if(!charging)
		return FALSE
	if(progress >= goal)
		if(!L.adjust_stamina(L.used_intent.chargedrain))
			L.stop_attack()
			return FALSE
		if(doneset)
			return TRUE
		doneset = TRUE
		chargedprog = 100
		if(mob.used_intent.charged_pointer)
			mouse_override_icon = mob.used_intent.charged_pointer
		else
			mouse_override_icon = 'icons/effects/mousemice/charge/default/100.dmi'
		if(L.curplaying && !L.used_intent.keep_looping)
			playsound(L, 'sound/magic/charged.ogg', 100, TRUE)
			L.curplaying.on_mouse_up()
		if(istype(L.used_intent, /datum/intent/shield/block))
			L.visible_message("<span class='danger'>[L] prepares to do a shield bash!</span>")
			playsound(L, 'sound/combat/shieldraise.ogg', 100, TRUE)

		return TRUE

	if(last_charge_process)
		progress += world.time - last_charge_process
	last_charge_process = world.time
	chargedprog = round((progress / goal) * 100)
	if(mob.used_intent.charge_pointer)
		mouse_override_icon = mob.used_intent.charge_pointer
	else
		var/mouseprog = clamp(round(chargedprog, 5), 0, 100)
		mouse_override_icon = file("icons/effects/mousemice/charge/default/[mouseprog].dmi")

	return TRUE

/mob/proc/CanMobAutoclick(object, location, params)

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_held_item()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/mob/proc/canMobMousedown(atom/object, location, params)

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	var/obj/item/H = get_active_held_item()
	if(H)
		. = H.canItemMouseDown(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)

/obj/item/proc/canItemMouseDown(object, location, params)
	if(canMouseDown)
		return src

/obj/item/proc/onMouseDown(object, location, params, mob)
	return

/obj/item/proc/onMouseUp(object, location, params, mob)
	return

/obj/item/gun/CanItemAutoclick(object, location, params)
	. = automatic

/atom/proc/IsAutoclickable()
	. = 1

/atom/movable/screen/IsAutoclickable()
	. = 0

/atom/movable/screen/click_catcher/IsAutoclickable()
	. = 1

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	if(mob.incapacitated(IGNORE_GRAB))
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if (src_object && src_location != over_location)
			middragtime = world.time
			middle_drag_atom_ref = WEAKREF(src_object)
		else
			middragtime = 0
			middle_drag_atom_ref = null

	mob.face_atom(over_object)

	mouseParams = params
	mouse_location_ref = WEAKREF(over_location)
	mouse_object_ref = WEAKREF(over_object)
	if(selected_target[1] && over_object && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params
	if(active_mousedown_item)
		active_mousedown_item.onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEDRAG, src_object, over_object, src_location, over_location, src_control, over_control, params)
	return ..()

/obj/item/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return

/client/MouseDrop(atom/src_object, atom/over_object, atom/src_location, atom/over_location, src_control, over_control, params)
	if (IS_WEAKREF_OF(src_object, middle_drag_atom_ref))
		middragtime = 0
		middle_drag_atom_ref = null
	..()
