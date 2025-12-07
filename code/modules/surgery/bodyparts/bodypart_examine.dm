/obj/item/bodypart/examine(mob/user)
	. = ..()
	. += inspect_limb(user)

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(owner)
		return
	var/list/head_status = list()
	if(!brain)
		head_status += "<span class='dead'>The brain is missing.</span>"
	/*
	else if(brain.suicided || brainmob?.suiciding)
		. += "<span class='info'>There's a pretty dumb expression on [real_name]'s face; they must have really hated life. There is no hope of recovery.</span>"
	else if(brain.brain_death || brainmob?.health <= HEALTH_THRESHOLD_DEAD)
		. += "<span class='info'></span>"
	else if(brainmob)
		if(brainmob.get_ghost(FALSE, TRUE))
			. += "<span class='info'>Its muscles are still twitching slightly... It still seems to have a bit of life left to it.</span>"
		else
			. += "<span class='info'>It seems particularly lifeless. Perhaps there'll be a chance for them later.</span>"
	else if(brain?.decoy_override)
		. += "<span class='info'>It seems particularly lifeless. Perhaps there'll be a chance for them later.</span>"
	else
		. += "<span class='info'>It seems completely devoid of life.</span>"
	*/

	if(!eyes)
		head_status += "<span class='warning'>The eyes appear are missing.</span>"

	if(!ears)
		head_status += "<span class='warning'>The ears are missing.</span>"

	if(!tongue)
		head_status += "<span class='warning'>The tongue is missing.</span>"

	if(length(head_status))
		. += "<B>Organs:</B>"
		. += head_status

/obj/item/bodypart/proc/inspect_limb(mob/user)
	var/bodypart_status = list("<B>[capitalize(name)]:</B>")
	var/observer_privilege = isobserver(user)
	if(owner && bodypart_disabled)
		switch(bodypart_disabled)
			if(BODYPART_DISABLED_DAMAGE)
				bodypart_status += "[src] is numb to touch."
			if(BODYPART_DISABLED_PARALYSIS)
				bodypart_status += "[src] is limp."
			if(BODYPART_DISABLED_CLAMPED)
				bodypart_status += "[src] is clamped."
			else
				bodypart_status += "[src] is crippled."
	if(has_wound(/datum/wound/fracture))
		bodypart_status += "[src] is fractured."
	if(has_wound(/datum/wound/dislocation))
		bodypart_status += "[src] is dislocated."
	var/location_accessible = TRUE
	if(owner)
		location_accessible = get_location_accessible(owner, body_zone)
		if(!observer_privilege && !location_accessible)
			bodypart_status += "Obscured by clothing."
	var/owner_ref = owner ? REF(owner) : REF(src)
	if(observer_privilege || location_accessible)
		if(skeletonized)
			bodypart_status += "[src] is skeletonized."
		else if(rotted)
			bodypart_status += "[src] is necrotic."

		var/brute = brute_dam
		var/burn = burn_dam
		if(brute >= DAMAGE_PRECISION)
			switch(brute/max_damage)
				if(0.75 to INFINITY)
					bodypart_status += "[src] is [heavy_brute_msg]."
				if(0.25 to 0.75)
					bodypart_status += "[src] is [medium_brute_msg]."
				else
					bodypart_status += "[src] is [light_brute_msg]."
		if(burn >= DAMAGE_PRECISION)
			switch(burn/max_damage)
				if(0.75 to INFINITY)
					bodypart_status += "[src] is [heavy_burn_msg]."
				if(0.25 to 0.75)
					bodypart_status += "[src] is [medium_burn_msg]."
				else
					bodypart_status += "[src] is [light_burn_msg]."

		if(!location_accessible)
			bodypart_status += "Obscured by clothing."

		if(bandage || length(wounds))
			bodypart_status += "<B>Wounds:</B>"
			if(bandage)
				var/usedclass = "notice"
				if(GET_ATOM_BLOOD_DNA(bandage))
					usedclass = "bloody"
				bodypart_status += "<a href='byond://?src=[owner_ref];bandage=[REF(bandage)];bandaged_limb=[REF(src)]' class='[usedclass]'>Bandaged</a>"
			if(!bandage || observer_privilege)
				for(var/datum/wound/wound as anything in wounds)
					bodypart_status += wound.get_visible_name(user)

	if(length(bodypart_status) <= 1)
		bodypart_status += "[src] is healthy."

	if(length(embedded_objects))
		bodypart_status += "<B>Embedded objects:</B>"
		for(var/obj/item/embedded as anything in embedded_objects)
			bodypart_status += "<a href='byond://?src=[owner_ref];embedded_object=[REF(embedded)];embedded_limb=[REF(src)]'>[embedded.name]</a>"

	return bodypart_status

