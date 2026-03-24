/mob/living/carbon/get_examine_name(mob/user)
	if(IsAdminGhost(user))
		return ..()
	return get_visible_name(html_tags = list("EM"))


/mob/living/carbon/examine(mob/user)
	. = list()

	var/list/P
	if(user == src)
		P = list(
			THEY = "I",
			THEM = "me",
			THEIR = "my",
			HAVE = "have",
			ARE = "am",
			THEYRE = "I am",
			THEYVE = "I have"
		)
	else
		P = list(
			THEY = p_they(TRUE),
			THEM = p_them(),
			THEIR = p_their(),
			HAVE = p_have(),
			ARE = p_are(),
			THEYRE = "[p_they(TRUE)] [p_are()]",
			THEYVE = "[p_they(TRUE)] [p_have()]",
		)

	var/alist/examine_sections = get_examine_list(user, P)

	//The wrap-up. Anything else we need to do before we start spanning things, we do it here.
	//Note that this also sends a copy of our subjective pronouns.
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, examine_sections, P)


	// round any decimal sections up to the rest of the group
	var/list/rounded_sections = list()
	for(var/section_index,section in examine_sections)
		if(!length(section))
			continue
		var/rounded_index = floor(section_index)
		LISTASSERTLEN(rounded_sections, rounded_index, list())
		LAZYADDASSOC(rounded_sections, rounded_index, section)

	for(var/i=1, i <= length(rounded_sections), i++)
		var/list/section = rounded_sections[i]
		if(!length(section))
			continue
		var/join_marker
		switch(i)
			if(EXAMINE_SECT_SPECIES)
				join_marker = " "
			else
				join_marker = "\n"
		var/joined_section = section.Join(join_marker)
		// post modifiers
		switch(i)
			if(EXAMINE_SECT_WARNING)
				joined_section = span_tinywarning(joined_section)
			if(EXAMINE_SECT_GEAR)
				joined_section = "<hr>[joined_section]<hr>"
		. += joined_section


/**
 * The contents of the examine box.
 * user = the examiner
 * P = the list of pronouns with a defined key, like THEY
 **/
/mob/living/carbon/proc/get_examine_list(mob/user, list/P)
	. = alist()
	// Our name
	LAZYADDASSOCLIST(., EXAMINE_SECT_NAME, span_larger("[get_examine_string(user, TRUE)]."))
	// Our face
	var/can_see_face = IsAdminGhost(user) || is_human_part_visible(src, HIDEFACE)
	LAZYADDASSOC(., EXAMINE_SECT_FACE+0.5, can_see_face ? get_examine_face(user, P, .) : get_examine_noface(user, P, .))
	// Our gear
	LAZYADDASSOC(., EXAMINE_SECT_GEAR+0.5, get_examine_gear(user, P, .))
	/// Our physical aspects
	LAZYADDASSOC(., EXAMINE_SECT_BODY+0.5, get_examine_body(user, P, .))
	/// Warnings
	LAZYADDASSOC(., EXAMINE_SECT_WARNING+0.5, get_examine_warnings(user, P, .))
	/// Our health
	LAZYADDASSOC(., EXAMINE_SECT_HEALTH+0.5, get_examine_health(user, P, .))

	// Antag stuff. This throws itself wherever it feels like.
	for(var/datum/antagonist/antag_datum in user.mind?.antag_datums)
		antag_datum.examine_target(user, src, P, .)


