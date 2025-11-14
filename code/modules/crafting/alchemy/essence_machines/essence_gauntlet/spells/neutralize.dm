/datum/action/cooldown/spell/essence/neutralize
	name = "Neutralize"
	desc = "Removes harmful toxins and poisons from objects or creatures."
	button_icon_state = "neutralize"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/life)

/datum/action/cooldown/spell/essence/neutralize/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	owner.visible_message(span_notice("[owner] neutralizes toxins in [target]."))

	if(istype(target, /mob/living))
		var/mob/living/L = target
		L.reagents?.remove_all_type(/datum/reagent/toxin, 5)
		L.reagents?.remove_all_type(/datum/reagent/poison, 5)
		new /obj/effect/temp_visual/snake/twin_up(null, L)