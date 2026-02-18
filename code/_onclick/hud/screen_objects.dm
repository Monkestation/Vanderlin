/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/atom/movable/screen
	name = ""
	icon = 'icons/mob/screen_gen.dmi'
	plane = HUD_PLANE
	appearance_flags = APPEARANCE_UI
	/// A reference to the object in the slot. Grabs or items, generally, but any datum will do.
	var/datum/weakref/master_ref = null
	/// A reference to the owner HUD, if any.
	VAR_PRIVATE/datum/hud/hud = null
	var/lastclick
	var/category

/atom/movable/screen/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(isnull(hud_owner)) //some screens set their hud owners on /new, this prevents overriding them with null post atoms init
		return
	set_new_hud(hud_owner)

/atom/movable/screen/Destroy(force)
	master_ref = null
	hud = null
	return ..()

/atom/movable/screen/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, LEFT_CLICK) && LAZYACCESS(modifiers, SHIFT_CLICKED)) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE

/atom/movable/screen/proc/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"
	inspec += "[extra_info(user)]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/atom/movable/screen/proc/extra_info(mob/user)
	return

/atom/movable/screen/orbit()
	return

/atom/movable/screen/proc/component_click(atom/movable/screen/component_button/component, params)
	return

/atom/movable/screen/text
	icon = null
	icon_state = null
	layer = FLOAT_LAYER
	plane = HUD_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/atom/movable/screen/swap_hand
	plane = HUD_PLANE
	name = "swap hand"

/atom/movable/screen/swap_hand/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1

	if(ismob(usr))
		var/mob/M = usr
		M.swap_hand()
	return 1

/atom/movable/screen/skills
	name = "skills"
	icon_state = "skills"
	screen_loc = ui_skill_menu

/atom/movable/screen/skills/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		if(ishuman(usr))
			var/mob/living/L = usr
			var/datum/language_holder/H = L.get_language_holder()
			H.open_language_menu(usr)
			return

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		var/ht
		var/mob/living/L = usr
		to_chat(L, "*----*")
		if(ishuman(usr))
			var/mob/living/carbon/human/M = usr
			for(var/datum/quirk/vice/vices in M.quirks)
				to_chat(M, "<span class='info'>[vices.get_desc()]</span>")
			to_chat(M, "*----*")
			if(M.mind)
				if(M.mind.language_holder)
					if(!length(M.mind.language_holder.languages))
						to_chat(M, "<span class='warning'>I don't know any languages.</span>")
					else
						for(var/X in M.mind.language_holder.languages)
							var/datum/language/LA = GLOB.language_datum_instances[X]
							to_chat(M, "<span class='info'>[LA.name] - ,[LA.key]</span>")
					to_chat(M, "*----*")
		for(var/X in GLOB.roguetraits)
			if(HAS_TRAIT(L, X))
				to_chat(L, "[X] - <span class='info'>[GLOB.roguetraits[X]]</span>")
				ht = TRUE
		if(!ht)
			to_chat(L, "<span class='warning'>I have no special traits.</span>")
		to_chat(L, "*----*")
		return

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.print_levels(H)

/atom/movable/screen/craft
	name = "crafting menu"
	icon_state = "craft"
	screen_loc = rogueui_craft
	var/last_craft
	var/obj/item/recipe_book/always_known/book

/atom/movable/screen/craft/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		if(QDELETED(book))
			book = new(null)
		var/mob/M = usr
		for(var/datum/recipe as anything in M.mind?.learned_recipes)
			book.types |= recipe.type
		book.generate_categories()
		usr << browse(book.generate_html(usr),"window=recipe;size=800x810")
		return
	if(world.time < lastclick + 3 SECONDS)
		return
	lastclick = world.time
	if(!HAS_TRAIT(usr, TRAIT_BLUEPRINT_VISION))
		var/mob/vision = usr
		vision.enter_blueprint()
	else
		var/mob/vision = usr
		REMOVE_TRAIT(usr, TRAIT_BLUEPRINT_VISION, TRAIT_GENERIC)
		vision.blueprints.quit()
		vision.blueprints = null

/atom/movable/screen/craft/Destroy()
	QDEL_NULL(book)
	. = ..()

/atom/movable/screen/area_creator
	name = "create new area"
	icon_state = "area_edit"
	screen_loc = ui_building

/atom/movable/screen/area_creator/Click()
	if(usr.incapacitated(IGNORE_GRAB) || (isobserver(usr) && !IsAdminGhost(usr)))
		return TRUE
	var/area/A = get_area(usr)
	if(!A.outdoors)
		to_chat(usr, "<span class='warning'>There is already a defined structure here.</span>")
		return TRUE
	create_area(usr)

/atom/movable/screen/language_menu
	name = "language menu"
	icon_state = "talk_wheel"
	screen_loc = ui_language_menu

/atom/movable/screen/language_menu/Click()
	var/mob/M = usr
	var/datum/language_holder/H = M.get_language_holder()
	H.open_language_menu(usr)

/atom/movable/screen/inventory
	/// The identifier for the slot. It has nothing to do with ID cards.
	var/slot_id
	/// Icon when empty. For now used only by humans.
	var/icon_empty
	/// Icon when contains an item. For now used only by humans.
	var/icon_full = "genslot"
	/// The overlay when hovering over with an item in your hand
	plane = HUD_PLANE
	no_over_text = FALSE


/atom/movable/screen/inventory/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return TRUE

	if(usr.incapacitated(IGNORE_GRAB))
		return TRUE

	if(hud?.mymob && slot_id)
		var/obj/item/inv_item = hud.mymob.get_item_by_slot(slot_id)
		if(inv_item)
			return inv_item.Click(location, control, params)

	if(usr.attack_ui(slot_id, params))
		usr.update_inv_hands()
	return TRUE

/atom/movable/screen/inventory/MouseEntered(location, control, params)
	. = ..()
	add_overlays()

/atom/movable/screen/inventory/MouseExited()
	..()
	if(hud)
		cut_overlay(hud.object_overlay)
		QDEL_NULL(hud.object_overlay)

/atom/movable/screen/inventory/update_icon_state()
	if(!icon_empty)
		icon_empty = icon_state

	if(hud?.mymob && slot_id && icon_full)
		var/obj/item/I = hud.mymob.get_item_by_slot(slot_id)
		if(I)
			icon_state = icon_full
			if(I.uses_integrity)
				if(I.obj_broken)
					icon_state = "slotbroke"
				else if(I.get_integrity() < I.max_integrity)
					icon_state = "slotdmg"
		else
			icon_state = icon_empty
	return ..()

