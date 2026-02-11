/datum/action/cooldown/spell/pressure
	name = "Arcane Tides"
	desc = "Drown one with arcane tides"
	sound = 'sound/foley/jumpland/waterland.ogg'

	cast_range = 6
	associated_skill = /datum/skill/magic/arcane

	invocation = "Innkalle Vann!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 1 SECONDS
	cooldown_time = 60 SECONDS
	spell_cost = 20

/datum/action/cooldown/spell/pressure/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/pressure/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(span_danger("[cast_on] is drowned by arcane tides!"), span_userdanger("I'm being drowned by arcane tides!"))
	cast_on.safe_throw_at(get_step(cast_on, get_dir(owner, cast_on)), 1, 1, owner, spin = TRUE, force = cast_on.move_force)
	var/already_dead = cast_on.stat == DEAD ? TRUE : FALSE
	cast_on.adjustOxyLoss(15)
	if(!already_dead && cast_on.stat == DEAD && cast_on.client)
		record_round_statistic(STATS_PEOPLE_DROWNED)
	else
		cast_on.Slowdown(3)
		cast_on.set_dizzy(8 SECONDS)
		cast_on.set_eye_blur_if_lower(20 SECONDS)
		cast_on.emote("drown")
	return
