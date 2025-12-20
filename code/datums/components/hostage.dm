// Repurposed gunpoint.dm component from tgstation

/// How long it takes from the gunpoint is initiated to reach stage 2
#define DELAY_STAGE_2 (2.5 SECONDS)
/// How long it takes from stage 2 starting to move up to stage 3
#define DELAY_STAGE_3 (7.5 SECONDS)
/// How much the damage and wound bonus mod is multiplied when you're on stage 1
#define MULT_STAGE_1 1.5
/// As above, for stage 2
#define MULT_STAGE_2 2.5
/// As above, for stage 3
#define MULT_STAGE_3 3.5
/// How many tiles around the target the captor can roam without losing their shot
#define CAPTOR_STRAY_RANGE 2

// holdup is for the person aiming
/datum/status_effect/holdup
	id = "holdup"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/holdup

/atom/movable/screen/alert/status_effect/holdup
	name = "Holding Up"
	desc = "You're currently holding someone hostage."
	icon_state = "aimed"

// heldup is for the person being aimed at
/datum/status_effect/grouped/heldup
	id = "heldup"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/heldup

/atom/movable/screen/alert/status_effect/heldup
	name = "Held Up"
	desc = "Making any sudden moves would probably be a bad idea!"
	icon_state = "aimed"

/datum/component/hostage
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/target
	var/obj/item/gun/weapon

	var/stage = 1
	var/damage_mult = MULT_STAGE_1

	var/point_of_no_return = FALSE

	var/stage_timer

// *extremely bad russian accent* no!
/datum/component/hostage/Initialize(mob/living/targ, obj/item/wep)
	if(!isliving(parent) || !isliving(targ))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/captor = parent
	target = targ
	weapon = wep
	RegisterSignal(targ, list(COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_FIRED_GUN, COMSIG_LIVING_RESIST_GRAB), PROC_REF(trigger_reaction))
	RegisterSignal(targ, COMSIG_MOVABLE_MOVED, PROC_REF(check_deescalate))
	RegisterSignal(targ, COMSIG_PARENT_QDELETING, PROC_REF(qdel), src)

	RegisterSignal(weapon, list(COMSIG_PARENT_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_SPEC_ATTACKEDBY), PROC_REF(cancel))

	captor.visible_message(span_danger("[captor] takes [target] hostage with [weapon]!"), \
		span_danger("You take [target] hostage with [weapon]."), ignored_mobs = target, \
		vision_distance = COMBAT_MESSAGE_RANGE)
	to_chat(target, span_userdanger("[captor] takes you hostage with [weapon]!"))

	captor.apply_status_effect(/datum/status_effect/holdup)
	target.apply_status_effect(/datum/status_effect/grouped/heldup, REF(captor))

	target.add_stress(/datum/stress_event/taken_hostage)

	stage_timer = addtimer(CALLBACK(src, PROC_REF(update_stage), 2), DELAY_STAGE_2, TIMER_STOPPABLE)

/datum/component/hostage/Destroy(force)
	var/mob/living/captor = parent
	captor.remove_status_effect(/datum/status_effect/holdup)
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(captor))
	target.remove_stress(/datum/stress_event/taken_hostage)
	deltimer(stage_timer)
	return ..()

/datum/component/hostage/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(flinch))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(check_shove))
	RegisterSignal(parent, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(check_deescalate))
	RegisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP), PROC_REF(check_bump))
	RegisterSignal(parent, COMSIG_MOB_SWAPPING_HANDS, PROC_REF(cancel))

/datum/component/hostage/UnregisterFromParent()
	UnregisterSignal(parent, \
		list(COMSIG_MOVABLE_MOVED, \
		COMSIG_MOB_APPLY_DAMGE, \
		COMSIG_MOB_UPDATE_SIGHT, \
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_LIVING_START_PULL, \
		COMSIG_MOVABLE_BUMP))

///If the captor bumps anything but the target, flinch
/datum/component/hostage/proc/check_bump(atom/B, atom/A)
	SIGNAL_HANDLER

	if(A == target)
		return
	flinch(parent)

///If the captor shoves or grabs the target, cancel the holdup to avoid cheesing
/datum/component/hostage/proc/check_shove(mob/living/carbon/captor, mob/captor_again, mob/living/T, datum/martial_art/attacker_style, modifiers)
	SIGNAL_HANDLER

	if(T != target)
		return
	captor.visible_message(span_danger("[captor] bumps into [target] and fumbles!"),
		span_userdanger("You bump into [target] and fumbles!"), ignored_mobs = target)
	to_chat(target, span_userdanger("[captor] bumps into you and fumbles!"))
	qdel(src)

