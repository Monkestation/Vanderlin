/datum/action/cooldown/spell/mind_spike
	name = "Mind Spike"
	desc = "You drive a disorienting spike of psychic energy into the mind of your target."
	sound = 'sound/magic/whiteflame.ogg'
	self_cast_possible = FALSE

	point_cost = 1
	attunements = list(
		/datum/attunement/dark = 0.5,
	)

	invocation = "Suffer."
	invocation_type = INVOCATION_SHOUT

	spell_flags = SPELL_RITUOS
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 0.3
	cooldown_time = 20 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/mind_spike/cast(atom/cast_on)
	. = ..()
	var/turf/victim = get_turf(cast_on)
	playsound(victim, 'sound/magic/charged.ogg', 80, TRUE)
	new /obj/effect/temp_visual/mind_spike/warn(victim)
	addtimer(CALLBACK(src, PROC_REF(drive_spike), victim), 1 SECONDS)

/datum/action/cooldown/spell/mind_spike/proc/drive_spike(turf/victim)
	playsound(victim, "genslash", 80, TRUE)
	new /obj/effect/temp_visual/mind_spike(victim)
	for(var/mob/living/L in victim)
		var/obj/item/organ/brain/brain = L.getorganslot(ORGAN_SLOT_BRAIN)
		if(!brain)
			continue
		brain.applyOrganDamage((brain.maxHealth / 8))
		to_chat(L, "<span class='userdanger'>Psychic energy is driven into my skull!!</span>")

/obj/effect/temp_visual/mind_spike
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	randomdir = FALSE
	duration = 1 SECONDS
	light_outer_range = 2
	plane = GAME_PLANE_UPPER

/obj/effect/temp_visual/mind_spike/warn
	icon_state = "bluestream_fade"
