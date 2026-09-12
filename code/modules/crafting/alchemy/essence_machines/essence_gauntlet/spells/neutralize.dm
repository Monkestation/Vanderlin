/datum/action/cooldown/spell/essence/neutralize
	name = "Neutralize"
	desc = "Removes harmful toxins and poisons from objects or creatures."
	button_icon_state = "borrowtime"
	cast_range = 1
	essences = list(/datum/thaumaturgical_essence/poison)

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

/datum/action/cooldown/spell/essence/neutralize/spell
	name = "Neutralize Toxins"
	charge_required = TRUE
	charge_time = 0.2 SECONDS
	spell_cost = 40
	spell_type = SPELL_MANA

	required_form = FORM_LIFE
	required_technique = TECHNIQUE_RESTORATION
