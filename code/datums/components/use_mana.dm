/* Design notes:
* This component designates the parent object as something that "uses mana".
* As such, it should modify the object's behavior at some point to require, consume, or check mana.
* Example: A magic crowbar that requires 5 mana to use it with anything.
* A component created for this crowbar should register the various signals for checking things, such as COMSIG_TOOL_START_USE, or
* COMSIG_ITEM_ATTACK. These should be linked to a proc that checks if the user has enough available mana (not sure how to make this info available with the current setuo)
* and if not, return something that cancels the proc.
* However, if the mana IS sufficient, we should listen for the successful item act signal, and react by, say, subtracting 5 mana from the mana pool provided.
* Not all need to do this, though, some could simply check and no nothing else, or others.
*/

/// Designates the item it's added to as something that "uses mana".
/datum/component/uses_mana
	var/datum/callback/get_mana_callback
	var/datum/callback/activate_check_failure_callback
	var/datum/callback/get_user_callback
	var/datum/callback/get_mana_required_callback

	var/list/datum/attunement/attunements

	var/pre_use_check_with_feedback_comsig
	var/pre_use_check_comsig
	var/post_use_comsig

	var/mana_required

/datum/component/uses_mana/Initialize(
	datum/callback/activate_check_failure_callback,
	datum/callback/get_user_callback,
	pre_use_check_with_feedback_comsig,
	pre_use_check_comsig,
	post_use_comsig,
	datum/callback/mana_required,
	list/datum/attunement/attunements,
)
	. = ..()

	if (isnull(pre_use_check_with_feedback_comsig))
		stack_trace("pre_use with feed back null")
		return COMPONENT_INCOMPATIBLE
	if (isnull(post_use_comsig))
		stack_trace("post_use comsig null")
		return COMPONENT_INCOMPATIBLE

	src.activate_check_failure_callback = activate_check_failure_callback
	src.get_user_callback = get_user_callback

	if (istype(mana_required))
		src.get_mana_required_callback = mana_required
	else if (isnum(mana_required))
		src.mana_required = mana_required

	src.attunements = attunements
	src.pre_use_check_with_feedback_comsig = pre_use_check_with_feedback_comsig
	src.post_use_comsig = post_use_comsig


/datum/component/uses_mana/RegisterWithParent()
	. = ..()

	RegisterSignal(parent, pre_use_check_with_feedback_comsig, PROC_REF(can_activate_with_feedback))
	RegisterSignal(parent, post_use_comsig, PROC_REF(react_to_successful_use))

/datum/component/uses_mana/UnregisterFromParent()
	. = ..()

	UnregisterSignal(parent, pre_use_check_with_feedback_comsig)
	UnregisterSignal(parent, post_use_comsig)

// TODO: Do I need the vararg?
/// Should return the numerical value of mana needed to use whatever it is we're using. Unaffected by attunements.
/datum/component/uses_mana/proc/get_mana_required(atom/caster, ...) // Get the mana required to cast the spell.
	if (!isnull(get_mana_required_callback))
		return get_mana_required_callback?.Invoke(arglist(args))

	var/required = 0

	if (!isnull(mana_required))
		required = mana_required
	else
		return stack_trace("Both the Callback and value for mana required is null!")
	return required

/datum/component/uses_mana/proc/get_mana_to_use()
	var/atom/movable/caster = get_parent_user()
	var/list/datum/mana_pool/usable_pools = list()

	for (var/atom/movable/thing as anything in caster.get_all_contents())
		if (!isnull(thing.mana_pool) && HAS_TRAIT(thing, TRAIT_POOL_AVAILABLE_FOR_CAST))
			usable_pools += thing.mana_pool

	if (!isnull(caster.mana_pool)) //we want this last so foci run first
		usable_pools += caster.mana_pool


	return usable_pools


/// Should return TRUE if the total adjusted mana of all mana pools surpasses get_mana_required(). FALSE otherwise.
/datum/component/uses_mana/proc/is_mana_sufficient(atom/movable/user, ...)
	for(var/obj/effect/temp_visual/silence_zone/zone in range(3, user))
		return FALSE

	var/total_effective_mana = 0
	var/list/datum/mana_pool/provided_mana = get_mana_to_use()
	var/required_mana = get_mana_required(arglist(args))
	var/atom/caster = user


	for (var/datum/mana_pool/iterated_pool as anything in provided_mana)
		total_effective_mana += iterated_pool.get_attuned_amount(attunements, caster)
	if (total_effective_mana > required_mana)
		return TRUE
	else
		return FALSE

