/obj/item/clothing/head/helmet
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	pickup_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ITEM
	clothing_flags = CANT_SLEEP_IN

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_POOR
	body_parts_covered = COVERAGE_SKULL
	prevent_crits = ALL_EXCEPT_STAB

	grid_height = 64
	grid_width = 64
	abstract_type = /obj/item/clothing/head/helmet

	material_category = ARMOR_MAT_PLATE
	var/can_add_cloth = FALSE //This being true allows alt clicking with a cloth on a helmet to create a colored [icon_name]_detail sprite overlayed.

/obj/item/clothing/head/helmet/AltClick(mob/user, list/modifiers)
	. = ..()
	if(!can_add_cloth)
		return
	if(get_detail_tag())
		user.visible_message(span_warning("[user] starts removing the wreath from [src]."))
		if(!do_after(user, 3 SECONDS, src))
			return
		if(!detail_tag)
			return
		var/obj/item/natural/cloth/refund_cloth = new /obj/item/natural/cloth(get_turf(src))
		user.put_in_hands(refund_cloth)
		detail_tag = null
		detail_color = null
		update_appearance(UPDATE_OVERLAYS)

		return

	var/obj/item/natural/cloth/material = user.get_active_held_item()
	if(!istype(material))
		return
	if(!user.Adjacent(src))
		return
	var/list/colors = GLOB.peasant_dyes | GLOB.noble_dyes | GLOB.royal_dyes
	var/choice = input(user, "Choose a color for the wreath.", "Wreath") as null|anything in colors
	if(!choice)
		return
	user.visible_message(span_warning("[user] decorates [src] with a cloth wreath."))
	qdel(material)
	detail_color = colors[choice]
	detail_tag = "_detail"
	update_appearance(UPDATE_OVERLAYS)


/obj/item/clothing/head/helmet/examine(mob/user)
	. = ..()

	if(detail_tag && can_add_cloth)
		. += span_notice("It is decorated with a cloth. (<b>Alt+click</b> to remove.)")
	else if(can_add_cloth)
		. += span_notice("This helmet can be decorated with a cloth. (<b>Alt+click</b> with cloth to add.)")
