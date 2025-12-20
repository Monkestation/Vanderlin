/datum/action/cooldown/spell/essence/gem_growth
	name = "Gem Growth"
	desc = "Encourages the natural formation of gems within suitable stone."
	button_icon_state = "gem_growth"
	cast_range = 2
	point_cost = 8
	attunements = list(/datum/attunement/earth, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/gem_growth/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	owner.visible_message(span_notice("[owner] encourages gem formation in the surrounding stone."))

	if(prob(40))
		new /obj/effect/temp_visual/gem_growth(target_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_gem), target_turf), 1 SECONDS)

/datum/action/cooldown/spell/essence/gem_growth/proc/spawn_gem(turf/target_turf)
	if(!target_turf)
		return
	new /obj/item/gem(target_turf)
	owner.visible_message(span_notice("A gem crystallizes from the stone!"))

/obj/effect/temp_visual/gem_growth
	icon = 'icons/effects/effects.dmi'
	icon_state = "gem_growth"
	duration = 1 SECONDS
	layer = EFFECTS_LAYER
