//Organ storage component, used in surgeries
/datum/component/storage/concrete/organ
	rustle_sound = list('sound/gore/organ1.ogg', 'sound/gore/organ2.ogg')
	attack_hand_interact = FALSE
	max_items = 99 //this doesn't actually matter
	max_combined_w_class = 99 //this doesn't actually matter
	max_w_class = WEIGHT_CLASS_GIGANTIC //this doesn't actually matter
	allow_big_nesting = TRUE //this doesn't actually matter
	var/obj/item/bodypart/bodypart_affected
	var/generated_chimeric = FALSE

// Unregister signals we don't want
/datum/component/storage/concrete/organ/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	boxes?.icon = 'icons/hud/screen_organ.dmi'
	boxes?.icon_state = "organ_block"
	if(boxes)
		var/image/ribs = image(boxes.icon, boxes, "[boxes.icon_state]_overlay", boxes.layer+1)
		ribs.plane = ABOVE_HUD_PLANE
		boxes.add_overlay(ribs)
	closer?.icon = 'icons/hud/screen_organ.dmi'
	closer?.icon_state = "organ_close"
	UnregisterSignal(parent, list(COMSIG_MOUSEDROPPED_ONTO, COMSIG_CLICK_ALT, \
							COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_HAND_SECONDARY, \
							COMSIG_ITEM_PRE_ATTACK, COMSIG_ITEM_ATTACK_SELF, \
							COMSIG_ITEM_PICKUP, COMSIG_ATOM_ATTACKBY, COMSIG_ATOM_ATTACK_GHOST, \
							COMSIG_ATOM_ATTACKBY))
	var/mob/living/carbon/C = parent
	if(length(C.bodyparts) && isbodypart(C.bodyparts[1]))
		assign_bodypart(C.bodyparts[1])

//No real location
/datum/component/storage/concrete/organ/Destroy()
	for(var/atom/atom in contents())
		atom.mouse_opacity = initial(atom.mouse_opacity)
	return ..()

// Assign a bodypart to be affected
/datum/component/storage/concrete/organ/proc/assign_bodypart(obj/item/bodypart/new_bodypart)
	if(bodypart_affected)
		UnregisterSignal(bodypart_affected, COMSIG_BODYPART_WOUND_REMOVED)
	bodypart_affected = new_bodypart
	RegisterSignal(bodypart_affected, COMSIG_BODYPART_WOUND_REMOVED, PROC_REF(update_viewers))

/datum/component/storage/concrete/organ/proc/update_viewers()
	if(is_accessible(parent))
		return FALSE

	for(var/mob/mob in is_using)
		hide_from(mob)

// Gives all organs parent as stored_in
/datum/component/storage/concrete/organ/proc/update_insides()
	for(var/obj/item/I in contents())
		I.stored_in = parent

// Revert the opacity proper
/datum/component/storage/concrete/organ/Destroy()
	for(var/atom/_A in contents())
		_A.mouse_opacity = initial(_A.mouse_opacity)
	for(var/obj/item/I in contents())
		I.stored_in = null
		UnregisterSignal(I, COMSIG_CLICK)
	bodypart_affected = null
	return ..()

// Check if we are accessible
/datum/component/storage/concrete/organ/proc/is_accessible()
	. = FALSE
	if(bodypart_affected)
		var/surgery_flags = bodypart_affected.get_surgery_flags()
		return CHECK_MULTIPLE_BITFIELDS(surgery_flags, SURGERY_INCISED|SURGERY_RETRACTED)
	else
		return TRUE

/datum/component/storage/concrete/organ/on_move()
	var/atom/A = parent
	for(var/mob/living/L in can_see_contents())
		if(!L.CanReach(A))
			hide_from(L)

// Only visible when accessible
/datum/component/storage/concrete/organ/user_show_to_mob(mob/M, force = FALSE)
	if(!is_accessible() && !force)
		return
	return ..()

