/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/bait_flag = NONE
	var/list/fishloot = null

/obj/item/natural/worms
	name = "worm"
	desc = ""
	icon_state = "worm"
	throwforce = 0
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 10,
					/obj/item/reagent_containers/food/snacks/fish/eel = 5,
					/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	bundletype = /obj/item/natural/bundle/worms
	bait_flag = MEAT

/obj/item/natural/worms/Initialize()
	. = ..()
	dir = rand(0,8)

/obj/item/natural/worms/grub_silk
	name = "silk grub"
	desc = "Squeeze hard to force out the silk string."
	icon_state = "grub"
	color = "#fff7bb"
	baitpenalty = 5
	isbait = TRUE
	bundletype = null
	fishloot = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 5,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
	)

/obj/item/natural/worms/grub_silk/attack_self(mob/living/user, list/modifiers)
	user.visible_message(span_notice("[user] crushes [src], forcing the silk out."), span_notice("I crush [src], forcing the silk out."))
	playsound(src, 'sound/foley/meatslap.ogg', 100, TRUE, -1)
	var/obj/item/natural/silk/M = new
	qdel(src)
	user.put_in_hands(M)

