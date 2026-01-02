/datum/action/cooldown/spell/essence/detect_poison
	name = "Detect Poison"
	desc = "Reveals the presence of toxins or poisons in nearby objects."
	button_icon_state = "detect_poison"
	cast_range = 2
	point_cost = 2
	attunements = list(/datum/attunement/life)

/datum/action/cooldown/spell/essence/detect_poison/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] scans for toxins in the area."))

	var/found_poison = FALSE
	for(var/obj/item/I in range(1, target_turf))
		if(I.reagents && I.reagents.has_reagent(/datum/reagent/toxin))
			I.visible_message(span_warning("[I] glows with a sickly light!"))
			new /obj/effect/temp_visual/solosnake(get_turf(I))
			found_poison = TRUE
			continue
		if(I.reagents && I.reagents.has_reagent(/datum/reagent/poison))
			I.visible_message(span_warning("[I] glows with a sickly light!"))
			new /obj/effect/temp_visual/solosnake(get_turf(I))
			found_poison = TRUE
			continue

	if(!found_poison)
		to_chat(owner, span_notice("No toxins detected in the area."))

/obj/effect/temp_visual/solosnake
	icon = 'icons/effects/effects.dmi'
	icon_state = "solosnake"
	duration = 2 SECONDS
	layer = EFFECTS_LAYER
