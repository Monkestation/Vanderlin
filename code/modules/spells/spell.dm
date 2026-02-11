/**
 * # The spell action
 *
 * This is the base action for how many of the game's
 * spells (and spell adjacent) abilities function.
 * These spells function off of a cooldown-based system.
 *
 * ## Pre-spell checks:
 * - [can_cast_spell][/datum/action/cooldown/spell/can_cast_spell] checks if the OWNER
 * of the spell is able to cast the spell.
 * - [is_valid_target][/datum/action/cooldown/spell/is_valid_target] checks if the TARGET
 * THE SPELL IS BEING CAST ON is a valid target for the spell. NOTE: The CAST TARGET is often THE SAME as THE OWNER OF THE SPELL,
 * but is not always - depending on how [Pre Activate][/datum/action/cooldown/spell/PreActivate] is resolved.
 * - [can_invoke][/datum/action/cooldown/spell/can_invoke] is run in can_cast_spell to check if
 * the OWNER of the spell is able to say the current invocation.
 *
 * ## The spell chain:
 * - [before_cast][/datum/action/cooldown/spell/before_cast] is the last chance for being able
 * to interrupt a spell cast. This returns a bitflag. if SPELL_CANCEL_CAST is set, the spell will not continue.
 * - [spell_feedback][/datum/action/cooldown/spell/spell_feedback] is called right before cast, and handles
 * invocation and sound effects. Overridable, if you want a special method of invocation or sound effects,
 * or you want your spell to handle invocation / sound via special means.
 * - [cast][/datum/action/cooldown/spell/cast] is where the brunt of the spell effects should be done
 * and implemented.
 * - [after_cast][/datum/action/cooldown/spell/after_cast] is the aftermath - final effects that follow
 * the main cast of the spell. By now, the spell cooldown has already started
 *
 * ## Other procs called / may be called within the chain:
 * - [invocation][/datum/action/cooldown/spell/invocation] handles saying any vocal (or emotive) invocations the spell
 * may have, and can be overriden or extended. Called by spell_feedback.
 * - [reset_spell_cooldown][/datum/action/cooldown/spell/reset_spell_cooldown] is a way to handle reverting a spell's
 * cooldown and making it ready again if it fails to go off at any point. Not called anywhere by default. If you
 * want to cancel a spell in before_cast and would like the cooldown restart, call this.
 *
 * ## Other procs of note:
 * - [level_spell][/datum/action/cooldown/spell/level_spell] is where the process of adding a spell level is handled.
 * this can be extended if you wish to add unique effects on level up for wizards.
 * - [delevel_spell][/datum/action/cooldown/spell/delevel_spell] is where the process of removing a spell level is handled.
 * this can be extended if you wish to undo unique effects on level up for wizards.
 * - [update_spell_name][/datum/action/cooldown/spell/update_spell_name] updates the prefix of the spell name based on its level.
 */