// Details we will only surmise by seeing their face
/mob/living/carbon/proc/get_examine_face(mob/user, list/P, list/examine_list)
	var/self_inspect = user == src
	var/pl = self_inspect ? "" : p_s()
	//var/mob/dead/observer/O = isobserver(user) ? user : null
	//var/mob/living/L = isliving(user) ? user : null
	//var/mob/living/carbon/C = iscarbon(user) ? user : null
	var/mob/living/carbon/human/H = ishuman(user) ? user : null

	. = list()

	// Species, just below the name
	var/datum/species/species = dna?.species
	if(species)
		var/species_name = "\improper [user.mind?.has_antag_datum(/datum/antagonist/maniac) ? "disgusting pig" : species.name]"
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES, "[P[THEYRE]] \a [species_name].")

	// Lord's title
	if(GLOB.lord_titles[real_name]) //should be tied to known persons but can't do that until there is a way to recognise new people
		. += span_notice("[P[THEYVE]] been granted the title of \"[GLOB.lord_titles[real_name]]\".")

	// Fish
	if(HAS_TRAIT(src, TRAIT_FISHFACE))
		if(self_inspect) // we fish
			user.add_stress(/datum/stress_event/self_fishface)
		else if(HAS_TRAIT(user, TRAIT_FISHFACE)) // we also fish
			user.add_stress(/datum/stress_event/fellow_fishface)
		else
			user.add_stress(/datum/stress_event/fishface)
			if(H?.age == AGE_CHILD && !HAS_ANY_OF_TRAITS(user, list(TRAIT_FEARLESS, TRAIT_STEELHEARTED, TRAIT_NOMOOD))) // destroy the child
				. += span_phobia("A MONSTER!!!")
			else // normal
				. += span_necrosis("A hideous Triton.")
	// Beauty/Ugly
	else //if youre a fish face you cant cancel it out
		var/ugly = HAS_ANY_OF_TRAITS(src, list(TRAIT_UGLY, TRAIT_ABOMINATION, TRAIT_DISFIGURED)) //todo: ABOMINATION descriptor
		var/beautiful = HAS_TRAIT(src, TRAIT_BEAUTIFUL)
		if(ugly ^ beautiful)
			if(beautiful)
				var/beauty_desc = "gorgeous"
				if(pronouns == SHE_HER) beauty_desc = "beautiful"
				else if(pronouns == HE_HIM) beauty_desc = "handsome"
				. += span_rose("[P[THEYRE]] [beauty_desc]!")
				user.add_stress(self_inspect ? /datum/stress_event/beautiful_self : /datum/stress_event/beautiful)
			else // you can only be ugly then, huh.
				. += span_necrosis("[P[THEYRE]] hideous!")
				user.add_stress(self_inspect ? /datum/stress_event/ugly_self : /datum/stress_event/ugly)

	// Self inspections
	if(!self_inspect)
		//Old Party
		if(HAS_TRAIT(src, TRAIT_OLDPARTY) && HAS_TRAIT(user, TRAIT_OLDPARTY))
			. += span_nicegreen("Ahh... my old friend!")
			user.add_stress(/datum/stress_event/saw_old_party)
		// Intolerant
		else if(!HAS_TRAIT(user, TRAIT_TOLERANT)) // friendship is kinda like tolerance after all
			if(!isdarkelf(user) && isdarkelf(src))
				user.add_stress(/datum/stress_event/delf)
			if(!istiefling(user) && istiefling(src))
				user.add_stress(/datum/stress_event/tieb)
			if(!ishalforc(user) && ishalforc(src))
				user.add_stress(/datum/stress_event/horc)

		// Excommunications
		if(real_name in GLOB.excommunicated_players)
			. += span_redtextbig("EXCOMMUNICATED!")
		if(real_name in GLOB.heretical_players)
			. += span_redtextbig("HERETIC! SHAME!")

		// Outlaws
		if(HAS_MIND_TRAIT(user, TRAIT_KNOWBANDITS) && (real_name in GLOB.outlawed_players))
			. += span_boldred(mind?.special_role == "Bandit" ? "BANDIT!" : "OUTLAW!")

		// Court Agents
		var/list/known_frumentarii = user.mind?.cached_frumentarii
		if(name in known_frumentarii)
			if(known_frumentarii[name])
				. += span_smallgreen("[P[THEYRE]] an agent of the court.")
			else
				. += span_redtextsmall("[P[THEYRE]] an ex-agent of the court.")

		// Faceless
		if(HAS_TRAIT(src, TRAIT_FACELESS))
			. += span_userdanger("NO FACE!!")
		// Foreigner
		if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_TRAIT(user, TRAIT_FOREIGNER))
			. += span_tinywarning("A foreigner.")
			user.add_stress(/datum/stress_event/para/foreigner)
		// Thuild
		if(HAS_TRAIT(src, TRAIT_THIEVESGUILD) && HAS_TRAIT(user, TRAIT_THIEVESGUILD))
			. += span_smallgreen("A member of the Thieves' Guild.")
		// Cabal
		if(HAS_TRAIT(user, TRAIT_CABAL) && (istype(patron, /datum/patron/inhumen/zizo) || HAS_TRAIT(src, TRAIT_CABAL)))
			. += span_purple("A fellow seeker of Her ascension.")
		// Centrist
		if(HAS_TRAIT(user, TRAIT_DIVINE_SERVANT) && (HAS_TRAIT(src, TRAIT_DIVINE_CENTRIST) && !HAS_TRAIT(src, TRAIT_DIVINE_SERVANT)))
			. += SPAN_GOD_ASTRATA("An 'Enlightened Centrist'. Shame!")

		// The disgusing inquistion section
		var/they_pur = HAS_TRAIT(user, TRAIT_PURITAN)
		var/they_inquis = HAS_TRAIT(user, TRAIT_INQUISITION)
		var/im_pur = HAS_TRAIT(src, TRAIT_PURITAN)
		var/im_inquis = HAS_TRAIT(src, TRAIT_INQUISITION)
		var/inquis_msg
		if(they_inquis && im_inquis)
			inquis_msg = "A Practical of our Psydonic Inquisitorial Sect."
		if(they_inquis && im_pur)
			inquis_msg = "The Lorde-Inquisitor of our Psydonic Inquisitorial Sect."
		if(they_pur && im_inquis)
			inquis_msg = "Subordinate to me in the Psydonic Inquisitorial Sect."
		if(they_pur && im_pur)
			inquis_msg = "The Lorde-Inquisitor of the Sect sent here. That should be me though..."
		if(inquis_msg)
			. += span_silver(inquis_msg)


		// Disgust
		var/disgust_msg
		switch(disgust)
			if(DISGUST_LEVEL_SLIGHTLYGROSS to DISGUST_LEVEL_GROSS)
				disgust_msg = "[P[THEY]] look[pl] a little disgusted."
			if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
				disgust_msg = span_warning("[P[THEY]] look[pl] disgusted.")
			if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
				disgust_msg = span_necrosis("[P[THEY]] look[pl] really disgusted.")
			if(DISGUST_LEVEL_DISGUSTED to INFINITY)
				disgust_msg = span_necrosis(html_tag("B", "[P[THEY]] look[pl] extremely disgusted."))
		if(disgust_msg && HAS_TRAIT(user, TRAIT_EMPATH) || disgust >= DISGUST_LEVEL_DISGUSTED)
			. += disgust_msg

		// Stress
		var/stress_msg
		switch(stress)
			if(15 to INFINITY)
				stress_msg = span_boldred("[P[THEYRE]] having a panic attack.")
			if(STRESS_INSANE to 15)
				stress_msg = span_red("[P[THEYRE]] twitching at the eyes.")
			if(STRESS_VBAD to STRESS_INSANE)
				stress_msg = span_warning("[P[THEY]] look[pl] really stressed.")
			if(STRESS_BAD to STRESS_VBAD)
				stress_msg = span_tinywarning("[P[THEY]] look[pl] stressed.")
			if(STRESS_NEUTRAL to STRESS_BAD)
				stress_msg = span_tinynotice("[P[THEY]] look[pl] a little stressed.")
		if(stress_msg && HAS_TRAIT(user, TRAIT_EMPATH) || stress >= STRESS_INSANE)
			. += stress_msg

		//Drunkenness
		var/drunk_msg
		switch(drunkenness)
			if(11 to 21)
				drunk_msg = span_tinynoticeital("[P[THEY]] look[pl] slightly flushed.")
			if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
				drunk_msg = span_tinynotice("[P[THEY]] look[pl] flushed.")
			if(41.01 to 51)
				drunk_msg = span_smallnotice("[P[THEY]] look[pl] quite flushed and [P[THEIR]] breath smells of ale.")
			if(51.01 to 61)
				drunk_msg = span_notice("[P[THEY]] look[pl] very flushed, with breath reeking of ale.")
			if(61.01 to 91)
				drunk_msg = span_boldnotice("[P[THEY]] look[pl] like a drunken mess.")
			if(91.01 to INFINITY)
				drunk_msg = span_bignotice(html_tag("B", "[P[THEYRE]] a shitfaced, slobbering wreck."))
		if(drunk_msg)
			. += drunk_msg
		// Closed eyes
		if(eyesclosed)
			. += "[capitalize(P[THEIR])] eyes are closed."

