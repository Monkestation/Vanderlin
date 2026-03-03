/datum/action/cooldown/spell/essence/vigor
	name = "Vigor"
	desc = "Increases physical strength and endurance temporarily."
	button_icon_state = "vigor"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/life)

/datum/action/cooldown/spell/essence/vigor/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] appears invigorated."))
	target.apply_status_effect(/datum/status_effect/buff/vigor, 60 SECONDS)
	new /obj/effect/temp_visual/snake/twin_up(null, target)

/atom/movable/screen/alert/status_effect/vigor
	name = "Vigor"
	desc = "You feel supernaturally strong and energetic."
	icon_state = "buff"

/datum/status_effect/buff/vigor
	id = "vigor"
	alert_type = /atom/movable/screen/alert/status_effect/vigor
	duration = 60 SECONDS
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = 1)

/datum/status_effect/buff/vigor/on_apply()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		L.adjust_stamina(50)
		ADD_TRAIT(owner, TRAIT_STRONG_GRABBER, TRAIT_STATUS_EFFECT(id))
		to_chat(owner, span_notice("You feel invigorated with supernatural strength."))

/datum/status_effect/buff/vigor/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRONG_GRABBER, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("The supernatural vigor fades."))