/// The primary proc we will use for draining mana to simulate it being consumed to power our actions.
/datum/component/uses_mana/proc/drain_mana(...)

	var/mob/user = get_user_callback?.Invoke()

	var/mana_consumed = -get_mana_required(arglist(args))
	var/total_mana_consumed = -mana_consumed
	if (isnull(mana_consumed))
		stack_trace("mana_consumed after get_mana_required is null!")
		return

	var/list/datum/mana_pool/available_pools = get_mana_to_use()
	var/mob/living/caster = get_parent_user()
	var/attunement_total_value = 0
	var/total_damage = 0
	for(var/datum/attunement/attunement as anything in attunements)
		attunement_total_value += attunements[attunement]

	while (mana_consumed <= -0.05)
		var/mult
		var/attuned_cost
		for (var/datum/mana_pool/pool as anything in available_pools)
			mult = pool.get_overall_attunement_mults(attunements, user)
			attuned_cost = (mana_consumed * mult)
			if (pool.amount < attuned_cost)
				attuned_cost = (pool.amount)
			var/mana_adjusted = SAFE_DIVIDE(pool.adjust_mana((attuned_cost)), mult) * (has_world_trait(/datum/world_trait/noc_wisdom) ? (is_ascendant(NOC) ? 0.7 : 0.8) : 1)
			mana_consumed -= mana_adjusted
			record_featured_stat(FEATURED_STATS_MAGES, user, abs(mana_adjusted))
			record_round_statistic(STATS_MANA_SPENT, abs(mana_adjusted))
			if (available_pools.Find(pool) == available_pools.len && mana_consumed <= -0.05) // if we're at the end of the list and mana_consumed is not 0 or near 0 (floating points grrr)
				mana_consumed = 0 // lets terminate the loop to be safe
			if(pool.parent == caster)
				for(var/datum/attunement/attunement as anything in attunements)
					if(pool.negative_attunements[attunement] < 0)
						var/composition_gain = attunement_total_value / attunements[attunement]
						var/negative_impact_mana = total_mana_consumed * composition_gain
						total_damage += round(negative_impact_mana * 0.1,1)
	if(total_damage)
		caster.mana_pool.mana_backlash(total_damage)



/// Should be the raw conditional we use for determining if the thing that "uses mana" can actually
/// activate the behavior that "uses mana".
/datum/component/uses_mana/proc/can_activate(...)
	return is_mana_sufficient(arglist(list(get_parent_user()) + args))

/// Wrapper for can_activate(). Should return a bitflag that will be passed down to the signal sender on failure.
/datum/component/uses_mana/proc/can_activate_with_feedback(...)
	var/can_activate
	var/list/argss = args.Copy(1)
	can_activate = can_activate(arglist(argss)) //doesnt return this + can_activate_check_... because returning TRUE/FALSE can gave bitflag implications

	if (!can_activate)
		return can_activate_check_failure(arglist(args.Copy()))
	return NONE

/// What can_activate_check returns apon failing to activate.
/datum/component/uses_mana/proc/can_activate_check_failure(...)
	return !activate_check_failure_callback?.Invoke(arglist(args))

/// Should react to a post-use signal given by the parent, and ideally subtract mana, or something.
/datum/component/uses_mana/proc/react_to_successful_use(...)

	drain_mana(arglist(list(get_parent_user()) + args))

	return

/datum/component/uses_mana/proc/get_parent_user()
	return get_user_callback?.Invoke()

// this is basically only used to cut down on boilerplate.
// all that remains is stuff that has to be on the spell itself to work (checking for mana cost, attunements, some of the callbacks)
// i'll provide a sample block so this file can be a "tutorial" IG
/datum/component/uses_mana/spell
	can_transfer = FALSE

