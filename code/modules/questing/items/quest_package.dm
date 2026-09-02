/obj/item/quest_package
	name = "quest parcel"
	desc = "A bundled parcel of quest turn-in items. The originating pledge scroll must be used on it to open it."
	icon = 'icons/obj/ration.dmi'
	icon_state = "ration_small"
	var/quest_title = ""
	/// Weakref to the specific pledge scroll that must be used to open this parcel.
	var/datum/weakref/pledge_ref
	var/delivery_target_name
	/// Weakref to the recovery quest this package belongs to.
	/// Null for pledge-delivery packages, which use pledge_ref instead.
	/// Used by the Notice Board to verify the package matches the turned-in scroll.
	var/datum/weakref/linked_quest_ref

/obj/item/quest_package/examine(mob/user)
	. = ..()
	if(quest_title)
		. += "It's labeled: \"[quest_title]\"."
	if(pledge_ref)
		. += span_notice("The seal bears a guild pledge mark. Only the originating pledge scroll can open it.")
	if(linked_quest_ref)
		. += span_notice("It bears a Notice Board seal. Return it with your quest scroll to claim your reward.")

/obj/item/quest_package/attackby(obj/item/used_item, mob/living/carbon/human/user, params)
	// Recovery packages are sealed until the board opens them on turn-in.
	// Trying to use anything on them just reminds the player what to do.
	if(linked_quest_ref)
		to_chat(user, span_warning("This package is sealed with a Notice Board mark. Turn it in at the board with your quest scroll."))
		return
	// Pledge-sealed packages require the exact originating scroll.
	if(pledge_ref)
		var/obj/item/paper/scroll/quest/pledge/PL = pledge_ref.resolve()
		if(QDELETED(PL) || used_item != PL)
			to_chat(user, span_warning("This parcel is sealed with a pledge mark. Only the originating pledge scroll can open it."))
			return
		do_open(user)
		return
	. = ..()

/obj/item/quest_package/proc/do_open(mob/user)
	if(!length(contents))
		to_chat(user, span_warning("The parcel is empty."))
		return
	to_chat(user, span_notice("You break the seal on [src] and tip out its contents."))
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(user))
	qdel(src)

/obj/item/quest_package/attack_self(mob/user)
	if(linked_quest_ref)
		to_chat(user, span_warning("This package is sealed with a Notice Board mark. Turn it in at the board with your quest scroll."))
		return
	if(pledge_ref && !delivery_target_name)
		return
	if(!length(contents))
		to_chat(user, span_warning("The parcel is empty."))
		return
	to_chat(user, span_notice("You unwrap [src] and tip out its contents."))
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(user))
	qdel(src)
