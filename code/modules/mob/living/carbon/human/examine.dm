/mob/living/carbon/human/proc/on_examine_face(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!isdarkelf(user) && isdarkelf(src))
		user.add_stress(/datum/stressevent/delf)
	if(!istiefling(user) && istiefling(src))
		user.add_stress(/datum/stressevent/tieb)
	if(!ishalforc(user) && ishalforc(src))
		user.add_stress(/datum/stressevent/horc)
	if(user.has_flaw(/datum/charflaw/paranoid) && (STASTR - user.STASTR) > 1)
		user.add_stress(/datum/stressevent/parastr)
	if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_TRAIT(user, TRAIT_FOREIGNER))
		if(user.has_flaw(/datum/charflaw/paranoid))
			user.add_stress(/datum/stressevent/paraforeigner)
		else
			user.add_stress(/datum/stressevent/foreigner)
	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL))
		if(user == src)
			user.add_stress(/datum/stressevent/beautiful_self)
		else
			user.add_stress(/datum/stressevent/beautiful)
	if(HAS_TRAIT(src, TRAIT_UGLY) && user != src)
		if(user == src)
			user.add_stress(/datum/stressevent/ugly_self)
		else
			user.add_stress(/datum/stressevent/ugly)
	if(HAS_TRAIT(src, TRAIT_OLDPARTY) && HAS_TRAIT(user, TRAIT_OLDPARTY) && user != src)
		user.add_stress(/datum/stressevent/saw_old_party)

/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
//	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()
	var/obscure_name
	var/race_name = dna?.species.name
	var/self_inspect = FALSE

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	var/m3 = "[t_He] [t_has]"
	. = list()
	if(user == src)
		m1 = "I am"
		m2 = "my"
		m3 = "I have"

	if(name == "Unknown" || name == "Unknown Man" || name == "Unknown Woman")
		obscure_name = TRUE

	if(isobserver(user))
		obscure_name = FALSE

	/// header
	. += span_info("ø ------------ ø")
	/// name, title, etc. of the person
	var/statement_of_identity = "This is "
	if(obscure_name)
		statement_of_identity += ("<EM>Unknown</EM>.")
		. += statement_of_identity
	else
		on_examine_face(user)
		var/used_name = name
		if(isobserver(user))
			used_name = real_name
		if(user == src)
			self_inspect = TRUE
		var/used_title = get_role_title()
		var/is_returning = FALSE
		if(islatejoin)
			is_returning = TRUE

		// building the examine identity
		statement_of_identity += "<EM>[used_name]</EM>"

		var/appendage_to_name
		if(is_returning && race_name && !HAS_TRAIT(src, TRAIT_FOREIGNER)) // latejoined? Foreigners can never be returning because they never lived here in the first place
			appendage_to_name += " returning"

		if(race_name) // race name
			appendage_to_name += " [race_name]"

		if(used_title && !HAS_TRAIT(src, TRAIT_FOREIGNER)) // job name, don't show job of foreigners.
			appendage_to_name += ", [used_title]"

		if(appendage_to_name) // if we got any of those paramaters add it to their name
			statement_of_identity += " the [appendage_to_name]"

		statement_of_identity += "." // comma at the end
		// full name with all paramaters would be: "John Serf the returning Rakshari, Minnie Bonnickers smithy apprentice.""
		. += statement_of_identity

		if(GLOB.lord_titles[real_name]) //should be tied to known persons but can't do that until there is a way to recognise new people
			. += span_notice("[m3] been granted the title of \"[GLOB.lord_titles[name]]\".")

		if(dna.species.use_skintones)
			var/skin_tone_wording = dna.species.skin_tone_wording ? lowertext(dna.species.skin_tone_wording) : "skin tone"
			var/list/skin_tones = dna.species.get_skin_list()
			var/skin_tone_seen = "incomprehensible"
			if(skin_tone)
				//AGGHHHHH this is stupid
				for(var/tone in skin_tones)
					if(src.skin_tone == skin_tones[tone])
						skin_tone_seen = lowertext(tone)
						break
			var/slop_lore_string = "."
			if(ishumannorthern(user))
				var/mob/living/carbon/human/racist = user
				var/list/user_skin_tones = racist.dna.species.get_skin_list()