/datum/action/cooldown/spell
	name = "Spell"
	desc = "A wizard spell."
	background_icon = 'icons/mob/actions/roguespells.dmi'
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "shieldsparkles"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED
	panel = "Spells"
	click_to_activate = TRUE

	/// Variable for type of spell.
	var/spell_type = SPELL_MANA
	/// School of magic. (Might go unused)
	var/school = SCHOOL_UNSET
	/// Cost to learn this spell in the tree.
	var/point_cost = 0
	/// Cost to cast based on [spell_type].
	var/spell_cost = 0

	/// The sound played on cast.
	var/sound = 'sound/magic/whiteflame.ogg'

	/// If the spell uses the wizard spell rank system, the cooldown reduction per rank of the spell
	var/cooldown_reduction_per_rank = 0 SECONDS
	/// The current spell level, if taken multiple times by a wizard
	var/spell_level = 1
	/// The max possible spell level
	var/spell_max_level = 5

	/// What is uttered when the user casts the spell.
	var/invocation
	/// What is shown in chat when the user casts the spell, only matters for INVOCATION_EMOTE.
	var/invocation_self_message
	/// What type of invocation the spell is.
	/// Can be "none", "whisper", "shout", "emote".
	var/invocation_type = INVOCATION_NONE
	/// If invocation is set, do we ignore whether the user can actually speak?
	var/ignore_can_speak = FALSE

	/// Generic spell flags that may or may not be related to casting.
	var/spell_flags = NONE
	/// Flag for certain states that the spell requires the user be in to cast.
	var/spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	/// This determines what type of antimagic is needed to block the spell.
	/// If SPELL_REQUIRES_NO_ANTIMAGIC is set in Spell requirements,
	/// The spell cannot be cast if the caster has any of the antimagic flags set.
	var/antimagic_flags = MAGIC_RESISTANCE

	/// If set to a positive number, the spell will produce sparks when casted.
	var/sparks_amt = 0
	/// The typepath of the smoke to create on cast.
	var/smoke_type
	/// The amount of smoke to create on cast. This is a range, so a value of 5 will create enough smoke to cover everything within 5 steps.
	var/smoke_amt = 0

	/// Required worn items to cast.
	var/list/required_items

	/// Skill associated with spell enhancements.
	var/associated_skill = /datum/skill/magic/arcane
	/// Stat associated with spell enchancements.
	var/associated_stat = STATKEY_INT

	/// Assoc list of [datum/attunement] to value.
	var/list/attunements
	/// Value summed from caster and spell attunements to adjust some spell effects.
	var/attuned_strength

	// Pointed vars
	// In the TG refactor these weren't a given but almost all our spells are pointed including most spell types.
	// I don't really like this but oh well its required without creating a mess of inheritance.
	/// If this spell can be cast on yourself.
	var/self_cast_possible = TRUE
	/// Message showing to the spell owner upon activating pointed spell.
	var/active_msg
	/// Message showing to the spell owner upon deactivating pointed spell.
	var/deactive_msg
	/// The casting range of our spell.
	var/cast_range = 7
	/// Variable dictating if the spell will use turf based aim assist.
	var/aim_assist = TRUE

	// Charged vars
	/// If the spell requires time to charge.
	var/charge_required = TRUE
	/// Whether we're currently charging the spell.
	var/currently_charging = FALSE
	/**
	 * Cost to charge.
	 *
	 * Total drain is: ([charge_time] / [process_time]) * charge_drain
	 * process_time is currently 4 from SSaction_charge.
	 */
	var/charge_drain = 0
	/// Time to charge.
	var/charge_time = 0
	/// Slowdown while charging.
	var/charge_slowdown = 0
	/// Message to show when we start casting.
	var/charge_message
	// Not using looping_sound due to their tendancy to break and hard delete,
	// also all the invoke sounds are just static sounds.
	/// What sound file should we play when we start chanelling.
	var/charge_sound = 'sound/magic/charging.ogg'
	/// The actual sound we generate, don't mess with this.
	var/sound/charge_sound_instance
	// Following vars are used for mouse pointer charge only
	/// World time that the charge started.
	var/charge_started_at = 0
	/// Charge target time, from get_charge_time().
	var/charge_target_time = 0
	/// Whether the spell is currently charged, for cases where you want to keep casting after the initial charge (projectiles).
	var/charged = FALSE

	/// If the spell creates visual effects.
	var/has_visual_effects = TRUE

	// Exp gain variables
	// Experience gain is dependant on spell cost and the associated skill
	/// Experience gain modifier, cost is multipled by this to get experience gain.
	/// Set to 0 to stop experience gain.
	var/experience_modifier = 0.4
	/// Max skill level this spell can raise to.
	var/experience_max_skill = SKILL_LEVEL_EXPERT
	// Sleep exp variables are reliant on the caster having a mind
	/// Whether this is always sleep experience.
	var/experience_sleep = FALSE
	/// If set we are sleep experience after this threshold and normal before.
	var/experience_sleep_threshold = SKILL_LEVEL_APPRENTICE

	/// Timer ID for the auto cancel, so we can cancel it
	var/auto_cancel_timer = null

/datum/action/cooldown/spell/New(Target)
	. = ..()
	if(!active_msg)
		active_msg = "You prepare to use [src] on a target..."
	if(!deactive_msg)
		deactive_msg = "You dispel [src]."

	if(click_to_activate && !charge_required)
		ranged_mousepointer = 'icons/effects/mousemice/charge/spell_charged.dmi'

	if(!charge_required)
		return
	if(charge_time <= 0)
		stack_trace("Charging spell [src] ([type]) has no charge time")
		charge_required = FALSE
		return
	if(charge_sound)
		charge_sound_instance = sound(charge_sound)

/datum/action/cooldown/spell/Destroy()
	if(charge_required && owner)
		cancel_casting()
	charge_sound_instance = null
	return ..()

/datum/action/cooldown/spell/process()
	. = ..()
	if(!currently_charging)
		return

	if(!owner)
		return PROCESS_KILL

	if(!can_cast_spell(TRUE))
		cancel_casting()
		return PROCESS_KILL

	if(charge_drain)
		if(!check_cost(charge_drain))
			owner.balloon_alert(owner, "I cannot uphold the channeling!")
			cancel_casting()
			return PROCESS_KILL
		invoke_cost(charge_drain)

	// If this is true we hit our charge goal so stop invoking the cost and update the pointer
	if(world.time > (charge_started_at + charge_target_time))
		// We don't want that mouseUp to end in sadness
		if(!check_cost(charge_drain))
			owner.balloon_alert(owner, "I cannot uphold the channeling!")
			cancel_casting()
			return PROCESS_KILL
		owner.client?.mouse_override_icon = 'icons/effects/mousemice/charge/spell_charged.dmi'
		owner.update_mouse_pointer()
		return PROCESS_KILL

