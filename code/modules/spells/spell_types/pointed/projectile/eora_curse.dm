/datum/action/cooldown/spell/projectile/eora_curse
	name = "Eora's Curse"
	desc = ""
	button_icon_state = "curse2"
	sound = 'sound/magic/whiteflame.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/eora)

	invocation =  "Nulla felicitas sine amore!"
	invocation_type = INVOCATION_WHISPER

	charge_time = 2 SECONDS
	cooldown_time = 30 SECONDS
	spell_cost = 55

	projectile_type = /obj/projectile/magic/eora

/obj/projectile/magic/eora
	name = "wine bubble"
	icon_state = "leaper"
	range = 7
	nondirectional_sprite = TRUE
	impact_effect_type = /obj/effect/temp_visual/wine_projectile_impact

/obj/projectile/magic/eora/on_hit(atom/target, blocked = FALSE)
	. = ..()
	make_bubble()
	if(isliving(target))
		var/mob/living/L = target
		L.OffBalance(50)
		L.visible_message(span_info("A purple haze shrouds [target]!"), span_notice("I feel incredibly drunk..."))
		L.reagents.add_reagent(/datum/reagent/berrypoison, 1)
		L.apply_status_effect(/datum/status_effect/debuff/eoradrunk)
		L.set_eye_blur_if_lower(40 SECONDS)

/obj/projectile/magic/eora/on_range()
	. = ..()
	make_bubble()

/obj/projectile/magic/eora/proc/make_bubble()
	new /obj/structure/wine_bubble(get_turf(src))

/obj/effect/temp_visual/wine_projectile_impact
	name = "wine bubble"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper_bubble_pop"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 3

/obj/structure/wine_bubble
	name = "wine bubble"
	desc = ""
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper"
	max_integrity = 10
	density = FALSE

/obj/structure/wine_bubble/Initialize()
	. = ..()
	AddElement(/datum/element/movetype_handler)
	ADD_TRAIT(src, TRAIT_MOVE_FLOATING, LEAPER_BUBBLE_TRAIT)
	QDEL_IN(src, 10 SECONDS)

/obj/structure/wine_bubble/Destroy()
	new /obj/effect/temp_visual/wine_projectile_impact(get_turf(src))
	return ..()

/obj/structure/wine_bubble/Crossed(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		L.OffBalance(50)
		L.reagents.add_reagent(/datum/reagent/berrypoison, 1)
		L.apply_status_effect(/datum/status_effect/debuff/eoradrunk)
		L.visible_message(span_info("A purple haze shrouds [L]!"), span_notice("I feel incredibly drunk..."))
		L.set_eye_blur_if_lower(40 SECONDS)
	qdel(src)