// Can only insert organs or cavity implants depending on a few conditions
/datum/component/storage/concrete/organ/handle_item_insertion(obj/item/storing, prevent_warning = FALSE, mob/user, datum/component/storage/remote, params, storage_click = FALSE)
	var/datum/component/storage/concrete/master = master()
	var/atom/parent = src.parent
	var/moved = FALSE
	if(!istype(storing))
		return FALSE
	if(user)
		if(!user.temporarilyRemoveItemFromInventory(storing))
			return FALSE
		else
			moved = TRUE //At this point if the proc fails we need to manually move the object back to the turf/mob/whatever.
	if(storing.pulledby)
		storing.pulledby.stop_pulling()
	if(silent)
		prevent_warning = TRUE
	if(!_insert_physical_item(storing, user = user))
		if(moved)
			if(user)
				if(!user.put_in_active_hand(storing))
					storing.forceMove(parent.drop_location())
			else
				storing.forceMove(parent.drop_location())
		return FALSE
	storing.on_enter_storage(master)
	storing.item_flags |= IN_STORAGE
	refresh_mob_views()
	storing.mouse_opacity = MOUSE_OPACITY_OPAQUE //So you can click on the area around the item to equip it, instead of having to pixel hunt
	if(user)
		if(user.client && user.active_storage != src)
			user.client.screen -= storing
		if(user.observers && length(user.observers))
			for(var/i in user.observers)
				var/mob/dead/observe = i
				if(observe.client && observe.active_storage != src)
					observe.client.screen -= storing
		if(!remote)
			parent.add_fingerprint(user)
			if(!prevent_warning)
				mob_item_insertion_feedback(usr, user, storing)
	playsound(storing, pick(rustle_sound), 50, 1, -5)
	update_insides()
	update_icon()
	return TRUE

// Don't play the default rustle sound PLEASE - Also, use the bodypart too to give better feedback
/datum/component/storage/concrete/organ/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override = FALSE)
	if(silent && !override)
		return
	for(var/mob/viewing in fov_viewers(world.view, user))
		if(M == viewing)
			to_chat(usr, span_notice("I put [I] [insert_preposition]to [parent]'s [bodypart_affected]."))
		else if(in_range(M, viewing)) //If someone is standing close enough, they can tell what it is...
			viewing.show_message(span_notice("<b>[M]</b> puts [I] [insert_preposition]to [parent]'s [bodypart_affected]."), MSG_VISUAL)
		else if(I?.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
			viewing.show_message(span_notice("<b>[M]</b> puts [I] [insert_preposition]to [parent]'s [bodypart_affected]."), MSG_VISUAL)

// Return the proper organ list
/datum/component/storage/concrete/organ/contents()
	if(!bodypart_affected)
		var/mob/living/carbon/carbon_parent = parent
		var/list/return_list = list()
		if(LAZYLEN(carbon_parent.internal_organs))
			return_list |= carbon_parent.internal_organs
		return return_list
	else
		var/list/return_list = list()
		var/list/organs = bodypart_affected.get_organs()
		if(LAZYLEN(organs))
			return_list |= bodypart_affected.get_organs()
		if(LAZYLEN(bodypart_affected.cavity_items))
			return_list |= bodypart_affected.cavity_items
		return return_list

// No real location
/datum/component/storage/concrete/organ/hide_from(mob/M)
	if(!M.client)
		return TRUE
	M.client.screen -= boxes
	M.client.screen -= closer
	for(var/obj/item/thing in contents())
		M.client.screen -= thing
	if(M.active_storage == src)
		M.active_storage = null
	LAZYREMOVE(is_using, M)
	return TRUE

// No real location
/datum/component/storage/concrete/organ/show_to(mob/M)
	if(!M.client)
		return FALSE
	if(M.active_storage != src && (M.stat == CONSCIOUS))
		for(var/obj/item/I in contents())
			if(I.on_found(M))
				return FALSE
	if(M.active_storage)
		M.active_storage.hide_from(M)
	orient2hud()
	M.client.screen |= boxes
	M.client.screen |= closer
	for(var/obj/item/thing in contents())
		M.client.screen |= thing
	M.active_storage = src
	LAZYOR(is_using, M)
	return TRUE

// No real location
/datum/component/storage/concrete/organ/orient2hud()
	var/adjusted_contents = length(contents())

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_numerical_stacking)
		numbered_contents = _process_numerical_display()
		adjusted_contents = length(numbered_contents)

	var/rows = clamp(max_items, 1, screen_max_rows)
	var/columns = clamp(CEILING(adjusted_contents / rows, 1), 1, screen_max_columns)
	standard_orient_objs(rows, columns, numbered_contents)

