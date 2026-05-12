#define DEFAULT_TASTE_SENSITIVITY 15

/mob/living
	var/last_taste_time
	var/last_taste_text

/mob/living/proc/get_taste_sensitivity()
	return DEFAULT_TASTE_SENSITIVITY

/mob/living/carbon/get_taste_sensitivity()
	var/obj/item/organ/tongue/tongue = getorganslot(ORGAN_SLOT_TONGUE)
	if(istype(tongue))
		. = tongue.taste_sensitivity
	else
		. = 101 // can't taste anything without a tongue

// non destructively tastes a reagent container
/mob/living/proc/taste(datum/reagents/from)
	if(last_taste_time + 50 < world.time)
		var/taste_sensitivity = get_taste_sensitivity()
		var/text_output = from.generate_taste_message(src, taste_sensitivity)
		if(text_output != last_taste_text || last_taste_time + 100 < world.time)
			to_chat(src, "<span class='info'>I can taste [text_output].</span>")
			// "something indescribable" -> too many tastes, not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output

#undef DEFAULT_TASTE_SENSITIVITY
