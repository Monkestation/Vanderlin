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
	var/obj/item/held_item = null
	var/hott = 0

/obj/item/weapon/tongs/examine(mob/user)
	. = ..()
	if(hott)
		. += "<span class='warning'>The tip is hot to the touch.</span>"

/obj/item/weapon/tongs/get_temperature()
	if(hott)
		return 150+T0C
	return ..()

/obj/item/weapon/tongs/fire_act(added, maxstacks)
	. = ..()
	hott = world.time
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(make_unhot), world.time), 30 SECONDS)

/obj/item/weapon/tongs/update_icon_state()
	. = ..()
	if(!held_item)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]i[hott ? "1" : "0"]"

/obj/item/weapon/tongs/proc/proxy_heat(incoming, max_heat)
	if(istype(held_item, /obj/item/storage/crucible))
		var/obj/item/storage/crucible/crucible = held_item
		crucible.crucible_temperature = min(crucible.crucible_temperature + incoming, max_heat)

/obj/item/weapon/tongs/proc/make_unhot(input)
	if(hott == input)
		hott = 0
	update_appearance(UPDATE_ICON_STATE)

///Places the ingot on the atom, this can be either a turf or a table
/obj/item/weapon/tongs/proc/place_item_to_atom(atom/A, mob/user)
	if(!held_item)
		return FALSE

	if(!isturf(A) && !istype(A, /obj/structure/table))
		to_chat(user, "<span class='warning'>Cannot place [held_item] here!</span>")
		return FALSE

	held_item.forceMove(get_turf(A))
	held_item = null
	hott = 0
	update_appearance(UPDATE_ICON_STATE)

	return TRUE

/obj/item/weapon/tongs/attack_self(mob/user, list/modifiers)
	. = ..()
	place_item_to_atom(get_turf(user), user)

/obj/item/weapon/tongs/dropped(mob/user)
	. = ..()
	place_item_to_atom(get_turf(src), user)

/obj/item/weapon/tongs/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(held_item)
		if(held_item.interact_with_atom(interacting_with, user, modifiers))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(!isitem(interacting_with))
		return NONE

	if(!isturf(interacting_with.loc))
		return NONE

	var/obj/item/item = interacting_with

	if(item.tool_flags & TOOL_USAGE_TONGS || HAS_TRAIT(interacting_with, TRAIT_NEEDS_QUENCH))
		user.visible_message("<span class='info'>[user] picks up [item] with [src].</span>")
		held_item = item
		item.forceMove(src)
		update_appearance(UPDATE_ICON_STATE)
		return ITEM_INTERACT_SUCCESS

/obj/item/weapon/tongs/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!held_item)
		return NONE

	if(place_item_to_atom(interacting_with))
		return ITEM_INTERACT_SUCCESS

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
