///Called on /mob/living/Initialize(), for the mob to register to relevant signals.
/mob/living/proc/register_init_signals()
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_KNOCKEDOUT), PROC_REF(on_knockedout_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT), PROC_REF(on_knockedout_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_DEATHCOMA), PROC_REF(on_deathcoma_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_DEATHCOMA), PROC_REF(on_deathcoma_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED), PROC_REF(on_immobilized_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_IMMOBILIZED), PROC_REF(on_immobilized_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_FLOORED), PROC_REF(on_floored_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_FLOORED), PROC_REF(on_floored_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED), PROC_REF(on_handsblocked_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_HANDS_BLOCKED), PROC_REF(on_handsblocked_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_UI_BLOCKED), PROC_REF(on_ui_blocked_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_UI_BLOCKED), PROC_REF(on_ui_blocked_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PULL_BLOCKED), PROC_REF(on_pull_blocked_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PULL_BLOCKED), PROC_REF(on_pull_blocked_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), PROC_REF(on_incapacitated_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED), PROC_REF(on_incapacitated_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_RESTRAINED), PROC_REF(on_restrained_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_RESTRAINED), PROC_REF(on_restrained_trait_loss))

	RegisterSignal(src, COMSIG_MOVETYPE_FLAG_ENABLED, PROC_REF(on_movement_type_flag_enabled))
	RegisterSignal(src, COMSIG_MOVETYPE_FLAG_DISABLED, PROC_REF(on_movement_type_flag_disabled))

	RegisterSignal(src, COMSIG_MOVABLE_EDIT_UNIQUE_IMMERSE_OVERLAY, PROC_REF(edit_immerse_overlay))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_DEAF), PROC_REF(on_hearing_loss))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_DEAF), PROC_REF(on_hearing_regain))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_LEPROSY), PROC_REF(on_leprosy_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_LEPROSY), PROC_REF(on_leprosy_trait_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_CRATEMOVER), PROC_REF(on_cratemover_trait_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_CRATEMOVER), PROC_REF(on_cratemover_trait_loss))

///Called when TRAIT_KNOCKEDOUT is added to the mob.
/mob/living/proc/on_knockedout_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(stat < UNCONSCIOUS)
		set_stat(UNCONSCIOUS)

///Called when TRAIT_KNOCKEDOUT is removed from the mob.
/mob/living/proc/on_knockedout_trait_loss(datum/source)
	SIGNAL_HANDLER
	if(stat < DEAD)
		update_stat()

///Called when TRAIT_DEATHCOMA is added to the mob.
/mob/living/proc/on_deathcoma_trait_gain(datum/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_KNOCKEDOUT, TRAIT_DEATHCOMA)

///Called when TRAIT_DEATHCOMA is removed from the mob.
/mob/living/proc/on_deathcoma_trait_loss(datum/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, TRAIT_DEATHCOMA)

///Called when TRAIT_IMMOBILIZED is added to the mob.
/mob/living/proc/on_immobilized_trait_gain(datum/source)
	SIGNAL_HANDLER
	mobility_flags &= ~MOBILITY_MOVE
	if(living_flags & MOVES_ON_ITS_OWN)
		walk(src, 0) //stop mid walk

///Called when TRAIT_IMMOBILIZED is removed from the mob.
/mob/living/proc/on_immobilized_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_MOVE

/// Called when [TRAIT_FLOORED] is added to the mob.
/mob/living/proc/on_floored_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(buckled && buckled.buckle_lying != NO_BUCKLE_LYING)
		return // Handled by the buckle.
	mobility_flags &= ~MOBILITY_STAND
	on_floored_start()


/// Called when [TRAIT_FLOORED] is removed from the mob.
/mob/living/proc/on_floored_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_STAND
	on_floored_end()