/obj/item/bodypart/proc/check_for_injuries(mob/user, advanced = FALSE)
	var/examination = "<span class='info'>"
	examination += "☼ [capitalize(src.name)]: "

	var/list/status = get_injury_status(user, advanced)
	if(!length(status))
		examination += "<span class='green'>OK</span>"
	else
		examination += status.Join(" | ")

	examination += "</span>"
	return examination

/obj/item/bodypart/proc/get_injury_status(mob/user, advanced = FALSE)
	var/list/status = list()

	var/brute = brute_dam
	var/burn = burn_dam

	if(advanced)
		if(brute)
			status += "<span class='[brute >= 10 ? "danger" : "warning"]'>[brute] BRUTE</span>"
		if(burn)
			status += "<span class='[burn >= 10 ? "danger" : "warning"]'>[burn] BURN</span>"
	else
		if(brute >= DAMAGE_PRECISION)
			switch(brute/max_damage)
				if(0.75 to INFINITY)
					status += "<span class='userdanger'><B>[heavy_brute_msg]</B></span>"
				if(0.5 to 0.75)
					status += "<span class='userdanger'>[heavy_brute_msg]</span>"
				if(0.25 to 0.5)
					status += "<span class='danger'>[medium_brute_msg]</span>"
				else
					status += "<span class='warning'>[light_brute_msg]</span>"

		if(burn >= DAMAGE_PRECISION)
			switch(burn/max_damage)
				if(0.75 to INFINITY)
					status += "<span class='userdanger'><B>[heavy_burn_msg]</B></span>"
				if(0.5 to 0.75)
					status += "<span class='userdanger'>[medium_burn_msg]</span>"
				if(0.25 to 0.5)
					status += "<span class='danger'>[medium_burn_msg]</span>"
				else
					status += "<span class='warning'>[light_burn_msg]</span>"

	var/bleed_rate = get_bleed_rate()
	if(bleed_rate)
		if(bleed_rate > 1) //Totally arbitrary value
			status += "<span class='bloody'><B>BLEEDING</B></span>"
		else
			status += "<span class='bloody'>BLEEDING</span>"

	var/list/wound_strings = list()
	for(var/datum/wound/wound as anything in wounds)
		if(!wound.check_name)
			continue
		wound_strings |= wound.get_check_name(user)
	status += wound_strings

	if(skeletonized)
		status += "<span class='dead'>SKELETON</span>"
	else if(rotted)
		status += "<span class='necrosis'>NECROSIS</span>"

	var/owner_ref = owner ? REF(owner) : REF(src)
	for(var/obj/item/embedded as anything in embedded_objects)
		if(embedded.embedding?.embedded_bloodloss)
			status += "<a href='byond://?src=[owner_ref];embedded_limb=[REF(src)];embedded_object=[REF(embedded)];' class='danger'>[uppertext(embedded.name)]</a>"
		else
			status += "<a href='byond://?src=[owner_ref];embedded_limb=[REF(src)];embedded_object=[REF(embedded)];' class='info'>[uppertext(embedded.name)]</a>"

	if(bandage)
		if(GET_ATOM_BLOOD_DNA_LENGTH(bandage))
			status += "<a href='byond://?src=[owner_ref];bandaged_limb=[REF(src)];bandage=[REF(bandage)]' class='bloody'>[uppertext(bandage.name)]</a>"
		else
			status += "<a href='byond://?src=[owner_ref];bandaged_limb=[REF(src)];bandage=[REF(bandage)]' class='info'>[uppertext(bandage.name)]</a>"

	if(bodypart_disabled)
		status += "<span class='deadsay'>CRIPPLED</span>"

	return status