/datum/action/cooldown/spell/Grant(mob/grant_to)
	// Spells are hard baked to pratically only work with living owners
	if(!isliving(grant_to))
		qdel(src)
		return

	// If our spell is mind-bound, we only wanna grant it to our mind
	if(istype(target, /datum/mind))
		var/datum/mind/mind_target = target
		if(mind_target.current != grant_to)
			return

	. = ..()
	if(!owner)
		return

	// Register some signals so our button's icon stays up to date
	if(spell_requirements & SPELL_REQUIRES_STATION)
		RegisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(update_status_on_signal))
	if(spell_requirements & (SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_WIZARD_GARB))
		RegisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(update_status_on_signal))

	if(spell_type == SPELL_MANA)
		RegisterSignal(owner, COMSIG_LIVING_MANA_CHANGED, PROC_REF(update_status_on_signal))
	if(spell_type == SPELL_MIRACLE)
		RegisterSignal(owner, COMSIG_LIVING_DEVOTION_CHANGED, PROC_REF(update_status_on_signal))
	if(spell_type == SPELL_RAGE)
		RegisterSignal(owner, COMSIG_RAGE_CHANGED, PROC_REF(update_status_on_signal))

	RegisterSignal(owner, list(COMSIG_MOB_ENTER_JAUNT, COMSIG_MOB_AFTER_EXIT_JAUNT), PROC_REF(update_status_on_signal))

/datum/action/cooldown/spell/Remove(mob/living/remove_from)
	UnregisterSignal(remove_from, list(
		COMSIG_MOB_AFTER_EXIT_JAUNT,
		COMSIG_MOB_ENTER_JAUNT,
		COMSIG_MOB_EQUIPPED_ITEM,
		COMSIG_MOVABLE_Z_CHANGED,
		COMSIG_LIVING_MANA_CHANGED,
		COMSIG_LIVING_DEVOTION_CHANGED
	))

	return ..()

/datum/action/cooldown/spell/is_action_active(atom/movable/screen/movable/action_button/current_button)
	if(charge_required && !click_to_activate)
		return currently_charging
	return ..()

/datum/action/cooldown/spell/IsAvailable(feedback = FALSE)
	return ..() && can_cast_spell(feedback = feedback)

/datum/action/cooldown/spell/Trigger(trigger_flags, atom/target)
	// We implement this can_cast_spell check before the parent call of Trigger()
	// to allow people to click unavailable abilities to get a feedback chat message
	// about why the ability is unavailable.
	// It is otherwise redundant, however, as IsAvailable() checks can_cast_spell as well.
	if(!can_cast_spell())
		return FALSE

	return ..()

/datum/action/cooldown/spell/set_click_ability(mob/on_who)
	if(SEND_SIGNAL(on_who, COMSIG_MOB_SPELL_ACTIVATED, src) & SPELL_CANCEL_CAST)
		return FALSE

	if(currently_charging)
		return FALSE

	if(click_to_activate)
		on_activation(on_who)

		if(charge_required)
			// If pointed we setup signals to override mouse down to call InterceptClickOn()
			RegisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))

	return ..()

// Note: Destroy() calls Remove(), Remove() calls unset_click_ability() if our spell is active.
/datum/action/cooldown/spell/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	if(click_to_activate)
		on_deactivation(on_who, refund_cooldown = refund_cooldown)

		if(charge_required)
			// Cleanup signal
			UnregisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN)

	return ..()

/*
 * The following three procs are only relevant to pointed spells
 */
/// Called when the spell is activated / the click ability is set to our spell
/datum/action/cooldown/spell/proc/on_activation(mob/on_who)
	SHOULD_CALL_PARENT(TRUE)

	var/tip = "<B>Middle-click to cast the spell on a target!</B>"
	if(charge_required)
		tip = "<B>Hold Middle-click and release once charged to cast the spell on a target!</B>"

	to_chat(on_who, span_smallnotice("[active_msg] [tip]"))
	build_all_button_icons()

	return TRUE

/// Called when the spell is deactivated / the click ability is unset from our spell
/datum/action/cooldown/spell/proc/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(refund_cooldown)
		// Only send the "deactivation" message if they're willingly disabling the ability
		to_chat(on_who, span_smallnotice("[deactive_msg]"))
	build_all_button_icons()

	return TRUE

/datum/action/cooldown/spell/InterceptClickOn(mob/living/clicker, list/modifiers, atom/click_target)
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return

	if(charge_required && !charged)
		end_charging()
		RegisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))
		return

	var/atom/aim_assist_target
	if(aim_assist && isturf(click_target))
		// Find any human in the list. We aren't picky, it's aim assist after all
		aim_assist_target = locate(/mob/living/carbon/human) in click_target
		if(!aim_assist_target)
			// If we didn't find a human, we settle for any living at all
			aim_assist_target = locate(/mob/living) in click_target

	return ..(clicker, modifiers, aim_assist_target || click_target)

// Where the cast chain starts
/datum/action/cooldown/spell/PreActivate(atom/target)
	charged = FALSE
	if(!is_valid_target(target))
		if(charge_required && click_to_activate)
			to_chat(owner, span_warning("I can't cast [src] on [target]!"))
			RegisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))
		return FALSE

	return Activate(target)

/// Adjust the base charge time based on the users stats
/datum/action/cooldown/spell/proc/get_adjusted_charge_time()
	if(charge_time <= 0)
		return

	var/mob/living/living_owner = owner
	var/new_time = charge_time

	new_time -= charge_time * living_owner.get_skill_level(associated_skill, TRUE) * 0.05

	var/owner_stat = living_owner.get_stat(associated_stat)
	if(owner_stat > 10)
		new_time -= charge_time * (owner_stat - 10) * 0.02
	else
		new_time += charge_time * (10 - owner_stat) * 0.02

	return max(new_time, 1 DECISECONDS)

