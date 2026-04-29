/mob/living/carbon/human/get_examine_string(mob/user, thats = FALSE)
	. = ..()
	var/used_title = get_role_title(src)
	if(!used_title)
		return
	if(!IsAdminGhost(user))
		if(!get_face_name("")) // face covered?
			return
		var/is_family_member = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			is_family_member = H.family_datum && H.family_datum != family_datum
		if(!is_family_member)
			if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_ANY_OF_TRAITS(src, list(TRAIT_RECRUITED, TRAIT_RECOGNIZED)))
				return
			if(!user.mind?.do_i_know(mind, real_name))
				return
	. += ", the [used_title]"

/mob/living/carbon/human/get_examine_list(mob/user, list/P)
	. = ..()
	// quirks
	for(var/datum/quirk/Q in quirks)
		Q.on_examined(user, P, .)


/mob/living/carbon/human/get_examine_face(mob/user, list/P, list/examine_list)
	var/self_inspect = user == src
	//var/pl = self_inspect ? "" : p_s()
	var/mob/dead/observer/O = isobserver(user) ? user : null
	//var/mob/living/L = isliving(user) ? user : null
	//var/mob/living/carbon/C = iscarbon(user) ? user : null
	var/mob/living/carbon/human/H = ishuman(user) ? user : null

	var/do_i_know = user.mind?.do_i_know(src.mind, real_name)

	// Skin tone procs on face but shows up with species
	var/datum/species/species = dna?.species
	if(species?.use_skintones)
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, \
			"[capitalize(P[THEIR])] [lowertext(species.skin_tone_wording || "skin tone")] \
			is [find_key_by_value(species.get_skin_list(), skin_tone) || "incomprehensible"].")

	. = list()

	// Culture
	if(culture)
		// do we know them, are we an observer, or do we share a culture
		if((do_i_know || O || istype(culture, H?.culture?.type)) && !istype(culture, /datum/culture/universal/ambiguous))
			var/culture_msg = self_inspect ? P[THEYRE] : "I believe [lowertext(P[THEYRE])]"
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, "[culture_msg] from [culture.examined_string(src, user)].")
		// are they from anywhere
		else if(!self_inspect)
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, "[P[THEY]] could be from anywhere.")

	// Pre-Non-Self Inspections
	if(!self_inspect)
		//Relation
		var/is_family = FALSE
		if(family_datum && family_datum == H?.family_datum)
			var/family_text = ReturnRelation(user)
			if(family_text)
				. += family_text
			is_family = TRUE
		// Know check
		if(!is_family && !O)
			if(do_i_know)
				. += span_tinynotice("I know [P[THEM]].")
			else
				. += span_tinywarning("I do not know [P[THEM]].")

	// Normal stuff
	. += ..()

	// Post-Non-Self Inspections
	if(!self_inspect)
		// Schism
		if(length(GLOB.tennite_schisms))
			var/datum/tennite_schism/S = GLOB.tennite_schisms[1]
			var/user_side = (WEAKREF(user) in S.supporters_astrata) ? ASTRATA : (WEAKREF(user) in S.supporters_challenger) ? "challenger" : null
			var/mob_side = (WEAKREF(src) in S.supporters_astrata) ? ASTRATA : (WEAKREF(src) in S.supporters_challenger) ? "challenger" : null

			if(user_side && mob_side)
				var/datum/patron/their_god = (mob_side == ASTRATA) ? S.astrata_god.resolve() : S.challenger_god.resolve()
				if(their_god)
					. += (user_side == mob_side) ? span_notice("Fellow [their_god.name] supporter!") : span_boldannounce("Vile [their_god.name] supporter!")

		// Servant Foods
		if(family_datum == SSfamilytree.ruling_family && length(culinary_preferences) && HAS_MIND_TRAIT(user, TRAIT_ROYALSERVANT))
			var/obj/item/reagent_containers/food/snacks/fav_food = culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/datum/reagent/consumable/fav_drink = culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(fav_food)
				if(fav_drink)
					. += span_tinynotice("[capitalize(P[THEIR])] favourites are [fav_food.name] and [fav_drink.name].")
				else
					. += span_tinynotice("[capitalize(P[THEIR])] favourite is [fav_food.name].")
			else if(fav_drink)
				. += span_tinynotice("[capitalize(P[THEIR])] favourite is [fav_drink.name].")
			var/obj/item/reagent_containers/food/snacks/hated_food = culinary_preferences[CULINARY_HATED_FOOD]
			var/datum/reagent/consumable/hated_drink = culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_food)
				if(hated_drink)
					. += span_tinynotice("[P[THEY]] hate [hated_food.name] and [hated_drink.name].")
				else
					. += span_tinynotice("[P[THEY]] hate [hated_food.name].")
			else if(hated_drink)
				. += span_tinynotice("[P[THEY]] hate [hated_drink.name].")

	if(!HAS_TRAIT(src, TRAIT_FACELESS))
		// Headshots ALWAYS go last.
		if(client?.is_donator())
			if(headshot_link)
				LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<img src=[headshot_link] width=100 height=100/>")
			if(flavortext || headshot_link || ooc_extra_link) // only show flavor text if there is a flavor text and we show headshot
				LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<a href='?src=[REF(src)];task=view_flavor_text;'>Examine Closer</a>")
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<a href='byond://?src=[REF(src)];view_descriptors=1'>Look at Features</a>")



//You can include this in any mob's examine() to show the examine texts of status effects!
/mob/living/proc/status_effect_examines(mob/user, pronoun_replacement, list/P)
	var/list/examine_list = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text(user, P)
		if(!effect_text)
			continue

		var/new_text = replacetext(effect_text, "SUBJECTPRONOUN", pronoun_replacement)
		new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
		examine_list += new_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")
