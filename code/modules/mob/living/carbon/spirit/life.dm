

/mob/living/carbon/spirit


/mob/living/carbon/spirit/Life()
	set invisibility = 0

	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

/mob/living/carbon/spirit/handle_environment()
	var/loc_temp = BODYTEMP_NORMAL
	if(!on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		if(loc_temp < bodytemperature)
			adjust_bodytemperature(max((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX))
		else
			adjust_bodytemperature(min((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX))


	if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !HAS_TRAIT(src, TRAIT_RESISTHEAT))
		switch(bodytemperature)
			if(360 to 400)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot, 1)
				apply_damage(HEAT_DAMAGE_LEVEL_1, BURN, skip_dtype = TRUE)
			if(400 to 460)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot, 2)
				apply_damage(HEAT_DAMAGE_LEVEL_2, BURN, skip_dtype = TRUE)
			if(460 to INFINITY)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/hot, 3)
				if(on_fire)
					apply_damage(HEAT_DAMAGE_LEVEL_3, BURN, skip_dtype = TRUE)
				else
					apply_damage(HEAT_DAMAGE_LEVEL_2, BURN, skip_dtype = TRUE)

	else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		switch(bodytemperature)
			if(200 to 260)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold, 1)
				apply_damage(COLD_DAMAGE_LEVEL_1, BURN, skip_dtype = TRUE)
			if(120 to 200)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold, 2)
				apply_damage(COLD_DAMAGE_LEVEL_2, BURN, skip_dtype = TRUE)
			if(-INFINITY to 120)
				throw_alert("temp", /atom/movable/screen/alert/status_effect/debuff/cold, 3)
				apply_damage(COLD_DAMAGE_LEVEL_3, BURN, skip_dtype = TRUE)

	else
		clear_alert("temp")

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
