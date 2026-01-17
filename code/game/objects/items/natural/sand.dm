/obj/item/natural/clod/sand
	name = "pile of sand"
	desc = "A handful of sand."
	icon_state = "sand1"
	pile = /obj/structure/fluff/clodpile/sand
	clod_type = "sand"

/obj/item/natural/clod/sand/Initialize()
	. = ..()
	icon_state = "sand[rand(1,2)]"

/obj/item/natural/clod/sand/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	var/targeted_zone = throwingdatum?.target_zone
	if(targeted_zone != (BODY_ZONE_PRECISE_L_EYE || BODY_ZONE_PRECISE_R_EYE))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		if(C.is_eyes_covered())
			return
		if(C.get_bodypart(targeted_zone))
			C.adjust_temp_blindness(2 SECONDS)
			C.set_eye_blur_if_lower(20 SECONDS)
			to_chat(C, span_userdanger("Sand hits my eyes. I can't see!"))
			C.emote("painscream")
			qdel(src)

/obj/structure/fluff/clodpile/sand
	name = "sand mound"
	desc = "A gathering of grains inedible to all but the bravest."
	icon_state = "sandpile"
	dirt_type = /obj/item/natural/clod/sand
