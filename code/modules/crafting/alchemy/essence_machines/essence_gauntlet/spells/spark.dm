/datum/action/cooldown/spell/essence/spark
	name = "Spark"
	desc = "Creates a small spark that can light candles or torches."
	button_icon_state = "spark"
	sound = 'sound/magic/fireball.ogg'
	cast_range = 1
	attunements = list(/datum/attunement/fire)

/datum/action/cooldown/spell/essence/spark/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	target = get_turf(target)

	owner.visible_message(span_notice("[owner] creates a small spark near [target]."))
	playsound(target, 'sound/magic/fireball.ogg', 30, TRUE)

	for(var/obj/item/item in target.contents)
		if(istype(item, /obj/item/candle))
			var/obj/item/candle/C = item
			if(!C.lit)
				C.light()

		else if(istype(item, /obj/item/flashlight/flare/torch))
			var/obj/item/flashlight/flare/torch/T = item
			if(!T.on)
				T.fuel += 5 MINUTES
				T.fire_act()
