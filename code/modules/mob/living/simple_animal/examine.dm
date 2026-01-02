/mob/living/simple_animal/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_is = p_are()

	. = list("<span class='info'>ᛉ ------------ ᛉ\nThis is \a <EM>[src]</EM>.")

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	if(user == src)
		m1 = "I am"
		m2 = "my"

	for(var/obj/item/held_item in held_items)
		if(held_item.item_flags & ABSTRACT)
			continue
		. += "[m1] holding [held_item.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(held_item))]."

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/temp = getBruteLoss() + getFireLoss()
	// Damage
	switch(temp)
		if(5 to 25)
			msg += "[m1] a little wounded."
		if(25 to 50)
			msg += "[m1] wounded."
		if(50 to 100)
			msg += "<B>[m1] severely wounded.</B>"
		if(100 to INFINITY)
			msg += "<span class='danger'>[m1] gravely wounded.</span>"

	// Blood volume
	switch(blood_volume)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			msg += "<span class='artery'><B>[m1] extremely pale and sickly.</B></span>"
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			msg += "<span class='artery'><B>[m1] very pale.</B></span>"
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += "<span class='artery'>[m1] pale.</span>"
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += "<span class='artery'>[m1] a little pale.</span>"

	// Bleeding
	var/bleed_rate = get_bleed_rate()
	if(bleed_rate)
		var/bleed_wording = "bleeding"
		switch(bleed_rate)
			if(0 to 1)
				bleed_wording = "bleeding slightly"
			if(1 to 5)
				bleed_wording = "bleeding"
			if(5 to 10)
				bleed_wording = "bleeding a lot"
			if(10 to INFINITY)
				bleed_wording = "bleeding profusely"
		if(bleed_rate >= 5)
			msg += "<span class='bloody'><B>[m1] [bleed_wording]</B>!</span>"
		else
			msg += "<span class='bloody'>[m1] [bleed_wording]!</span>"

	//Fire/water stacks
	if(on_fire)
		var/fire_text = "[m1] on fire!"
		if(user.has_flaw(/datum/charflaw/addiction/pyromaniac))
			fire_text += span_boldred(" IT'S BEAUTIFUL!")
			user.sate_addiction()
		msg += fire_text
	if(fire_stacks + divine_fire_stacks > 0)
		msg += "[m1] covered in something flammable."
	else if(fire_stacks < 0 && !on_fire)
		msg += "[m1] soaked."

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1] being grabbed by [pulledby]."

	if(stat >= UNCONSCIOUS)
		msg += "[m1] unconscious."

	if(length(msg))
		. += "<span class='warning'>[msg.Join("\n")]</span>"

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += "<span class='warning'><B>[t_He] look[p_s()] much stronger than I.</B></span>"
			if(1 to 5)
				. += "<span class='warning'>[t_He] look[p_s()] stronger than I.</span>"
			if(0)
				. += "[t_He] look[p_s()] about as strong as I."
			if(-5 to -1)
				. += "<span class='warning'>[t_He] look[p_s()] weaker than I.</span>"
			if(-INFINITY to -5)
				. += "<span class='warning'><B>[t_He] look[p_s()] much weaker than I.</B></span>"

	if(Adjacent(user) && HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		. += "<a href='byond://?src=[REF(src)];inspect_animal=1'>Inspect Wounds</a>"

	if(desc)
		. += desc

	. += "ᛉ ------------ ᛉ</span>"
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)
