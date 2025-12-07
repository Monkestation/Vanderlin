/obj/item/bottle_kit
	name = "bottlin' kit"
	desc = "A parcel of colored bottles and some labels."
	icon = 'icons/obj/brewing.dmi'
	icon_state = "bottler_box"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 64
	var/glass_colour = "brew_bottle"
	var/fake_glass_name = "Kinda Blue"

/obj/item/bottle_kit/examine(mob/user)
	. = ..()
	. += "[src] will make [lowertext(fake_glass_name)] bottles."

/obj/item/bottle_kit/attack_self(mob/user as mob)
	..()
	glass_picker(user)

/obj/item/bottle_kit/proc/glass_picker(mob/user as mob)
	var/list/options = list()
	options["Kinda Blue"] = "brew_bottle"
	options["Redish"] = "brew_red_bottle"
	options["Green-Adjcent"] = "brew_green_bottle"
	options["Scuffed Platium"] = "brew_white_bottle"
	options["Sorta Coal"] = "brew_coal_bottle"
	options["Maybe Bronze"] = "brew_fancy_bottle"
	options["Off-Amethyst"] = "brew_funky_bottle"
	options["Odd Sky Shade"] = "brew_sky_bottle"
	options["Washed Out Brass"] = "brew_saint_po_bottle"
	options["Faded Caramel"] = "brew_gold_bottle"
	options["Approximate Sea Shore"] = "brew_pianowoman_bottle"
	options["Faded Dust"] = "brew_noir_bottle"
	options["Close Honeycomb"] = "brew_bees_bottle"


	if(!options.len)
		to_chat(user, span_info("The bottle kit is limited to only normal blue bottles. Oh no!"))
		glass_colour = "brew_bottle"
		fake_glass_name = "Blue"
		return

	var/choice = input(user, "What colour do you pick?", name) as anything in options

	var/printing_choice = options[choice]

	if(!printing_choice)
		glass_colour = "brew_bottle"
		fake_glass_name = "Kinda Blue"
		return

	fake_glass_name = choice
	glass_colour = printing_choice

/obj/item/reagent_containers/glass/bottle/brewing_bottle
	name = "brewer's bottle"
	desc = "A bottle with a special cork. When sealed, it is a valuable commodity for trade."
	icon =  'icons/obj/bottle.dmi'
	icon_state = "brew_bottle"
	volume = 50
	can_label_container = FALSE

/obj/item/reagent_containers/glass/bottle/brewing_bottle/examine(mob/user)
	. = ..()
	if(sellprice)
		. += span_notice("The bottle is sealed and can be sold on the market.")

/obj/item/reagent_containers/glass/bottle/brewing_bottle/toggle_cork(mob/user)
	if(closed && sellprice && reagents?.total_volume)
		to_chat(user, span_boldwarning("You start to unseal [src], ruining its economic value."))
		if(!do_after(user, 5 SECONDS, src))
			return
		sellprice = initial(sellprice)
	. = ..()
