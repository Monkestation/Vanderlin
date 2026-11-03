//Added by Jack Rost
/obj/item/trash
	icon_state = "applecore"
	icon = 'icons/roguetown/items/produce.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

/obj/item/trash/Initialize(mapload)
	var/turf/T = get_turf(src)
	if(T && is_town_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	return ..()

/obj/item/trash/Destroy()
	var/turf/T = get_turf(src)
	if(T && is_town_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	return ..()

/obj/item/trash/candle
	name = "melted candle"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "candle4"
	item_weight = 23 GRAMS

/obj/item/trash/candle/eora
	name = "melted eora's candle"
	icon_state = "candle_eora_melted"

/obj/item/trash/attack(mob/M, mob/living/user, list/modifiers)
	return