/*
	for(var/body_zone in body_zones)
		var/self_aware = FALSE
		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			self_aware = TRUE
		var/max_damage = max_damage
		var/status = ""
		var/brutedamage = brute_dam
		var/burndamage = burn_dam
		if(hallucination)
			if(prob(30))
				brutedamage += rand(30,40)
			if(prob(30))
				burndamage += rand(30,40)

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			status = "[brutedamage] brute damage and [burndamage] burn damage"
			if(!brutedamage && !burndamage)
				status = "no damage"

		else
			if(brutedamage > 0)
				status = light_brute_msg
			if(brutedamage > max_damage * 0.4))
				status = medium_brute_msg
			if(brutedamage > max_damage * 0.8))
				status = heavy_brute_msg
			if(brutedamage > 0 && burndamage > 0)
				examination += " and "

			if(burndamage > max_damage * 0.8))
				examination += heavy_burn_msg
			else if(burndamage > max_damage * 0.2))
				examination += medium_burn_msg
			else if(burndamage > 0)
				examination += light_burn_msg

			if(status == "")
				status = "OK"
		var/no_damage
		if(status == "OK" || status == "no damage")
			no_damage = TRUE
		var/isdisabled = " "
		if(is_disabled())
			isdisabled = " is disabled "
			if(no_damage)
				isdisabled += " but otherwise "
			else
				isdisabled += " and "
		to_chat(src, "\t <span class='[no_damage ? "notice" : "warning"]'>My [name][isdisabled][self_aware ? " has " : " is "][status].</span>")

		for(var/obj/item/I in embedded_objects)
			to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] in my [name]!</a>")

	for(var/t in missing)
		to_chat(src, "<span class='boldannounce'>My [parse_zone(t)] is missing!</span>")

	if(bleed_rate)
		to_chat(src, "<span class='danger'>I am bleeding!</span>")
	if(getStaminaLoss())
		if(getStaminaLoss() > 30)
			to_chat(src, "<span class='info'>You're completely exhausted.</span>")
		else
			to_chat(src, "<span class='info'>I feel fatigued.</span>")
	if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
		if(toxloss)
			if(toxloss > 10)
				to_chat(src, "<span class='danger'>I feel sick.</span>")
			else if(toxloss > 20)
				to_chat(src, "<span class='danger'>I feel nauseated.</span>")
			else if(toxloss > 40)
				to_chat(src, "<span class='danger'>I feel very unwell!</span>")
		if(oxyloss)
			if(oxyloss > 10)
				to_chat(src, "<span class='danger'>I feel lightheaded.</span>")
			else if(oxyloss > 20)
				to_chat(src, "<span class='danger'>My thinking is clouded and distant.</span>")
			else if(oxyloss > 30)
				to_chat(src, "<span class='danger'>You're choking!</span>")

	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		switch(nutrition)
			if(NUTRITION_LEVEL_FULL to INFINITY)
				to_chat(src, "<span class='info'>You're completely stuffed!</span>")
			if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
				to_chat(src, "<span class='info'>You're well-fed!</span>")
			if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
				to_chat(src, "<span class='info'>You're not hungry.</span>")
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				to_chat(src, "<span class='info'>I could use a bite to eat.</span>")
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				to_chat(src, "<span class='info'>I feel quite hungry.</span>")
			if(0 to NUTRITION_LEVEL_STARVING)
				to_chat(src, "<span class='danger'>You're starving!</span>")

	//Compiles then shows the list of damaged organs and broken organs
	var/list/broken = list()
	var/list/damaged = list()
	var/broken_message
	var/damaged_message
	var/broken_plural
	var/damaged_plural
	//Sets organs into their proper list
	for(var/obj/item/organ/organ as anything in internal_organs)
		if(organ.organ_flags & ORGAN_FAILING)
			if(broken.len)
				broken += ", "
			broken += organ.name
		else if(organ.damage > organ.low_threshold)
			if(damaged.len)
				damaged += ", "
			damaged += organ.name
	//Checks to enforce proper grammar, inserts words as necessary into the list
	if(broken.len)
		if(broken.len > 1)
			broken.Insert(broken.len, "and ")
			broken_plural = TRUE
		else
			var/holder = broken[1]	//our one and only element
			if(holder[length(holder)] == "s")
				broken_plural = TRUE
		//Put the items in that list into a string of text
		for(var/B in broken)
			broken_message += B
		to_chat(src, "<span class='warning'>My [broken_message] [broken_plural ? "are" : "is"] non-functional!</span>")
	if(damaged.len)
		if(damaged.len > 1)
			damaged.Insert(damaged.len, "and ")
			damaged_plural = TRUE
		else
			var/holder = damaged[1]
			if(holder[length(holder)] == "s")
				damaged_plural = TRUE
		for(var/D in damaged)
			damaged_message += D
		to_chat(src, "<span class='info'>My [damaged_message] [damaged_plural ? "are" : "is"] hurt.</span>")


	var/max_damage = FB.max_damage
	var/status = ""
	var/brutedamage = FB.brute_dam
	var/burndamage = FB.burn_dam
	var/wounddamage = 0
	for(var/datum/wound/wound as anything in FB.wounds)
		wounddamage = wounddamage + wound.woundpain
	if(hallucination)
		if(prob(30))
			brutedamage += rand(30,40)
		if(prob(30))
			burndamage += rand(30,40)

	if(brutedamage > 0)
		status = FB.light_brute_msg
	if(brutedamage > max_damage * 0.4))
		status = FB.medium_brute_msg
	if(brutedamage > max_damage * 0.8))
		status = FB.heavy_brute_msg
	if(brutedamage > 0)
		if(burndamage > 0 && wounddamage > 0)
			examination += ", "
		else if(burndamage > 0 || wounddamage > 0)
			examination += " and "

	if(burndamage > max_damage * 0.8))
		examination += FB.heavy_burn_msg
	else if(burndamage > max_damage * 0.2))
		examination += FB.medium_burn_msg
	else if(burndamage > 0)
		examination += FB.light_burn_msg
	if(burndamage > 0)
		if(brutedamage > 0 && wounddamage > 0)
			examination += ", and "
		else if(wounddamage > 0)
			examination += " and "

	if(wounddamage > 0)
		if(wounddamage > 80)
			examination += "has incredibly painful wounds."
		else if(wounddamage > 40)
			examination += "has painful wounds."
		else
			examination += "has light wounds."

	if(status == "")
		status = "is OK."
	var/no_damage
	if(status == "is OK." || status == "no damage")
		no_damage = TRUE
	var/isdisabled = ""
	switch(FB.is_disabled())
		if(BODYPART_DISABLED_WOUND)
			isdisabled = "broken "
		if(BODYPART_DISABLED_DAMAGE)
			isdisabled = "numb "
		if(BODYPART_DISABLED_PARALYSIS)
			isdisabled = "limp "
		if(BODYPART_DISABLED_ROT)
			if(FB.skeletonized)
				isdisabled = "skeletonized "
			else
				isdisabled = "rotting "
	to_chat(src, "\t <span class='[no_damage ? "notice" : "warning"]'>My [isdisabled][FB.name] [status].</span>")

	for(var/obj/item/I in FB.embedded_objects)
		to_chat(src, "\t <a href='byond://?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(FB)]' class='warning'>There is \a [I] in my [FB.name]!</a>")
*/
