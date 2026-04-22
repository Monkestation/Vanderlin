/obj/item/caparison
	name = "caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. This one fits on a Saiga."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "caparison"
	var/caparison_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	var/caparison_state = "caparison"
	var/detail_state
	var/list/detail_types
	var/list/symbol_types
	var/female_caparison_state = "caparison-f"
	gender = NEUTER
	item_weight = 500 GRAMS
	var/list/valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/saiga)

/obj/item/caparison/attack(mob/living/M, mob/living/user)
	if(!istype(M, /mob/living/simple_animal))
		to_chat(user, span_warning("\The [src] can only be used on animals!"))
		return
	if(!is_type_in_list(M, valid_animal_types))
		to_chat(user, span_warning("\The [src] cannot be used on [M]! It is only meant for specific animals."))
		return

	var/mob/living/simple_animal/animal = M
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal] is a juvenile and cannot wear a caparison!"))
		return
	if(animal.ccaparison)
		to_chat(user, span_warning("[animal] is already wearing a caparison!"))
		return
	if(!animal.ssaddle)
		to_chat(user, span_warning("[animal] needs to be saddled before you can fit a caparison onto it!"))
		return

	user.visible_message(span_notice("[user] is fitting a caparison onto [animal]..."), span_notice("I start fitting a caparison onto [animal]..."))
	if(!do_after(user, 5 SECONDS, animal))
		return

	animal.ccaparison = src
	forceMove(animal)
	animal.update_icon()
	user.visible_message(span_notice("[user] fits a caparison onto [animal]."), span_notice("I fit a caparison onto [animal]."))


/obj/item/caparison/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!length(detail_types))
		return

	var/list/possible_detail_types = list("None" = null) + detail_types.Copy()
	if(length(symbol_types))
		possible_detail_types += list("Symbol" = null)

	var/chosen_design = input(user, "Select a design.", "Caparison Design") as null|anything in possible_detail_types
	if(!chosen_design)
		return

	if(chosen_design == "Symbol")
		var/chosen_symbol = input(user, "Select a symbol.", "Caparison Design") as null|anything in symbol_types
		if(!chosen_symbol)
			return
		detail_state = symbol_types[chosen_symbol]
	else
		detail_state = detail_types[chosen_design]

	var/list/colors_to_pick = list()
	if(GLOB.lordprimary)
		colors_to_pick["Primary Keep Color"] = GLOB.lordprimary
	if(GLOB.lordsecondary)
		colors_to_pick["Secondary Keep Color"] = GLOB.lordsecondary
	var/list/color_map_list = COLOR_MAP
	colors_to_pick += color_map_list.Copy()

	var/primary_color = input(user, "Select a primary color.", "Caparison Design") as null|anything in colors_to_pick
	if(!primary_color)
		return
	color = colors_to_pick[primary_color]

	if(chosen_design != "None")
		if(chosen_design != "Symbol")
			var/secondary_color = input(user, "Select a secondary color.", "Caparison Design") as null|anything in colors_to_pick
			if(!secondary_color)
				return
			detail_color = colors_to_pick[secondary_color]
		else
			detail_color = COLOR_WHITE

//////////////////////
// SUBTYPES - SAIGA //
//////////////////////

/obj/item/caparison/psy
	name = "psydonite caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Psycrosses. This one fits on a Saiga."
	caparison_state = "psy_caparison"
	female_caparison_state = "psy_caparison-f"

/obj/item/caparison/astrata
	name = "astratan caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Astratan crosses. This one fits on a Saiga."
	caparison_state = "astra_caparison"
	female_caparison_state = "astra_caparison-f"

/obj/item/caparison/eora
	name = "eoran caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Eoran hearts. This one fits on a Saiga."
	caparison_state = "eora_caparison"
	female_caparison_state = "eora_caparison-f"

/obj/item/caparison/azure
	name = "azurean caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with ducal colours. This one fits on a Saiga."
	caparison_state = "azure_caparison"
	female_caparison_state = "azure_caparison-f"

/obj/item/caparison/heartfelt
	name = "Heartfelt caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with the colours of Heartfelt. This one fits on a Saiga."
	caparison_state = "heartfelt_caparison"
	female_caparison_state = "heartfelt_caparison-f"

/////////////////////////
// SUBTYPES - HONSE //
/////////////////////////

/obj/item/caparison/honse
	name = "caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. This one fits on a Honse."
	caparison_icon = 'icons/mob/monster/fogbeast.dmi'
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/honse)
	color = COLOR_WHITE
	detail_types = list("Quad" = "quad")
	symbol_types = list("Psycross" = "psycross", "Astrata" = "astrata")
	item_weight = 700 GRAMS
