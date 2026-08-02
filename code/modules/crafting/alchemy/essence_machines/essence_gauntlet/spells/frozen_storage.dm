/datum/action/cooldown/spell/essence/frozen_storage
	name = "Fridigitation"
	desc = "Prevents rot from ever touching."
	button_icon_state = "fridigitation"
	cast_range = 1
	point_cost = 6
	attunements = list(/datum/attunement/ice, /datum/attunement/blood)
	essences = list(/datum/thaumaturgical_essence/frost, /datum/thaumaturgical_essence/water)

/datum/action/cooldown/spell/fridigitation/cast(atom/cast_on, mob/user = usr)
	. = ..()
	if(istype(cast_on, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = cast_on
		var/turf/T = get_turf(F)
		F.rotprocess = null
		F.add_filter("fridigitation_glow", 2, list("type" = "outline", "color" = "#87CEEB", "alpha" = 150, "size" = 1))
		if(T)
			var/mutable_appearance/chilly = mutable_appearance('icons/effects/effects.dmi', "mist", layer = 10)
			T.add_overlay(chilly)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), chilly), 1 SECONDS)
		to_chat(user, "The [F.name] is frozen, greatly extending its shelf life.")
		F.name = "[F.name] (frozen)"
		return TRUE
	else
		to_chat(user, span_warning("That is not a valid target for Fridigitation."))
		return FALSE
