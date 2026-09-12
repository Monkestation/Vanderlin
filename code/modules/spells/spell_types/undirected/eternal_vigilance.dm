/datum/action/cooldown/spell/undirected/eternal_vigilance
	name = "Eternal Vigilance"
	desc = "Enter a dreamless stasis. Close your eyes for a deeper trance."
	has_visual_effects = FALSE

	//so we don't accidentally give them arcane exp...
	associated_skill = /datum/attribute/skill/magic/holy

	//quick to get in and out.
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_cost = 0
	check_flags = NONE

	/// tracking if we're already in basic stasis
	var/stasis = FALSE

/datum/action/cooldown/spell/undirected/eternal_vigilance/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(stasis)
		//we're ALREADY in basic stasis, time to wake up
		stasis = FALSE
		cast_on.remove_status_effect(/datum/status_effect/aasimar_stasis)
		return

	//try to enter stasis
	if(cast_on.eyesclosed)
		var/can_sleep = TRUE
		var/list/equipped_items = cast_on.get_equipped_items()
		for(var/obj/item/clothing/thing in equipped_items)
			if(thing.clothing_flags & CANT_SLEEP_IN)
				//we're too uncomfortable for deep stasis
				to_chat(cast_on, span_boldwarning("I can't enter stasis...[thing] bothers me..."))
				can_sleep = FALSE
				break
		//we made it through the items check, go into deep stasis for a set duration.
		if(can_sleep)
			cast_on.apply_status_effect(/datum/status_effect/aasimar_stasis/deep)
		return

	//time for regular stasis
	cast_on.apply_status_effect(/datum/status_effect/aasimar_stasis)
	stasis = TRUE