///Called when TRAIT_HANDS_BLOCKED is added to the mob.
/mob/living/proc/on_handsblocked_trait_gain(datum/source)
	SIGNAL_HANDLER
	mobility_flags &= ~(MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	on_handsblocked_start()

///Called when TRAIT_HANDS_BLOCKED is removed from the mob.
/mob/living/proc/on_handsblocked_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	REMOVE_TRAIT(src, TRAIT_UI_BLOCKED, TRAIT_HANDS_BLOCKED)
	REMOVE_TRAIT(src, TRAIT_PULL_BLOCKED, TRAIT_HANDS_BLOCKED)

/// Called when [TRAIT_UI_BLOCKED] is added to the mob.
/mob/living/proc/on_ui_blocked_trait_gain(datum/source)
	SIGNAL_HANDLER
	mobility_flags &= ~(MOBILITY_UI)
	unset_machine()
	update_mob_action_buttons()

/// Called when [TRAIT_UI_BLOCKED] is removed from the mob.
/mob/living/proc/on_ui_blocked_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_UI
	update_mob_action_buttons()

/// Called when [TRAIT_PULL_BLOCKED] is added to the mob.
/mob/living/proc/on_pull_blocked_trait_gain(datum/source)
	SIGNAL_HANDLER
	mobility_flags &= ~(MOBILITY_PULL)
	if(pulling)
		stop_pulling()

/// Called when [TRAIT_PULL_BLOCKED] is removed from the mob.
/mob/living/proc/on_pull_blocked_trait_loss(datum/source)
	SIGNAL_HANDLER
	mobility_flags |= MOBILITY_PULL


/// Called when [TRAIT_INCAPACITATED] is added to the mob.
/mob/living/proc/on_incapacitated_trait_gain(datum/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_UI_BLOCKED, TRAIT_INCAPACITATED)
	ADD_TRAIT(src, TRAIT_PULL_BLOCKED, TRAIT_INCAPACITATED)

/// Called when [TRAIT_INCAPACITATED] is removed from the mob.
/mob/living/proc/on_incapacitated_trait_loss(datum/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_UI_BLOCKED, TRAIT_INCAPACITATED)
	REMOVE_TRAIT(src, TRAIT_PULL_BLOCKED, TRAIT_INCAPACITATED)

/// Called when [TRAIT_RESTRAINED] is added to the mob.
/mob/living/proc/on_restrained_trait_gain(datum/source)
	SIGNAL_HANDLER
	ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_RESTRAINED)

/// Called when [TRAIT_RESTRAINED] is removed from the mob.
/mob/living/proc/on_restrained_trait_loss(datum/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, TRAIT_RESTRAINED)

/* ROGUE */

/datum/attribute_holder/sheet/job/leper_vice
	raw_attribute_list = list(
		STAT_STRENGTH = -3,
		STAT_ENDURANCE = -3,
		STAT_CONSTITUTION = -3,
		STAT_PERCEPTION = -3,
		STAT_SPEED = -3,
		STAT_INTELLIGENCE = -3,
		STAT_FORTUNE = -3
	)
///Called when TRAIT_LEPROSY is added to the mob.
/mob/living/proc/on_leprosy_trait_gain(datum/source)
	SIGNAL_HANDLER
	if(has_quirk(/datum/quirk/vice/leprosy))
		attributes?.add_sheet(/datum/attribute_holder/sheet/job/leper_vice)

	else
		adjust_stat_modifier(TRAIT_LEPROSY, list(
			STAT_STRENGTH = -3,
			STAT_ENDURANCE = -3,
			STAT_CONSTITUTION = -3,
			STAT_PERCEPTION = -3,
			STAT_SPEED = -3,
			STAT_INTELLIGENCE = -3,
			STAT_FORTUNE = -3
		))

///Called when TRAIT_LEPROSY is removed from the mob.
/mob/living/proc/on_leprosy_trait_loss(datum/source)
	SIGNAL_HANDLER
	if(has_quirk(/datum/quirk/vice/leprosy))
		attributes?.subtract_sheet(/datum/attribute_holder/sheet/job/leper_vice)
	remove_stat_modifier(TRAIT_LEPROSY)

///Called when TRAIT_CRATEMOVER is added to the mob.
/mob/living/proc/on_cratemover_trait_gain(datum/source)
	SIGNAL_HANDLER
	AddComponent(/datum/component/strong_pull)

///Called when TRAIT_CRATEMOVER is removed from the mob.
/mob/living/proc/on_cratemover_trait_loss(datum/source)
	SIGNAL_HANDLER
	var/datum/component/strongpull = GetComponent(/datum/component/strong_pull)
	if(strongpull)
		strongpull.RemoveComponent()

///From [element/movetype_handler/on_movement_type_trait_gain()]
/mob/living/proc/on_movement_type_flag_enabled(datum/source, trait)
	SIGNAL_HANDLER
	update_movespeed(FALSE)

///From [element/movetype_handler/on_movement_type_trait_loss()]
/mob/living/proc/on_movement_type_flag_disabled(datum/source, trait)
	SIGNAL_HANDLER
	update_movespeed(FALSE)

/mob/living/proc/edit_immerse_overlay(datum/source, atom/movable/immerse_mask/effect_relay)
	SIGNAL_HANDLER
	effect_relay.transform = effect_relay.transform.Scale(1 / current_size)
	effect_relay.transform = effect_relay.transform.Turn(-lying_angle)

///Called when [TRAIT_DEAF] is added to the mob
/mob/living/proc/on_hearing_loss()
	SIGNAL_HANDLER
	refresh_looping_ambience()
	stop_sound_channel(CHANNEL_AMBIENCE)

///Called when [TRAIT_DEAF] is removed from the mob.
/mob/living/proc/on_hearing_regain()
	SIGNAL_HANDLER
	refresh_looping_ambience()