/mob/living/carbon/proc/get_examine_noface(mob/user, list/P, list/examine_list)
	. = list()
	if(stat < UNCONSCIOUS)
		user.add_stress(/datum/stress_event/hunted)


/mob/living/carbon/proc/get_examine_gear(mob/user, list/P, list/examine_list)
	. = list()
	var/list/unobscured = get_unobscured_items(FALSE)
	for(var/obj/item/I as anything in unobscured)
		var/slot_title = null
		switch(unobscured[I]) // this could probably be abstracted into its own proc at some point
			if(ITEM_SLOT_SHIRT, ITEM_SLOT_ARMOR, ITEM_SLOT_PANTS, ITEM_SLOT_CLOAK, ITEM_SLOT_SHOES)
				slot_title = " on"
			if(ITEM_SLOT_HEAD)
				slot_title = " on [P[THEIR]] head"
			if(ITEM_SLOT_MASK)
				slot_title = " on [P[THEIR]] face"
			if(ITEM_SLOT_MOUTH)
				slot_title = " in [P[THEIR]] mouth"
			if(ITEM_SLOT_NECK)
				slot_title = " around [P[THEIR]] neck"
			if(ITEM_SLOT_BACK_L)
				slot_title = " on [P[THEIR]] left shoulder"
			if(ITEM_SLOT_BACK_R)
				slot_title = " on [P[THEIR]] right shoulder"
			if(ITEM_SLOT_WRISTS)
				slot_title = " on [P[THEIR]] wrist[I.gender == PLURAL ? "s" : ""]"
			if(ITEM_SLOT_GLOVES)
				slot_title = " on [P[THEIR]] hand[I.gender == PLURAL ? "s" : ""]"
			if(ITEM_SLOT_RING)
				slot_title = " on [P[THEIR]] finger[I.gender == PLURAL ? "s" : ""]"
			if(ITEM_SLOT_BELT)
				slot_title = " around [P[THEIR]] waist"
			if(ITEM_SLOT_BELT_L)
				slot_title = " on [P[THEIR]] left side"
			if(ITEM_SLOT_BELT_R)
				slot_title = " on [P[THEIR]] right side"
		. += "[I.get_examine_icon(user)] - [P[THEYVE]] [I.get_examine_string(user)][slot_title]."
	for(var/obj/item/I in held_items)
		if(I.item_flags & ABSTRACT)
			continue
		var/wielding = I.is_wielded()
		. += "[I.get_examine_icon(user)] - [P[THEYRE]] [wielding ? "wielding" : "holding"] [I.get_examine_string(user)] in [P[THEIR]] [wielding ? "hands" : get_held_index_name(get_held_index_of_item(I))]."


