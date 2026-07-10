/obj/item/paint_brush
	name = "paint brush"
	desc = "A tool used for painting"
	icon = 'icons/paint_supplies/paint_items.dmi'
	icon_state = "paintbrush"

	grid_height = 32
	grid_width = 64
	item_weight = 9 GRAMS
	var/current_color


/obj/item/paint_brush/update_overlays()
	. = ..()
	if(!current_color)
		return

	. += mutable_appearance(icon, "paintbrush-color", color = current_color)

/obj/item/paint_brush/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/item/paint_palette))
		var/obj/item/paint_palette/palette = interacting_with
		var/merge_color =  browser_input_list(user, "Choose a color to blend", items = palette.colors)
		if(!merge_color)
			return ITEM_INTERACT_BLOCKING

		var/list/colors = palette.colors
		merge_color = colors[merge_color]
		if(!current_color)
			current_color = merge_color
		else
			current_color = BlendRGB(current_color, merge_color, 0.5)

		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS

	if(!(interacting_with.reagents?.flags & DRAINABLE))
		return NONE

	if(!interacting_with.reagents.has_reagent(/datum/reagent/water))
		return NONE

	to_chat(user, span_notice("I start to wash [src] in [interacting_with]..."))
	if(!do_after(user, 1 SECONDS, interacting_with))
		return

	current_color = null
	update_appearance(UPDATE_OVERLAYS)

	return ITEM_INTERACT_SUCCESS