/atom/movable/screen/inventory/proc/add_overlays()
	var/mob/user = hud?.mymob

	cut_overlays()

	if(!user || !slot_id)
		return

	var/obj/item/holding = user.get_active_held_item()

	if(!holding || user.get_item_by_slot(slot_id))
		return

	var/image/item_overlay = image(holding)
	item_overlay.alpha = 92

	if(!user.can_equip(holding, slot_id, disable_warning = TRUE, bypass_equip_delay_self = TRUE))
		item_overlay.color = "#fd0279"
	else
		item_overlay.color = "#c5c5c5"

	if(hud)
		if(hud.object_overlay)
			if(hud.overlay_curloc != src)
				hud.overlay_curloc.cut_overlay(hud.object_overlay)
		hud.overlay_curloc = src
		cut_overlay(hud.object_overlay)
		hud.object_overlay = item_overlay
		add_overlay(hud.object_overlay)


/atom/movable/screen/inventory/hand
	no_over_text =  TRUE
	var/mutable_appearance/handcuff_overlay
	var/static/mutable_appearance/blocked_overlay = mutable_appearance('icons/mob/screen_gen.dmi', "blocked")
	var/static/mutable_appearance/fingerless_overlay = mutable_appearance('icons/mob/screen_gen.dmi', "fingerless")
	var/static/mutable_appearance/grabbed_overlay = mutable_appearance('icons/mob/screen_gen.dmi', "grabbed")
	var/held_index = 0

/atom/movable/screen/inventory/hand/update_overlays()
	. = ..()

	if(!handcuff_overlay)
		var/state = (!(held_index % 2)) ? "markus" : "gabrielle"
		handcuff_overlay = mutable_appearance('icons/mob/screen_gen.dmi', state)

	if(!hud?.mymob)
		return

	if(iscarbon(hud.mymob))
		var/mob/living/carbon/C = hud.mymob
		if(C.handcuffed)
			. += handcuff_overlay

		if(held_index)
			if(!C.has_hand_for_held_index(held_index))
				. += blocked_overlay
			else if(C.check_arm_grabbed(held_index))
				. += grabbed_overlay
			else if(!C.has_hand_for_held_index(held_index, TRUE))
				. += fingerless_overlay

	if(held_index == hud.mymob.active_hand_index)
		. += "hand_active"

/atom/movable/screen/inventory/hand/add_overlays()
	return

/atom/movable/screen/inventory/hand/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	var/mob/user = hud?.mymob
	if(usr != user)
		return TRUE
	if(world.time <= user.next_move)
		return TRUE

	if(user.active_hand_index == held_index)
		var/obj/item/I = user.get_active_held_item()
		if(I)
			I.Click(location, control, params)
	else
		user.swap_hand(held_index)
	return TRUE

/atom/movable/screen/drop
	name = "drop"
	icon_state = "act_drop"
	plane = HUD_PLANE

/atom/movable/screen/drop/Click()
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	if(usr.stat == CONSCIOUS)
		usr.dropItemToGround(usr.get_active_held_item(), silent = FALSE)

/atom/movable/screen/act_intent
	name = "intent"
	icon_state = "help"
	screen_loc = ui_acti

/atom/movable/screen/act_intent/Click(location, control, params)
	usr.a_intent_change(INTENT_HOTKEY_RIGHT)

/atom/movable/screen/act_intent/proc/switch_intent(index as num)
	return

/atom/movable/screen/act_intent/rogintent
	name = ""
	desc = ""
	icon = 'icons/mob/rogueintentbase.dmi'
	icon_state = "intentbase"
	screen_loc = rogueui_intents
	var/intent1
	var/intent2
	var/intent3
	var/intent4
	var/border1
	var/border2

/atom/movable/screen/act_intent/rogintent/update_overlays()
	. = ..()
	. += intent1
	. += intent2
	. += intent3
	. += intent4
	. += border1
	. += border2

/atom/movable/screen/act_intent/rogintent/proc/update(list/left_intents, list/right_intents, active = FALSE)
	if(!left_intents || !right_intents)
		return
	if(!hud?.mymob)
		return
	var/lol = 0
	intent1 = null
	intent2 = null
	intent3 = null
	intent4 = null
	var/list/used = right_intents
	if(hud.mymob.active_hand_index == 1)
		used = left_intents
	for(var/datum/intent/intenty as anything in used)
		lol++
		switch(lol)
			if(1)
				intent1 = image(icon='icons/mob/roguehud.dmi',icon_state=intenty.icon_state, pixel_x = 64, pixel_y = 16, layer = layer+0.02)
			if(2)
				intent2 = image(icon='icons/mob/roguehud.dmi',icon_state=intenty.icon_state, pixel_x = 96, pixel_y = 16, layer = layer+0.02)
			if(3)
				intent3 = image(icon='icons/mob/roguehud.dmi',icon_state=intenty.icon_state, pixel_x = 64, layer = layer+0.02)
			if(4)
				intent4 = image(icon='icons/mob/roguehud.dmi',icon_state=intenty.icon_state, pixel_x = 96, layer = layer+0.02)
	if(ismob(usr))
		var/mob/M = usr
		switch_intent(M.r_index, M.l_index, active)
		update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/act_intent/rogintent/switch_intent(r_index, l_index)
	var/used = "offintent"
	if(!r_index || !l_index)
		return
	var/used_index = r_index
	var/other = l_index
	if(hud.mymob.active_hand_index == 1)
		used_index = l_index
		other = r_index
	switch(used_index)
		if(1)
			border1 = image(icon='icons/mob/roguehud.dmi', icon_state="intentselected", pixel_x = 64, pixel_y = 16, layer = layer+0.01)
		if(2)
			border1 = image(icon='icons/mob/roguehud.dmi', icon_state="intentselected", pixel_x = 96, pixel_y = 16, layer = layer+0.01)
		if(3)
			border1 = image(icon='icons/mob/roguehud.dmi', icon_state="intentselected", pixel_x = 64, layer = layer+0.01)
		if(4)
			border1 = image(icon='icons/mob/roguehud.dmi', icon_state="intentselected", pixel_x = 96, layer = layer+0.01)
	switch(other)
		if(1)
			border2 = image(icon='icons/mob/roguehud.dmi', icon_state=used, pixel_x = 64, pixel_y = 16, layer = layer+0.01)
		if(2)
			border2 = image(icon='icons/mob/roguehud.dmi', icon_state=used, pixel_x = 96, pixel_y = 16, layer = layer+0.01)
		if(3)
			border2 = image(icon='icons/mob/roguehud.dmi', icon_state=used, pixel_x = 64, layer = layer+0.01)
		if(4)
			border2 = image(icon='icons/mob/roguehud.dmi', icon_state=used, pixel_x = 96, layer = layer+0.01)
	update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/act_intent/rogintent/Click(location, control, params)
	var/list/modifiers = params2list(params)

	var/mob/user = hud?.mymob
	if(usr != user)
		return TRUE

	user.playsound_local(user, 'sound/misc/click.ogg', 100)

	var/_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/clicked = get_index_at_loc(_x, _y)
	if(!clicked)
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(LAZYACCESS(modifiers, SHIFT_CLICKED))
			user.examine_intent(clicked, FALSE)
			return
	user.rog_intent_change(clicked)

