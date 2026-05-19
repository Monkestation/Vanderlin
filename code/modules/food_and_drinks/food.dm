////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/// Note: When adding food items with dummy parents, make sure to add
/// the parent to the exclusion list in code/__HELPERS/unsorted.dm's
/// get_random_food proc.
////////////////////////////////////////////////////////////////////////////////
#define STOP_SERVING_BREAKFAST (15 MINUTES)

/obj/item/reagent_containers/food
	possible_transfer_amounts = list()
	volume = 50	//Sets the default container amount for all food items.
	reagent_flags = INJECTABLE | DRAWABLE //fun
	resistance_flags = FLAMMABLE
	grid_width = 32
	grid_height = 32
	var/do_random_pixel_offset = TRUE
	var/foodtype = NONE
	var/last_check_time
	var/in_container = FALSE //currently just stops "was bitten X times!" messages on canned food

	/// How palatable is this food for a given social class?
	var/faretype = FARE_NEUTRAL
	/// If false, this will inflict mood debuffs on nobles who eat it without being near a table.
	var/portable = TRUE

/obj/item/reagent_containers/food/Initialize(mapload)
	. = ..()
	if(!mapload && do_random_pixel_offset)
		pixel_x = base_pixel_x + rand(-4, 4)
		pixel_y = base_pixel_y + rand(-4, 4)

/obj/item/reagent_containers/food/proc/checkLiked(fraction, mob/M)
	if(last_check_time + 50 < world.time)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(foodtype & H.dna.species.toxic_food)
				to_chat(H,"<span class='warning'>What the hell was that thing?!</span>")
				H.adjust_disgust(25 + 30 * fraction)
				H.add_stress(/datum/stress_event/disgusting_food)
			else if(foodtype & H.dna.species.disliked_food)
				to_chat(H,"<span class='notice'>That didn't taste very good...</span>")
				H.adjust_disgust(11 + 15 * fraction)
				H.add_stress(/datum/stress_event/gross_food)
			else if(foodtype & H.dna.species.liked_food)
				to_chat(H,"<span class='notice'>I love this taste!</span>")
				H.adjust_disgust(-5 + -2.5 * fraction)
				H.add_stress(/datum/stress_event/favorite_food)
			if((foodtype & BREAKFAST) && world.time - SSticker.round_start_time < STOP_SERVING_BREAKFAST)
				H.add_stress(/datum/stress_event/breakfast)
			last_check_time = world.time

#undef STOP_SERVING_BREAKFAST