/// Adjust the base spell cost based on the users stats
/datum/action/cooldown/spell/proc/get_adjusted_cost(cost_override)
	if(spell_cost <= 0 && !cost_override)
		return

	var/mob/living/living_owner = owner
	var/new_cost = spell_cost
	if(cost_override)
		new_cost = cost_override

	new_cost -= spell_cost * living_owner.get_skill_level(associated_skill) * 0.03

	var/owner_stat = living_owner.get_stat(associated_stat)
	if(owner_stat > 10)
		new_cost -= spell_cost * (owner_stat - 10) * 0.02
	else
		new_cost += spell_cost * (10 - owner_stat) * 0.02

	var/owner_encumbrance = living_owner.get_encumbrance()
	if(owner_encumbrance > 0.4)
		new_cost += spell_cost * owner_encumbrance * 0.5

	return max(new_cost, 0)

/// Do any attunement handling in here or any time after before_cast
/datum/action/cooldown/spell/proc/handle_attunements()
	SHOULD_CALL_PARENT(TRUE)

	var/mob/living/caster = owner
	var/list/datum/mana_pool/usable_pools = caster.get_all_pools()
	var/list/total_attunements = GLOB.default_attunements.Copy()

	for(var/datum/mana_pool/pool as anything in usable_pools)
		for(var/negative_attunement in pool.negative_attunements)
			total_attunements[negative_attunement] += pool.negative_attunements[negative_attunement]
		for(var/attunement in pool.attunements)
			total_attunements[attunement] += pool.attunements[attunement]

	var/total_value = 1
	for(var/datum/attunement/attunement as anything in attunements)
		if(!(attunement in total_attunements))
			continue
		total_value += total_attunements[attunement] * attunements[attunement]

	attuned_strength = clamp(total_value, 0.5, 2.5)

/// Checks if the owner of the spell can currently cast it.
/// Does not check anything involving potential targets.
/datum/action/cooldown/spell/proc/can_cast_spell(feedback = TRUE)
	if(!owner)
		CRASH("[type] - can_cast_spell called on a spell without an owner!")

	if(!(spell_flags & SPELL_IGNORE_SPELLBLOCK) && HAS_TRAIT(owner, TRAIT_SPELLBLOCK))
		if(feedback)
			owner.balloon_alert(owner, "Can't focus on casting...")
		return FALSE

	if(HAS_TRAIT(owner, TRAIT_NOC_CURSE))
		if(feedback)
			owner.balloon_alert(owner, "My magicka has left me...")
		return FALSE

	for(var/datum/action/cooldown/spell/spell in owner.actions)
		if(spell == src)
			continue
		if(spell.currently_charging)
			if(feedback)
				owner.balloon_alert(owner, "Already channeling!")
			return FALSE

	if(!check_cost(feedback = feedback))
		return FALSE

	// Certain spells are not allowed on the centcom zlevel
	var/turf/caster_turf = get_turf(owner)
	if((spell_requirements & SPELL_REQUIRES_STATION) && is_centcom_level(caster_turf.z))
		if(feedback)
			owner.balloon_alert(owner, "Cannot cast here!")
		return FALSE

	if((spell_requirements & SPELL_REQUIRES_MIND) && !owner.mind)
		// No point in feedback here, as mindless mobs aren't players
		return FALSE

	// If the spell requires the user has no antimagic equipped, and they're holding antimagic
	// that corresponds with the spell's antimagic, then they can't actually cast the spell
	if((spell_requirements & SPELL_REQUIRES_NO_ANTIMAGIC) && !owner.can_cast_magic(antimagic_flags))
		if(feedback)
			owner.balloon_alert(owner, "Antimagic is preventing casting!")
		return FALSE

	if(!can_invoke(feedback = feedback))
		return FALSE

	if(!ishuman(owner))
		if(spell_requirements & (SPELL_REQUIRES_HUMAN))
			if(feedback)
				owner.balloon_alert(owner, "Can only be cast by humans!")
			return FALSE

	if(LAZYLEN(required_items))
		var/found = FALSE
		for(var/obj/item/I in owner.contents)
			if(is_type_in_list(I, required_items))
				found = TRUE
				break
		if(!found && feedback)
			owner.balloon_alert(owner, "Missing something to cast!")
			return FALSE

	return TRUE

/**
 * Check if the target we're casting on is a valid target.
 * For self-casted spells, the target being checked (cast_on) is the caster.
 *
 * Return TRUE if cast_on is valid, FALSE otherwise
 */
/datum/action/cooldown/spell/proc/is_valid_target(atom/cast_on)
	if(click_to_activate && !self_cast_possible)
		if(cast_on == owner)
			owner.balloon_alert(owner, "Can't self cast!")
			return FALSE

	return TRUE