/atom/movable/screen/act_intent/rogintent/proc/get_index_at_loc(xl, yl)
/*	if(xl<=64)
		if(xl<32)
			if(yl>16)
				return 1
			else
				return 3
		else
			if(yl>16)
				return 2
			else
				return 4
	else*/
	if(xl > 64)
		if(xl<96)
			if(yl>16)
				return 1
			else
				return 3
		else
			if(yl>16)
				return 2
			else
				return 4

//

/atom/movable/screen/quad_intents
	name = "mmb intents"
	icon_state = "mmbintents0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_quad

/atom/movable/screen/quad_intents/proc/switch_intent(input)
	icon_state = "mmbintents0"
	if(input in 1 to 4)
		icon_state = "mmbintents[input]"

/atom/movable/screen/quad_intents/Click(location, control, params)
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)

	var/list/modifiers = params2list(params)
	var/_y = text2num(LAZYACCESS(modifiers, ICON_Y))

	if(_y<=9)
		usr.mmb_intent_change(QINTENT_STEAL)

	else if(_y>=9 && _y<=16)
		usr.mmb_intent_change(QINTENT_KICK)

	else if(_y>=17 && _y<=24)
		usr.mmb_intent_change(QINTENT_JUMP)

	else if(_y>=24 && _y<=32)
		usr.mmb_intent_change(QINTENT_BITE)


/atom/movable/screen/give_intent
	name = "give/take"
	icon_state = "take0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_give
	var/giving = FALSE

/atom/movable/screen/give_intent/proc/switch_intent(ass)
	if(ass == QINTENT_GIVE)
		giving = TRUE
	else
		giving = FALSE
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/give_intent/Click(location, control, params)
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	usr.mmb_intent_change(QINTENT_GIVE)

/atom/movable/screen/give_intent/update_icon_state()
	..()
	if(ismob(usr))
		var/mob/M = usr
		if(M.get_active_held_item())
			icon_state = "give[giving]"
		else
			icon_state = "take[giving]"

/atom/movable/screen/def_intent
	name = "defense intent"
	icon_state = "def1n"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_def

/atom/movable/screen/def_intent/update_icon_state()
	. = ..()
	icon_state = "def[hud.mymob.d_intent]n"

/atom/movable/screen/def_intent/Click(location, control, params)
	var/list/modifiers = params2list(params)
	var/_y = text2num(LAZYACCESS(modifiers, ICON_Y))

	if(_y>=0 && _y<17)
		usr.def_intent_change(INTENT_DODGE)
	else if(_y>16 && _y<=32)
		usr.def_intent_change(INTENT_PARRY)

/atom/movable/screen/cmode
	name = "combat mode"
	icon_state = "combat0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_cmode

/atom/movable/screen/cmode/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(isliving(usr))
		var/mob/living/L = usr
		L.playsound_local(L, 'sound/misc/click.ogg', 100)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			L.submit()
		else
			L.toggle_cmode()
			update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/cmode/update_icon_state()
	. = ..()
	icon_state = "combat[hud?.mymob?.cmode]"

/atom/movable/screen/mov_intent
	name = "run/walk toggle"
	icon_state = "running"

/atom/movable/screen/mov_intent/Click(location, control, params)
	toggle(usr)

/atom/movable/screen/mov_intent/update_icon_state()
	. = ..()
	switch(hud?.mymob?.m_intent)
		if(MOVE_INTENT_WALK)
			icon_state = "walking"
		if(MOVE_INTENT_RUN)
			icon_state = "running"

/atom/movable/screen/mov_intent/proc/toggle(mob/user)
	if(isobserver(user))
		return
	user.toggle_move_intent(user)
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/rogmove
	name = "sneak mode"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "sneak0"
	screen_loc = rogueui_moves

/atom/movable/screen/rogmove/Click(location, control, params)
	var/mob/M = usr
	toggle(M)

/atom/movable/screen/rogmove/proc/toggle(mob/user)
	if(isobserver(user))
		return
	if(user.m_intent == MOVE_INTENT_SNEAK)
		user.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		user.toggle_rogmove_intent(MOVE_INTENT_SNEAK)
	update_appearance(UPDATE_ICON_STATE)
	user.update_sneak_invis()

/atom/movable/screen/rogmove/update_icon_state()
	. = ..()
	if(hud?.mymob?.m_intent == MOVE_INTENT_SNEAK)
		icon_state = "sneak1"
	else
		icon_state = "sneak0"

/atom/movable/screen/rogmove/sprint
	name = "sprint mode"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "sprint0"
	screen_loc = rogueui_moves

/atom/movable/screen/rogmove/sprint/toggle(mob/user)
	if(isobserver(user))
		return
	if(user.m_intent == MOVE_INTENT_RUN)
		user.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		user.toggle_rogmove_intent(MOVE_INTENT_RUN)
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/rogmove/sprint/update_icon_state()
	. = ..()
	if(hud?.mymob?.m_intent == MOVE_INTENT_RUN)
		icon_state = "sprint1"
	else
		icon_state = "sprint0"

/atom/movable/screen/advsetup
	name = ""
	icon = null
	icon_state = ""

/atom/movable/screen/advsetup/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_mob)), 3 SECONDS)

/atom/movable/screen/advsetup/Destroy()
	hud?.static_inventory -= src
	return ..()

/atom/movable/screen/advsetup/proc/check_mob()
	if(QDELETED(src))
		return
	if(!hud)
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		qdel(src)
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(H.mind && H.mind.antag_datums)
		for(var/datum/antagonist/D in H.mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire))
				qdel(src)
				return
	if(H.advsetup)
		alpha = 0
		icon = 'icons/mob/advsetup.dmi'
		animate(src, alpha = 255, time = 30)

/atom/movable/screen/advsetup/Click(location,control,params)
	if(!hud)
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		qdel(src)
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(!H.advsetup)
		qdel(src)
		return
	else
		SSrole_class_handler.setup_class_handler(H)

/atom/movable/screen/eye_intent
	name = "eye intent"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "eye"

/atom/movable/screen/eye_intent/Click(location,control,params)
	var/list/modifiers = params2list(params)
	var/_y = text2num(LAZYACCESS(modifiers, ICON_Y))

	hud.mymob.playsound_local(hud.mymob, 'sound/misc/click.ogg', 100)
	if(isliving(hud?.mymob))
		var/mob/living/L = hud.mymob
		if(L.eyesclosed)
			L.set_eyes_closed(FALSE)
			return

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(_y>=29 || _y<=4)
			if(isliving(hud.mymob))
				var/mob/living/L = hud.mymob
				L.set_eyes_closed(TRUE)
		else
			toggle(usr)

	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(isliving(hud.mymob))
			var/mob/living/L = hud.mymob
			L.look_up()
	update_appearance(UPDATE_ICON)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(isliving(hud.mymob))
			var/mob/living/L = hud.mymob
			L.look_around()

