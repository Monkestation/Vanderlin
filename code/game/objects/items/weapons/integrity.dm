/obj/item
	/// Current blade integrity
	var/blade_int = 0
	/// Blade integrity at which dismemberment reaches 100% effectiveness
	var/dismember_blade_int = 0
	/// Maximum blade integrity
	var/max_blade_int = 0

/obj/item/proc/remove_bintegrity(amt as num, mob/user)
	if(user && HAS_TRAIT(user, TRAIT_SHARPER_BLADES))
		amt = amt * 0.7
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

/obj/item/proc/add_bintegrity(amt as num)
	if(blade_int >= max_blade_int)
		blade_int = max_blade_int
		return FALSE
	else
		blade_int = blade_int + amt
		if(blade_int >= max_blade_int)
			blade_int = max_blade_int
		return TRUE

/obj/structure/attackby(obj/item/I, mob/user, list/modifiers)
	user.changeNext_move(user.used_intent.clickcd)
	. = ..()


/obj/machinery/attackby(obj/item/I, mob/user, list/modifiers)
	user.changeNext_move(user.used_intent.clickcd)
	. = ..()

/obj/item/attackby(obj/item/I, mob/living/user, list/modifiers)
	user.changeNext_move(user.used_intent.clickcd)
	if(max_blade_int)
		if(istype(I, /obj/item/natural/stone))
			playsound(src, pick('sound/items/sharpen_long1.ogg','sound/items/sharpen_long2.ogg'), 100)
			user.visible_message("<span class='notice'>[user] sharpens [src]!</span>")
			degrade_bintegrity(0.5)
			add_bintegrity(max_blade_int * 0.1)
			if(prob(35))
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_step(user,user.dir)
				S.set_up(1, 1, front)
				S.start()
			return
	. = ..()