/// Things that are physical but do not need to see your face to establish.
/// Since these tend to vary in location items must be added to the list manually.
/mob/living/carbon/proc/get_examine_body(mob/user, list/P, list/examine_list)
	var/self_inspect = user == src
	var/pl = self_inspect ? "" : p_s()
	//var/mob/dead/observer/O = isobserver(user) ? user : null
	var/mob/living/L = isliving(user) ? user : null
	//var/mob/living/carbon/C = iscarbon(user) ? user : null
	//var/mob/living/carbon/human/H = ishuman(user) ? user : null

	. = list()

	// Maniac, higher up than others
	if(HAS_TRAIT(src, TRAIT_MANIAC_AWOKEN))
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_FACE, span_big(span_phobia("THE WORLD TWISTS! MANIAC!")))
	// Leper
	if(HAS_TRAIT(src, TRAIT_LEPROSY))
		. += span_necrosis("A LEPER...")
	// Fat
	if(HAS_TRAIT(src, TRAIT_FAT))
		. += span_boldnotice("[P[THEYRE]] obese!")
	// Pricing
	if(HAS_TRAIT(user, TRAIT_SEEPRICES) && sellprice)
		. += span_tinynoticeital("[P[THEYRE]] worth around [sellprice] mammon\s.")
	if(HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		var/atom/item = get_most_expensive()
		if(item)
			. += span_tinynoticeital("You get the feeling [P[THEIR]] most valuable possession is [item.get_examine_name(user)].")


	if(isautomaton(user))
		if(HAS_TRAIT(src, TRAIT_NOBLE_BLOOD))
			. += span_blue("[P[THEYRE]] a Blue-blooded Noble.")
		else if(HAS_TRAIT(src, TRAIT_NOBLE_POWER))
			. += span_blue("[P[THEYRE]] a crown-recognised Noble.")
		if(job in GLOB.automaton_order_jobs)
			. += span_blue("[P[THEYRE]] an authenticated Artificer.")

	/// Stat comparing
	if(!self_inspect && L && user.cmode)
		var/final_str = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)
		var/final_con = GET_MOB_ATTRIBUTE_VALUE(src, STAT_CONSTITUTION)
		var/final_spd = GET_MOB_ATTRIBUTE_VALUE(src, STAT_SPEED)
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
			final_con = 10
			final_spd = 10

		var/list/comp_msg = list()
		var/str_msg
		switch(final_str - GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH))
			if(5 to INFINITY)
				str_msg = span_bold("[P[THEY]] look[pl] much stronger than me.")
				user.add_stress(/datum/stress_event/para/str)
			if(1 to 5)
				str_msg = "[P[THEY]] look[pl] stronger than me."
				user.add_stress(/datum/stress_event/para/str)
			if(0)
				str_msg = "[P[THEY]] look[pl] about as strong as me."
			if(-5 to -1)
				str_msg = "[P[THEY]] look[pl] weaker than me."
			else
				str_msg =  span_bold("[P[THEY]] look[pl] much weaker than me.")
		if(str_msg)
			comp_msg += str_msg

		if(GET_MOB_ATTRIBUTE_VALUE(L, STAT_PERCEPTION)>= 12)
			var/con_msg
			switch(final_con - GET_MOB_ATTRIBUTE_VALUE(L, STAT_CONSTITUTION))
				if(5 to INFINITY)
					con_msg = span_bold("[P[THEY]] look[pl] much more bulky than me.")
				if(1 to 5)
					con_msg = "[P[THEY]] look[pl] more bulky than me."
				if(0)
					con_msg = "[P[THEY]] look[pl] about as bulky as me."
				if(-5 to -1)
					con_msg = "[P[THEY]] look[pl] frailer than me."
				else
					con_msg =  span_bold("[P[THEY]] look[pl] much frailer than me.")
			if(con_msg)
				comp_msg += con_msg

			var/spd_msg
			switch(final_spd - GET_MOB_ATTRIBUTE_VALUE(L, STAT_SPEED))
				if(5 to INFINITY)
					spd_msg = span_bold("[P[THEY]] look[pl] much quicker than me.")
				if(1 to 5)
					spd_msg = "[P[THEY]] look[pl] quicker than me."
				if(0)
					spd_msg = "[P[THEY]] look[pl] about as quick as me."
				if(-5 to -1)
					spd_msg = "[P[THEY]] look[pl] slower than me."
				else
					spd_msg =  span_bold("[P[THEY]] look[pl] much slower than me.")
			if(spd_msg)
				comp_msg += spd_msg
		if(length(comp_msg))
			. += span_warning(comp_msg.Join(" "))


