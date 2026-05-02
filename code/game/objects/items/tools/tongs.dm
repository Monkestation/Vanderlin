/obj/item/weapon/tongs
	name = "tongs"
	desc = ""
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "tongs"
	force = DAMAGE_CLUB / 3
	possible_item_intents = list(MACE_STRIKE)
	sharpness = IS_BLUNT
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	associated_skill = null
	smeltresult = /obj/item/ingot/iron
	grid_width = 32
	grid_height = 96
	item_weight = 143 GRAMS
	var/obj/item/held_item = null

/obj/item/weapon/tongs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/weapon/tongs/Initialize(mapload)
	. = ..()
	item_flags |= SURGICAL_TOOL // we lost a real one tbh

/obj/item/weapon/tongs/examine(mob/user)
	. = ..()
	if(held_item)
		. += span_info("[src] is holding \a [held_item.name].")
		if(HAS_TRAIT(held_item, TRAIT_NEEDS_QUENCH))
			. += span_warning("The tip is hot to the touch.")

/obj/item/weapon/tongs/Destroy()
	place_item_to_atom(drop_location())
	. = ..()

/obj/item/weapon/tongs/get_temperature()
	if(held_item && HAS_TRAIT(held_item, TRAIT_NEEDS_QUENCH))
		return 150+T0C
	return ..()

/obj/item/weapon/tongs/fire_act(added, maxstacks)
	. = ..()
	heat_held_item(source = "fire_act", duration = 10 SECONDS)

/obj/item/weapon/tongs/update_icon_state()
	. = ..()
	if(!held_item)
		icon_state = initial(icon_state)
	else
		var/hot_status = HAS_TRAIT(held_item, TRAIT_NEEDS_QUENCH)
		icon_state = "[initial(icon_state)]i[hot_status ? "1" : "0"]"

/**
 * Attempts to heat up the held item. Returns TRUE if successful, FALSE otherwise
 *
 * Arguments:
 * source - the source that TRAIT_NEEDS_QUENCH is applied from
 * duration - the time that TRAIT_NEEDS_QUENCH is applied for
 * incoming - Value of added temperature. Currently only used for crucibles.
 * max_heat - Value of the maximum that can be heated up to. Currently only used for crucibles.
 */
/obj/item/weapon/tongs/proc/heat_held_item(source, duration, incoming, max_heat)
	if(!held_item)
		return FALSE
	if(istype(held_item, /obj/item/storage/crucible))
		var/obj/item/storage/crucible/crucible = held_item
		crucible.crucible_temperature = min(crucible.crucible_temperature + incoming, max_heat)
		return TRUE
	if(duration)
		held_item.add_quench_requirement(source, duration)
		return TRUE
	return FALSE

/obj/item/weapon/tongs/proc/set_held_item(obj/item/new_held_item)
	if(!QDELETED(held_item))
		UnregisterSignal(held_item, list(\
			SIGNAL_ADDTRAIT(TRAIT_NEEDS_QUENCH), SIGNAL_REMOVETRAIT(TRAIT_NEEDS_QUENCH), \
			COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	held_item = new_held_item
	if(held_item)
		held_item.forceMove(src)
		RegisterSignals(held_item, list(SIGNAL_ADDTRAIT(TRAIT_NEEDS_QUENCH), SIGNAL_REMOVETRAIT(TRAIT_NEEDS_QUENCH)), PROC_REF(update_icon_state_upon_signal))
		RegisterSignals(held_item, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(unset_item_on_signal))
	update_appearance(UPDATE_ICON_STATE)

/obj/item/weapon/tongs/proc/unset_item_on_signal(datum/source)
	SIGNAL_HANDLER
	set_held_item(null)

/obj/item/weapon/tongs/proc/update_icon_state_upon_signal(datum/source, trait)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)

/// Places the ingot on the atom, this can be either a turf or a table
/obj/item/weapon/tongs/proc/place_item_to_atom(atom/A, mob/user)
	if(!held_item)
		return

	if(user && held_item.tong_interaction(A, user))
		return
	if(isturf(A) || istype(A, /obj/structure/table))
		held_item.forceMove(get_turf(A))
	else
		to_chat(user, span_warning("Cannot place [held_item] here!"))

/obj/item/weapon/tongs/attack_self(mob/user, list/modifiers)
	. = ..()
	place_item_to_atom(get_turf(user), user)

/obj/item/weapon/tongs/equipped(mob/user, slot, initial)
	. = ..()
	place_item_to_atom(get_turf(src), user)

/obj/item/weapon/tongs/dropped(mob/user)
	. = ..()
	place_item_to_atom(get_turf(src), user)

/obj/item/weapon/tongs/pre_attack_secondary(atom/A, mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	place_item_to_atom(get_turf(A), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// TODO: REWRITE TONGS INTERACTIONS USING interact_with_atom()
/obj/item/weapon/tongs/pre_attack(obj/item/attacked_item, mob/living/user, list/modifiers)
	if(held_item?.tong_interaction(attacked_item, user))
		return TRUE

	if(!istype(attacked_item))
		return ..()

	if(held_item)
		return ..()

	if(istype(attacked_item, /obj/item/storage/crucible))
		. = TRUE
	else if(HAS_TRAIT(attacked_item, TRAIT_NEEDS_QUENCH))
		. = TRUE
	else if(attacked_item.melting_material || attacked_item.anvilrepair || attacked_item.smeltresult)
		. = TRUE
	if(.)
		user.visible_message(span_info("[user] picks up [attacked_item] with [src]."))
		set_held_item(attacked_item)

/obj/item/weapon/tongs/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = 1,"nx" = 12,"ny" = 1,"wx" = -8,"wy" = 1,"ex" = 6,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/tongs/stone
	name = "stone tongs"
	icon_state = "stonetongs"
	force = 3
	smeltresult = null
	anvilrepair = null
	max_integrity = INTEGRITY_WORST / 5

/// Called in pre_attack of tongs, used for items held by tongs. Return TRUE to stop attack chain early.
/atom/proc/tong_interaction(atom/target, mob/user)
	return FALSE
