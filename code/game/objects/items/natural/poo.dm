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
		H.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
		playsound(H, 'sound/foley/meatslap.ogg', 100, TRUE)
		if(HAS_TRAIT(H, TRAIT_STINKY))
			to_chat(H, span_green("[src] hits you. How wonderful!"))
		else
			to_chat(H, span_danger("[src] hits you. Disgusting!"))
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