// The actual cast chain occurs here, in Activate().
// You should generally not be overriding or extending Activate() for spells.
// Defer to any of the cast chain procs instead.
/datum/action/cooldown/spell/Activate(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Pre-casting of the spell
	// Pre-cast is the very last chance for a spell to cancel
	// Stuff like target input can go here.
	var/precast_result = before_cast(target)
	if(precast_result & SPELL_CANCEL_CAST)
		if(charge_required)
			cancel_casting()
		return FALSE

	// Extra safety
	if(!check_cost())
		return FALSE

	// Spell is officially being cast
	if(!(precast_result & SPELL_NO_FEEDBACK))
		// We do invocation and sound effects here, before actual cast
		// That way stuff like teleports or shape-shifts can be invoked before ocurring
		spell_feedback(owner)

	if(length(attunements))
		handle_attunements()

	// Actually cast the spell. Main effects go here
	cast(target)

	if(!(precast_result & SPELL_NO_IMMEDIATE_COOLDOWN))
		// The entire spell is done, start the actual cooldown at its set duration
		StartCooldown()

	if(!(precast_result & SPELL_NO_IMMEDIATE_COST))
		// Invoke the base cost of the spell in whatever unit it uses based on spell_type
		var/spent_cost = invoke_cost()
		if(spent_cost)
			handle_exp(spent_cost)

	// And then proceed with the aftermath of the cast
	// Final effects that happen after all the casting is done can go here
	after_cast(target)
	build_all_button_icons()

	return TRUE

/**
 * Actions done before the actual cast is called.
 * This is the last chance to cancel the spell from being cast.
 *
 * Can be used for target selection or to validate checks on the caster (cast_on).
 *
 * Returns a bitflag.
 * - SPELL_CANCEL_CAST will stop the spell from being cast.
 * - SPELL_NO_FEEDBACK will prevent the spell from calling [proc/spell_feedback] on cast. (invocation, sounds)
 * - SPELL_NO_IMMEDIATE_COOLDOWN will prevent the spell from starting its cooldown between cast and before after_cast.
 * - SPELL_NO_IMMEDIATE_COST will prevent the spell from charging its cost and subsequent gain of experience between cast and before after_cast.
 */
/datum/action/cooldown/spell/proc/before_cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	var/sig_return = SEND_SIGNAL(src, COMSIG_SPELL_BEFORE_CAST, cast_on)
	if(owner)
		sig_return |= SEND_SIGNAL(owner, COMSIG_MOB_BEFORE_SPELL_CAST, src, cast_on)

	if(click_to_activate)
		if(sig_return & SPELL_CANCEL_CAST)
			on_deactivation(owner, refund_cooldown = FALSE)
			return sig_return

		if(get_dist(owner, cast_on) > cast_range)
			owner.balloon_alert(owner, "Too far away!")
			return sig_return | SPELL_CANCEL_CAST

		if((spell_type == SPELL_MIRACLE) && HAS_TRAIT(cast_on, TRAIT_ATHEISM_CURSE))
			if(isliving(cast_on))
				var/mob/living/L = cast_on
				L.visible_message(
					span_danger("[L] recoils in disgust!"),
					span_userdanger("These fools are trying to cure me with religion!!")
				)
				L.cursed_freak_out()
			return sig_return | SPELL_CANCEL_CAST

		if((spell_type == SPELL_MIRACLE) && HAS_TRAIT(cast_on, TRAIT_SILVER_BLESSED) && !(spell_flags & SPELL_PSYDON))
			cast_on.visible_message(span_info("[cast_on] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			playsound(cast_on, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return sig_return | SPELL_CANCEL_CAST

	if(charge_required && !click_to_activate)
		// Otherwise we use a simple do_after
		var/do_after_flags = IGNORE_HELD_ITEM | IGNORE_USER_LOC_CHANGE | IGNORE_USER_DIR_CHANGE
		if(spell_requirements & SPELL_REQUIRES_NO_MOVE)
			do_after_flags &= ~IGNORE_USER_LOC_CHANGE
		on_start_charge()
		var/success = TRUE
		if(!do_after(owner, get_adjusted_charge_time(), timed_action_flags = do_after_flags, extra_checks = CALLBACK(src, PROC_REF(do_after_checks), owner, cast_on)))
			success = FALSE
			sig_return |= SPELL_CANCEL_CAST

		if(currently_charging) // in case charging was interrupted elsewhere
			on_end_charge(success)

	return sig_return

/datum/action/cooldown/spell/proc/do_after_checks(mob/owner, atom/cast_on)
	if(!currently_charging)
		return FALSE
	if(!can_cast_spell(TRUE))
		return FALSE
	if(!is_valid_target(cast_on))
		return FALSE
	return TRUE

/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/datum/action/cooldown/spell/proc/cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_SPELL_CAST, cast_on)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	if(owner)
		SEND_SIGNAL(owner, COMSIG_MOB_CAST_SPELL, src, cast_on)
		if(owner.ckey)
			owner.log_message("cast the spell [name][cast_on != owner ? " on / at [key_name_admin(cast_on)]":""].", LOG_ATTACK)
			if(cast_on != owner)
				cast_on.log_message("affected by spell [name] by [key_name_admin(owner)].", LOG_ATTACK)

/**
 * Actions done after the main cast is finished.
 * This is called after the cooldown's already begun.
 *
 * It can be used to apply late spell effects where order matters
 * (for example, causing smoke *after* a teleport occurs in cast())
 * or to clean up variables or references post-cast.
 */
/datum/action/cooldown/spell/proc/after_cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_SPELL_AFTER_CAST, cast_on)
	if(!owner)
		return

	SEND_SIGNAL(owner, COMSIG_MOB_AFTER_SPELL_CAST, src, cast_on)

	// Sparks and smoke can only occur if there's an owner to source them from.
	if(sparks_amt)
		do_sparks(sparks_amt, FALSE, get_turf(owner))

	if(ispath(smoke_type, /datum/effect_system/smoke_spread))
		var/datum/effect_system/smoke_spread/smoke = new smoke_type()
		smoke.set_up(smoke_amt, loca = get_turf(owner))
		smoke.start()

	if(has_visual_effects)
		var/mob/living/caster = owner
		caster.finish_spell_visual_effects(attunements)

/// Provides feedback after a spell cast occurs, in the form of a cast sound and/or invocation
/datum/action/cooldown/spell/proc/spell_feedback(mob/living/invoker)
	if(!invoker)
		return

	///even INVOCATION_NONE should go through this because the signal might change that
	invocation(invoker)

	if(sound)
		playsound(owner, sound, 50, TRUE)

/// The invocation that accompanies the spell, called from spell_feedback() before cast().
/datum/action/cooldown/spell/proc/invocation(mob/living/invoker)
	//lists can be sent by reference, a string would be sent by value
	var/list/invocation_list = list(invocation, invocation_type)
	SEND_SIGNAL(invoker, COMSIG_MOB_PRE_INVOCATION, src, invocation_list)
	var/used_invocation_message = invocation_list[INVOCATION_MESSAGE]
	var/used_invocation_type = invocation_list[INVOCATION_TYPE]

	switch(used_invocation_type)
		if(INVOCATION_SHOUT)
			invoker.say(used_invocation_message, forced = "spell ([src])")

		if(INVOCATION_WHISPER)
			invoker.whisper(used_invocation_message, forced = "spell ([src])")

		if(INVOCATION_EMOTE)
			invoker.visible_message(
				capitalize(replace_pronouns(replacetext(used_invocation_message, "%CASTER", invoker.name), invoker)),
				capitalize(replace_pronouns(replacetext(invocation_self_message, "%CASTER", invoker.name), invoker)),
			)

/// When we start charging the spell called from set_click_ability or start_casting
/datum/action/cooldown/spell/proc/on_start_charge()
	currently_charging = TRUE
	START_PROCESSING(SSaction_charge, src)
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)

	if(charge_slowdown)
		owner.add_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING, override = TRUE, multiplicative_slowdown = charge_slowdown)

	if(charge_sound_instance)
		playsound(owner, charge_sound_instance, 50, FALSE, channel = CHANNEL_CHARGED_SPELL)

	if(has_visual_effects)
		var/mob/living/caster = owner
		caster.start_spell_visual_effects(attunements)

	if(charge_message)
		owner.balloon_alert(owner, charge_message)

	if(spell_requirements & SPELL_REQUIRES_NO_MOVE)
		owner.balloon_alert(owner, "Be still while channelling...")

	if(owner?.mmb_intent)
		owner.mmb_intent_change(null)