/datum/component/uses_mana/spell/Initialize(
	datum/callback/activate_check_failure_callback,
	datum/callback/get_user_callback,
	pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST,
	pre_use_check_comsig,
	post_use_comsig = COMSIG_SPELL_AFTER_CAST,
	datum/callback/mana_required,
	list/datum/attunement/attunements
	)

	. = ..()

/* sample tutorial block. plus explanations.

/datum/action/cooldown/spell/ourspell/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_X] += SPELL_X_ATTUNEMENT // define the numeric value you want for the attunement ideally at the top, it is the value you want the spell's cost to be multiplied (done using decimals since its supposed to be a discount) by when the user is correctly attunned..
		replace the "X" with what element you want, such as "light". Replace "SPELL" with the name of your spell.

	AddComponent(/datum/component/uses_mana/spell, \ // the two main signals are pre-defined in uses_mana/spell so you don't have to copy paste it. everything here needs to be in the init since its on the spell itself.
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \ // this is defined on datum/action/cooldown/spell and just sends the signal used to cancel casting. must be in this define.
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \ // "get_owner" is a proc on datum/action/ and must be defined in "the block"
		mana_required = mana_cost, \ // mana_cost is defined on the spell datum action, set it to a variable at the top ideally. if you want fancier stuff, see the next line:
		mana_required = CALLBACK(src, PROC_REF(get_mana_consumed)), \ // obviously only ever set mana required ONCE, but this is an example of what you want to do if you want to do a variable cost system, define the proc for this on the spell itself.
		attunements = attunements, \ // see above. you can just copy paste this to every instance, if you don't want attunements just don't add this block or the two lines outside the add component
	)

	heres a sample callback for get mana required, taken from healing touch.

	/datum/action/cooldown/spell/touch/healing_touch/proc/get_mana_consumed(atom/caster, atom/cast_on, ...)
	return (brute_heal + burn_heal + tox_heal + oxy_heal + pain_heal * 3) \ // instead this will calculate your cost based on how much it heals. whenever it wants to check the mana cost value, it'll defer to this proc.
		* mana_cost
*/
// this should be the only thing left lmfao, the rest is going to be held till the end
/**
 * Actions done before the actual cast is called.
 * This is the last chance to cancel the spell from being cast.
 *
 * Can be used for target selection or to validate checks on the caster (cast_on).
 *
 * Returns a bitflag.
 * - SPELL_CANCEL_CAST will stop the spell from being cast.
 * - SPELL_NO_FEEDBACK will prevent the spell from calling [proc/spell_feedback] on cast. (invocation), sounds)
 * - SPELL_NO_IMMEDIATE_COOLDOWN will prevent the spell from starting its cooldown between cast and before after_cast.
 */
/* /datum/component/uses_mana/spell/RegisterWithParent()
	. = ..()

	RegisterSignal(parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(parent, COMSIG_SPELL_CAST, PROC_REF(handle_cast))
	RegisterSignal(parent, COMSIG_SPELL_AFTER_CAST, PROC_REF(react_to_successful_use)) */

/* /datum/component/uses_mana/spell/UnregisterFromParent()
	. = ..()

	UnregisterSignal(parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_CAST)
	UnrecooldowngisterSignal(parent, COMSIG_SPELL_AFTER_CAST) */

/* /datum/component/uses_mana/spell/give_unable_to_activate_feedback(atom/cast_on)
	. = ..()
	var/datum/action/cooldown/spell/spell_parent = parent

	spell_parent.owner.balloon_alert(spell_parent.owner, "insufficient mana!") */ // should be redundant, holding onto till pr completion

// SIGNAL HANDLERS


/* /datum/component/uses_mana/spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER
	return can_activate_with_feedback() */ // todo get this up to date
	//can_activate_with_feedback(TRUE, parent_spell.owner, cast_on)
	//var/datum/action/cooldown/spell/parent_spell = parent



/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/* /datum/component/uses_mana/spell/proc/handle_cast(atom/cast_on)
	SIGNAL_HANDLER
	return

/datum/component/uses_mana/spell/proc/get_mana_required_spell(atom/caster, atom/cast_on, ...)
	if(ismob(caster))
		var/mob/caster_mob = caster
		return caster_mob.get_casting_cost_mult()
	return 1 */