/atom/movable/screen/eye_intent/update_icon_state()
	. = ..()
	var/mob/living/L = hud.mymob
	if(!istype(L))
		icon_state = "eye"
		return
	if(L.eyesclosed)
		icon_state = "eye_closed"
	else if(L.tempfixeye)
		icon_state = "eye_target"
	else if(L.fixedeye)
		icon_state = "eye_fixed"
	else
		icon_state = "eye"

/atom/movable/screen/eye_intent/update_overlays()
	. = ..()
	var/mob/living/carbon/human/human = hud.mymob
	if(!istype(human))
		return
	var/mutable_appearance/iris = mutable_appearance(src.icon, "oeye")
	switch(icon_state)
		if("eye_closed")
			iris.icon_state = "oeye_closed"
		if("eye_target")
			iris.icon_state = "oeye_target"
		if("eye_fixed")
			iris.icon_state = "oeye_fixed"
		else
			iris.icon_state = "oeye"
	iris.color = "#[human.get_eye_color()]"
	. += iris

/atom/movable/screen/eye_intent/proc/toggle(mob/user)
	if(isobserver(user))
		return
	user.toggle_eye_intent(user)

/atom/movable/screen/pull
	name = "stop pulling"

	icon_state = "pull"

/atom/movable/screen/pull/Click()
	if(isobserver(usr))
		return
	usr.stop_pulling()

/atom/movable/screen/pull/update_icon_state()
	if(hud?.mymob?.pulling)
		icon_state = "pull"
	else
		icon_state = "pull0"
	return ..()

/atom/movable/screen/rest
	name = "rest"
	icon_state = "act_rest"
	plane = HUD_PLANE

/atom/movable/screen/rest/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		L.lay_down()

/atom/movable/screen/rest/update_icon_state()
	var/mob/living/user = hud?.mymob
	if(!istype(user))
		return

	if(!user.resting)
		icon_state = "act_rest"
	else
		icon_state = "act_rest0"
	return ..()

/atom/movable/screen/restup
	name = "stand up"
	icon_state = "act_rest_up"
	plane = HUD_PLANE

/atom/movable/screen/restup/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/L = usr
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			L.look_up()
		else
			L.stand_up()

/atom/movable/screen/restdown
	name = "lay down"
	icon_state = "act_rest_down"
	plane = HUD_PLANE

/atom/movable/screen/restdown/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/L = usr
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			var/turf/O
			for(var/turf/T in range(1, L))
				if(istransparentturf(T))
					O = T
					break
			L.look_down(O)
		else
			L.lay_down()

/atom/movable/screen/storage
	name = "storage"
	icon_state = "block"
	screen_loc = "7,7 to 10,8"
	plane = HUD_PLANE

/atom/movable/screen/storage/Initialize(mapload, datum/hud/hud_owner, obj/item/new_master)
	. = ..()
	master_ref = WEAKREF(new_master)

/atom/movable/screen/storage/Click(location, control, params)
	var/list/modifiers = params2list(params)
	var/obj/item/master = master_ref?.resolve()
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(master)
			var/obj/item/flipper = usr.get_active_held_item()
			if(!flipper || (!usr.Adjacent(flipper) && !usr.DirectAccess(flipper)) || !isliving(usr) || usr.incapacitated(IGNORE_GRAB))
				return
			var/old_width = flipper.grid_width
			var/old_height = flipper.grid_height
			flipper.grid_height = old_width
			flipper.grid_width = old_height
			update_hovering(location, control, modifiers)
			return

	if(world.time <= usr.next_move)
		return TRUE
	if(usr.incapacitated(IGNORE_GRAB))
		return TRUE
	if(master)
		var/obj/item/I = usr.get_active_held_item()
		if(I)
			master.attackby(src, I, usr, modifiers, TRUE)
	return TRUE

/atom/movable/screen/throw_catch
	name = "throw/catch"

	icon_state = "catch0"
	var/throwy = 0

/atom/movable/screen/throw_catch/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()

/atom/movable/screen/throw_catch/update_icon_state()
	. = ..()
	if(!ismob(usr))
		return
	var/mob/M = usr
	if(M.get_active_held_item())
		icon_state = "throw[throwy]"
	else
		icon_state = "catch[throwy]"

/atom/movable/screen/zone_sel
	name = "damage zone"
	icon_state = "m-zone_sel"
	screen_loc = rogueui_targetdoll
	var/overlay_icon = 'icons/mob/roguehud64.dmi'
	var/static/list/hover_overlays_cache = list()
	var/hovering
	var/arrowheight = 0

/atom/movable/screen/zone_sel/Click(location, control,params)
	if(isobserver(usr))
		return

	var/list/modifiers = params2list(params)
	var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y)
	if(ismob(hud.mymob))
		var/mob/M = hud.mymob
		if(M.gender == FEMALE)
			choice = get_zone_at(icon_x, icon_y, FEMALE)
	if (!choice)
		return 1

	if(LAZYACCESS(modifiers, RIGHT_CLICK) && ishuman(hud.mymob))
		var/mob/living/carbon/human/H = hud.mymob
		return H.check_limb_for_injuries(H, choice = check_zone(choice))
	else
		return set_selected_zone(choice, usr)

/atom/movable/screen/zone_sel/MouseEntered(location, control, params)
	MouseMove(location, control, params)

/atom/movable/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/modifiers = params2list(params)
	var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y)
	choice = "m_[choice]"
	if(ismob(hud.mymob))
		var/mob/M = hud.mymob
		if(M.gender == FEMALE)
			choice = get_zone_at(icon_x, icon_y, FEMALE)
			choice = "f_[choice]"

	if(hovering == choice)
		return
	vis_contents -= hover_overlays_cache[hovering]
	hovering = choice


	var/obj/effect/overlay/zone_sel/overlay_object = hover_overlays_cache[choice]
	if(!overlay_object)
		overlay_object = new
//		overlay_object.icon_state = "[basedholder]-[choice]"
		overlay_object.icon_state = "[choice]"
		hover_overlays_cache[choice] = overlay_object
	vis_contents += overlay_object

/obj/effect/overlay/zone_sel
	icon = 'icons/mob/roguehud64.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
	anchored = TRUE
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/zone_sel/MouseExited(location, control, params)
	if(!isobserver(usr) && hovering)
		vis_contents -= hover_overlays_cache[hovering]
		hovering = null

