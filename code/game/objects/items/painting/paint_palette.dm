/obj/item/paint_palette/filled
	colors = list(
		"Red" = COLOR_RED,
		"Blue" = COLOR_BLUE,
		"Green" = COLOR_GREEN,
		"Purple" = COLOR_PURPLE,
		"Cyan" = COLOR_CYAN
	)

/obj/item/paint_palette
	name = "paint palette"
	desc = "A tool used for painting"
	icon = 'icons/paint_supplies/paint_items.dmi'
	icon_state = "palette"

	grid_height = 32
	grid_width = 64
	var/list/colors = list()


/obj/item/paint_palette/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/paint_palette/proc/add_color(mob/user)
	if(length(colors) >= 5)
		return
	var/add_color = input(user, "Choose a color to add") as color|null
	if(!add_color)
		return
	var/color_name = input(user, "Choose a name for this color")
	if(!color_name)
		return
	if(length(colors) >= 5)
		return
	colors |= color_name
	colors[color_name] = add_color
	update_appearance(UPDATE_OVERLAYS)

/obj/item/paint_palette/proc/remove_color(mob/user)
	var/remove_color = input(user, "Choose a color to remove") as anything in colors
	if(!remove_color)
		return
	colors -= remove_color
	update_appearance(UPDATE_OVERLAYS)

/obj/item/paint_palette/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	remove_color(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/paint_palette/attack_self(mob/user, list/modifiers)
	. = ..()
	add_color(user)

/obj/item/paint_palette/update_overlays()
	. = ..()

	for(var/i = 1 to length(colors))
		var/mutable_appearance/MA = mutable_appearance(icon, "palette-greyscale[i]")
		var/color_name = colors[i]
		MA.color = colors[color_name]
		. += MA