//No real location
/datum/component/storage/concrete/organ/standard_orient_objs(rows, cols, list/obj/item/numerical_display_contents)
	boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+cols-1]:[screen_pixel_x],[screen_start_y-rows+1]:[screen_pixel_y]"
	var/cx = screen_start_x
	var/cy = screen_start_y
	if(islist(numerical_display_contents))
		for(var/type in numerical_display_contents)
			var/datum/numbered_display/ND = numerical_display_contents[type]
			ND.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			ND.sample_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			ND.sample_object.maptext = MAPTEXT("<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>")
			ND.sample_object.plane = ABOVE_HUD_PLANE
			cy--
			if(screen_start_y - cy >= rows)
				cy = screen_start_y
				cx++
				if(cx - screen_start_x >= cols)
					break
	else
		for(var/obj/O in contents())
			if(QDELETED(O))
				continue
			O.mouse_opacity = MOUSE_OPACITY_OPAQUE //This is here so storage items that spawn with contents correctly have the "click around item to equip"
			O.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			O.maptext = ""
			O.plane = ABOVE_HUD_PLANE
			cy--
			if(screen_start_y - cy >= rows)
				cy = screen_start_y
				cx++
				if(cx - screen_start_x >= cols)
					break
	closer.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y+1]:[screen_pixel_y]"