//				var/user_skin_tone_seen = "incomprehensible"	gives unused warning now, sick of seeing it
				for(var/tone in user_skin_tones)
					if(racist.skin_tone == user_skin_tones[tone])
//						user_skin_tone_seen = lowertext(tone)	gives unused warning now, sick of seeing it
						break
			. += "<span class='info'>[capitalize(m2)] [skin_tone_wording] is [skin_tone_seen][slop_lore_string]</span>"

		if(ishuman(user))
			var/mob/living/carbon/human/stranger = user
			var/is_male = FALSE
			if(gender == MALE)
				is_male = TRUE
			if(RomanticPartner(stranger))
				. += span_love(span_bold("[t_He] is my [is_male ? "husband" : "wife"]."))
			if(family_datum == stranger.family_datum && family_datum)
				var/family_text = ReturnRelation(user)
				if(family_text)
					. += family_text
			if(HAS_TRAIT(src, TRAIT_BEAUTIFUL))
				//Handsome only if male, beautiful in all other pronouns.
				. += span_love(span_bold("[self_inspect ? "I am" : "[t_He] is"] [is_male ? "handsome" : "beautiful"]!"))
			if(HAS_TRAIT(src, TRAIT_UGLY))
				. += span_necrosis(span_bold("[self_inspect ? "I am" : "[t_He] is"] hideous."))

		if(length(GLOB.tennite_schisms))
			var/datum/tennite_schism/S = GLOB.tennite_schisms[1]
			var/user_side = (WEAKREF(user) in S.supporters_astrata) ? "astrata" : (WEAKREF(user) in S.supporters_challenger) ? "challenger" : null
			var/mob_side = (WEAKREF(src) in S.supporters_astrata) ? "astrata" : (WEAKREF(src) in S.supporters_challenger) ? "challenger" : null

			if(user_side && mob_side)
				var/datum/patron/their_god = (mob_side == "astrata") ? S.astrata_god.resolve() : S.challenger_god.resolve()
				if(their_god)
					. += (user_side == mob_side) ? span_notice("Fellow [their_god.name] supporter!") : span_userdanger("Vile [their_god.name] supporter!")

		if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_TRAIT(user, TRAIT_FOREIGNER))
			. += span_phobia("A foreigner...")

		if(real_name in GLOB.excommunicated_players)
			. += span_userdanger("EXCOMMUNICATED!")

		if(real_name in GLOB.heretical_players)
			. += span_userdanger("HERETIC! SHAME!")

		if(real_name in GLOB.outlawed_players)
			. += span_userdanger("OUTLAW!")

		if(iszizocultist(user) || iszizolackey(user))
			if(virginity)
				. += span_userdanger("VIRGIN!")

		if(mind && mind.special_role)
			if(mind && mind.special_role == "Bandit" && HAS_TRAIT(user, TRAIT_KNOWBANDITS))
				. += span_userdanger("BANDIT!")
			if(mind && mind.special_role == "Vampire Lord")
				. += span_userdanger("A MONSTER!")

		var/list/known_frumentarii = user.mind?.cached_frumentarii
		if(name in known_frumentarii)
			. += span_greentext("<b>[m1] an agent of the court!</b>")

		if(user != src)
			if(HAS_TRAIT(src, TRAIT_OLDPARTY) && HAS_TRAIT(user, TRAIT_OLDPARTY))
				. += span_green("Ahh... my old friend!")

			if(HAS_TRAIT(src, TRAIT_THIEVESGUILD) && HAS_TRAIT(user, TRAIT_THIEVESGUILD))
				. += span_green("A member of the Thieves Guild.")

			if(HAS_TRAIT(src, TRAIT_CABAL) && HAS_TRAIT(user, TRAIT_CABAL))
				. += span_purple("A fellow seeker of Her ascension.")

	if(HAS_TRAIT(src, TRAIT_MANIAC_AWOKEN))
		. += span_userdanger("MANIAC!")

	if(HAS_TRAIT(src, TRAIT_LEPROSY))
		. += span_necrosis("A LEPER...")

	if(user != src)
		var/datum/mind/Umind = user.mind
		if(Umind && mind)
			for(var/datum/antagonist/aD in mind.antag_datums)
				for(var/datum/antagonist/bD in Umind.antag_datums)
					var/shit = bD.examine_friendorfoe(aD,user,src)
					if(shit)
						. += shit
		if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
			. += span_userdanger("Blood Volume: [blood_volume]")
		if(HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
			var/atom/item = get_most_expensive()
			if(item)
				. += span_notice("You get the feeling [m2] most valuable possession is \a [item.name].")

	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))

	if(wear_shirt && !(SLOT_SHIRT in obscured))
		. += "[m3] [wear_shirt.get_examine_string(user)]."

	//uniform
	if(wear_pants && !(SLOT_PANTS in obscured))
		//accessory
		var/accessory_msg
		if(istype(wear_pants, /obj/item/clothing/pants))
			var/obj/item/clothing/pants/U = wear_pants
			if(U.attached_accessory)
				accessory_msg += " with [icon2html(U.attached_accessory, user)] \a [U.attached_accessory]"

		. += "[m3] [wear_pants.get_examine_string(user)][accessory_msg]."

	//head
	if(head && !(SLOT_HEAD in obscured))
		. += "[m3] [head.get_examine_string(user)] on [m2] head."
	//suit/armorF
	if(wear_armor && !(SLOT_ARMOR in obscured))
		. += "[m3] [wear_armor.get_examine_string(user)]."

	if(cloak && !(SLOT_CLOAK in obscured))
		. += "[m3] [cloak.get_examine_string(user)] on [m2] shoulders."

	if(backr && !(SLOT_BACK_R in obscured))
		. += "[m3] [backr.get_examine_string(user)] on [m2] back."

	if(backl && !(SLOT_BACK_L in obscured))
		. += "[m3] [backl.get_examine_string(user)] on [m2] back."

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[m1] holding [I.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(I))]."

	var/datum/component/forensics/FR = GetComponent(/datum/component/forensics)
	//gloves
	if(gloves && !(SLOT_GLOVES in obscured))
		. += "[m3] [gloves.get_examine_string(user)] on [m2] hands."
	else if(FR && length(FR.blood_DNA))
		if(num_hands)
			. += span_warning("[t_He] [t_has] [num_hands > 1 ? "" : "a"] blood-stained hand[num_hands > 1 ? "s" : ""]!")

	//belt
	if(belt && !(SLOT_BELT in obscured))
		. += "[m3] [belt.get_examine_string(user)] about [m2] waist."

	if(beltr && !(SLOT_BELT_R in obscured))
		. += "[m3] [beltr.get_examine_string(user)] on [m2] belt."

	if(beltl && !(SLOT_BELT_L in obscured))
		. += "[m3] [beltl.get_examine_string(user)] on [m2] belt."

	//shoes
	if(shoes && !(SLOT_SHOES in obscured))
		. += "[m3] [shoes.get_examine_string(user)] on [m2] feet."

	//mask
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		. += "[m3] [wear_mask.get_examine_string(user)] on [m2] face."

	if(mouth && !(SLOT_MOUTH in obscured))
		. += "[m3] [mouth.get_examine_string(user)] in [m2] mouth."

	if(wear_neck && !(SLOT_NECK in obscured))
		. += "[m3] [wear_neck.get_examine_string(user)] around [m2] neck."

	if(get_eye_color() == BLOODCULT_EYE)
		. += "<span class='warning'><B>[capitalize(m2)] eyes are glowing an unnatural red!</B></span>"

	//ears
	if(ears && !(SLOT_HEAD in obscured))
		. += "[m3] [ears.get_examine_string(user)] on [m2] ears."

	//ID
	if(wear_ring && !(SLOT_RING in obscured))
		. += "[m3] [wear_ring.get_examine_string(user)]."

	if(wear_wrists && !(SLOT_WRISTS in obscured))
		. += "[m3] [wear_wrists.get_examine_string(user)]."

	//handcuffed?
	if(handcuffed)
		. += "<A href='byond://?src=[REF(src)];item=[SLOT_HANDCUFFED]'><span class='warning'>[m1] tied up with \a [handcuffed]!</span></A>"

	if(legcuffed)
		. += "<A href='byond://?src=[REF(src)];item=[SLOT_LEGCUFFED]'><span class='warning'>[m3] \a [legcuffed] around [m2] legs!</span></A>"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/appears_dead = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE
		if(suiciding)
			msg += "[t_He] appear[p_s()] to have committed suicide... there is no hope of recovery."
		if(hellbound)
			msg += "[capitalize(m2)] soul seems to have been ripped out of [m2] body. Revival is impossible."