/// When finish charging the spell called from set_click_ability or try_casting
/// This does not mean we succeeded in charging the spell just that we did mouseUp/ended the do_after
/datum/action/cooldown/spell/proc/on_end_charge(success)
	end_charging()
	. = success
	if(success)
		charged = TRUE
		return
	if(owner)
		owner.balloon_alert(owner, "Channeling was interrupted!")

/// End the charging cycle
/datum/action/cooldown/spell/proc/end_charging()
	UnregisterSignal(owner.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))
	UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_MOVED))
	currently_charging = FALSE
	charge_started_at = null
	charge_target_time = null
	STOP_PROCESSING(SSaction_charge, src)
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)

	if(charge_slowdown)
		owner.remove_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING)

	if(charge_sound_instance)
		owner.stop_sound_channel(CHANNEL_CHARGED_SPELL)
		// Play a null sound in to cancel the sound playing, because byond
		playsound(owner, sound(null, repeat = 0), 50, FALSE, channel = CHANNEL_CHARGED_SPELL)

	if(has_visual_effects)
		var/mob/living/caster = owner
		caster.cancel_spell_visual_effects()

	owner.client?.mouse_override_icon = initial(owner.client?.mouse_override_icon)
	owner.update_mouse_pointer()

/// Cancel casting and all its effects.
/datum/action/cooldown/spell/proc/cancel_casting()
	if(QDELETED(src)) // Timer
		return
	charged = FALSE
	end_charging()

/// Checks if the current OWNER of the spell is in a valid state to say the spell's invocation
/datum/action/cooldown/spell/proc/can_invoke(feedback = TRUE)
	if(spell_requirements & SPELL_CASTABLE_WITHOUT_INVOCATION)
		return TRUE

	if(invocation_type == INVOCATION_NONE)
		return TRUE

	var/mob/living/living_owner = owner
	if(invocation_type == INVOCATION_EMOTE && HAS_TRAIT(living_owner, TRAIT_EMOTEMUTE))
		if(feedback)
			owner.balloon_alert(owner, "Can't position your hands correctly to invoke!")
		return FALSE

	if((invocation_type == INVOCATION_WHISPER || invocation_type == INVOCATION_SHOUT) && !ignore_can_speak && !living_owner.can_speak_vocal())
		if(feedback)
			owner.balloon_alert(owner, "Can't get the words out to invoke!")
		return FALSE

	return TRUE

