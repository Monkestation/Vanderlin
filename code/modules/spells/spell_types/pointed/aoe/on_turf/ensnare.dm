/datum/action/cooldown/spell/aoe/on_turf/ensnare
	name = "Ensnare"
	desc = "Tendrils of arcyne force will hold all in an area in place, for a time."
	button_icon_state = "ensnare"
	point_cost = 3
	attunements = list(
		/datum/attunement/time = 0.3,
		/datum/attunement/arcyne = 0.4,
	)

	invocation = "H'ld D'wn!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_drain = 2
	cooldown_time = 25 SECONDS
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	aoe_radius = 4

	var/duration = 4 SECONDS
	var/delay = 0.8 SECONDS
	var/ensnare_radius = 1

/datum/action/cooldown/spell/aoe/on_turf/ensnare/cast_on_thing_in_aoe(turf/victim)
	new /obj/effect/temp_visual/slowdown_spell_aoe(victim)
	addtimer(CALLBACK(src, PROC_REF(apply_slowdown), victim), delay)

/datum/action/cooldown/spell/aoe/on_turf/ensnare/proc/apply_slowdown(turf/victim)
	for(var/mob/living/simple_animal/animal in range(ensnare_radius, victim))
		animal.Paralyze(duration, ignore_canstun = TRUE)

	for(var/mob/living/L in range(ensnare_radius, victim))
		if(L.can_block_magic(MAGIC_RESISTANCE))
			victim.visible_message(span_warning("The tendrils of force can't seem to latch onto [L] "))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			return
		L.Immobilize(duration)
		L.OffBalance(duration)
		L.visible_message(span_warning("[L] is held by tendrils of arcyne force!"))
		new /obj/effect/temp_visual/slowdown_spell_aoe/long(get_turf(L))

/obj/effect/temp_visual/slowdown_spell_aoe
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 0.8 SECONDS

/obj/effect/temp_visual/slowdown_spell_aoe/long
	duration = 4 SECONDS
