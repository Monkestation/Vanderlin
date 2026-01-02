/datum/action/cooldown/spell/essence/healing_spring
	name = "Healing Spring"
	desc = "Creates a small spring of healing water that slowly restores health."
	button_icon_state = "healing_spring"
	cast_range = 2
	point_cost = 8
	attunements = list(/datum/attunement/life, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/healing_spring/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] causes a healing spring to bubble forth from the ground."))

	var/obj/structure/healing_spring/spring = new(target_turf)
	QDEL_IN(spring, 600 SECONDS)

/obj/structure/healing_spring
	name = "healing spring"
	desc = "A mystical spring that bubbles with healing waters."
	icon = 'icons/effects/effects.dmi'
	icon_state = "healingspring"
	density = FALSE
	anchored = TRUE

/obj/structure/healing_spring/Initialize()
	. = ..()
	AddComponent( \
		/datum/component/aura_healing, \
		range = 7, \
		brute_heal = 1.4, \
		burn_heal = 1.4, \
		toxin_heal = 1.4, \
		suffocation_heal = 1.4, \
		stamina_heal = 1.4, \
		clone_heal = 0.4, \
		simple_heal = 1.4, \
		organ_healing = TRUE, \
		healing_color = "#375637", \
	)
