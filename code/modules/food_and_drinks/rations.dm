// Design wise, I want to gate this behind high cooking skills role who can wrap their food and provide a convenient source of
// Stats-boosting food for adventurers / other alike. Currently there's very few good preserved food items that also give foodbuffs.
// This is a flavorful way to provide more reasons for adventurers to buy from innkeep instead of doing their own raisins.
// FOR GODS SAKE DO NOT GIVE THIS ROUNDSTART TO ANYONE BUT INNKEEP ON MAP.
/obj/item/ration // Ration. Sprites and Concept by Pintlewaiver.
	name = "ration wrapping paper"
	desc = "A piece of paper greased with a thin layer of oil, used to wrap food and preserve it for a long journey. \
	The final size of the ration depends on the size of the original food item. The food will last as long as the ration is wrapped."
	icon = 'icons/obj/ration.dmi'
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	var/obj/item/reagent_containers/food/snacks/food = null // The food item wrapped in the ration

/obj/item/ration/Destroy()
	. = ..()
	food = null

/obj/item/ration/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = I
		if(food)
			to_chat(user, span_warning("There is already something wrapped in [src]."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			user.transferItemToLoc(F, src)
			food = I
			to_chat(user, span_notice("You wrap [F] in the ration wrapper."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			F.rotprocess = null
			if(I.w_class >= WEIGHT_CLASS_NORMAL)
				name = "large ration pack ([food.name])"
				desc = "A large ration pack containing a [food.name]."
				icon_state = "ration_large"
				dropshrink = 1
				// No need to change grid size cuz cakes are 1x1 huh??
			else
				name = "small ration pack ([food.name])"
				desc = "A small ration pack containing a [food.name]."
				icon_state = "ration_small"
				dropshrink = 1
			update_icon()

/obj/item/ration/attack_self(mob/user)
	. = ..()
	if(food)
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("You unwrap [food] from the ration wrapper."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			var/obj/item/reagent_containers/food/snacks/F = food
			user.put_in_hands(F)
			F.update_icon()
			F.rotprocess = initial(F.rotprocess)
			food = null
			qdel(src) // No reusing wrapper
