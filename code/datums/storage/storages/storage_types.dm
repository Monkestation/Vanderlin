// These storages should be no_interface, as to not use the grid. This means they can only be accessed semi randomly
/datum/storage/no_interface/scabbard
	max_slots = 1
	rustle_sound = 'sound/foley/equip/scabbard_holster.ogg'
	max_specific_storage = WEIGHT_CLASS_BULKY
	quickdraw = TRUE
	insert_preposition = "in"

/datum/storage/no_interface/scabbard/set_parent(atom/new_parent)
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE, PROC_REF(update_icon_state))

/datum/storage/no_interface/scabbard/Destroy(force)
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE)
	return ..()

/datum/storage/no_interface/proc/update_icon_state(datum/source)
	if(!istype(parent))
		return

	parent.icon_state = initial(parent.icon_state)

	if(length(real_location.contents))
		var/obj/item/sheathed_weapon = real_location.contents[1]
		var/icon/possible_sheaths = icon(parent.icon) //hehe
		var/list/extensions = list()
		for(var/s in possible_sheaths.IconStates(1))
			extensions[s] = TRUE
		qdel(possible_sheaths)

		if(extensions[parent.icon_state + "_[sheathed_weapon.icon_state]"])
			parent.icon_state += "_[sheathed_weapon.icon_state]"
		else
			parent.icon_state += "-sheathed"

/datum/storage/no_interface/scabbard/knife/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife))

/datum/storage/no_interface/scabbard/sword/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword), list(/obj/item/weapon/sword/long/exe, /obj/item/weapon/sword/long/greatsword))

/datum/storage/no_interface/scabbard/daewalker/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword/long/daewalker))

/datum/storage/no_interface/scabbard/blackmeadow/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword/katana))

/datum/storage/no_interface/boots
	max_slots = 1
	rustle_sound = 'sound/foley/equip/scabbard_holster.ogg'
	max_specific_storage = WEIGHT_CLASS_SMALL
	quickdraw = TRUE
	insert_preposition = "in"

/datum/storage/no_interface/boots/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife, /obj/item/coin, /obj/item/key))

/datum/storage/no_interface/boots/set_parent(atom/new_parent)
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(equipped_stress), override = TRUE)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(unequipped_stress), override = TRUE)

/datum/storage/no_interface/boots/item_interact_insert(mob/living/user, obj/item/thing, list/modifiers)
	if(can_insert(thing, messages = TRUE))
		var/atom/boots = parent
		if(istype(thing, /obj/item/weapon/knife) && ishuman(boots?.loc))
			var/mob/living/carbon/human/unlucky = boots.loc
			if(unlucky.shoes == parent && prob(40 - max((GET_MOB_ATTRIBUTE_VALUE(unlucky, STAT_FORTUNE) * 4), 0)))
				var/cached_aim = user.zone_selected
				user.zone_selected = pick(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
				unlucky.attackby(thing, user, modifiers)
				to_chat(unlucky, span_danger("UNLUCKY! I've stabbed myself with [thing]!"))
				user.zone_selected = cached_aim

	return ..()

/datum/storage/no_interface/boots/attempt_insert(obj/item/to_insert, mob/user, override, force, messages, list/modifiers)
	. = ..()
	if(!.)
		return

	var/obj/item/clothing/shoes/boots = parent
	if(ishuman(boots?.loc))
		var/mob/living/carbon/human/uncomfy = boots.loc
		if(uncomfy.shoes != parent)
			return
		uncomfy.add_stress(/datum/stress_event/fullshoe)

/datum/storage/no_interface/boots/attempt_remove(obj/item/thing, atom/remove_to_loc, silent, visual_updates)
	. = ..()

	var/atom/boots = parent
	if(!ishuman(boots?.loc))
		return

	var/mob/living/carbon/human/uncomfy = boots.loc
	if(uncomfy.shoes != parent)
		return

	if(!length(return_inv(recursive = FALSE)))
		uncomfy.remove_stress(/datum/stress_event/fullshoe)

/datum/storage/no_interface/boots/proc/equipped_stress(datum/source, mob/user, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_SHOES)
		return

	var/obj/item/clothing/shoes/boots = parent
	if(ishuman(boots?.loc))
		var/mob/living/carbon/human/uncomfy = boots.loc
		if(uncomfy.shoes != parent)
			return
		uncomfy.add_stress(/datum/stress_event/fullshoe)

/datum/storage/no_interface/boots/proc/unequipped_stress(datum/source, mob/living/carbon/user)
	SIGNAL_HANDLER

	if(!istype(user) || (user.shoes != parent) )
		return

	user.remove_stress(/datum/stress_event/fullshoe)

/datum/storage/no_interface/toilet
	max_slots = 5
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_total_storage = 5