/// General miscellaneous stuff that's typically good to know about someone.
/mob/living/carbon/proc/get_examine_warnings(mob/user, list/P, list/examine_list)
	//var/self_inspect = user == src
	//var/pl = self_inspect ? "" : p_s()
	//var/mob/dead/observer/O = isobserver(user) ? user : null
	var/mob/living/L = isliving(user) ? user : null
	//var/mob/living/carbon/C = iscarbon(user) ? user : null
	//var/mob/living/carbon/human/H = ishuman(user) ? user : null

	. = list()

	//Cuffs
	if(handcuffed)
		var/handcuff_msg = "[capitalize(P[THEIR])] arms are restrained by [handcuffed.get_examine_string(user)]!"
		. += "<A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDCUFFED]'>[handcuff_msg]</A>"
	if(legcuffed)
		var/legcuff_msg = "[capitalize(P[THEIR])] legs are restrained by [handcuffed.get_examine_string(user)]!"
		. += "<A href='byond://?src=[REF(src)];item=[ITEM_SLOT_LEGCUFFED]'>[legcuff_msg]</A>"

	//Bloody hands
	if(num_hands && GET_ATOM_BLOOD_DNA_LENGTH(src) && !(check_obscured_slots(FALSE) & ITEM_SLOT_GLOVES))
		. += "[P[THEYVE]] [span_bloody("blood")] on [P[THEIR]] hand[num_hands > 1 ? "s" : ""]."

	// Fire
	var/fire_str
	if(on_fire)
		fire_str = span_boldwarning("on fire!")
		if(L?.has_quirk(/datum/quirk/vice/pyromaniac)) // living only
			fire_str += span_boldred(" IT'S BEAUTIFUL!")
			L.sate_addiction(/datum/quirk/vice/pyromaniac)
	else if(fire_stacks + divine_fire_stacks > 0)
		fire_str += "covered in something flammable."
	else if(fire_stacks < 0 && !on_fire)
		fire_str += "soaked."
	if(fire_str)
		. += "[P[THEYRE]] [fire_str]"

	// Grabs
	if(pulledby && pulledby.grab_state)
		. += "[P[THEYRE]] being grabbed by [pulledby]."

	//Disgusting behemoth of stun absorption
	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				. += "[P[THEYRE]][stun_absorption[i]["examine_message"]]"

	//Status effects
	var/list/status_examines = status_effect_examines(user, P=P)
	if(length(status_examines))
		. += status_examines


