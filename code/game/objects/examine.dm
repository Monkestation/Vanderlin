/datum/examine_effect/proc/trigger(mob/user)
	return

/datum/examine_effect/proc/get_examine_line(mob/user)
	return

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()
	var/price_text = get_displayed_price(user)
	if(uses_integrity)
		if(atom_integrity < max_integrity)
			var/meme = round(((atom_integrity / max_integrity) * 100), 1)
			switch(meme)
				if(0 to 1)
					. += "<span class='warning'>It's broken.</span>"
				if(1 to 10)
					. += "<span class='warning'>It's nearly broken.</span>"
				if(10 to 30)
					. += "<span class='warning'>It's severely damaged.</span>"
				if(30 to 80)
					. += "<span class='warning'>It's damaged.</span>"
				if(80 to 99)
					. += "<span class='warning'>It's a little damaged.</span>"
		if(max_integrity < initial(max_integrity))
			var/lost_percent = round((1 - (max_integrity / initial(max_integrity))) * 100, 1)
			if(lost_percent >= 50)
				. += "<span class='warning'>It has been beaten and repaired so many times that it is a shadow of what it once was.</span>"
			else if(lost_percent >= 25)
				. += "<span class='warning'>The metal bears the memory of old damage. It is weaker than it was made.</span>"
			else
				. += "<span class='warning'>There are signs of old repairs. It has lost some of its original strength.</span>"

		if(integrity_restores > 0)
			if(integrity_restores >= 3)
				. += "<span class='notice'>New material has been worked into it many times. It drinks in no more.</span>"
			else if(integrity_restores == 2)
				. += "<span class='notice'>New material has been worked into it more than once. It accepts further restoration poorly.</span>"
			else
				. += "<span class='notice'>New material has been worked into it. A skilled eye can see where the materials meet.</span>"


//	if(has_inspect_verb || (obj_integrity < max_integrity))
//		. += "<span class='notice'><a href='byond://?src=[REF(src)];inspect=1'>Inspect</a></span>"

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
		. += "<span class='info'>It is \a [baitquality] bait for fish.</span>"

	for(var/datum/examine_effect/E in examine_effects)
		E.trigger(user)

	var/weight = get_carry_weight()
	if(!weight)
		return
	if(weight < 1)
		. += "It weighs around [round(weight * 1000, 1)]g."
		return
	. += "It weighs around [round(weight, 0.01)]kg."
