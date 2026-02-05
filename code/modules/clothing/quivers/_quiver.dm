
/obj/item/ammo_holder
	desc = ""
	icon = 'icons/roguetown/weapons/ammo_holders.dmi'
	w_class = WEIGHT_CLASS_BULKY
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	sewrepair = TRUE
	item_weight = 4
	/// Max amount of ammo to hold
	var/max_storage
	/// Instances of ammo this contains
	var/list/ammo_list = list()
	/// Types of ammo this can hold
	var/list/ammo_type
	/// Type of ammo to fill
	var/fill_type
	/// Amount to fill, uses max_storage if omitted
	var/fill_to

/obj/item/ammo_holder/Initialize()
	. = ..()
	if(fill_type)
		var/to_fill = fill_to ? fill_to : max_storage
		for(var/i in 1 to to_fill)
			var/obj/item/ammo = new fill_type(src)
			ammo_list += ammo
		update_appearance(UPDATE_ICON_STATE)

/obj/item/ammo_holder/attackby(obj/A, loc, list/modifiers)
	for(var/i in ammo_type)
		if(istype(A, i))
			if(ammo_list.len < max_storage)
				if(ismob(loc))
					var/mob/mob = loc
					mob.transferItemToLoc(A, src, force)
				else
					A.forceMove(src)
				ammo_list += A
				update_appearance(UPDATE_ICON_STATE)
			else
				to_chat(loc, span_warning("[src] is full!"))
			return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/B = A
		var/obj/item/ammo_box/gun_magazine = B.mag_type
		var/obj/item/ammo_casing/caseless/gun_ammo = initial(gun_magazine?.ammo_type)
		if(ammo_list.len && gun_ammo && !B.chambered)
			for(var/AR in reverseList(ammo_list))
				if(istype(AR, gun_ammo))
					ammo_list -= AR
					contents -= AR
					B.attackby(AR, loc, modifiers)
					break
		update_appearance(UPDATE_ICON_STATE)
		return
	..()

/obj/item/ammo_holder/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(length(ammo_list))
		var/obj/O = ammo_list[length(ammo_list)]
		ammo_list -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_appearance(UPDATE_ICON_STATE)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/ammo_holder/examine(mob/user)
	. = ..()
	if(length(ammo_list))
		var/list/unique_ammos = list()
		for(var/obj/item/ammo_casing/ammo in ammo_list)
			unique_ammos[ammo.name] += 1
		for(var/ammo_name in unique_ammos)
			. += span_info("[unique_ammos[ammo_name]] [ammo_name][unique_ammos[ammo_name] > 1 ? "s" : ""].")

/obj/item/ammo_holder/update_icon_state()
	. = ..()
	if(length(ammo_list))
		icon_state = "[item_state]1"
	else
		icon_state = "[item_state]0"
