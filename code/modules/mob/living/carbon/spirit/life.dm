

/mob/living/carbon/spirit


/mob/living/carbon/spirit/Life()
	set invisibility = 0

	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

/mob/living/carbon/spirit/handle_random_events()
	..()
	if (prob(1) && prob(2))
		emote("scratch")

/mob/living/carbon/spirit/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return 1

/mob/living/carbon/spirit/handle_fire()
	return
/*
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return

	//the fire tries to damage the exposed clothes and items
	var/list/burning_items = list()
	//HEAD//
	var/list/obscured = check_obscured_slots(TRUE)
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		burning_items += wear_mask
	if(wear_neck && !(SLOT_NECK in obscured))
		burning_items += wear_neck
	if(head)
		burning_items += head

	if(back)
		burning_items += back

	for(var/obj/item/I as anything in burning_items)
		I.fire_act((fire_stacks * 50)) //damage taken is reduced to 2% of this value by fire_act()

	adjust_bodytemperature(BODYTEMP_HEATING_MAX)
	add_stress(/datum/stress_event/on_fire)
*/
