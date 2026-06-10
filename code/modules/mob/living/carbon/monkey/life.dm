

/mob/living/carbon/monkey


/mob/living/carbon/monkey/Life()
	set invisibility = 0

	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(..())

		if(!client)
			if(stat == CONSCIOUS)
				if(on_fire || buckled || HAS_TRAIT(src, TRAIT_RESTRAINED))
					if(!resisting && prob(MONKEY_RESIST_PROB))
						resisting = TRUE
						walk_to(src,0)
						resist()
				else if(resisting)
					resisting = FALSE
				else if((mode == MONKEY_IDLE && !pickupTarget && !prob(MONKEY_SHENANIGAN_PROB)) || !handle_combat())
					if(prob(25) && !HAS_TRAIT(src, TRAIT_IMMOBILIZED) && isturf(loc) && !pulledby)
						step(src, pick(GLOB.cardinals))
					else if(prob(1))
						emote(pick("scratch","jump","roll","tail"))
			else
				walk_to(src,0)

/mob/living/carbon/monkey/handle_random_events()
	..()
	if (prob(1) && prob(2))
		emote("scratch")

/mob/living/carbon/monkey/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return 1

/mob/living/carbon/monkey/handle_fire()
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return

	//the fire tries to damage the exposed clothes and items
	var/list/burning_items = list()
	//HEAD//
	var/list/obscured = check_obscured_slots(TRUE)
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		burning_items += wear_mask
	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		burning_items += wear_neck
	if(head)
		burning_items += head

	if(backr)
		burning_items += backr
	if(backl)
		burning_items += backl

	for(var/obj/item/I as anything in burning_items)
		I.fire_act(((fire_stacks + divine_fire_stacks)* 50)) //damage taken is reduced to 2% of this value by fire_act()

	adjust_bodytemperature(BODYTEMP_HEATING_MAX)
	add_stress(/datum/stress_event/on_fire)
