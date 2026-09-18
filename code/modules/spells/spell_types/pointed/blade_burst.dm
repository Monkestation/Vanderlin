/datum/action/cooldown/spell/blade_burst
	name = "Blade Burst"
	desc = "Summon a storm of arcyne force in an area that damages through armor, wounding anything in that location after a delay."
	button_icon_state = "blade_burst"
	self_cast_possible = FALSE

	required_form = FORM_EARTH
	required_technique = TECHNIQUE_CREATION

	invocation = "Earth pierce you!!!"
	invocation_type = INVOCATION_SHOUT

	spell_flags = SPELL_RITUOS
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/blade_burst/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	new /obj/effect/temp_visual/trap(T)
	playsound(T, 'sound/magic/blade_burst.ogg', 80, TRUE, soundping = TRUE)
	addtimer(CALLBACK(src, PROC_REF(send_blades), T), round(1 SECONDS / spell_magnitude_modifier))

/datum/action/cooldown/spell/blade_burst/proc/send_blades(turf/victim)
	var/scaled_damage = round(45 * spell_magnitude_modifier)
	new /obj/effect/temp_visual/blade_burst(victim)
	playsound(victim,'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)
	for(var/mob/living/L in victim)
		var/def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		L.apply_damage(scaled_damage, BRUTE, def_zone)
		var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
		if(BP)
			var/probby = (BP.get_damage() / BP.max_damage) * 20 * spell_magnitude_modifier
			if(prob(probby))
				BP.add_wound(/datum/wound/fracture)
		L.adjustBruteLoss(scaled_damage, damage_type = BCLASS_CUT)
		to_chat(L, span_userdanger("I'm cut by arcyne force!"))

/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range =  2
	duration = 7
	plane = GAME_PLANE_UPPER

/obj/effect/temp_visual/blade_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "grassblade"
	randomdir = FALSE
	duration = 1 SECONDS

/obj/effect/temp_visual/trap/telomancy
	color = "#9932CC"
	light_color = "#9932CC"
	duration = 3 SECONDS

/obj/effect/temp_visual/trap/geomancy
	color = "#8B4513"
	light_color = "#8B4513"
	duration = 4 SECONDS