// No real location
/datum/component/storage/concrete/organ/can_be_inserted(obj/item/I, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	if(!istype(I) || (I.item_flags & ABSTRACT) || !is_accessible(parent))
		return FALSE //Not an item
	if(I == parent)
		return FALSE //no paradoxes for you
	if(!user.used_intent.type == INTENT_HELP)
		return FALSE //must be on grab intent
	var/organ_volume = bodypart_affected?.get_cavity_volume()
	var/obj/item/organ/O = I
	if(!istype(O) && bodypart_affected && ((organ_volume + I.w_class > bodypart_affected.max_cavity_volume) || (I.w_class > bodypart_affected.max_cavity_item_size)) )
		if(!stop_messages)
			to_chat(user, span_warning("\The [bodypart_affected ? bodypart_affected : "<b>[parent]</b>"] cannot hold [I]!"))
		return FALSE
	else if(istype(O) && bodypart_affected && !((bodypart_affected.body_zone in O.possible_zones) || (organ_volume + O.organ_volume > bodypart_affected.max_cavity_volume)) )
		if(!stop_messages)
			to_chat(user, span_warning("\The [bodypart_affected ? bodypart_affected : "<b>[parent]</b>"] cannot hold [O]!"))
		return FALSE
	var/atom/host = parent
	if(I in contents())
		return FALSE //Means the item is already in the storage
	if(is_type_in_typecache(I, cant_hold)) //Check for specific items which this container can't hold.
		if(!stop_messages)
			to_chat(user, span_warning("[host] cannot hold [I]!"))
		return FALSE
	if(HAS_TRAIT(I, TRAIT_NODROP)) //SHOULD be handled in unEquip, but better safe than sorry.
		to_chat(user, span_warning("\The [I] is stuck to your hand, you can't put it in \the [host]!"))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.slave_can_insert_object(src, I, stop_messages, user)

// No real location
/datum/component/storage/concrete/organ/_insert_physical_item(obj/item/I, override = FALSE, mob/living/user)
	. = FALSE
	var/obj/item/organ/O = I
	if(istype(O))
		if(!(O in contents()))
			var/mob/living/carbon/carbon_parent = parent
			O.forceMove(bodypart_affected)
			O.Insert(carbon_parent, new_zone = user.zone_selected)
			update_insides()
	else
		if(!(I in contents()))
			if(istype(I, /obj/item/mob_holder))
				var/obj/item/mob_holder/holder = I
				holder.organ_stored = bodypart_affected
				I.forceMove(bodypart_affected.owner)
			else
				I.forceMove(bodypart_affected)
			LAZYADD(bodypart_affected.cavity_items, I)
			update_insides()

	refresh_mob_views()
	return TRUE

// No real location
/datum/component/storage/concrete/organ/attackby(datum/source, obj/item/I, mob/M, params)
	. = TRUE //no afterattack
	if(!can_be_inserted(I, FALSE, M))
		return FALSE
	handle_item_insertion(I, FALSE, M)

// No real location
/datum/component/storage/concrete/organ/remaining_space_items()
	return TRUE

//No real location
/datum/component/storage/concrete/organ/signal_take_obj(datum/source, atom/movable/AM, new_loc, force = FALSE)
	if(!(AM in contents()))
		return FALSE
	return remove_from_storage(AM, new_loc)

// No real location
/datum/component/storage/concrete/organ/on_contents_del(datum/source, atom/A)
	if(A in contents())
		usr = null
		remove_from_storage(A, null)


// Deal with cavity items and organs appropriately
/datum/component/storage/concrete/organ/remove_from_storage(atom/movable/AM, atom/new_location)
	if(!is_accessible(parent))
		return FALSE
	var/obj/item/organ/O = AM
	if(istype(O))
		if(!CHECK_BITFIELD(O.organ_flags, ORGAN_CUT_AWAY))
			return FALSE
	. = ..()
	if(.)
		AM.mouse_opacity = initial(AM.mouse_opacity)
		if(!istype(O))
			var/obj/item/cavity_item = AM
			if(length(bodypart_affected?.cavity_items) && (cavity_item in bodypart_affected.cavity_items))
				cavity_item.stored_in = null
				bodypart_affected.cavity_items -= cavity_item
			if(istype(cavity_item))
				cavity_item.stored_in = null
			update_insides()
			return
		var/mob/living/carbon/carbon_parent = parent
		if(!carbon_parent.IsUnconscious() && (carbon_parent.get_chem_effect(CE_PAINKILLER) < 50))
			carbon_parent.emote("scream")
			/*
			if(!CHECK_BITFIELD(O.organ_flags, ORGAN_CUT_AWAY))
				carbon_parent.custom_pain("MY [capitalize(O.name)] HURTS!", rand(30, 40))
			*/
		if(!CHECK_BITFIELD(O.organ_flags, ORGAN_CUT_AWAY))
			O.applyOrganDamage(rand(10, 20))
		O.stored_in = null
		O.Remove(O.owner, FALSE)
		O.organ_flags |= ORGAN_CUT_AWAY
		refresh_mob_views()
		playsound(O, pick(rustle_sound), 50, 1, -5)
		update_insides()

//AAAAAAAA
/datum/component/storage/concrete/organ/mousedrop_onto(datum/source, atom/over_object, mob/M)
	var/mob/A = parent
	A.add_fingerprint(M)
	if(!over_object)
		return FALSE
	// this must come before the screen objects only block, dunno why it wasn't before
	var/mob/living/L = M
	var/mob/living/carbon/carbon_mob = parent
	if(istype(L) && L.used_intent.type == INTENT_HELP)
		assign_bodypart(carbon_mob.get_bodypart(check_zone(L.zone_selected)))
		if(!generated_chimeric)
			if(istype(bodypart_affected, /obj/item/bodypart/chest))
				var/mob/living/carbon/carbon = parent
				var/amount = rand(1, 3)
				for(var/i = 1 to amount)
					var/atom/movable/new_atom = carbon.create_chimeric_node(FALSE)
					new_atom.forceMove(bodypart_affected)
					LAZYADD(bodypart_affected.cavity_items, new_atom)
				generated_chimeric = TRUE
	if(!istype(L) || !L.used_intent.type == INTENT_HELP || !is_accessible(L) || !bodypart_affected)
		return FALSE
	if(isliving(over_object) && (check_zone(L.zone_selected) == check_zone(bodypart_affected?.body_zone)))
		update_insides()
		user_show_to_mob(M)
		return COMPONENT_NO_MOUSEDROP

/// Signal handler for when we get attacked with secondary click by an item.
/datum/component/storage/concrete/organ/attackby_secondary(datum/source, atom/weapon, mob/user, list/modifiers)
	return
