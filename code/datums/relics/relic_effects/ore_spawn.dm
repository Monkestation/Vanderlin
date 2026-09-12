/datum/relic_effect/mad_god_dream
	active_duration = -1
	signal = TRUE

/datum/relic_effect/mad_god_dream/setup_signals()
	// Listen globally for any crop harvests across the world
	RegisterSignal(SSdcs, COMSIG_GLOBAL_PLANT_HARVESTED, PROC_REF(on_global_harvest))

/datum/relic_effect/mad_god_dream/remove_signals()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_PLANT_HARVESTED)

/**
 * Triggered whenever anyone harvests a plant.
 */
/datum/relic_effect/mad_god_dream/proc/on_global_harvest(datum/source, atom/soil, mob/living/user, atom/drop_loc)
	SIGNAL_HANDLER

	// 2% Gold Roll
	if(prob(2))
		new /obj/item/ore/gold(drop_loc)
		to_chat(user, span_purple("A shimmering nugget of raw gold tumbles from the roots as you harvest!"))
		stored_lookup.play_relic_effects()
		return

	// 4% Silver Roll
	if(prob(4))
		new /obj/item/ore/silver(drop_loc)
		to_chat(user, span_notice("A chunk of raw silver is unearthed amidst the harvest."))
		stored_lookup.play_relic_effects()
		return

	// 6% Iron Roll
	if(prob(6))
		new /obj/item/ore/iron(drop_loc)
		to_chat(user, span_notice("You find a piece of metallic bark matching iron ore tangled in the crop."))
		stored_lookup.play_relic_effects()
		return
