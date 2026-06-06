/datum/enchantment/shattering
	enchantment_name = "Shattering"
	examine_text = "The bottle looks unusually brittle, as if eager to break."
	enchantment_end_message = "The bottle loses its volatile enchantment."
	enchantment_color = "#87CEEB"
	required_type = /obj/item/reagent_containers/glass/bottle
	essence_recipe = list(
		/datum/thaumaturgical_essence/crystal = 10,
		/datum/thaumaturgical_essence/chaos = 5
	)

/datum/enchantment/shattering/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_MOVABLE_IMPACT
	RegisterSignal(item, COMSIG_MOVABLE_IMPACT, PROC_REF(on_impact))

/datum/enchantment/shattering/proc/on_impact(datum/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	var/obj/item/reagent_containers/glass/bottle/bottle = source
	if(!bottle.reagents || bottle.reagents.total_volume <= 0)
		return

	var/turf/T = get_turf(bottle)
	if(!T)
		return
	var/datum/effect_system/smoke_spread/chem/fast/smoke = new
	smoke.set_up(bottle.reagents, 2, T, silent = TRUE)
	smoke.start()
	playsound(T, "glassbreak", 50, TRUE)
	new /obj/effect/decal/cleanable/debris/glass(T)

	qdel(bottle)
