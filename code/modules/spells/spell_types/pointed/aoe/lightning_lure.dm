/datum/action/cooldown/spell/aoe/lightning_lure
	name = "Lightning Lure"
	desc = "Leash lightning energy onto targets in range."
	button_icon_state = "lightning"
	sound = 'sound/weather/rain/thunder_1.ogg'
	charge_sound = 'sound/magic/charging_lightning.ogg'
	click_to_activate = FALSE

	point_cost = 4
	attunements = list(
		/datum/attunement/electric = 0.9
	)

	invocation = "Lighnting Lure!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2.5 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 40 MINUTES
	spell_cost = 45
	spell_flags = SPELL_RITUOS
	aoe_radius = 4
	max_targets = 3

/datum/action/cooldown/spell/aoe/lightning_lure/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/aoe/lightning_lure/cast_on_thing_in_aoe(mob/living/carbon/victim, atom/caster)
	if(IS_DEAD_OR_INCAP(victim))
		return
	caster.visible_message(
		span_warning("[victim] is connected to [caster] with a lightning lure!"),
		span_warning("You create a static link with [victim]."),
	)
	playsound(victim, 'sound/items/stunmace_gen (2).ogg', 100)
	victim.AddComponent(\
		/datum/component/leash,\
		owner,\
		aoe_radius + 1,\
		null,\
		null,\
		"lightning7",\
		'icons/effects/beam.dmi',\
		FALSE,\
		CALLBACK(src, PROC_REF(on_break), victim),\
		duration = 15 SECONDS,\
	)

/datum/action/cooldown/spell/aoe/lightning_lure/proc/on_break(mob/living/carbon/victim)
	if(QDELETED(owner))
		return
	if(get_dist(victim, owner) > aoe_radius - 1)
		playsound(victim, 'sound/items/stunmace_toggle (3).ogg', 100)
		owner.visible_message(span_warning("The lightning lure fizzles out!"), span_warning("[victim] was too far away!"))
		return
	victim.visible_message(span_warning("[victim] is hooked!"), span_userdanger("I'm hooked!"))
	victim.electrocute_act(15, owner)
