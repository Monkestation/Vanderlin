/datum/action/cooldown/spell/essence/haste
	name = "Swift Step"
	desc = "Briefly increases movement speed."
	button_icon_state = "haste"
	//sound = 'sound/magic/whiff.ogg'
	cast_range = 0
	has_visual_effects = FALSE
	essences = list(/datum/thaumaturgical_essence/air)

/datum/action/cooldown/spell/essence/haste/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] moves with enhanced speed."))
	//playsound(owner, 'sound/magic/whiff.ogg', 50, TRUE)

	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/haste, 5 MINUTES)
	new /obj/effect/temp_visual/snake/swarm(null, L)

/datum/action/cooldown/spell/essence/haste/spell
	name = "Lesser Haste"
	charge_required = TRUE
	charge_time = 0.2 SECONDS
	spell_cost = 25
	spell_type = SPELL_MANA

	required_form = FORM_AIR
