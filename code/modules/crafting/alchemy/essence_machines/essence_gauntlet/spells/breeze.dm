
/datum/action/cooldown/spell/essence/breeze
	name = "Gentle Breeze"
	desc = "Creates a small breeze that can blow out candles or scatter light objects."
	button_icon_state = "breeze"
	//sound = 'sound/magic/whiff.ogg'
	cast_range = 3
	attunements = list(/datum/attunement/aeromancy = 0.2)

/datum/action/cooldown/spell/essence/breeze/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	owner.visible_message(span_notice("[owner] gestures, creating a gentle breeze."))

	for(var/obj/item/candle/C in range(1, target_turf))
		if(C.lit)
			C.extinguish()

	for(var/obj/item/I in target_turf)
		if(I.w_class <= WEIGHT_CLASS_SMALL && prob(50))
			SSmove_manager.move_rand(I)
