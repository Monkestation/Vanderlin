
/datum/action/cooldown/spell/essence/probability_warp
	name = "Probability Warp"
	desc = "Alters the likelihood of minor events occurring."
	button_icon_state = "guidanceneu"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/polymorph, /datum/attunement/illusion)
	essences = list(/datum/thaumaturgical_essence/chaos, /datum/thaumaturgical_essence/void)

/datum/action/cooldown/spell/essence/probability_warp/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] warps probability in the local area."))

	for(var/mob/living/M in range(2, target_turf))
		M.apply_status_effect(/datum/status_effect/buff/probability_flux, 60 SECONDS)

/atom/movable/screen/alert/status_effect/probability_flux
	name = "Probability Flux"
	desc = "The odds seem to be in your favor... or against you."
	icon_state = "buff"

/datum/status_effect/buff/probability_flux
	id = "probability_flux"
	alert_type = /atom/movable/screen/alert/status_effect/probability_flux
	duration = 60 SECONDS
	effectedstats = list(STAT_FORTUNE = 2)

/datum/status_effect/buff/probability_flux/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.attributes?.add_diceroll_modifier(/datum/diceroll_modifier/probability_flux)

/datum/status_effect/buff/probability_flux/on_remove()
	. = ..()
	var/mob/living/target = owner
	target.attributes?.remove_diceroll_modifier(/datum/diceroll_modifier/probability_flux)