/atom/movable/screen/zone_sel/proc/get_zone_at(icon_x, icon_y, gender = MALE)
	if(gender == MALE)
		switch(icon_y)
			if(1 to 3)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(17 to 28)
						return BODY_ZONE_PRECISE_R_FOOT
					if(38 to 49)
						return BODY_ZONE_PRECISE_L_FOOT
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(4 to 5)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(17 to 28)
						return BODY_ZONE_PRECISE_R_FOOT
					if(38 to 49)
						return BODY_ZONE_PRECISE_L_FOOT
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(6 to 15)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(16 to 21)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(12 to 18)
						return BODY_ZONE_PRECISE_R_HAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(48 to 54)
						return BODY_ZONE_PRECISE_L_HAND
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(22 to 24)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(12 to 18)
						return BODY_ZONE_PRECISE_R_HAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(48 to 54)
						return BODY_ZONE_PRECISE_L_HAND
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(25 to 29)
				switch(icon_x)
					if(16 to 22)
						return BODY_ZONE_R_ARM
					if(27 to 39)
						return BODY_ZONE_PRECISE_STOMACH
					if(44 to 50)
						return BODY_ZONE_L_ARM
			if(30 to 38)
				switch(icon_x)
					if(16 to 22)
						return BODY_ZONE_R_ARM
					if(24 to 42)
						return BODY_ZONE_CHEST
					if(44 to 50)
						return BODY_ZONE_L_ARM
			if(39)
				switch(icon_x)
					if(29 to 37)
						return BODY_ZONE_PRECISE_NECK
			if(40 to 46)
				switch(icon_x)
					if(27 to 39)
						if(icon_y in 40 to 41)
							if(icon_x in 29 to 37)
								return BODY_ZONE_PRECISE_NECK
						if(icon_y in 42 to 44)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_MOUTH
						if(icon_y == 46)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						return BODY_ZONE_HEAD
			if(47 to 50)
				switch(icon_x)
					if(24 to 26)
						return BODY_ZONE_PRECISE_EARS
					if(27 to 39)
						if(icon_y in 49 to 50)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 47 to 48)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						return BODY_ZONE_HEAD
					if(40 to 42)
						return BODY_ZONE_PRECISE_EARS
			if(51 to 55)
				switch(icon_x)
					if(27 to 39)
						if(icon_y == 51)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 53 to 55)
							if(icon_x in 29 to 37)
								return BODY_ZONE_PRECISE_SKULL
						return BODY_ZONE_HEAD
	else
		switch(icon_y)
			if(1 to 7)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(26 to 32)
						return BODY_ZONE_PRECISE_R_FOOT
					if(34 to 40)
						return BODY_ZONE_PRECISE_L_FOOT
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(8 to 16)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(24 to 31)
						return BODY_ZONE_R_LEG
					if(35 to 42)
						return BODY_ZONE_L_LEG
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(17 to 20)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 23)
						return BODY_ZONE_PRECISE_R_HAND
					if(24 to 31)
						return BODY_ZONE_R_LEG
					if(35 to 42)
						return BODY_ZONE_L_LEG
					if(43 to 46)
						return BODY_ZONE_PRECISE_L_HAND
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(21)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 23)
						return BODY_ZONE_PRECISE_R_HAND
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(43 to 46)
						return BODY_ZONE_PRECISE_L_HAND
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(22 to 23)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(41 to 46)
						return BODY_ZONE_L_ARM
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(24 to 29)
				switch(icon_x)
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(28 to 38)
						return BODY_ZONE_PRECISE_STOMACH
					if(41 to 46)
						return BODY_ZONE_L_ARM
			if(30 to 37)
				switch(icon_x)
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(27 to 39)
						return BODY_ZONE_CHEST
					if(41 to 46)
						return BODY_ZONE_L_ARM
			if(38 to 39)
				switch(icon_x)
					if(30 to 36)
						return BODY_ZONE_PRECISE_NECK
			if(40 to 43)
				switch(icon_x)
					if(28 to 38)
						if(icon_y == 40)
							if(icon_x in 30 to 36)
								return BODY_ZONE_PRECISE_NECK
						if(icon_y in 41 to 43)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_MOUTH
						return BODY_ZONE_HEAD
			if(44 to 47)
				switch(icon_x)
					if(26 to 27)
						return BODY_ZONE_PRECISE_EARS
					if(28 to 38)
						if(icon_y in 44 to 46)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						if(icon_y == 47)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						return BODY_ZONE_HEAD
					if(39 to 40)
						return BODY_ZONE_PRECISE_EARS
			if(48 to 51)
				switch(icon_x)
					if(28 to 38)
						if(icon_y in 48 to 49)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 50 to 51)
							if(icon_x in 30 to 36)
								return BODY_ZONE_PRECISE_SKULL
						return BODY_ZONE_HEAD
			if(52)
				if(icon_x in 30 to 36)
					return BODY_ZONE_PRECISE_SKULL

/atom/movable/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(user != hud?.mymob)
		return

	if(choice != hud.mymob.zone_selected)
		hud.mymob.select_zone(choice)
		update_appearance(UPDATE_OVERLAYS)

	return TRUE

/atom/movable/screen/zone_sel/update_overlays()
	. = ..()
	if(!hud?.mymob)
		return

	icon_state = "[hud.mymob.gender == "male" ? "m" : "f"]-zone_sel"

	if(hud.mymob.stat != DEAD && ishuman(hud.mymob))
		var/mob/living/carbon/human/H = hud.mymob
		var/list/missing_bodyparts_zones = H.get_missing_limbs()
		for(var/obj/item/bodypart/BP as anything in H.bodyparts)
			if(BP.body_zone in missing_bodyparts_zones)
				continue
			if(HAS_TRAIT(H, TRAIT_NOPAIN))
				var/mutable_appearance/limby = mutable_appearance('icons/mob/roguehud64.dmi', "[H.gender == "male" ? "m" : "f"]-[BP.body_zone]")
				limby.color = "#78a8ba"
				. += limby
				continue
			var/damage = BP.burn_dam + BP.brute_dam
			if(damage > BP.max_damage)
				damage = BP.max_damage
			var/comparison = (damage/BP.max_damage)
			. += mutable_appearance('icons/mob/roguehud64.dmi', "[H.gender == "male" ? "m" : "f"]-[BP.body_zone]") //apply healthy limb
			var/mutable_appearance/limby = mutable_appearance('icons/mob/roguehud64.dmi', "[H.gender == "male" ? "m" : "f"]w-[BP.body_zone]") //apply wounded overlay
			limby.alpha = (comparison*255)*2
			. += limby
			if(BP.get_bleed_rate())
				. += mutable_appearance('icons/mob/roguehud64.dmi', "[H.gender == "male" ? "m" : "f"]-[BP.body_zone]-bleed") //apply healthy limb
		for(var/X in missing_bodyparts_zones)
			var/mutable_appearance/limby = mutable_appearance('icons/mob/roguehud64.dmi', "[H.gender == "male" ? "m" : "f"]-[X]") //missing limb
			limby.color = "#2f002f"
			. += limby

	. += mutable_appearance(overlay_icon, "[hud.mymob.gender == "male" ? "m" : "f"]_[hud.mymob.zone_selected]")

/atom/movable/screen/flash
	name = "flash"
	icon_state = "blank"
	blend_mode = BLEND_ADD
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = FLASH_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/damageoverlay
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "oxydamageoverlay0"
	name = "dmg"
	blend_mode = BLEND_MULTIPLY
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/healths
	name = "health"
	icon_state = "health0"
	screen_loc = ui_health

/atom/movable/screen/healthdoll
	name = "health doll"
	screen_loc = rogueui_targetdoll

