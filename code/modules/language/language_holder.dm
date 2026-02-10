/datum/language_holder
	var/list/languages = list(/datum/language/common)
	var/list/shadow_languages = list()
	var/only_speaks_language = null
	var/selected_default_language = null
	var/datum/language_menu/language_menu

	var/omnitongue = FALSE
	var/owner
	/// Lazyassoclist of all other mutual understanding this holder has in addition to what they understand from their understood languages.
	/// This is primarily for adding mutual understanding from other sources at runtime.
	/// Format: list(language_type = list(source = % of understanding))
	var/list/other_mutual_understanding

/datum/language_holder/New(owner)
	src.owner = owner

	languages = typecacheof(languages)
	shadow_languages = typecacheof(shadow_languages)

/datum/language_holder/Destroy()
	owner = null
	QDEL_NULL(language_menu)
	languages.Cut()
	shadow_languages.Cut()
	return ..()

/datum/language_holder/proc/copy(newowner)
	var/datum/language_holder/copy = new(newowner)
	copy.languages = src.languages.Copy()
	// shadow languages are not copied.
	copy.only_speaks_language = src.only_speaks_language
	copy.selected_default_language = src.selected_default_language
	// language menu is not copied, that's tied to the holder.
	copy.omnitongue = src.omnitongue
	return copy

/datum/language_holder/proc/grant_language(datum/language/dt, shadow = FALSE)
	if(shadow)
		shadow_languages[dt] = TRUE
	else
		languages[dt] = TRUE

/datum/language_holder/proc/grant_all_languages(omnitongue=FALSE)
	for(var/la in GLOB.all_languages)
		grant_language(la)

	if(omnitongue)
		src.omnitongue = TRUE

/datum/language_holder/proc/get_random_understood_language()
	var/list/possible = list()
	for(var/dt in languages)
		possible += dt
	. = safepick(possible)

/// Grants partial understanding of the passed language.
/// Giving 100 understanding is basically equivalent to knowning the language, just with butchered punctuation.
/datum/language_holder/proc/grant_partial_language(language, amount = 50)
	LAZYINITLIST(other_mutual_understanding)
	other_mutual_understanding[language] = amount
	return TRUE

/datum/language_holder/proc/remove_language(datum/language/dt, shadow = FALSE)
	if(shadow)
		shadow_languages -= dt
	else
		languages -= dt

/datum/language_holder/proc/remove_all_languages()
	languages.Cut()


/// Removes partial understanding of the passed language.
/datum/language_holder/proc/remove_partial_language(language)
	other_mutual_understanding -= language
	ASSOC_UNSETEMPTY(other_mutual_understanding, language)
	UNSETEMPTY(other_mutual_understanding)
	return TRUE

/// Removes all partial understandings of all languages.
/datum/language_holder/proc/remove_all_partial_languages()
	for(var/language in other_mutual_understanding)
		remove_partial_language(language)
	return TRUE

/datum/language_holder/proc/has_language(datum/language/dt)
	if(is_type_in_typecache(dt, languages))
		return LANGUAGE_KNOWN
	else
		var/atom/movable/AM = get_atom()
		var/datum/language_holder/L = AM.get_language_holder(shadow=FALSE)
		if(L != src)
			if(is_type_in_typecache(dt, L.shadow_languages))
				return LANGUAGE_SHADOWED
	return FALSE

/datum/language_holder/proc/copy_known_languages_from(thing, replace=FALSE)
	var/datum/language_holder/other
	if(istype(thing, /datum/language_holder))
		other = thing
	else if(ismovableatom(thing))
		var/atom/movable/AM = thing
		other = AM.get_language_holder()
	else if(istype(thing, /datum/mind))
		var/datum/mind/M = thing
		other = M.get_language_holder()

	if(replace)
		src.remove_all_languages()

	for(var/l in other.languages)
		src.grant_language(l)


/datum/language_holder/proc/open_language_menu(mob/user)
	if(!language_menu)
		language_menu = new(src)
	language_menu.ui_interact(user)

/datum/language_holder/proc/get_atom()
	if(ismovableatom(owner))
		. = owner
	else if(istype(owner, /datum/mind))
		var/datum/mind/M = owner
		if(M.current)
			. = M.current


/// Gets a list of all mutually understood languages.
/datum/language_holder/proc/get_partially_understood_languages()
	var/list/mutual_languages = list()
	for(var/language_type in languages)
		var/datum/language/language_instance = GLOB.language_datum_instances[language_type]
		for(var/mutual_language_type in language_instance.mutual_understanding)
			// add it to the list OR override it if it's a stronger mutual understanding
			if(mutual_languages[mutual_language_type] < language_instance.mutual_understanding[mutual_language_type])
				mutual_languages[mutual_language_type] = language_instance.mutual_understanding[mutual_language_type]

	for(var/language_type in other_mutual_understanding)
		for(var/language_source in other_mutual_understanding[language_type])
			var/understanding_for_type_by_source = other_mutual_understanding[language_type][language_source]
			if(mutual_languages[language_type] < understanding_for_type_by_source)
				mutual_languages[language_type] = understanding_for_type_by_source

	return mutual_languages

/datum/language_holder/monkey
	languages = list(/datum/language/common)


/datum/language_holder/empty
	languages = list()
	shadow_languages = list()

/datum/language_holder/universal/New()
	..()
	grant_all_languages(omnitongue=TRUE)

/datum/language_holder/hellspeak
	languages = list(/datum/language/hellspeak)
