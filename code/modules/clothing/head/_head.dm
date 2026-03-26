/obj/item/clothing/head
	name = "hat"
	desc = ""

	icon = 'icons/roguetown/clothing/head.dmi'
	icon_state = "surghood"
	dynamic_hair_suffix = "+generic"
	bloody_icon_state = "helmetblood"
	item_state = "that"

	body_parts_covered = COVERAGE_SKULL
	slot_flags = ITEM_SLOT_HEAD
	max_integrity = INTEGRITY_WORST

	equip_sound = "rustle"
	pickup_sound = "rustle"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	grid_height = 32
	grid_width = 64

	resistance_flags = FLAMMABLE

	sewrepair = /datum/attribute/skill/misc/sewing/mending
	dyeable = TRUE
	anvilrepair = null
	smeltresult = /obj/item/fertilizer/ash // Helmets have pre-defined smeltresults, this is for hats
	sellprice = VALUE_CHEAP_CLOTHING
	edelay_type = 1

	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	abstract_type = /obj/item/clothing/head

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_body_parts()

///Special throw_impact for hats to frisbee hats at people to place them on their heads/attempt to de-hat them.
/obj/item/clothing/head/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()


/obj/item/clothing/head/equipped(mob/user, slot)
	. = ..()
	user.update_fov_angles()
	if(!(slot & ITEM_SLOT_HEAD))
		flags_inv = null
	else
		flags_inv = initial(flags_inv)

/obj/item/clothing/head/dropped(mob/user)
	. = ..()
	user.update_fov_angles()
	flags_inv = initial(flags_inv)

/obj/item/clothing/head/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()
