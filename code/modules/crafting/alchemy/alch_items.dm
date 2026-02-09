/obj/item/reagent_containers/glass/alchemical
	name = "alchemical vial"
	desc = "A cute bottle, designed to hold 3 swigs of a fluid."
	icon = 'icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "vial_bottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	volume = 25
	fill_icon_thresholds = list(0, 33, 66, 100)
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	obj_flags = CAN_BE_HIT
	spillable = FALSE
	var/closed = TRUE //Put a cork in it!
	reagent_flags = TRANSPARENT
	fill_icon_under_override = TRUE
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	experimental_onhip = TRUE
	sellprice = 1

/obj/item/reagent_containers/glass/alchemical/attackby(obj/item/I, mob/user, list/modifiers)
	if(reagents.total_volume)
		return
	if(closed)
		return
	else
		return ..()

/obj/item/reagent_containers/glass/alchemical/update_overlays()
	. = ..()
	if(closed)
		. += mutable_appearance(icon, "vial_cork")

/obj/item/reagent_containers/glass/alchemical/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	closed = !closed
	user.changeNext_move(CLICK_CD_RAPID)
	if(closed)
		reagent_flags &= ~TRANSFERABLE
		reagents.flags = reagent_flags
		to_chat(user, span_notice("You carefully press the cork back into the mouth of [src]."))
		spillable = FALSE
		desc = initial(desc)
	else
		reagent_flags |= TRANSFERABLE
		reagents.flags = reagent_flags
		to_chat(user, span_notice("You thumb off the cork from [src]."))
		playsound(user,'sound/items/uncork.ogg', 100, TRUE)
		spillable = TRUE
		desc += "The cork appears to be off."
	update_appearance(UPDATE_OVERLAYS)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
