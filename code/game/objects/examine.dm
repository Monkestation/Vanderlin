/datum/examine_effect/proc/trigger(mob/user)
	return

/datum/examine_effect/proc/get_examine_line(mob/user)
	return

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()
	var/p_They = p_they(TRUE)
	var/p_are = p_are()

	switch(germ_level)
		// if(GERM_LEVEL_DIRTY to GERM_LEVEL_FILTHY)
		// 	. += "[p_They] [p_are] a bit dirty."
		if(GERM_LEVEL_FILTHY to GERM_LEVEL_SMASHPLAYER)
			. += span_warning("[p_They] [p_are] filthy.")
		if(GERM_LEVEL_SMASHPLAYER to INFINITY)
			. += span_warning("[p_They] [p_are] <b>foul</b>.")

	var/price_text = get_displayed_price(user)
	if(uses_integrity)
		if(atom_integrity < max_integrity)
			var/meme = round(((atom_integrity / max_integrity) * 100), 1)
			switch(meme)
				if(0 to 1)
					. += span_warning("It's broken.")
				if(1 to 10)
					. += span_warning("It's nearly broken.")
				if(10 to 30)
					. += span_warning("It's severely damaged.")
				if(30 to 80)
					. += span_warning("It's damaged.")
				if(80 to 99)
					. += span_warning("It's a little damaged.")

		if(max_integrity < initial(max_integrity))
			var/lost_percent = round((1 - (max_integrity / initial(max_integrity))) * 100, 1)
			if(lost_percent >= 50)
				. += span_warning("Long-term damage has rendered this a shadow of what it once was.")
			else if(lost_percent >= 25)
				. += span_warning("Its structure is compromised by old damage.")
			else
				. += span_warning("The material has lost some of its original strength.")

		// if(integrity_restores > 0)
		// 	if(integrity_restores >= 3)
		// 		. += "<span class='notice'>New material has been worked into it many times. It drinks in no more.</span>"
		// 	else if(integrity_restores == 2)
		// 		. += "<span class='notice'>New material has been worked into it more than once. It accepts further restoration poorly.</span>"
		// 	else
		// 		. += "<span class='notice'>New material has been worked into it. A skilled eye can see where the materials meet.</span>"


//	if(has_inspect_verb || (obj_integrity < max_integrity))
//		. += span_notice("<a href='byond://?src=[REF(src)];inspect=1'>Inspect</a>")

	if(price_text)
		. += price_text

// Only show if it's actually useable as bait, so that it doesn't show up on every single item of the game.
	if(isbait)
		var/baitquality = ""
		switch(baitpenalty)
			if(0)
				baitquality = "excellent"
			if(5)
				baitquality = "good"
			if(10)
				baitquality = "passable"
		. += span_info("It is \a [baitquality] bait for fish.")

	for(var/datum/examine_effect/E in examine_effects)
		E.trigger(user)

	var/weight = get_carry_weight()
	if(!weight)
		return
	if(weight < 1)
		. += "It weighs around [round(weight * 1000, 1)]g."
		return
	. += "It weighs around [round(weight, 0.01)]kg."
