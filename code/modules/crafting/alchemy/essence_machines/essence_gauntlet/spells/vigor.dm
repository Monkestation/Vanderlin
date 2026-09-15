/datum/action/cooldown/spell/essence/vigor
	name = "Vigor"
	desc = "Increases physical strength and endurance temporarily."
	button_icon_state = "bat_transform"
	cast_range = 1
	essences = list(/datum/thaumaturgical_essence/life)

/datum/action/cooldown/spell/essence/vigor/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] appears invigorated."))
	target.apply_status_effect(/datum/status_effect/buff/vigor, 10 MINUTES)
	new /obj/effect/temp_visual/snake/twin_up(null, target)

/atom/movable/screen/alert/status_effect/vigor
	name = "Vigor"
	desc = "You feel supernaturally strong and energetic."
	icon_state = "buff"

/datum/status_effect/buff/vigor
	id = "vigor"
	alert_type = /atom/movable/screen/alert/status_effect/vigor
	duration = 10 MINUTES
	effectedstats = list(STAT_STRENGTH = 1, STAT_ENDURANCE = 1)

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

/datum/action/cooldown/spell/essence/vigor/spell
	name = "Greater Vigor"
	charge_required = TRUE
	charge_time = 3 SECONDS
	spell_cost = 70
	spell_type = SPELL_MANA

	required_form = FORM_LIFE
	required_technique = TECHNIQUE_ALTERATION
