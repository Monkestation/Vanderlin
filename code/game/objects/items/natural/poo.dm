/obj/item/natural/poo
	name = "nitesoil"
	desc = "This smells bad. Excrement from some disgusting individual."
	icon_state = "humpoo"
	dropshrink = 0.75
	throwforce = 0
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/natural/poo/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		playsound(H, 'sound/foley/meatslap.ogg', 100, TRUE)
		if(HAS_TRAIT(H, TRAIT_STINKY))
			H.add_stress(/datum/stress_event/poohit_nice)
		else
			H.add_stress(/datum/stress_event/poohit)
		H.adjust_hygiene(-200)
		qdel(src)

/obj/item/natural/poo/examine(mob/user)
	. = ..()
	if(user.get_skill_level(/datum/skill/labor/farming) >= 3)
		. += span_info("Restores 60 Nitrogen")
		. += span_info("Restores 40 Phosphorus")
		. += span_info("Restores 50 Potassium")

/obj/item/natural/poo/cow
	name = "moo-beast pie"
	desc = "A pie that could not be described as delicious."
	icon_state = "cowpoo"

/obj/item/natural/poo/horse
	name = "droppings"
	desc = "Fecal matter from some animal."
	icon_state = "horsepoo"
