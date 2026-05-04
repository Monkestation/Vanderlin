/obj/item/bodypart/examine(mob/user)
	. = ..()
	. += inspect_limb(user)

/obj/item/bodypart/proc/get_injury_types()
	var/list/untreated_types = list()
	for(var/datum/injury/injury in injuries)
		if(injury.germ_level >= INFECTION_LEVEL_ONE)
			untreated_types |= "germs"
		var/auto_heal = injury.can_autoheal()
		if(auto_heal)
			untreated_types |= "self_heal"
			continue
		if(injury.is_treated())
			continue
		untreated_types |= injury.damage_type
	return untreated_types

/obj/item/bodypart/get_mechanics_examine(mob/user)
	. = ..()
	var/list/untreated_types = get_injury_types()

	for(var/wound_type in untreated_types)
		switch(wound_type)
			if(WOUND_SLASH, WOUND_PIERCE, WOUND_BITE)
				. += "Suture or bandage cuts, bites, or punctures to allow them to heal."
			if(WOUND_BLUNT, WOUND_LASH)
				. += "Bandage bruises and lashes to allow them to heal."
			if(WOUND_BURN)
				. += "Disinfect and salve burns to allow them to heal."
			if("germs")
				. += "Infected injuries can be disinfected by covering them in beer or other disinfectent soaked bandages."
			if("self_heal")
				. += "Small injuries will heal on their own."

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(owner)
		return
	var/list/head_status = list()
	if(!brain)
		head_status += "<span class='dead'>The brain is missing.</span>"

	if(!eyes_left)
		head_status += "<span class='warning'>The left eye is missing.</span>"
	if(!eyes_right)
		head_status += "<span class='warning'>The right eye is missing.</span>"

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
		else if(HAS_TRAIT(src, TRAIT_ROTTEN))
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

		if(bandage || length(injuries))
			bodypart_status += "<B>Injuries:</B>"
			if(bandage)
				var/usedclass = "notice"
				if(GET_ATOM_BLOOD_DNA(bandage))
					usedclass = "bloody"
				bodypart_status += "<a href='byond://?src=[owner_ref];bandage=[REF(bandage)];bandaged_limb=[REF(src)]' class='[usedclass]'>Bandaged</a>"
			if(!bandage || observer_privilege)
				bodypart_status += get_injuries_desc()

	if(length(bodypart_status) <= 1)
		bodypart_status += "[src] is healthy."

	if(length(embedded_objects))
		bodypart_status += "<B>Embedded objects:</B>"
		for(var/obj/item/embedded as anything in embedded_objects)
			bodypart_status += "<a href='byond://?src=[owner_ref];embedded_object=[REF(embedded)];embedded_limb=[REF(src)]'>[embedded.name]</a>"

	return bodypart_status

/obj/item/bodypart/proc/get_chronic_status(mob/user, advanced = FALSE)
	var/list/chronic_types = list()
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_FRACTURE))
		chronic_types += "poorly healed fracture"
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_ARTHRITIS))
		chronic_types += "chronic arthritis"
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_MIGRAINE))
		chronic_types += "chronic migraines"
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_SCAR))
		chronic_types += "permanent scarring"
	if(CHECK_BITFIELD(limb_flags, BODYPART_CHRONIC_NERVE_DAMAGE))
		chronic_types += "nerve damage"
	return chronic_types

/obj/item/bodypart/proc/check_for_injuries(mob/user, advanced = FALSE, should_mechanical = FALSE)
	var/examination = "<span class='info'>"
	examination += "☼ [capitalize(src.name)]: "

	var/list/status = get_injury_status(user, advanced)
	if(!length(status))
		examination += "<span class='green'>OK</span>"
	else
		examination += status.Join(" | ")

	if(should_mechanical)
		var/list/result = list()
		var/list/mechanics_result = get_mechanics_examine(src)
		if(length(mechanics_result))
			var/mechanics_result_str = "<details><summary>Mechanics</summary>"
			for(var/line in mechanics_result)
				mechanics_result_str += " - " + span_blue(line) + "\n"
			mechanics_result_str += "</details>"
			result += mechanics_result_str
		for(var/i in 1 to (length(result) - 1))
			result[i] += "\n"

		examination += result.Join()

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
		wound_strings |= wound.get_check_name(user, advanced)

	status += get_chronic_status(user, advanced)

	status += get_injuries_desc()
	wound_strings -= null
	status += wound_strings

	for(var/obj/item/organ/possible_artery in shuffle(getorganslotlist(ORGAN_SLOT_ARTERY)))
		if(possible_artery.is_bruised())
			if(get_incision())
				status += "<span class='bloody'>[possible_artery.name]'s been cut.</span>"
			else
				status += "<span class='bloody'>spreading bruises underneath the [parse_zone(possible_artery.zone)].</span>"

	if(skeletonized)
		status += "<span class='dead'>SKELETON</span>"
	else if(HAS_TRAIT(src, TRAIT_ROTTEN))
		status += "<span class='necrosis'>NECROSIS</span>"
	else
		switch(germ_level)
			if(INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
				status += span_infection("Light Infection")
			if(INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
				status += span_infection("Medium Infection+")
			if(INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_TWO)
				status += span_infection("Serious Infection")
			if(INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3))
				status += span_infection("<b>Acute Infection</b>")
			if(INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3) to INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3))
				status += span_infection("<b>Acute Infection+</b>")
			if(INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3) to INFECTION_LEVEL_THREE)
				status += span_infection("<b>Acute Infection++</b>")
			if(INFECTION_LEVEL_THREE to INFINITY)
				status += span_necrosis("<b>Septic</b>")

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


