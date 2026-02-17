/mob/living/carbon/human/species/dwarf/mountain/subterra
	race = /datum/species/dwarf/mountain/subterra

/datum/species/dwarf/mountain/subterra
	name = "Subterran Dwarf"
	id = SPEC_ID_DWARF_SUBTERRAN
	id_override = SPEC_ID_DWARF
	desc = "Dwarves lost to the darkest reaches of Subterra.\
	\n\n\
	Carvings of rock are replaced with holy tenets of caustic minerals and pools of acid, \
	those who fail were too weak and those who succeed are the next generation.\
	\n\n\
	Following a now twisted version of Pestran teachings, most worship the Wurm, \
	turning medicine into madness and plague into purity.\
	\n\n\
	Rituals of flesh searing and caustic air have turned them green, the deepest \
	hues showing the most devout.\
	\n\n\
	There are some who find their way out of their stone cages. Those fortunate to wander into humen \
	settlements, live just like their unscarred kin. Yet still remembering their old tenets, \
	they may never see Pestra the same."

	custom_id = SPEC_ID_DWARF // this is stupid
	custom_clothes = TRUE

	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_ACID_IMMUNE)

/datum/species/dwarf/mountain/subterra/after_creation(mob/living/carbon/C)
	. = ..()

	if(!C.mind || !istype(C.patron, /datum/patron/alternate/wurm))
		return

	if(SSticker.current_state < GAME_STATE_PLAYING && length(GLOB.jarosite_starts))
		var/turf/place = pick(GLOB.jarosite_starts) // Lord forgive my sins
		SSticker.OnRoundstart(CALLBACK(C, TYPE_PROC_REF(/atom/movable, forceMove), place))

/datum/species/dwarf/mountain/subterra/preference_accessible(datum/preferences/prefs)
	. = ..()
	if(!.)
		return

	if(!prefs?.parent)
		return FALSE

	return prefs.parent.has_triumph_buy(TRIUMPH_BUY_SUBTERRAN_DWARF)

/datum/species/dwarf/mountain/subterra/get_skin_list()
	return sortList(list(
		"Jarosite" = "aabf7c"
	))