/// Resets the cooldown of the spell, sending COMSIG_SPELL_CAST_RESET
/// and allowing it to be used immediately (+ updating button icon accordingly)
/datum/action/cooldown/spell/proc/reset_spell_cooldown()
	SEND_SIGNAL(src, COMSIG_SPELL_CAST_RESET)
	next_use_time -= cooldown_time // Basically, ensures that the ability can be used now
	build_all_button_icons()

// Spell level is unused currently, it could be used for attunement thresholds

/**
 * Levels the spell up a single level, reducing the cooldown.
 * If bypass_cap is TRUE, will level the spell up past it's set cap.
 */
/datum/action/cooldown/spell/proc/level_spell(bypass_cap = FALSE)
	// Spell cannot be levelled
	if(spell_max_level <= 1)
		return FALSE

	// Spell is at cap, and we will not bypass it
	if(!bypass_cap && (spell_level >= spell_max_level))
		return FALSE

	spell_level++
	cooldown_time = max(cooldown_time - cooldown_reduction_per_rank, 0)
	build_all_button_icons(UPDATE_BUTTON_NAME)
	return TRUE

/**
 * Levels the spell down a single level, down to 1.
 */
/datum/action/cooldown/spell/proc/delevel_spell()
	// Spell cannot be levelled
	if(spell_max_level <= 1)
		return FALSE

	if(spell_level <= 1)
		return FALSE

	spell_level--
	if(cooldown_reduction_per_rank > 0 SECONDS)
		cooldown_time = min(cooldown_time + cooldown_reduction_per_rank, initial(cooldown_time))
	else
		cooldown_time = max(cooldown_time + cooldown_reduction_per_rank, initial(cooldown_time))

	build_all_button_icons(UPDATE_BUTTON_NAME)
	return TRUE

/datum/action/cooldown/spell/update_button_name(atom/movable/screen/movable/action_button/button, force)
	name = "[get_spell_title()][initial(name)]"
	return ..()

/// Gets the title of the spell based on its level.
/datum/action/cooldown/spell/proc/get_spell_title()
	switch(spell_level)
		if(2)
			return "Efficient "
		if(3)
			return "Quickened "
		if(4)
			return "Free "
		if(5)
			return "Instant "
		if(6)
			return "Ludicrous "

	return ""

/// Check if the spell is castable by cost
/datum/action/cooldown/spell/proc/check_cost(cost_override, feedback = TRUE)
	var/mob/living/caster = owner

	var/used_cost = get_adjusted_cost(cost_override)
	if(used_cost <= 0)
		return TRUE

	if(!HAS_TRAIT(owner, TRAIT_NOSTAMINA))
		var/not_stamina_spell = (spell_type != SPELL_STAMINA)
		if(!caster.check_stamina(used_cost / (1 + not_stamina_spell)))
			if(feedback)
				owner.balloon_alert(owner, "Not enough stamina to cast!")
			return FALSE

	if(spell_type == NONE || spell_type == SPELL_STAMINA)
		return TRUE

	switch(spell_type)
		if(SPELL_MANA)
			if(!caster.has_mana_available(attunements, used_cost))
				if(feedback)
					owner.balloon_alert(owner, "Not enough mana to cast!")
				return FALSE

			return TRUE

		if(SPELL_BLOOD)
			if(!caster.has_bloodpool_cost(used_cost))
				if(feedback)
					owner.balloon_alert(owner, "Need more blood to cast!")
				return FALSE

			return TRUE

		if(SPELL_MIRACLE)
			var/mob/living/carbon/human/H = caster
			if(!istype(H) || !H.cleric?.check_devotion(spell_cost))
				if(feedback)
					owner.balloon_alert(owner, "Devotion too weak!")
				return FALSE

			return TRUE

		if(SPELL_RAGE)
			var/mob/living/carbon/human/H = caster
			if(!istype(H) || !H.rage_datum?.check_rage(spell_cost))
				if(feedback)
					owner.balloon_alert(owner, "Not enough Rage!")
				return FALSE

			return TRUE

		if(SPELL_ESSENCE)
			var/obj/item/clothing/gloves/essence_gauntlet/gaunt = target
			if(QDELETED(target) || !istype(target))
				stack_trace("Essence spell checking cost without being assigned to an essence gauntlet!")
				return FALSE
			if(!gaunt.check_gauntlet_validity(owner))
				return FALSE
			// Ditto
			if(!length(gaunt.stored_vials))
				return FALSE
			if(!gaunt.can_consume_essence(used_cost, attunements))
				if(feedback)
					owner.balloon_alert(owner, "Not enough essence!")
				return FALSE

			return TRUE

		if(SPELL_PSYDONIC_MIRACLE)
			if(!caster.has_bloodpool_cost(used_cost))
				if(feedback)
					owner.balloon_alert(owner, "Need more grace to cast!")
				return FALSE

			return TRUE

/**
 * Charge the owner with the cost of the spell.
 *
 * Vars
 * * cost_override override the used cost
 * * type_override override the method of charging cost
 * * re_run if the proc is being recursively run due to lack of requirements
 *
 * Returns
 * * Cost used
 */
