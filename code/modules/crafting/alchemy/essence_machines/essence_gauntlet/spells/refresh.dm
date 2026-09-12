/datum/action/cooldown/spell/essence/refresh
	name = "Refresh"
	desc = "Removes minor fatigue and restores a small amount of stamina."
	button_icon_state = "terrors"
	//sound = 'sound/magic/staff_healing.ogg'
	cast_range = 1
	essences = list(/datum/thaumaturgical_essence/life)

/datum/action/cooldown/spell/essence/refresh/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] appears refreshed."))
	//playsound(owner, 'sound/magic/staff_healing.ogg', 50, TRUE)

	target.adjust_stamina(20)
	target.adjust_energy(20)

/datum/action/cooldown/spell/essence/refresh/spell
	name = "Reinvigorate"
	charge_required = TRUE
	charge_time = 0.2 SECONDS
	spell_cost = 30
	spell_type = SPELL_MANA

	required_form = FORM_LIGHTNING
