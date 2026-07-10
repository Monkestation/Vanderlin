/obj/item
	/// Current blade integrity
	var/blade_int = 0
	/// Blade integrity at which dismemberment reaches 100% effectiveness
	var/dismember_blade_int = 0
	/// randomize the blade integrity on creation?
	var/randomize_blade_int = TRUE
	/// Maximum blade integrity
	var/max_blade_int = 0
	/// Sharpness loss multiplier
	var/sharpness_mod = 1

/obj/item/proc/remove_bintegrity(amt as num, mob/user)
	if(sharpness_mod != 1)
		amt *= sharpness_mod
	var/mob/living/L
	if(loc && loc == user)
		L = user
	else
		if(loc && ishuman(loc))
			L = loc
	if(L && HAS_TRAIT(L, TRAIT_SHARPER_BLADES))
		amt = amt * 0.67
	if(L && max_blade_int)
		var/ratio = blade_int / max_blade_int
		var/newratio = (blade_int - amt) / max_blade_int
		if(ratio > SHARPNESS_TIER1_THRESHOLD && newratio <= SHARPNESS_TIER1_THRESHOLD)
			if(GET_MOB_ATTRIBUTE_VALUE(L, STAT_INTELLIGENCE) > 9)
				to_chat(L, span_info("<i><font color = '#ececec'>The edge chips! \The [src]'s damage will start to slowly wane, now.</font></i>"))
			playsound(L, 'sound/combat/sharpness_loss1.ogg', 75, TRUE)
		if(ratio > SHARPNESS_TIER2_THRESHOLD && newratio <= SHARPNESS_TIER2_THRESHOLD)
			if(GET_MOB_ATTRIBUTE_VALUE(L, STAT_INTELLIGENCE) > 9)
				to_chat (L, span_userdanger("A chunk snapped off! \The [src]'s damage will decay much quicker now."))
			playsound(L, 'sound/combat/sharpness_loss2.ogg', 100, TRUE)

	blade_int = blade_int - amt
	if(blade_int <= 0)
		blade_int = 0
		return FALSE
	return TRUE

/obj/item/proc/degrade_bintegrity(amt as num)
	if(max_blade_int <= 10)
		max_blade_int = 10
		return FALSE
	else
		max_blade_int = max_blade_int - amt
		if(max_blade_int <= 10)
			max_blade_int = 10
		return TRUE

/obj/item/proc/add_bintegrity(amt as num, mob/user)
	if(blade_int >= max_blade_int)
		blade_int = max_blade_int
		return FALSE
	else
		var/ratio = blade_int / max_blade_int
		if(ratio < SHARPNESS_TIER2_THRESHOLD && ((blade_int + amt) / max_blade_int) > SHARPNESS_TIER2_THRESHOLD)
			to_chat(user, span_info("The <b>chunks</b> smooth out. The edge regains some smoothness."))
		if(ratio < SHARPNESS_TIER1_THRESHOLD && ((blade_int + amt) / max_blade_int) > SHARPNESS_TIER1_THRESHOLD)
			to_chat(user, span_info("The <b>chips</b> disappear. The edge is now as sharp as ever."))
		blade_int = blade_int + amt
		if(blade_int >= max_blade_int)
			blade_int = max_blade_int
		return TRUE

/obj/item/proc/restore_bintegrity()
	max_blade_int = initial(max_blade_int)
	blade_int = initial(max_blade_int)
