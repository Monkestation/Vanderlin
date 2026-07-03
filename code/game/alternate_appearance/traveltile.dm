/datum/atom_hud/alternate_appearance/basic/traveltile/mob_should_See(mob/M)
	if(HAS_TRAIT(M, appearance_key))
		return TRUE
	. = ..()
