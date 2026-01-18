/datum/action/cooldown/spell/status/booming_blade
	name = "Booming Blade"
	desc = "Causes explosions to ripple out from your target when they move."
	button_icon_state = "blade_burst"
	self_cast_possible = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_NO_MOVE // reap what you sow

	point_cost = 1
	attunements = list(
		/datum/attunement/arcyne = 0.4,
	)
	spell_flags = SPELL_RITUOS
	invocation = "Be still!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 30 SECONDS
	spell_cost = 50

	status_effect = /datum/status_effect/debuff/booming_blade

/datum/action/cooldown/spell/status/booming_blade/handle_attunements()
	. = ..()
	extra_args = list(attuned_strength)

/datum/status_effect/debuff/booming_blade
	id = "booming_blade"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/booming_blade
	duration = 10 SECONDS

	var/strength_multiplier = 1
	var/boomed = FALSE

/atom/movable/screen/alert/status_effect/debuff/booming_blade
	name = "Be still!"
	desc = "<span class='warning'>Something terrible will happen if I move...</span>\n"

/datum/status_effect/debuff/booming_blade/on_creation(mob/living/new_owner, duration_override, strength_multiplier)
	. = ..()
	src.strength_multiplier = strength_multiplier

/datum/status_effect/debuff/booming_blade/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(boom))
	to_chat(owner, span_userdanger("I feel as though I should not move one step!"))

/datum/status_effect/debuff/booming_blade/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	if(!boomed)
		to_chat(owner, span_nicegreen("I feel as though I can move once more..."))

/datum/status_effect/debuff/booming_blade/proc/boom(datum/source, atom/OldLoc, Dir, Forced)
	if(Forced)
		return
	var/exp_heavy = 0
	var/exp_light = round(1 * strength_multiplier)  // Scale explosion
	var/exp_flash = round(2 * strength_multiplier)
	var/exp_fire = 0
	var/damage = round(10 * strength_multiplier)  // Scale damage

	explosion(owner, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire)
	owner.adjustBruteLoss(damage)
	owner.visible_message(span_warning("A thunderous boom emanates from [owner]!"), span_danger("A thunderous boom emanates from me!"))

	boomed = TRUE

	qdel(src)
