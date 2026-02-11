/mob/living/carbon/human/proc/on_examine_face(mob/living/carbon/human/user, self_inspect = FALSE)
	if(!istype(user))
		return

	// Intolerant
	if(!self_inspect && !HAS_TRAIT(user, TRAIT_TOLERANT))
		if(!isdarkelf(user) && isdarkelf(src))
			user.add_stress(/datum/stress_event/delf)

		if(!istiefling(user) && istiefling(src))
			user.add_stress(/datum/stress_event/tieb)

		if(!ishalforc(user) && ishalforc(src))
			user.add_stress(/datum/stress_event/horc)

		if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_TRAIT(user, TRAIT_FOREIGNER))
			if(user.has_quirk(/datum/quirk/vice/paranoid))
				user.add_stress(/datum/stress_event/paraforeigner)
			else
				user.add_stress(/datum/stress_event/foreigner)

		if(HAS_TRAIT(src, TRAIT_FISHFACE) && !HAS_TRAIT(user, TRAIT_FISHFACE))
			user.add_stress(/datum/stress_event/fishface)

	if(HAS_TRAIT(src, TRAIT_FISHFACE))
		var/observer_fish = HAS_TRAIT(user, TRAIT_FISHFACE)
		if(!self_inspect)
			if(observer_fish)
				user.add_stress(/datum/stress_event/fellow_fishface)
			else if(user.age == AGE_CHILD)
				user.add_stress(/datum/stress_event/fish_monster)
		else if(observer_fish)
			user.add_stress(/datum/stress_event/self_fishface)

	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL))
		if(self_inspect)
			user.add_stress(/datum/stress_event/beautiful_self)
		else
			user.add_stress(/datum/stress_event/beautiful)

	if(HAS_TRAIT(src, TRAIT_UGLY))
		if(self_inspect)
			user.add_stress(/datum/stress_event/ugly_self)
		else
			user.add_stress(/datum/stress_event/ugly)

	if(!self_inspect)
		if(user.has_quirk(/datum/quirk/vice/paranoid) && (STASTR - user.STASTR) > 1)
			user.add_stress(/datum/stress_event/parastr)

		if(HAS_TRAIT(src, TRAIT_OLDPARTY) && HAS_TRAIT(user, TRAIT_OLDPARTY))
			user.add_stress(/datum/stress_event/saw_old_party)