/atom/movable/screen/healthdoll/Click(location, control, params)
	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.check_for_injuries(H)
		to_chat(H, "I am [H.get_encumbrance() * 100]% encumbered.")

/atom/movable/screen/party_member_health
	name = "party_health"
	icon = 'icons/mob/rogueheat.dmi'
	icon_state = "dam0"
	screen_loc = "WEST:28,CENTER-1:15"

	var/member_key
	var/mob/member
	var/datum/party/party

/atom/movable/screen/party_member_health/Destroy()
	if(member)
		UnregisterSignal(member, COMSIG_MOB_HEALTHHUD_UPDATE)
	member = null
	party = null
	return ..()

/atom/movable/screen/party_member_health/proc/set_party_member(mob/mob, datum/party/incoming_party)
	member = mob
	party = incoming_party
	RegisterSignal(member, COMSIG_MOB_HEALTHHUD_UPDATE, PROC_REF(update_info))

/atom/movable/screen/party_member_health/proc/update_info(incoming_state)
	icon_state = incoming_state


/atom/movable/screen/party_member_name
	name = "party_member_name"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "blank"
	screen_loc = "EAST-1,CENTER-1:15"
	maptext_width = 128
	maptext_height = 48
	maptext_x = -64
	maptext_y = 0
	var/member_key
	var/mob/member
	var/datum/party/party