/obj/item/bodypart/proc/get_injuries_desc()
	var/list/flavor_text = list()
	var/list/injury_descriptors = list()
	for(var/thing in injuries)
		var/datum/injury/injury = thing
		var/this_injury_desc = injury.get_desc(TRUE)
		if(!this_injury_desc)
			continue
		if(injury.can_autoheal() && (injury.current_stage >= length(injury.stages)) && (injury.damage < 5))
			this_injury_desc = "<span style='color: [COLOR_PALE_RED_GRAY];'>[this_injury_desc]</span>"
		if(injury.is_bleeding())
			if(is_artery_torn())
				this_injury_desc = "<b><i><span class='artery'>blood-gushing</span></i></b> [this_injury_desc]"
			//Completely arbitrary value
			else if(injury.get_bleed_rate() > 1)
				this_injury_desc = "<b><i>badly bleeding</i></b> [this_injury_desc]"
			else
				this_injury_desc = "<b>bleeding</b> [this_injury_desc]"
		if(injury.is_clamped())
			this_injury_desc = "<span style='color: [COLOR_SILVER]'>clamped</span> [this_injury_desc]"
		if(injury.is_sutured())
			this_injury_desc = "<span style='color: [COLOR_SILVER]'>sutured</span> [this_injury_desc]"
		if(injury.is_bandaged())
			this_injury_desc = "<span style='color: [COLOR_ASSEMBLY_WHITE]'>bandaged</span> [this_injury_desc]"
		if(injury.is_salved())
			this_injury_desc = "<span class='nicegreen'>salved</span> [this_injury_desc]"
		if(injury.is_disinfected())
			this_injury_desc = "<span style='color: [COLOR_BLUE_LIGHT]'>disinfected</span> [this_injury_desc]"

		if(injury.germ_level >= INFECTION_LEVEL_TWO)
			this_injury_desc = "<span class='necrosis'><b>pus-ridden</b></span> [this_injury_desc]"
		else if(injury.germ_level >= INFECTION_LEVEL_ONE)
			this_injury_desc = "<span class='infection'>inflamed</span> [this_injury_desc]"

		if(length(injury.embedded_objects))
			var/list/embed_strings = list()
			for(var/obj/item/embedded_item as anything in injury.embedded_objects)
				embed_strings += "\a [embedded_item]"
			this_injury_desc += " with [english_list(embed_strings)] poking out of [injury.amount > 1 ? "them" : "it"]"

		if(injury_descriptors[this_injury_desc])
			injury_descriptors[this_injury_desc] += injury.amount
		else
			injury_descriptors[this_injury_desc] = injury.amount

	for(var/injury in injury_descriptors)
		var/final_text = ""
		var/clean_final = ""
		final_text += injury
		clean_final = injury
		if(injury_descriptors[injury] > 1)
			if(findtext(final_text, "[COLOR_PALE_RED_GRAY];"))
				final_text += "<span style='color: [COLOR_PALE_RED_GRAY];'>s</span>"
				clean_final += "<span style='color: [COLOR_PALE_RED_GRAY];'>s</span>"
			else
				final_text += "s"
				clean_final += "s"
		switch(injury_descriptors[injury])
			if(-INFINITY to 1)
				final_text = ""
				final_text += "[clean_final]"
			if(2)
				final_text = ""
				final_text += "pair of [clean_final]"
			if(3 to 5)
				final_text = ""
				final_text += "several [clean_final]"
			if(6 to INFINITY)
				final_text = ""
				final_text += "ton of [clean_final]"
		flavor_text += final_text
	return flavor_text
