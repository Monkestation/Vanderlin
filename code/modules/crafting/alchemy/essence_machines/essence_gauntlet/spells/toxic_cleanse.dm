/datum/action/cooldown/spell/essence/toxic_cleanse
	name = "Toxic Cleanse"
	desc = "Completely purges an area of all toxic substances and poisons."
	button_icon_state = "toxic_cleanse"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/life, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/toxic_cleanse/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] cleanses all toxins from the area."))

	for(var/mob/living/M in range(2, target_turf))
		M.reagents?.remove_all_type(/datum/reagent/toxin)
		M.reagents?.remove_all_type(/datum/reagent/poison)
		M.apply_status_effect(/datum/status_effect/buff/toxin_immunity, 300 SECONDS)
		new /obj/effect/temp_visual/snake/twin_up(null, M)

/atom/movable/screen/alert/status_effect/toxin_immunity
	name = "Toxin Immunity"
	desc = "You are protected from all toxins and poisons."
	icon_state = "buff"

/datum/status_effect/buff/toxin_immunity
	id = "toxin_immunity"
	alert_type = /atom/movable/screen/alert/status_effect/toxin_immunity
	duration = 300 SECONDS

/datum/status_effect/buff/toxin_immunity/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_TOXINLOVER, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("Toxins cannot harm you!"))

/datum/status_effect/buff/toxin_immunity/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_TOXINLOVER, TRAIT_STATUS_EFFECT(id))