/mob/living/carbon/human/examine(mob/user)
	var/self_inspect = (user == src)

	var/is_family_member = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/stranger = user
		if(family_datum && family_datum == stranger.family_datum)
			is_family_member = TRUE

	var/temp_gender = null
	var/obscure_name = FALSE
	var/person_known = self_inspect
	if(!self_inspect && !isobserver(user))
		if(name in list("Unknown", "Unknown Man", "Unknown Woman"))
			obscure_name = TRUE
			temp_gender = PLURAL
		else if(is_family_member || user.mind?.do_i_know(name = real_name)) // If you don't know someone use their bodytype
			person_known = TRUE

	if(!obscure_name && src == SSticker.rulermob)
		person_known = TRUE // Monarch is known to everyone

	var/race_name = dna?.species.name
	var/datum/antagonist/maniac/maniac = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	if(!self_inspect && maniac)
		race_name = "disgusting pig"

	var/ignore_pronouns = (obscure_name || !person_known)
	var/t_He = p_they(TRUE, temp_gender, ignore_pronouns)
	var/t_his = p_their(FALSE, temp_gender, ignore_pronouns)
	var/t_has = p_have(temp_gender, ignore_pronouns)
	var/t_is  = p_are(temp_gender, ignore_pronouns)

	var/m1
	var/m2
	var/m3

	if(!self_inspect)
		m1 = "[t_He] [t_is]"
		m2 = "[t_his]"
		m3 = "[t_He] [t_has]"
	else
		m1 = "I am"
		m2 = "my"
		m3 = "I have"

	. = list()

	/// header
	. += span_info("ø ------------ ø")
	/// name, title, etc. of the person
	var/statement_of_identity = "This is "
	if(obscure_name)
		statement_of_identity += ("<EM>Unknown</EM>.")
		. += statement_of_identity
	else
		on_examine_face(user, self_inspect)

		var/used_name = name
		if(isobserver(user))
			used_name = real_name

		var/used_title = get_role_title(person_known)

		// building the examine identity
		statement_of_identity += "<EM>[used_name]</EM>"

		var/appendage_to_name
		if(race_name) // race name
			appendage_to_name += " [race_name]"

		// job name, don't show job of foreigners.
		if(used_title && !HAS_TRAIT(src, TRAIT_FACELESS) && (!HAS_TRAIT(src, TRAIT_FOREIGNER) || HAS_TRAIT(src, TRAIT_RECRUITED) || HAS_TRAIT(src, TRAIT_RECOGNIZED)))
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
					if(skin_tone == skin_tones[tone])
						skin_tone_seen = lowertext(tone)
						break

			. += span_info("[capitalize(m2)] [skin_tone_wording] is [skin_tone_seen].")

		if(culture)
			if(!person_known || istype(culture, /datum/culture/universal/ambiguous))
				if(!self_inspect)
					. += span_info("[capitalize(t_He)] could be from anywhere.")
			else
				var/pre_string = "[capitalize(m1)]"
				if(!self_inspect)
					pre_string = "I believe [m1]"

				. += span_info("[pre_string] from [culture.examined_string(src, user)].")

		if(ishuman(user))
			var/mob/living/carbon/human/stranger = user
			var/is_male = FALSE
			if(t_He == "He")
				is_male = TRUE

			if(!self_inspect && family_datum && family_datum == stranger.family_datum)
				var/family_text = ReturnRelation(user)
				if(family_text)
					. += family_text

			if(HAS_TRAIT(src, TRAIT_BEAUTIFUL))
				//Handsome only if male, beautiful in all other pronouns.
				. += span_love(span_bold("[self_inspect ? "I am" : "[t_He] is"] [is_male ? "handsome" : "beautiful"]!"))

			if(HAS_TRAIT(src, TRAIT_UGLY))
				. += span_necrosis(span_bold("[self_inspect ? "I am" : "[t_He] is"] hideous."))

			if(HAS_TRAIT(src, TRAIT_FAT))
				. += span_boldwarning(span_bold("[self_inspect ? "I am" : "[t_He] is"] very obese!"))

		if(HAS_TRAIT(src, TRAIT_FISHFACE) && HAS_TRAIT(user, TRAIT_FISHFACE))
			if(self_inspect)
				. += span_green("I don't look that bad, I just look different to other species.")
			else
				. += span_green("A fellow triton.")

		// Things that happen when you can see face and its another person you are examining
		if(!self_inspect)
			if(length(GLOB.tennite_schisms))
				var/datum/tennite_schism/S = GLOB.tennite_schisms[1]
				var/user_side = (WEAKREF(user) in S.supporters_astrata) ? "astrata" : (WEAKREF(user) in S.supporters_challenger) ? "challenger" : null
				var/mob_side = (WEAKREF(src) in S.supporters_astrata) ? "astrata" : (WEAKREF(src) in S.supporters_challenger) ? "challenger" : null

				if(user_side && mob_side)
					var/datum/patron/their_god = (mob_side == "astrata") ? S.astrata_god.resolve() : S.challenger_god.resolve()
					if(their_god)
						. += (user_side == mob_side) ? span_notice("Fellow [their_god.name] supporter!") : span_userdanger("Vile [their_god.name] supporter!")

			if(ishuman(user) && HAS_TRAIT(src, TRAIT_FISHFACE) && !HAS_TRAIT(user, TRAIT_FISHFACE))
				var/mob/living/carbon/human/H = user
				if(H.age == AGE_CHILD)
					. += span_userdanger("IT'S A HORRIBLE MONSTER!!!")
					user.emote("scream")
				else
					. += span_necrosis("That fish is ugly!")

			if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_TRAIT(user, TRAIT_FOREIGNER))
				. += span_phobia("A foreigner...")

			if(has_quirk(/datum/quirk/vice/alcoholic) && HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
				. += span_userdanger("ALCOHOLIC!")

			if(has_quirk(/datum/quirk/vice/junkie) && HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
				. += span_userdanger("JUNKIE!")

			if(HAS_TRAIT(src, TRAIT_OLDPARTY) && HAS_TRAIT(user, TRAIT_OLDPARTY))
				. += span_green("Ahh... my old friend!")

			if(HAS_TRAIT(src, TRAIT_THIEVESGUILD) && HAS_TRAIT(user, TRAIT_THIEVESGUILD))
				. += span_green("A member of the Thieves' Guild.")

			if((HAS_TRAIT(src, TRAIT_CABAL) && HAS_TRAIT(user, TRAIT_CABAL)) || (patron?.type == /datum/patron/inhumen/zizo && HAS_TRAIT(user, TRAIT_CABAL)))
				. += span_purple("A fellow seeker of Her ascension.")

			if(HAS_TRAIT(user, TRAIT_ROYALSERVANT))
				if(length(culinary_preferences) && family_datum == SSfamilytree.ruling_family)
					var/obj/item/reagent_containers/food/snacks/fav_food = culinary_preferences[CULINARY_FAVOURITE_FOOD]
					var/datum/reagent/consumable/fav_drink = culinary_preferences[CULINARY_FAVOURITE_DRINK]
					if(fav_food)
						if(fav_drink)
							. += span_notice("Their favourites are [fav_food.name] and [fav_drink.name].")
						else
							. += span_notice("Their favourite is [fav_food.name].")
					else if(fav_drink)
						. += span_notice("Their favourite is [fav_drink.name].")
					var/obj/item/reagent_containers/food/snacks/hated_food = culinary_preferences[CULINARY_HATED_FOOD]
					var/datum/reagent/consumable/hated_drink = culinary_preferences[CULINARY_HATED_DRINK]
					if(hated_food)
						if(hated_drink)
							. += span_notice("They hate [hated_food.name] and [hated_drink.name].")
						else
							. += span_notice("They hate [hated_food.name].")
					else if(hated_drink)
						. += span_notice("They hate [hated_drink.name].")

			if(HAS_TRAIT(src, TRAIT_LEPROSY))
				. += span_necrosis("A LEPER...")

			if(HAS_TRAIT(src, TRAIT_FACELESS))
				. += span_userdanger("FACELESS?! AN ASSASSIN!")

			var/list/known_frumentarii = user.mind?.cached_frumentarii
			if(name in known_frumentarii)
				if(known_frumentarii[name])
					. += span_greentext("<b>[m1] an agent of the court!</b>")
				else
					. += span_redtext("[m1] an ex-agent of the court.")

			if(real_name in GLOB.excommunicated_players)
				. += span_userdanger("EXCOMMUNICATED!")

			if(real_name in GLOB.heretical_players)
				. += span_userdanger("HERETIC! SHAME!")

			if(user.mind)
				if(is_zizocultist(user.mind) || is_zizolackey(user.mind))
					if(virginity)
						. += span_userdanger("VIRGIN!")

			var/is_bandit = FALSE
			if(mind?.special_role == "Bandit")
				is_bandit = TRUE
				if((real_name in GLOB.outlawed_players) && HAS_TRAIT(user, TRAIT_KNOWBANDITS))
					. += span_userdanger("BANDIT!")

			if(!is_bandit && (real_name in GLOB.outlawed_players))
				. += span_userdanger("OUTLAW!")

			if(mind && mind?.special_role == "Vampire Lord")
				var/datum/component/vampire_disguise/disguise_comp = GetComponent(/datum/component/vampire_disguise)
				if(!disguise_comp.disguised)
					. += span_userdanger("A MONSTER!")

			var/inquisition_text =get_inquisition_text(user)
			if(inquisition_text)
				. +=span_notice(inquisition_text)

	// Things that happen when you examine someone else
	if(!self_inspect)
		var/datum/mind/user_mind = user.mind
		if(user_mind && mind)
			for(var/datum/antagonist/examined_antag_datum in mind.antag_datums)
				for(var/datum/antagonist/user_antag_datums in user_mind.antag_datums)
					var/examine_friend_or_foe_append = user_antag_datums.examine_friendorfoe(examined_antag_datum, user, src)
					if(examine_friend_or_foe_append)
						. += examine_friend_or_foe_append

		if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
			. += span_userdanger("Blood Volume: [blood_volume]")

		if(HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
			var/atom/item = get_most_expensive()
			if(item)
				. += span_notice("You get the feeling [m2] most valuable possession is \a [item.name].")

		if(HAS_TRAIT(src, TRAIT_MANIAC_AWOKEN))
			. += span_userdanger("THE WORLD TWISTS! MANIAC!")

	var/obscured = check_obscured_slots()

	if(wear_shirt && !(obscured & ITEM_SLOT_SHIRT))
		. += "[m3] [wear_shirt.get_examine_string(user)]."

	//uniform
	if(wear_pants && !(obscured & ITEM_SLOT_PANTS))
		//accessory
		var/accessory_msg
		if(istype(wear_pants, /obj/item/clothing/pants))
			var/obj/item/clothing/pants/U = wear_pants
			if(U.attached_accessory)
				accessory_msg += " with [icon2html(U.attached_accessory, user)] \a [U.attached_accessory]"

		. += "[m3] [wear_pants.get_examine_string(user)][accessory_msg]."

	//head
	if(head && !(obscured & ITEM_SLOT_HEAD))
		. += "[m3] [head.get_examine_string(user)] on [m2] head."
	//suit/armorF
	if(wear_armor && !(obscured & ITEM_SLOT_ARMOR))
		. += "[m3] [wear_armor.get_examine_string(user)]."

	if(cloak && !(obscured & ITEM_SLOT_CLOAK))
		. += "[m3] [cloak.get_examine_string(user)] on [m2] shoulders."

	if(backr && !(obscured & ITEM_SLOT_BACK_R))
		. += "[m3] [backr.get_examine_string(user)] on [m2] back."

	if(backl && !(obscured & ITEM_SLOT_BACK_L))
		. += "[m3] [backl.get_examine_string(user)] on [m2] back."

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[m1] holding [I.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(I))]."

	//gloves
	if(gloves && !(obscured & ITEM_SLOT_GLOVES))
		. += "[m3] [gloves.get_examine_string(user)] on [m2] hands."
	else if(GET_ATOM_BLOOD_DNA_LENGTH(src))
		if(num_hands)
			. += span_warning("[m3] [num_hands > 1 ? "" : "a"] blood-stained hand[num_hands > 1 ? "s" : ""]!")

	//belt
	if(belt && !(obscured & ITEM_SLOT_BELT))
		. += "[m3] [belt.get_examine_string(user)] about [m2] waist."

	if(beltr && !(obscured & ITEM_SLOT_BELT_R))
		. += "[m3] [beltr.get_examine_string(user)] on [m2] belt."

	if(beltl && !(obscured & ITEM_SLOT_BELT_L))
		. += "[m3] [beltl.get_examine_string(user)] on [m2] belt."

	//shoes
	if(shoes && !(obscured & ITEM_SLOT_SHOES))
		. += "[m3] [shoes.get_examine_string(user)] on [m2] feet."

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		. += "[m3] [wear_mask.get_examine_string(user)] on [m2] face."

	if(mouth && !(obscured & ITEM_SLOT_MOUTH))
		. += "[m3] [mouth.get_examine_string(user)] in [m2] mouth."

	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		. += "[m3] [wear_neck.get_examine_string(user)] around [m2] neck."

	if(get_eye_color() == BLOODCULT_EYE)
		. += span_warning("<B>[capitalize(m2)] eyes are glowing an unnatural red!</B>")

	//ID
	if(wear_ring && !(obscured & ITEM_SLOT_RING))
		. += "[m3] [wear_ring.get_examine_string(user)]."

	if(wear_wrists && !(obscured & ITEM_SLOT_WRISTS))
		. += "[m3] [wear_wrists.get_examine_string(user)]."

	//handcuffed?
	if(handcuffed)
		. += "<A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDCUFFED]'><span class='warning'>[m1] tied up with \a [handcuffed]!</span></A>"

	if(legcuffed)
		. += "<A href='byond://?src=[REF(src)];item=[ITEM_SLOT_LEGCUFFED]'><span class='warning'>[m3] \a [legcuffed] around [m2] legs!</span></A>"

	var/datum/status_effect/bugged/effect = has_status_effect(/datum/status_effect/bugged)
	if(effect && HAS_TRAIT(user, TRAIT_INQUISITION))
		. += "<A href='?src=[REF(src)];item=[effect.device]'><span class='warning'>[m3] \a [effect.device] implanted.</span></A>"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/appears_dead = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE
		if(suiciding)
			msg += "[t_He] appear[p_s()] to have committed suicide... there is no hope of recovery."
		if(hellbound)
			msg += "[capitalize(m2)] soul seems to have been ripped out of [m2] body. Revival is impossible."

	var/temp = getBruteLoss() + getFireLoss() //no need to calculate each of these twice

	if(!(self_inspect && hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
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
	if(!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))
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
				msg += span_bloody("<B>[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!</B>")
			else
				msg += span_bloody("[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!")
		else
			if(bleed_rate >= 5)
				msg += span_bloody("<B>[m1] [bleed_wording]</B>!")
			else
				msg += span_bloody("[m1] [bleed_wording]!")

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
			missing_limb_message = span_dead("[missing_limb_message]")
		else
			missing_limb_message = span_danger("[missing_limb_message]")
		msg += missing_limb_message

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1] being grabbed by [pulledby]."

	//Nutrition and Thirst
	var/list/msg_list = list()
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		msg_list += "[m1] looking emaciated."
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
	if(on_fire)
		var/fire_text = "[m1] on fire!"
		if(isliving(user))
			var/mob/living/liver = user
			if(liver.has_quirk(/datum/quirk/vice/pyromaniac))
				fire_text += span_boldred(" IT'S BEAUTIFUL!")
				liver.sate_addiction(/datum/quirk/vice/pyromaniac)
		msg += fire_text
	else if(fire_stacks + divine_fire_stacks > 0)
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
		if(!obscure_name)
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

		if(InCritical())
			msg += span_warning("[m1] barely conscious.")
		else
			if(stat >= UNCONSCIOUS)
				msg += "[m1] [IsSleeping() ? "sleeping" : "unconscious"]."
			else if(eyesclosed)
				msg += "[capitalize(m2)] eyes are closed."
			else if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				msg += "[m1] looking a little tired."
	else
		msg += "[m1] unconscious."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	if(!self_inspect && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		var/con_check = STACON
		var/spd_check = STASPD
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
			con_check = 10
			spd_check = 10
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[t_He] look[p_s()] much stronger than I.</B>")
			if(1 to 5)
				. += span_warning("[t_He] look[p_s()] stronger than I.")
			if(0)
				. += span_warning("[t_He] look[p_s()] about as strong as I.")
			if(-5 to -1)
				. += span_warning("[t_He] look[p_s()] weaker than I.")
			if(-INFINITY to -5)
				. += span_warning("<B>[t_He] look[p_s()] much weaker than I.</B>")
		if(L.STAPER >= 12)
			switch(con_check)
				if(15 to INFINITY)
					. += span_warning("<B>[t_He] look[p_s()] very vigorous.</B>")
				if(10 to 15)
					. += span_warning("[t_He] look[p_s()] vigorous.")
				if(5 to 10)
					. += span_warning("[t_He] look[p_s()] sickly.")
				if(-INFINITY to 5)
					. += span_warning("<B>[t_He] look[p_s()] very sickly.</B>")
			switch(spd_check)
				if(15 to INFINITY)
					. += span_warning("<B>[t_He] look[p_s()] very swift.</B>")
				if(10 to 15)
					. += span_warning("[t_He] look[p_s()] quick.")
				if(5 to 10)
					. += span_warning("[t_He] look[p_s()] sluggish.")
				if(-INFINITY to 5)
					. += span_warning("<B>[t_He] look[p_s()] very sluggish.</B>")

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

	if(!obscure_name) // Miniature headshot on examine
		if(headshot_link && client?.is_donator())
			. += "<img src=[headshot_link] width=100 height=100/>"

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
			if(!self_inspect && body_position == LYING_DOWN && (user.zone_selected == BODY_ZONE_CHEST))
				. += "<a href='byond://?src=[REF(src)];check_hb=1'>Listen to Heartbeat</a>"

	if(!HAS_TRAIT(src, TRAIT_FACELESS))
		. += "<a href='byond://?src=[REF(src)];view_descriptors=1'>Look at Features</a>"

	// Characters with the hunted flaw will freak out if they can't see someone's face.
	if(!appears_dead)
		if(!self_inspect && obscure_name && isliving(user))
			var/mob/living/liver = user
			if(liver.has_quirk(/datum/quirk/vice/hunted))
				user.add_stress(/datum/stress_event/hunted)

	if(!obscure_name && (flavortext || ((headshot_link || ooc_extra_link) && client?.is_donator()))) // only show flavor text if there is a flavor text and we show headshot
		. += "<a href='?src=[REF(src)];task=view_flavor_text;'>Examine Closer</a>"

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam

	// The Assassin's profane dagger can sniff out their targets, even masked.
	if(HAS_TRAIT(user, TRAIT_ASSASSIN) && ((has_quirk(/datum/quirk/vice/hunted) || HAS_TRAIT(src, TRAIT_ZIZOID_HUNTED))))
		//TODO: move this to an examinate signal call
		if ((src != user) && iscarbon(user))
			var/mob/living/carbon/assassin = user
			for(var/obj/item/I in assassin.get_all_gear())
				if(istype(I, /obj/item/weapon/knife/dagger/steel/profane))
					. += "profane dagger whispers, [span_danger("\"That's [real_name]! Strike their heart!\"")]"
					break

	if(HAS_TRAIT(user, TRAIT_SEEPRICES) && sellprice)
		. += "Is worth around [sellprice] mammons."

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/hierarchy_text = get_clan_hierarchy_examine(human_user)
		if(hierarchy_text)
			. += hierarchy_text

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/examine_list = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text()
		if(!effect_text)
			continue

		var/new_text = replacetext(effect_text, "SUBJECTPRONOUN", pronoun_replacement)
		new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
		examine_list += new_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")

/mob/living/proc/get_inquisition_text(mob/examiner)
	var/inquisition_text
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "A Practical of our Psydonic Inquisitorial Sect."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "The Lorde-Inquisitor of our Psydonic Inquisitorial Sect."
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "Subordinate to me in the Psydonic Inquisitorial Sect."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "The Lorde-Inquisitor of the Sect sent here. That's me."

	return inquisition_text