/// When the captor moves, downgrade focus to first stage
/datum/component/hostage/proc/move_react(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER

	if(check_deescalate())
		return
	if(stage > 1)
		to_chat(parent, span_danger("You lose focus steadying [weapon] towards [target]!"))
		to_chat(target, span_userdanger("[parent] loses their focus steadying [weapon] towards you!"))
		update_stage(1)

///Update the damage multiplier for whatever stage we're entering into
/datum/component/hostage/proc/update_stage(new_stage)
	stage = new_stage
	deltimer(stage_timer)
	switch(stage)
		if(1)
			damage_mult = MULT_STAGE_1
			stage_timer = addtimer(CALLBACK(src, PROC_REF(update_stage), 2), DELAY_STAGE_2, TIMER_STOPPABLE)
		if(2)
			to_chat(parent, span_warning("You steady [weapon] towards [target]."))
			to_chat(target, span_userdanger("[parent] has steadied [weapon] towards you!"))
			damage_mult = MULT_STAGE_2
			stage_timer = addtimer(CALLBACK(src, PROC_REF(update_stage), 3), DELAY_STAGE_3, TIMER_STOPPABLE)
		if(3)
			to_chat(parent, span_warning("You have fully steadied [weapon] towards [target]."))
			to_chat(target, span_userdanger("[parent] has fully steadied [weapon] towards you!"))
			damage_mult = MULT_STAGE_3

///Cancel the holdup if the captor moves out of sight or out of range of the target
/datum/component/hostage/proc/check_deescalate()
	SIGNAL_HANDLER

	var/mob/living/living_parent = parent
	if(!can_see(living_parent, target, CAPTOR_STRAY_RANGE) || !living_parent.can_see_cone(target))
		cancel()
		return TRUE

///Stabby stabby, we're killing now
/datum/component/hostage/proc/trigger_reaction()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(async_trigger_reaction))

/datum/component/hostage/proc/async_trigger_reaction()
	var/mob/living/captor = parent
	captor.remove_status_effect(/datum/status_effect/holdup) // try doing these before the trigger gets pulled since the target (or captor even) may not exist after pulling the trigger, dig?
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(captor))

	if(point_of_no_return)
		return
	point_of_no_return = TRUE

	weapon.force *= damage_mult
	target.attacked_by(weapon, captor)
	captor.changeNext_move(CLICK_CD_MELEE)
	weapon.force /= damage_mult

	qdel(src)

///Captor released the hostage, either by dropping/equipping their weapon, leaving sight/range, or switching hands
/datum/component/hostage/proc/cancel()
	SIGNAL_HANDLER

	var/mob/living/captor = parent
	captor.visible_message(span_danger("[captor] breaks [captor.p_their()] focus on [target]!"), \
		span_userdanger("You no longer have [weapon] focused on [target]!"), ignored_mobs = target)
	to_chat(target, span_userdanger("[captor] breaks [captor.p_their()] focus on you!"))
	qdel(src)

///If the captor is hit by an attack, they have a 50% chance to flinch and fire. If it hit the arm holding the weapon, it's an 80% chance to fire instead
/datum/component/hostage/proc/flinch(mob/living/source, damage_amount, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER

	if(!attack_direction) // No fliching from yourself
		return

	var/flinch_chance = 50
	var/gun_hand = (source.get_held_index_of_item(weapon) % 2) ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM

	if(isbodypart(def_zone))
		var/obj/item/bodypart/hitting = def_zone
		def_zone = hitting.body_zone

	if(def_zone == gun_hand)
		flinch_chance = 80

	if(prob(flinch_chance))
		source.visible_message(
			span_danger("[source] flinches!"),\
			span_userdanger("You flinch!"),\
			vision_distance = COMBAT_MESSAGE_RANGE
		)
		INVOKE_ASYNC(src, PROC_REF(trigger_reaction))

#undef DELAY_STAGE_2
#undef DELAY_STAGE_3
#undef MULT_STAGE_1
#undef MULT_STAGE_2
#undef MULT_STAGE_3
#undef CAPTOR_STRAY_RANGE