/// Things relevant to one's health.
/mob/living/carbon/proc/get_examine_health(mob/user, list/P, list/examine_list)
	var/self_inspect = user == src
	var/pl = self_inspect ? "" : p_s()
	var/mob/dead/observer/O = isobserver(user) ? user : null
	//var/mob/living/L = isliving(user) ? user : null
	//var/mob/living/carbon/C = iscarbon(user) ? user : null
	//var/mob/living/carbon/human/H = ishuman(user) ? user : null

	. = list()

	// General Damage
	var/overall_damage = getBruteLoss() + getFireLoss() //no need to calculate each of these twice
	if(!(self_inspect && hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		// Damage
		var/max_health = 1 //let's not divide by 0
		for(var/obj/item/bodypart/bodypart as anything in bodyparts)
			max_health += bodypart.max_damage
		var/damage_msg
		switch(overall_damage/max_health)
			if(0.0625 to 0.125)
				damage_msg = "[P[THEYRE]] a little wounded."
			if(0.125 to 0.25)
				damage_msg = span_warning("[P[THEYRE]] wounded.")
			if(0.25 to 0.5)
				damage_msg = span_boldwarning("[P[THEYRE]] severely wounded.")
			if(0.5 to INFINITY)
				damage_msg = span_boldred("[P[THEYRE]] gravely wounded.")
		if(damage_msg)
			. += damage_msg

	// missing limbs
	var/appears_dead = FALSE
	var/is_clearly_dead = FALSE
	for(var/t in get_missing_limbs())
		var/limb_msg = "[capitalize(P[THEIR])] [parse_zone(t)] is gone."
		if(t==BODY_ZONE_HEAD)
			limb_msg = span_boldred(limb_msg)
			is_clearly_dead = TRUE
		else
			limb_msg = span_boldwarning(limb_msg)
		. += limb_msg

	// Health statuses
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE
		if(suiciding)
			. += span_red("[P[THEY]] appear[pl] to have committed suicide... there is no hope of recovery.")
		if(hellbound)
			. += span_red("[P[THEIR]] soul seems to have been ripped out of [P[THEIR]] body. Revival is impossible.")

	if(is_clearly_dead || (stat == DEAD && (IsAdminGhost(user) || self_inspect)))
		. += span_boldred("[P[THEYRE]] dead.")
	else if(appears_dead || stat >= UNCONSCIOUS)
		. += span_boldwarning("[P[THEYRE]] unconscious.")
	else if(InCritical())
		. += span_warning("[P[THEYRE]] barely unconscious.")

	// Blood volume
	if(!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))
		var/blood_lvl_msg
		switch(blood_volume)
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				blood_lvl_msg = html_tag("B", "[P[THEYRE]] extremely pale and sickly.")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				blood_lvl_msg = html_tag("B", "[P[THEYRE]] very pale.")
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				blood_lvl_msg = "[P[THEYRE]] pale."
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				blood_lvl_msg = "[P[THEYRE]] a little pale."
		if(blood_lvl_msg)
			. += span_artery(blood_lvl_msg)

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
		var/list/bleeding_limbs = list()
		for(var/obj/item/bodypart/bleeder in bodyparts)
			if(!bleeder.get_bleed_rate() || !get_location_accessible(src, bleeder.body_zone))
				continue
			bleeding_limbs += parse_zone(bleeder.body_zone)
		var/bleeding_msg
		if(length(bleeding_limbs))
			bleeding_msg = "[capitalize(P[THEIR])] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!"
		else
			bleeding_msg = "[P[THEYRE]] [bleed_wording]!"
		if(bleed_rate >= 5)
			bleeding_msg = html_tag("B", bleeding_msg)
		. += span_bloody(bleeding_msg)

	// Nutrition
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		. += span_boldwarning("[P[THEY]] look[pl] emaciated.")
	else if(HAS_TRAIT(user, TRAIT_EXTEROCEPTION))
		var/nutrition_msg
		switch(nutrition)
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				nutrition_msg = "peckish"
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				nutrition_msg = "hungry"
			if(NUTRITION_LEVEL_STARVING-50 to NUTRITION_LEVEL_STARVING)
				nutrition_msg = "starved"
		if(nutrition_msg)
			. += span_tinywarning("[P[THEY]] look[pl] [nutrition_msg].")
		var/hydration_msg
		switch(hydration)
			if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
				hydration_msg = "like [P[THEIR]] mouth is dry"
			if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
				hydration_msg = "thirsty"
			if(0 to HYDRATION_LEVEL_DEHYDRATED)
				hydration_msg = html_tag("B", "dehydrated")
		if(hydration_msg)
			. += span_tinywarning("[P[THEY]] look[pl] [hydration_msg].")

	if(Adjacent(user))
		if(O)
			var/static/list/check_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			var/list/zone_str = list()
			for(var/zone in check_zones)
				var/obj/item/bodypart/bodypart = get_bodypart(zone)
				if(!bodypart)
					continue
				zone_str += "<a href='byond://?src=[REF(src)];inspect_limb=[zone]'>Inspect [parse_zone(zone)]</a>"
			if(length(zone_str))
				. += zone_str.Join(" ")
			. += "<a href='byond://?src=[REF(src)];check_hb=1'>Check Heartbeat</a>"
		else
			var/checked_zone = check_zone(user.zone_selected)
			. += "<a href='byond://?src=[REF(src)];inspect_limb=[checked_zone]'>Inspect [parse_zone(checked_zone)]</a>"
			if(!self_inspect && body_position == LYING_DOWN && (user.zone_selected == BODY_ZONE_CHEST))
				. += "<a href='byond://?src=[REF(src)];check_hb=1'>Listen to Heartbeat</a>"

	// i dont really wanna put this here but its kinda of a huge hassel to make an appropriate spot
	if(IsAdminGhost(user))
		var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
		if(heart && heart.maniacs)
			for(var/datum/antagonist/maniac/M in heart.maniacs)
				var/K = LAZYACCESS(heart.inscryptions, M)
				var/W = LAZYACCESS(heart.maniacs2wonder_ids, M)
				var/N = M.owner?.name
				. += span_notice("Inscryption[N ? " by [N]'s " : ""][W ? "Wonder #[W]" : ""]: [K ? K : ""]")