/datum/action/cooldown/spell/proc/invoke_cost(cost_override, type_override, re_run = FALSE)
	if(!owner)
		return

	var/used_cost = get_adjusted_cost(cost_override)

	if(used_cost <= 0)
		return

	var/used_type = spell_type
	if(type_override)
		used_type = type_override

	if(!re_run)
		if(used_type == SPELL_STAMINA)
			owner.adjust_stamina(used_cost)

	if(spell_type == NONE)
		return // No return value == No exp

	switch(used_type)
		if(SPELL_MANA)
			var/mob/living/caster = owner
			caster.consume_mana(attunements, used_cost)

		if(SPELL_MIRACLE)
			var/mob/living/carbon/human/H = owner
			if(!istype(H))
				return
			H.cleric?.update_devotion(-used_cost)

		if(SPELL_RAGE)
			var/mob/living/carbon/human/H = owner
			if(!istype(H))
				return
			H.rage_datum?.update_rage(-used_cost)

		if(SPELL_ESSENCE)
			var/obj/item/clothing/gloves/essence_gauntlet/gaunt = target
			if(!gaunt?.check_gauntlet_validity(owner))
				return

			gaunt.consume_essence(used_cost, attunements)

		if(SPELL_BLOOD)
			var/mob/living/caster = owner
			caster.adjust_bloodpool(-used_cost)

		if(SPELL_PSYDONIC_MIRACLE)
			var/mob/living/caster = owner
			caster.adjust_bloodpool(-used_cost)

	return used_cost

/datum/action/cooldown/spell/proc/handle_exp(cost_in)
	if(experience_modifier <= 0 || !associated_skill)
		return

	if(!experience_max_skill)
		experience_max_skill = SKILL_LEVEL_LEGENDARY

	var/skill_level = owner.get_skill_level(associated_skill)
	if(skill_level >= experience_max_skill)
		return

	var/mob/living/caster = owner
	var/exp_to_gain = caster.get_stat(associated_stat) + (cost_in * experience_modifier) / 2

	var/datum/mind/owner_mind = owner.mind
	if(owner_mind && experience_sleep || (experience_sleep_threshold && (skill_level >= experience_sleep_threshold)))
		// Check to make sure that experience max is adhered to even when using sleep exp
		if(!owner_mind.sleep_adv.enough_sleep_xp_to_advance(associated_skill, experience_max_skill - skill_level))
			owner_mind.add_sleep_experience(associated_skill, exp_to_gain)
		return
	owner.adjust_experience(associated_skill, exp_to_gain)

/// Try to begin the casting process on mouse down
/datum/action/cooldown/spell/proc/start_casting(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		return
	if(LAZYACCESS(modifiers, CTRL_CLICKED))
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	if(LAZYACCESS(modifiers, ALT_CLICKED))
		return
	if(!isturf(owner.loc))
		return
	if(charge_started_at)
		return

	if(isnull(location) || istype(_target, /atom/movable/screen)) //Clicking on a screen object.
		if(_target.plane != CLICKCATCHER_PLANE)
			return

	// We don't actually care about the target or params now, we only care about the target on mouse up

	// Register here because the mouse up can get triggered before the mouse down otherwise
	RegisterSignal(source, COMSIG_CLIENT_MOUSEUP, PROC_REF(try_casting))
	RegisterSignal(owner, list(COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(signal_cancel))
	if(spell_requirements & SPELL_REQUIRES_NO_MOVE)
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(signal_cancel), TRUE)

	var/spell_timeout = 3 MINUTES

	// Cancel the next click with 3 minutes timeout
	source?.click_intercept_time = world.time + spell_timeout
	// This is a failsafe to cancel casting in extreme circimstances that aren't covered here
	// We need to call cancel_casting
	auto_cancel_timer = addtimer(CALLBACK(src, PROC_REF(cancel_casting)), spell_timeout, TIMER_STOPPABLE)
	source?.mouse_override_icon = 'icons/effects/mousemice/charge/spell_charging.dmi'
	owner.update_mouse_pointer()

	on_start_charge()
	charge_started_at = world.time
	charge_target_time = get_adjusted_charge_time()

/// Attempt to cast the spell after the mouse up
/datum/action/cooldown/spell/proc/try_casting(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER

	// Stop the failsafe timer
	if(auto_cancel_timer)
		deltimer(auto_cancel_timer)

	// This can happen
	if(!source || !charge_started_at || !can_cast_spell(TRUE))
		cancel_casting()
		return

	var/success = world.time >= (charge_started_at + charge_target_time)
	if(!on_end_charge(success)) // Give them another try if they mess up the timing
		RegisterSignal(source, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))
		return

	var/list/modifiers = params2list(params)

	// At this point we DO care about the _target value
	if(isnull(location) || istype(_target, /atom/movable/screen)) //Clicking on a screen object.
		_target = parse_caught_click_modifiers(modifiers, get_turf(source.eye), source)
		if(!_target)
			CRASH("Failed to get the turf under clickcatcher")

	// Call this directly to do all the relevant checks and aim assist
	InterceptClickOn(owner, modifiers, _target)
	source.click_intercept_time = 0

/datum/action/cooldown/spell/proc/signal_cancel()
	SIGNAL_HANDLER

	cancel_casting()
