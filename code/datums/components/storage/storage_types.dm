/datum/component/storage/concrete/scabbard
	max_items = 1
	rustle_sound = 'sound/foley/equip/scabbard_holster.ogg'
	max_w_class = WEIGHT_CLASS_BULKY
	quickdraw = TRUE
	allow_look_inside = FALSE
	insert_verb = "slide"
	insert_preposition = "in"

/datum/component/storage/concrete/scabbard/knife/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife))

/datum/component/storage/concrete/scabbard/sword/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword), list(/obj/item/weapon/sword/long/exe, /obj/item/weapon/sword/long/greatsword))

/datum/component/storage/concrete/scabbard/kazengun/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword/katana))

/datum/component/storage/concrete/boots
	max_items = 1
	rustle_sound = 'sound/foley/equip/scabbard_holster.ogg'
	max_w_class = WEIGHT_CLASS_SMALL
	quickdraw = TRUE
	allow_look_inside = FALSE
	insert_verb = "slide"
	insert_preposition = "in"

/datum/component/storage/concrete/boots/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife, /obj/item/coin, /obj/item/key))

/datum/component/storage/concrete/boots/Initialize(datum/component/storage/concrete/master)
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(equipped_stress))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(unequipped_stress))

/datum/component/storage/concrete/boots/Destroy(force)
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)
	return ..()

/datum/component/storage/concrete/boots/attackby(datum/source, obj/item/attacking_item, mob/user, list/modifiers, storage_click)
	if(isatom(parent) && can_be_inserted(attacking_item, stop_messages = TRUE))
		var/atom/boots = parent
		if(istype(attacking_item, /obj/item/weapon/knife) && ishuman(boots?.loc))
			var/mob/living/carbon/human/unlucky = boots.loc
			if(unlucky.shoes == parent && prob(40 - max((unlucky.STALUC * 4), 0)))
				var/cached_aim = user.zone_selected
				user.zone_selected = pick(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
				unlucky.attackby(attacking_item, user, modifiers)
				to_chat(unlucky, span_danger("UNLUCKY! I've stabbed myself with [attacking_item]!"))
				user.zone_selected = cached_aim

	return ..()

/datum/component/storage/concrete/boots/handle_item_insertion(obj/item/I, prevent_warning, mob/M, datum/component/storage/remote, list/modifiers, storage_click)
	. = ..()
	if(!.)
		return

	if(!istype(I, /obj/item/weapon/knife) && isatom(parent))
		var/obj/item/clothing/shoes/boots = parent
		if(ishuman(boots?.loc))
			var/mob/living/carbon/human/uncomfy = boots.loc
			if(uncomfy.shoes != parent)
				return
			uncomfy.add_stress(/datum/stress_event/fullshoe)

/datum/component/storage/concrete/boots/remove_from_storage(atom/movable/removed, atom/new_location)
	. = ..()

	var/atom/boots = parent
	if(ishuman(boots?.loc))
		var/mob/living/carbon/human/uncomfy = boots.loc
		if((uncomfy.shoes != parent))
			return
		var/atom/real_location = real_location()
		if(length(real_location.contents))
			for(var/obj/item/I in real_location.contents)
				if(!istype(I, /obj/item/weapon/knife))
					uncomfy.add_stress(/datum/stress_event/fullshoe)
					return
		uncomfy.remove_stress(/datum/stress_event/fullshoe)
		return

/datum/component/storage/concrete/boots/proc/equipped_stress(datum/source, mob/user, slot)
	if(slot != ITEM_SLOT_SHOES)
		return

	var/atom/boots = parent
	if(ishuman(boots?.loc))
		var/mob/living/carbon/human/uncomfy = boots.loc
		var/atom/real_location = real_location()
		if(length(real_location.contents))
			for(var/obj/item/I in real_location.contents)
				if(!istype(I, /obj/item/weapon/knife))
					uncomfy.add_stress(/datum/stress_event/fullshoe)
					return

/datum/component/storage/concrete/boots/proc/unequipped_stress(datum/source, mob/living/carbon/user)
	if(!istype(user) || (user.shoes != parent) )
		return
	user.remove_stress(/datum/stress_event/fullshoe)
