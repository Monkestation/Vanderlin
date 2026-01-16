/datum/action/cooldown/spell/essence/cleanse
	name = "Cleanse"
	desc = "Removes dirt and minor stains from objects or surfaces."
	button_icon_state = "cleanse"
	//sound = 'sound/magic/splash.ogg'
	cast_range = 1
	attunements = list(/datum/attunement/blood)

/datum/action/cooldown/spell/essence/cleanse/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE

	owner.visible_message(span_notice("[owner] gestures, creating a cleansing mist around [target]."))
	//playsound(target, 'sound/magic/splash.ogg', 50, TRUE)

	target.wash(CLEAN_WASH)
