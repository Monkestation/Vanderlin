/datum/action/cooldown/spell/aoe/on_turf/arcyne_storm
	name = "Arcyne storm"
	desc = "Conjure ripples of force into existence over a large area, injuring any who enter."
	button_icon_state = "hierophant"

	point_cost = 8

	charge_time = 4 SECONDS
	charge_drain = 1
	cooldown_time = 50 SECONDS
	spell_cost = 40

	aoe_radius = 4

	attunements = list(
		/datum/attunement/arcyne = 1.2
	)

	invocation = "BE TORN APART!!!"
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/aoe/on_turf/arcyne_storm/cast_on_thing_in_aoe(atom/victim, atom/caster)
	for(var/i in 1 to 16)
		addtimer(CALLBACK(src, PROC_REF(apply_damage), victim), wait = i * 1 SECONDS)

/datum/action/cooldown/spell/aoe/on_turf/arcyne_storm/proc/apply_damage(turf/victim)
	new /obj/effect/temp_visual/arcyne_storm(victim)
	playsound(victim, "genslash", 40, TRUE)
	for(var/mob/living/L in victim.contents)
		L.adjustBruteLoss(round(10 * attuned_strength))
		to_chat(L, span_userdanger("I'm cut by an arcyne force!"))

/obj/effect/temp_visual/arcyne_storm
	name = "vortex energy"
	icon_state = "hierophant_squares"
	layer = BELOW_MOB_LAYER
	duration = 3
	light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	randomdir = FALSE
