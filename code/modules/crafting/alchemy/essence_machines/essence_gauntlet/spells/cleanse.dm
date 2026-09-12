/datum/action/cooldown/spell/essence/cleanse
	name = "Cleanse"
	desc = "Removes dirt and minor stains from objects or surfaces."
	button_icon_state = "deathdoor"
	//sound = 'sound/magic/splash.ogg'
	cast_range = 1
	essences = list(/datum/thaumaturgical_essence/water)

/datum/action/cooldown/spell/essence/cleanse/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE

	owner.visible_message(span_notice("[owner] gestures, creating a cleansing mist around [target]."))
	playsound(target,  'sound/effects/splash.ogg', 50, TRUE)

	target.wash(CLEAN_WASH)

/datum/action/cooldown/spell/essence/cleanse/spell
	name = "Lesser Cleanse"
	charge_required = TRUE
	charge_time = 2 SECONDS
	spell_cost = 15
	spell_type = SPELL_MANA

	required_form = FORM_WATER