/atom/movable/screen/party_member_name/proc/set_party_member(mob/mob, datum/party/incoming_party, rank = "Recruit")
	member = mob
	party = incoming_party
	member_key = mob.ckey
	var/display_name = mob.real_name || mob.name

	maptext = MAPTEXT({"<div style="text-align: left; font-family: 'Small Fonts'; font-size: 7px; color: #FFFFFF; text-shadow: 1px 1px 0px #000000;">\
		<div style="color: #FFFFFF;">[display_name]</div>\
		<div style="color: #FFD700; margin-top: 1px;">[rank]</div>\
	</div>"})

/atom/movable/screen/party_member_name/Destroy()
	member = null
	party = null
	return ..()

/atom/movable/screen/mood
	name = "mood"
	icon_state = "mood5"
	screen_loc = null

/atom/movable/screen/healths/blood
	name = "life"
	icon_state = "blood100"
	screen_loc = rogueui_blood
	icon = 'icons/mob/rogueheat.dmi'

/atom/movable/screen/healths/blood/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(ishuman(usr))
		var/mob/living/carbon/human/user_mob = usr
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			user_mob.check_for_injuries(user_mob)
			to_chat(user_mob, "I am [user_mob.get_encumbrance() * 100]% encumbered.")
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(!user_mob.mind)
				return
			if(length(user_mob.mind.known_people))
				user_mob.mind.display_known_people(user_mob)
			else
				to_chat(user_mob, "<span class='warning'>I don't know anyone.</span>")
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			if(!user_mob.mind)
				return
			user_mob.make_acquaintance()

/atom/movable/screen/splash
	icon = 'icons/blank_title.png'
	icon_state = ""
	screen_loc = "1,1"
	plane = SPLASHSCREEN_PLANE
	var/client/holder
	var/fucme = TRUE

/atom/movable/screen/splash/credits
	icon = 'icons/fullblack.dmi'
	icon_state = ""
	screen_loc = ui_backhudl
	plane = SPLASHSCREEN_PLANE
	fucme = FALSE

/atom/movable/screen/splash/Initialize(mapload, datum/hud/hud_owner, client/client, visible, use_previous_title)
	. = ..()

	holder = client

	if(!visible)
		alpha = 0

	if(fucme)
		if(!use_previous_title)
			if(SStitle.icon)
				icon = SStitle.icon
		else
			if(!SStitle.previous_icon)
				qdel(src)
				return
			icon = SStitle.previous_icon

	holder.screen += src

/atom/movable/screen/splash/Destroy()
	if(holder)
		holder.screen -= src
		holder = null
	return ..()

/atom/movable/screen/splash/proc/Fade(out, qdel_after = TRUE)
	if(QDELETED(src))
		return
	if(out)
		animate(src, alpha = 0, time = 30)
	else
		alpha = 0
		animate(src, alpha = 255, time = 30)
	if(qdel_after)
		QDEL_IN(src, 30)

/atom/movable/screen/gameover
	icon = 'icons/gameover.dmi'
	icon_state = ""
	screen_loc = ui_backhudl
	plane = SPLASHSCREEN_PLANE

/atom/movable/screen/gameover/proc/Fade(out = FALSE, qdel_after = FALSE)
	if(QDELETED(src))
		return
	if(out)
		animate(src, alpha = 0, time = 30, flags = ANIMATION_PARALLEL)
	else
		alpha = 0
		animate(src, alpha = 255, time = 30, flags = ANIMATION_PARALLEL)
	if(qdel_after)
		QDEL_IN(src, 30)


/atom/movable/screen/gameover/hog
	icon_state = "hog"
	alpha = 0

/atom/movable/screen/gameover/hog/Fade(out = FALSE, qdel_after = FALSE)
	if(QDELETED(src))
		return
//	icon_state = "blank"
//	var/image/MA = image(icon, "hog")
//	MA.alpha = 0
//	add_overlay(MA)
//	animate(MA, alpha = 255, time = 30)
	if(!out)
		animate(src, alpha = 255, time = 30, flags = ANIMATION_PARALLEL)
	else
		animate(src, alpha = 0, time = 30, flags = ANIMATION_PARALLEL)
		QDEL_IN(src, 30)

/atom/movable/screen/component_button
	var/atom/movable/screen/parent

/atom/movable/screen/component_button/Initialize(mapload, datum/hud/owner_hud, atom/movable/screen/parent)
	. = ..()
	src.parent = parent

/atom/movable/screen/component_button/Click(location, control, params)
	if(parent)
		parent.component_click(src, params)

//Roguehud objects

/atom/movable/screen/backhudl
	icon = 'icons/mob/roguehudback2.dmi'
	icon_state = ""
	name = " "
	screen_loc = ui_backhudl
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/backhudl/Click()
	return

/atom/movable/screen/backhudl/ghost
	icon_state = "dead"
	icon = 'icons/mob/roguehudbackghost.dmi'

/atom/movable/screen/backhudl/obs
	icon_state = "obs"
	icon = 'icons/mob/roguehudbackghost.dmi'

/atom/movable/screen/aim
	name = ""
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "aimbg"
	plane = HUD_PLANE

/atom/movable/screen/stress
	name = "sanity"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "stressback"

/atom/movable/screen/stress/update_overlays()
	. = ..()
	var/state2use = "stress1"
	if(!hud?.mymob)
		. += state2use
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(!HAS_TRAIT(H, TRAIT_NOMOOD))
		var/stress_amt = H.get_stress_amount()
		if(stress_amt >= STRESS_BAD)
			state2use = "stress2"
		if(stress_amt >= STRESS_VBAD)
			state2use = "stress3"
		if(stress_amt == STRESS_INSANE)
			state2use = "stress4"
		if(stress_amt >= STRESS_INSANE)
			state2use = "stress5"
	if(H.has_status_effect(/datum/status_effect/buff/drunk) || H.has_status_effect(/datum/status_effect/buff/druqks))
		state2use = "mood_drunk"
	if(H.InFullCritical())
		state2use = "mood_fear"
	if(H.stat == DEAD || H.mind?.has_antag_datum(/datum/antagonist/zombie))
		state2use = "mood_dead"
	. += state2use

/atom/movable/screen/stress/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(ishuman(usr))
		var/mob/living/carbon/human/M = usr
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			to_chat(M, "*----*")
			for(var/datum/quirk/vice/vices in M.quirks)
				to_chat(M, span_info("[vices.get_desc()]"))
			to_chat(M, "*--------*")
			if(!length(M.stressors))
				to_chat(M, span_info("I'm not feeling much of anything right now."))
			for(var/datum/stress_event/stress_event in M.stressors)
				if(!stress_event.can_show())
					continue
				var/count = stress_event.stacks
				var/ddesc = islist(stress_event.desc) ? pick(stress_event.desc) : stress_event.desc
				if(count > 1)
					to_chat(M, "• [ddesc] (x[count])")
				else
					to_chat(M, "• [ddesc]")
			to_chat(M, "*--------*")
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(M.get_triumphs() <= 0)
				to_chat(M, "<span class='warning'>I haven't TRIUMPHED.</span>")
				return
			if(alert("Do you want to remember a TRIUMPH?", "", "Yes", "No") == "Yes")
				if(M.add_stress(/datum/stress_event/triumph))
					M.adjust_triumphs(-1)
					M.playsound_local(M, 'sound/misc/notice (2).ogg', 100, FALSE)


/atom/movable/screen/rmbintent
	name = "alt intents"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "rmbintent"
	var/list/shown_intents = list()
	var/showing = FALSE

/atom/movable/screen/rmbintent/update_overlays()
	. = ..()
	if(!isliving(hud?.mymob))
		return
	var/mob/living/L = hud.mymob
	if(!L.rmb_intent)
		return
	. += "[L.rmb_intent.icon_state]_x"
	name = L.rmb_intent.name
	desc = L.rmb_intent.desc

/atom/movable/screen/rmbintent/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/M = usr
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			if(showing)
				collapse_intents()
			else
				show_intents(M)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			if(M.rmb_intent)
				to_chat(M, "<span class='info'>* --- *</span>")
				to_chat(M, "<span class='info'>[name]: [desc]</span>")
				to_chat(M, "<span class='info'>* --- *</span>")

/atom/movable/screen/rmbintent/proc/collapse_intents()
	if(!showing)
		return
	showing = FALSE
	QDEL_LIST(shown_intents)
	update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/rmbintent/proc/show_intents(mob/living/M)
	if(showing)
		return
	if(!M)
		return
	showing = TRUE
	var/cnt
	var/i = 15
	var/they = 0.02
	for(var/X in M.possible_rmb_intents)
		if(M.rmb_intent?.type == X)
			continue
		var/atom/movable/screen/rintent_selection/R = new(null, M.hud_used, M.client)
		var/datum/rmb_intent/RI = new X
		R.stored_intent = X
		R.icon_state = RI.icon_state
		R.name = RI.name
		R.desc = RI.desc
		shown_intents += R
		R.screen_loc = "WEST-4:0,SOUTH+8:[i]"
		R.layer = layer+they
		i += 15
		they += 0.01
		cnt++
	if(!cnt)
		showing = FALSE

/atom/movable/screen/rmbintent/Destroy()
	QDEL_LIST(shown_intents)
	. = ..()

/atom/movable/screen/rintent_selection
	name = "rmb intent"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "rmbaimed"
	var/stored_intent
	var/stored_name
	var/client/holder

/atom/movable/screen/rintent_selection/Initialize(mapload, datum/hud/hud_owner, client/client)
	. = ..()
	if(client)
		holder = client
	holder.screen += src

/atom/movable/screen/rintent_selection/Destroy()
	if(holder)
		holder.screen -= src
		holder = null
	return ..()

/atom/movable/screen/rintent_selection/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/M = usr
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			if(stored_intent)
				M.swap_rmb_intent(type = stored_intent)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			to_chat(M, "<span class='info'>* --- *</span>")
			to_chat(M, "<span class='info'>[name]: [desc]</span>")
			to_chat(M, "<span class='info'>* --- *</span>")

/mob/living/proc/swap_rmb_intent(type, num)
	if(!possible_rmb_intents?.len)
		return
	if(type)
		if(type in possible_rmb_intents)
			rmb_intent = new type()
			if(hud_used?.rmb_intent)
				hud_used.rmb_intent.update_appearance(UPDATE_OVERLAYS)
				hud_used.rmb_intent.collapse_intents()
	if(num)
		if(possible_rmb_intents.len < num)
			return
		var/A = possible_rmb_intents[num]
		if(A)
			rmb_intent = new A()
			if(hud_used?.rmb_intent)
				hud_used.rmb_intent.update_appearance(UPDATE_OVERLAYS)
				hud_used.rmb_intent.collapse_intents()

/// Cycles through right-mouse-button intents. Loops.
/mob/living/proc/cycle_rmb_intent()
	if(!length(possible_rmb_intents))
		return

	// Find the index of the current intent
	var/index = possible_rmb_intents.Find(rmb_intent.type)
	var/A

	if(index == -1)
		A = possible_rmb_intents[1]
	else
		index = (index % length(possible_rmb_intents)) + 1
		A = possible_rmb_intents[index]
	rmb_intent = new A()

	if(hud_used?.rmb_intent)
		hud_used.rmb_intent.update_appearance(UPDATE_OVERLAYS)
		hud_used.rmb_intent.collapse_intents()

/atom/movable/screen/time
	name = "Astrata"
	icon = 'icons/time.dmi'
	icon_state = "day"

/atom/movable/screen/time/update_icon_state()
	icon_state = GLOB.tod
	return ..()

/atom/movable/screen/time/update_name()
	switch(GLOB.tod)
		if("day")
			name = "Astrata"
		if("dusk")
			name = "Astrata - Dusk"
		if("night")
			name = "Noc"
		if("dawn")
			name = "Astrata - Dawn"
	return ..()

/atom/movable/screen/time/update_overlays()
	. = ..()
	if(SSParticleWeather.runningWeather.target_trait == PARTICLEWEATHER_RAIN)
		. += "rainlay"

/atom/movable/screen/mana
	name = "Mana Pool"
	icon_state = "mana100"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = mana_loc

/atom/movable/screen/mana/extra_info(mob/user)
	var/info = ""
	for(var/datum/attunement/attunement as anything in user?.mana_pool.attunements)
		var/value = user.mana_pool.attunements[attunement]
		if(!value)
			continue

		switch(value)
			if(0.01 to 0.4)
				info += "<br> Minor [initial(attunement.name)] Attunment"
			if(0.41 to 0.7)
				info += "<br> Moderate [initial(attunement.name)] Attunment"
			if(0.71 to 1.2)
				info += "<br> Major [initial(attunement.name)] Attunment"
			if(1.21 to INFINITY)
				info += "<br> Apex [initial(attunement.name)] Attunment"

	return info

/atom/movable/screen/vis_holder
	icon = ""
	invisibility = INVISIBILITY_MAXIMUM

/atom/movable/screen/stamina
	name = "stamina"
	icon_state = "fat100"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = stamina_loc

/atom/movable/screen/energy
	name = "energy"
	icon_state = "stam100"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = stamina_loc

/atom/movable/screen/heatstamover
	name = ""
	mouse_opacity = 0
	icon_state = "heatstamover"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = stamina_loc
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/mana_over
	name = ""
	mouse_opacity = 0
	icon_state = "manaover"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = mana_loc
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/scannies
	icon = 'icons/mob/roguehudback2.dmi'
	icon_state = "crt"
	name = ""
	screen_loc = ui_backhudl
	mouse_opacity = 0
	alpha = 0
	plane = HUD_PLANE
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/char_preview
	name = "Me."
	icon_state = ""

#define READ_RIGHT 1
#define READ_LEFT 2
#define READ_BOTH 3

/atom/movable/screen/read
	icon = 'icons/roguetown/hud/read.dmi'
	icon_state = ""
	name = ""
	screen_loc = "1,1"
	plane = HUD_PLANE
	alpha = 0
	var/atom/movable/screen/readtext/textright
	var/atom/movable/screen/readtext/textleft
	var/reading

/atom/movable/screen/read/Destroy()
	. = ..()
	textleft = null
	textright = null

/atom/movable/screen/read/Click(location, control, params)
	. = ..()
	destroy_read()
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	user << browse(null, "window=reading")

/atom/movable/screen/read/proc/destroy_read()
	if(textright)
		textright.alpha = 0
		textleft.maptext = null
	if(textleft)
		textleft.alpha = 0
		textleft.maptext = null
	alpha = 0
	icon_state = ""
	reading = FALSE

/atom/movable/screen/read/proc/show()
	alpha = 255
	reading = TRUE

/atom/movable/screen/read/proc/show_text(input)
	reading = TRUE
	animate(src, alpha = 255, time = 5, easing = EASE_IN)
	if(input == READ_RIGHT)
		animate(textright, alpha = 255, time = 5, easing = EASE_IN)
		textleft.alpha = 0
	if(input == READ_LEFT)
		textright.alpha = 0
		animate(textleft, alpha = 255, time = 5, easing = EASE_IN)
	if(input == READ_BOTH)
		animate(textleft, alpha = 255, time = 5, easing = EASE_IN)
		animate(textright, alpha = 255, time = 5, easing = EASE_IN)

#undef READ_RIGHT
#undef READ_LEFT
#undef READ_BOTH

/atom/movable/screen/readtext
	name = ""
	icon = null
	icon_state = ""
	screen_loc = "5,5"
	plane = ABOVE_HUD_PLANE
	plane = HUD_PLANE

/atom/movable/screen/area_text
	icon = null
	icon_state = ""
	name = ""
	screen_loc = "5,5"
	plane = ABOVE_HUD_PLANE
	plane = HUD_PLANE
	alpha = 0
	var/reading

/atom/movable/screen/daynight
	icon = 'icons/time.dmi'
	icon_state = ""
	screen_loc = "EAST-2:-14,CENTER-6:16"

/atom/movable/screen/daynight/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	icon_state = GLOB.tod

/atom/movable/screen/bloodpool
	appearance_flags = KEEP_TOGETHER
	icon_state = "empty"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_vitae
	var/width = 4
	var/height = 43
	var/orientation = NORTH
	var/atom/movable/screen/bloodpool_maskpart/background
	var/atom/movable/screen/bloodpool_maskpart/foreground
	var/atom/movable/screen/bloodpool_maskpart/fill
	var/atom/movable/screen/bloodpool_maskpart/mask

/atom/movable/screen/bloodpool/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	foreground = new /atom/movable/screen/bloodpool_maskpart/foreground(null, hud_owner, icon, src)
	background = new /atom/movable/screen/bloodpool_maskpart/background(null, hud_owner, icon, src)
	fill = new /atom/movable/screen/bloodpool_maskpart/fill(null, hud_owner, icon, src)
	mask = new /atom/movable/screen/bloodpool_maskpart/mask(null, hud_owner, icon, src)

	background.vis_contents += fill
	mask.vis_contents += background
	vis_contents.Add(mask, foreground)

/atom/movable/screen/bloodpool/Destroy()
	QDEL_NULL(background)
	QDEL_NULL(foreground)
	QDEL_NULL(fill)
	QDEL_NULL(mask)
	return ..()

/atom/movable/screen/bloodpool/proc/set_fill_color(new_color = "#ffffff")
	fill.color = new_color

/atom/movable/screen/bloodpool/proc/set_value(ratio = 1.0, duration = 0)
	//constrain the ratio between 0 and 1
	ratio = min(max(ratio,0),1)

	//apply orientation factors for fill bar offsets
	var/fx = 0, fy = 0
	switch(orientation)
		if(EAST)
			fx = -1
		if(WEST)
			fx = 1
		if(SOUTH)
			fy = 1
		if(NORTH)
			fy = -1

	//calculate the offset of the fill bar.
	var/invratio = 1-ratio
	var/epx = width * invratio * fx
	var/epy = height * invratio * fy

	//apply the offset to the fill bar
	if(duration)
		//if a time value has been supplied, animate the transition from the current position
		animate(fill, pixel_w = epx,pixel_z = epy, time = duration)
	else
		//if a time value has not been supplied, instantly set to the new position
		fill.pixel_w = epx
		fill.pixel_z = epy

	animate(fill, time = duration)

/atom/movable/screen/bloodpool_maskpart
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE
	/// Ref to our parent screem, purely for examine purposes
	var/atom/movable/screen/parent_screen

/atom/movable/screen/bloodpool_maskpart/Initialize(mapload, datum/hud/owner_hud, icon, parent_screen)
	. = ..()
	src.icon = icon
	src.parent_screen = parent_screen

/atom/movable/screen/bloodpool_maskpart/examine_ui(mob/user)
	return parent_screen?.examine_ui(user)

/atom/movable/screen/bloodpool_maskpart/Destroy()
	parent_screen = null
	return ..()

/atom/movable/screen/bloodpool_maskpart/background
	icon_state = "mana_bg"
	appearance_flags = KEEP_TOGETHER
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/bloodpool_maskpart/foreground
	icon_state = "mana_fg"

/atom/movable/screen/bloodpool_maskpart/fill
	icon_state = "mana_fill"

/atom/movable/screen/bloodpool_maskpart/mask
	icon_state = "mana_mask"
