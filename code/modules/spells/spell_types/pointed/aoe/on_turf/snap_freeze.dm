/datum/action/cooldown/spell/aoe/on_turf/snap_freeze
	name = "Snap Freeze"
	desc = "Freeze the air in a small area in an instant."
	button_icon_state = "snapfreeze"

	point_cost = 2
	attunements = list(
		/datum/attunement/blood = 0.3,
		/datum/attunement/ice = 0.4,
	)

	invocation = "Air be still!"
	invocation_type = INVOCATION_SHOUT
	spell_flags = SPELL_RITUOS
	charge_time = 3 SECONDS
	charge_drain = 2
	charge_slowdown = 1.3
	cooldown_time = 40 SECONDS
	spell_cost = 45

	aoe_radius = 2

/datum/action/cooldown/spell/aoe/on_turf/snap_freeze/cast_on_thing_in_aoe(turf/victim, atom/caster)
	new /obj/effect/temp_visual/trapice(victim)
	playsound(victim, 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 80, TRUE, soundping = TRUE)
	addtimer(CALLBACK(src, PROC_REF(do_freeze), victim), 0.5 SECONDS)

/datum/action/cooldown/spell/aoe/on_turf/snap_freeze/proc/do_freeze(turf/victim)
	new /obj/effect/temp_visual/snap_freeze(victim)
	playsound(victim, 'sound/combat/newstuck.ogg', 80, TRUE)
	for(var/mob/living/L in victim)
		if(L.can_block_magic(MAGIC_RESISTANCE))
			L.visible_message(span_warning("The ice fades away around [L]."))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		L.adjustFireLoss(35)
		L.apply_status_effect(/datum/status_effect/debuff/frostbite, null, attuned_strength)
		to_chat(L, span_userdanger("The air chills your bones!"))

/obj/effect/temp_visual/trapice
	icon = 'icons/effects/effects.dmi'
	icon_state = "blueshatter"
	light_power = 1
	light_outer_range = 2
	light_color = "#4cadee"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/snap_freeze
	icon = 'icons/effects/freeze.dmi'
	icon_state = "ice_shards"
	randomdir = FALSE
	duration = 1 SECONDS