//		if(getorgan(/obj/item/organ/brain) && !key && !get_ghost(FALSE, TRUE))
//			msg += "<span class='deadsay'>[m1] limp and unresponsive; there are no signs of life and [m2] soul has departed...</span>"
//		else
//			msg += "<span class='deadsay'>[m1] limp and unresponsive; there are no signs of life...</span>"

	var/temp = getBruteLoss() + getFireLoss() //no need to calculate each of these twice

	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		// Damage
		var/max_health = 1 //let's not divide by 0
		for(var/obj/item/bodypart/bodypart as anything in bodyparts)
			max_health += bodypart.max_damage
		switch(temp/max_health)
			if(0.0625 to 0.125)
				msg += "[m1] a little wounded."
			if(0.125 to 0.25)
				msg += "[m1] wounded."
			if(0.25 to 0.5)
				msg += "<B>[m1] severely wounded.</B>"
			if(0.5 to INFINITY)
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
		var/list/bleeding_limbs = list()
		var/static/list/bleed_zones = list(
			BODY_ZONE_HEAD,
			BODY_ZONE_CHEST,
			BODY_ZONE_R_ARM,
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_LEG,
			BODY_ZONE_L_LEG,
		)
		for(var/bleed_zone in bleed_zones)
			var/obj/item/bodypart/bleeder = get_bodypart(bleed_zone)
			if(!bleeder?.get_bleed_rate() || !get_location_accessible(src, bleeder.body_zone))
				continue
			bleeding_limbs += parse_zone(bleeder.body_zone)
		if(length(bleeding_limbs))
			if(bleed_rate >= 5)
				msg += "<span class='bloody'><B>[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!</B></span>"
			else
				msg += "<span class='bloody'>[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!</span>"
		else
			if(bleed_rate >= 5)
				msg += "<span class='bloody'><B>[m1] [bleed_wording]</B>!</span>"
			else
				msg += "<span class='bloody'>[m1] [bleed_wording]!</span>"

	// Missing limbs
	var/missing_head = FALSE
	var/list/missing_limbs = list()
	for(var/missing_zone in get_missing_limbs())
		if(missing_zone == BODY_ZONE_HEAD)
			missing_head = TRUE
		missing_limbs += parse_zone(missing_zone)

	if(length(missing_limbs))
		var/missing_limb_message = "<B>[capitalize(m2)] [english_list(missing_limbs)] [missing_limbs.len > 1 ? "are" : "is"] gone.</B>"
		if(missing_head)
			missing_limb_message = "<span class='dead'>[missing_limb_message]</span>"
		else
			missing_limb_message = "<span class='danger'>[missing_limb_message]</span>"
		msg += missing_limb_message

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1] being grabbed by [pulledby]."

	//Nutrition and Thirst
	var/list/msg_list = list()
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		msg_list += "[m1] looking emaciated."
//	else if(nutrition >= NUTRITION_LEVEL_FAT)
//		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
//			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy."
//		else
//			msg += "[t_He] [t_is] quite chubby."
	if(HAS_TRAIT(user, TRAIT_EXTEROCEPTION))
		switch(nutrition)
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				msg_list += "[m1] looking peckish."
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				msg_list += "[m1] looking hungry."
			if(NUTRITION_LEVEL_STARVING-50 to NUTRITION_LEVEL_STARVING)
				msg_list += "[m1] looking starved."
		switch(hydration)
			if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
				msg_list += "[m1] looking like [m2] mouth is dry."
			if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
				msg_list += "[m1] looking thirsty for a drink."
			if(0 to HYDRATION_LEVEL_DEHYDRATED)
				msg_list += "[m1] looking parched."
	if(length(msg_list))
		msg += msg_list.Join(" ")

	//Fire/water stacks
	if(fire_stacks + divine_fire_stacks > 0)
		msg += "[m1] covered in something flammable."
	else if(fire_stacks < 0 && !on_fire)
		msg += "[m1] soaked."

	//Status effects
	var/list/status_examines = status_effect_examines()
	if(length(status_examines))
		msg += status_examines

	//Disgusting behemoth of stun absorption
	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[m1][stun_absorption[i]["examine_message"]]"

	if(!appears_dead)
		if(!skipface)
			//Disgust
			switch(disgust)
				if(DISGUST_LEVEL_SLIGHTLYGROSS to DISGUST_LEVEL_GROSS)
					msg += "[m1] a little disgusted."
				if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
					msg += "[m1] disgusted."
				if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
					msg += "[m1] really disgusted."
				if(DISGUST_LEVEL_DISGUSTED to INFINITY)
					msg += "<B>[m1] extremely disgusted.</B>"

			//Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[m1] slightly flushed."
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[m1] flushed."
				if(41.01 to 51)
					msg += "[m1] quite flushed and [m2] breath smells of alcohol."
				if(51.01 to 61)
					msg += "[m1] very flushed, with breath reeking of alcohol."
				if(61.01 to 91)
					msg += "[m1] looking like a drunken mess."
				if(91.01 to INFINITY)
					msg += "[m1] a shitfaced, slobbering wreck."

			//Stress
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				switch(stress)
					if(20 to INFINITY)
						msg += "[m1] extremely stressed."
					if(10 to 19)
						msg += "[m1] very stressed."
					if(1 to 9)
						msg += "[m1] a little stressed."
					if(-9 to 0)
						msg += "[m1] not stressed."
					if(-19 to -10)
						msg += "[m1] somewhat at peace."
					if(-20 to INFINITY)
						msg += "[m1] at peace inside."
			else if(stress > 10)
				msg += "[m3] stress all over [m2] face."

		//Jitters
		switch(jitteriness)
			if(300 to INFINITY)
				msg += "<B>[m1] convulsing violently!</B>"
			if(200 to 300)
				msg += "[m1] extremely jittery."
			if(100 to 200)
				msg += "[m1] twitching ever so slightly."

		if(InCritical())
			msg += "<span class='warning'>[m1] barely conscious.</span>"
		else
			if(stat >= UNCONSCIOUS)
				msg += "[m1] [IsSleeping() ? "sleeping" : "unconscious"]."
			else if(eyesclosed)
				msg += "[capitalize(m2)] eyes are closed."
			else if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				msg += "[m1] looking a little tired."
	else
		msg += "[m1] unconscious."
