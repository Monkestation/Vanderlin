/obj/item/paint_brush
	name = "paint brush"
	desc = "A tool used for painting"
	icon = 'icons/paint_supplies/paint_items.dmi'
	icon_state = "paintbrush"

	grid_height = 32
	grid_width = 64
	var/current_color


/obj/item/paint_brush/update_overlays()
	. = ..()
	if(!current_color)
		return

	var/mutable_appearance/MA = mutable_appearance(icon, "paintbrush-color")
	MA.color = current_color
	. += MA

/obj/item/paint_brush/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(istype(target, /obj/item/paint_palette))
		var/merge_color = input(user, "Choose a color to blend") as anything in target:colors
		if(!merge_color)
			return
		var/list/colors = target:colors
		merge_color = colors[merge_color]
		if(!current_color)
			current_color = merge_color
		else
			current_color = BlendRGB(current_color, merge_color, 0.5)
		update_appearance(UPDATE_OVERLAYS)
		return

	if(!(target?.reagents?.flags & DRAINABLE))
		return

	if(target.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_notice("I start to wash [src] in [target]..."))
		if(!do_after(user, 1 SECONDS, target))
			return
		current_color = null
		update_appearance(UPDATE_OVERLAYS)
