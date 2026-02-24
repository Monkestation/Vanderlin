/obj/item/natural/clod/sand
	name = "pile of sand"
	desc = "A handful of sand."
	icon_state = "sand1"
	pile = /obj/structure/fluff/clodpile/sand
	clod_type = "sand"
	smeltresult = /obj/item/natural/glass

/obj/item/natural/clod/sand/Initialize()
	. = ..()
	icon_state = "sand[rand(1,2)]"

/obj/item/natural/clod/sand/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	var/targeted_zone = throwingdatum?.target_zone
	if(targeted_zone != (BODY_ZONE_PRECISE_L_EYE || BODY_ZONE_PRECISE_R_EYE))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(H.is_eyes_covered())
			return
		if(H.get_bodypart(targeted_zone))
			H.adjust_temp_blindness(2 SECONDS)
			H.set_eye_blur_if_lower(20 SECONDS)
			to_chat(H, span_userdanger("Sand hits my eyes. I can't see!"))
			H.emote("painscream")
			qdel(src)

/obj/structure/fluff/clodpile/sand
	name = "sand mound"
	desc = "A gathering of grains inedible to all but the bravest."
	icon_state = "sandpile"
	dirt_type = /obj/item/natural/clod/sand
