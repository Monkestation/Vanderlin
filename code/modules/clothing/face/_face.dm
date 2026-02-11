/obj/item/clothing/face
	name = ""

	icon = 'icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/masks.dmi'

	body_parts_covered = FACE
	slot_flags = ITEM_SLOT_MASK

	resistance_flags = FIRE_PROOF

	strip_delay = 40
	equip_delay_other = 40

	grid_width = 64
	grid_height = 32

	sewrepair = TRUE
	anvilrepair = null

	var/modifies_speech = FALSE
	var/mask_adjusted = 0
	var/adjusted_flags = null
	abstract_type = /obj/item/clothing/face
	wetable = FALSE

/obj/item/clothing/face/attack_self(mob/user, list/modifiers)
	if(CHECK_BITFIELD(clothing_flags, VOICEBOX_TOGGLABLE))
		TOGGLE_BITFIELD(clothing_flags, VOICEBOX_DISABLED)
		var/status = !CHECK_BITFIELD(clothing_flags, VOICEBOX_DISABLED)
		to_chat(user, "<span class='notice'>I turn the voice box in [src] [status ? "on" : "off"].</span>")

/obj/item/clothing/face/equipped(mob/user, slot)
	. = ..()
	if ((slot & ITEM_SLOT_MASK) && modifies_speech)
		RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(user, COMSIG_MOB_SAY)
	user.update_fov_angles()

/obj/item/clothing/face/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SAY)
	user.update_fov_angles()

/obj/item/clothing/face/proc/handle_speech()

/obj/item/clothing/face/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_mask()

//Proc that moves gas/breath masks out of the way, disabling them and allowing pill/food consumption
/obj/item/clothing/face/proc/adjustmask(mob/living/user)
	if(user && user.incapacitated(IGNORE_GRAB))
		return
	mask_adjusted = !mask_adjusted
	if(!mask_adjusted)
		src.icon_state = initial(icon_state)
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		permeability_coefficient = initial(permeability_coefficient)
		clothing_flags |= visor_flags
		flags_inv |= visor_flags_inv
		flags_cover |= visor_flags_cover
		to_chat(user, "<span class='notice'>I push \the [src] back into place.</span>")
		slot_flags = initial(slot_flags)
	else
		icon_state += "_up"
		to_chat(user, "<span class='notice'>I push \the [src] out of the way.</span>")
		gas_transfer_coefficient = null
		permeability_coefficient = null
		clothing_flags &= ~visor_flags
		flags_inv &= ~visor_flags_inv
		flags_cover &= ~visor_flags_cover
		if(adjusted_flags)
			slot_flags = adjusted_flags
	if(user)
		user.wear_mask_update(src, toggle_off = mask_adjusted)
