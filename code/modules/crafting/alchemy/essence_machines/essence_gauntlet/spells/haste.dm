/datum/action/cooldown/spell/essence/haste
	name = "Swift Step"
	desc = "Briefly increases movement speed."
	button_icon_state = "haste"
	//sound = 'sound/magic/whiff.ogg'
	cast_range = 0
	point_cost = 4
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/aeromancy)

/datum/action/cooldown/spell/essence/haste/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] moves with enhanced speed."))
	//playsound(get_turf(owner), 'sound/magic/whiff.ogg', 50, TRUE)

	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/haste, 10 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)