//		else
//			if(HAS_TRAIT(src, TRAIT_DUMB))
//				msg += "[m3] a stupid expression on [m2] face."
//			if(InCritical())
//				msg += "[m1] barely conscious."
//		if(getorgan(/obj/item/organ/brain))
//			if(!key)
//				msg += "<span class='deadsay'>[m1] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.</span>"
//			else if(!client)
//				msg += "[m3] a blank, absent-minded stare and appears completely unresponsive to anything. [t_He] may snap out of it soon."

	if(length(msg))
		. += "<span class='warning'>[msg.Join("\n")]</span>"

	if(isliving(user) && user != src)
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

		var/datum/antagonist/maniac/maniac = user.mind?.has_antag_datum(/datum/antagonist/maniac)
		if(maniac)
			var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
			if(heart)
				var/inscryption_key = LAZYACCESS(heart.inscryption_keys, maniac) // SPECIFICALLY the key that WE wrote
				if(inscryption_key && (inscryption_key in maniac.key_nums))
					. += span_danger("[t_He] know[p_s()] [inscryption_key], I AM SURE OF IT!")

	if(IsAdminGhost(user))
		var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
		if(heart && heart.maniacs)
			for(var/datum/antagonist/maniac/M in heart.maniacs)
				var/K = LAZYACCESS(heart.inscryptions, M)
				var/W = LAZYACCESS(heart.maniacs2wonder_ids, M)
				var/N = M.owner?.name
				. += span_notice("Inscryption[N ? " by [N]'s " : ""][W ? "Wonder #[W]" : ""]: [K ? K : ""]")

	if(Adjacent(user))
		if(isobserver(user))
			var/static/list/check_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			for(var/zone in check_zones)
				var/obj/item/bodypart/bodypart = get_bodypart(zone)
				if(!bodypart)
					continue
				. += "<a href='byond://?src=[REF(src)];inspect_limb=[zone]'>Inspect [parse_zone(zone)]</a>"
			. += "<a href='byond://?src=[REF(src)];check_hb=1'>Check Heartbeat</a>"
		else
			var/checked_zone = check_zone(user.zone_selected)
			. += "<a href='byond://?src=[REF(src)];inspect_limb=[checked_zone]'>Inspect [parse_zone(checked_zone)]</a>"
			if(body_position == LYING_DOWN && user != src && (user.zone_selected == BODY_ZONE_CHEST))
				. += "<a href='byond://?src=[REF(src)];check_hb=1'>Listen to Heartbeat</a>"
		. += "<a href='byond://?src=[REF(src)];view_descriptors=1'>Look at Features</a>"

	// Characters with the hunted flaw will freak out if they can't see someone's face.
	if(!appears_dead)
		if(skipface && user.has_flaw(/datum/charflaw/hunted))
			user.add_stress(/datum/stressevent/hunted)

	if(!obscure_name && (flavortext || (headshot_link && src.client?.patreon?.has_access(ACCESS_ASSISTANT_RANK)))) // only show flavor text if there is a flavor text and we show headshot
		. += "<a href='?src=[REF(src)];task=view_flavor_text;'>Examine Closer</a>"

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam

	// The Assassin's profane dagger can sniff out their targets, even masked.
	if(HAS_TRAIT(user, TRAIT_ASSASSIN) && ((has_flaw(/datum/charflaw/hunted) || HAS_TRAIT(src, TRAIT_ZIZOID_HUNTED))))
		//TODO: move this to an examinate signal call
		if ((src != user) && iscarbon(user))
			var/mob/living/carbon/assassin = user
			for(var/obj/item/I in assassin.get_all_gear())
				if(istype(I, /obj/item/weapon/knife/dagger/steel/profane))
					. += "profane dagger whispers, [span_danger("\"That's [real_name]! Strike their heart!\"")]"
					break

	if(HAS_TRAIT(user, TRAIT_SEEPRICES) && sellprice)
		. += "Is worth around [sellprice] mammons."
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
			dat += "[new_text]" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join("\n")
