/datum/component/storage/concrete/scabbard
	max_items = 1
	rustle_sound = 'sound/foley/equip/scabbard_holster.ogg'
	max_w_class = WEIGHT_CLASS_BULKY
	quickdraw = TRUE
	allow_look_inside = FALSE
	insert_verb = "slide"
	insert_preposition = "in"

/datum/component/storage/concrete/scabbard/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE, PROC_REF(update_icon_state))

/datum/component/storage/concrete/scabbard/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE)
	. = ..()

/datum/component/storage/concrete/scabbard/proc/update_icon_state(obj/item/I)
	if(!istype(I))
		return
	I.icon_state = initial(I.icon_state)
	I.item_state = initial(I.item_state)

	if(length(I.contents))
		var/obj/item/sheathed_weapon = I.contents[1]
		var/icon/possible_sheaths = icon(I.icon) //hehe
		var/list/extensions = list()
		for(var/s in possible_sheaths.IconStates(1))
			extensions[s] = TRUE
		qdel(possible_sheaths)
		if(extensions[I.icon_state+"_[sheathed_weapon.icon_state]"])
			I.icon_state += "_[sheathed_weapon.icon_state]"
		else
			I.icon_state += "-sheathed"


/datum/component/storage/concrete/scabbard/knife/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife))

/datum/component/storage/concrete/scabbard/sword/New(list/raw_args)
	. = ..()
	set_holdable(list(/obj/item/weapon/sword), list(/obj/item/weapon/sword/long/exe, /obj/item/weapon/sword/long/greatsword, /obj/item/weapon/sword/long/daewalker))

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
			if(unlucky.shoes == parent && prob(40 - max((GET_MOB_ATTRIBUTE_VALUE(unlucky, STAT_FORTUNE) * 4), 0)))
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

/datum/component/storage/concrete/toilet
	allow_look_inside = FALSE
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 5
	max_items = 5
	silent = TRUE

/datum/component/storage/concrete/toilet/attackby(datum/source, obj/item/attacking_item, mob/user, list/modifiers, storage_click)
	if(isliving(user) && !user.cmode)
		if(istype(attacking_item, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/RG = attacking_item
			if(istype(RG, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/B = RG
				if(B.closed)
					return TRUE
			if(user.used_intent.type == INTENT_FILL)
				RG.reagents.add_reagent(/datum/reagent/water/gross, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
				to_chat(user, span_notice("I fill [RG] from the toilet."))
			else if(user.used_intent.type == INTENT_POUR && RG.reagents.total_volume > 0)
				RG.reagents.remove_all(RG.amount_per_transfer_from_this)
				to_chat(user, span_notice("I pour [RG] down the toilet."))
			else if(user.used_intent.type == INTENT_SPLASH && RG.reagents.total_volume > 0)
				RG.reagents.clear_reagents()
				to_chat(user, span_notice("I empty [RG] into the toilet."))
			return TRUE
		else if(!can_be_inserted(attacking_item, user))
			return TRUE
		to_chat(user, span_notice("I carefully place [attacking_item] into the toilet."))
	return ..()

/datum/component/storage/concrete/toilet/can_be_inserted(obj/item/I, mob/M, list/modifiers, storage_click)
	if(!istype(I) || (I.item_flags & ABSTRACT))
		return FALSE //Not an item
	var/atom/real_location = real_location()
	var/atom/host = parent
	if(!isturf(host.loc))
		return FALSE
	if(I.w_class > max_w_class)
		to_chat(M, span_warning("[I] does not fit!"))
		return FALSE
	if(real_location.contents.len >= max_items)
		to_chat(M, span_warning("The toilet is full!"))
		return FALSE //Storage item is full
	var/sum_w_class = I.w_class
	for(var/obj/item/_I in real_location)
		sum_w_class += _I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(sum_w_class > max_combined_w_class)
		to_chat(M, span_warning("The toilet is too full to fit [I]!"))
		return FALSE
	if(HAS_TRAIT(I, TRAIT_NODROP)) //SHOULD be handled in unEquip, but better safe than sorry.
		to_chat(M, span_warning("\the [I] is stuck to your hand, you can't put it in \the [host]!"))
		return FALSE
	return TRUE


/datum/component/storage/concrete/keyrack
	screen_max_rows = 2
	screen_max_columns = 10
	display_numerical_stacking = TRUE
	max_items = 20
	max_w_class = WEIGHT_CLASS_SMALL
	collection_mode = COLLECT_ONE
	insert_verb = "slide"
	insert_preposition = "on"
	rustle_sound = 'sound/items/gems (1).ogg'
	silent = TRUE

/datum/component/storage/concrete/keyrack/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/key, /obj/item/storage/keyring, /obj/item/lockpick, /obj/item/lockpickring))
