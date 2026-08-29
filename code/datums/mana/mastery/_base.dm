/datum/spell_mastery
	/// The mana pool that owns us.
	var/datum/mana_pool/owner
	///optionally the atom that this is attached to
	var/atom/movable/parent
	/// assoc list of technique define (string) -> points invested (your mastery level in it)
	var/list/technique_levels = list()
	/// assoc list of form define (string) -> points invested (your mastery level in it)
	var/list/form_levels = list()

	/// Free/unspent level points, spendable ONLY to level up Form tracks
	var/unspent_form_points = 0
	/// Free/unspent level points, spendable ONLY to level up Technique tracks
	var/unspent_technique_points = 0

	///our initial form points
	var/initial_form_points = 0
	/// our initial technique points
	var/initial_technique_points = 0

	/// Dynamic pools: track define (string) -> spendable points left to buy actual spells
	var/list/spendable_form_points = list()
	var/list/spendable_technique_points = list()

	/// Lifetime totals, purely informational (character sheet / debug purposes).
	var/total_form_points_earned = 0
	var/total_technique_points_earned = 0

	/// The last level we synced points against - lets sync_points_to_level() be idempotent.
	var/last_synced_level = 0

	/// List of spell typepaths that have been unlocked/learned innately.
	var/list/unlocked_spells = list()
	/// assoc list of spell typepath -> the actual granted action instance, so we can
	/// cleanly remove it again if the spell is unlearned.
	var/list/granted_actions = list()

	/// assoc list of spellbook item -> (assoc list of spell typepath -> granted action instance).
	/// Only contains entries for books CURRENTLY held/granted.
	var/list/spellbook_granted_actions = list()
	/// assoc list of spellbook item -> (assoc list of spell typepath -> charges remaining today).
	/// Persists across equip/drop - a book keeps its charge count between holds.
	var/list/spellbook_charges = list()
	///who use to hold us
	var/atom/movable/holder

/datum/spell_mastery/New(datum/mana_pool/owner, atom/contained_source)
	src.owner = owner
	if(contained_source)
		register_parent(contained_source)

/datum/spell_mastery/Destroy(force)
	remove_spells()
	unregister_parent(parent)

	owner = null
	technique_levels = null
	form_levels = null
	unlocked_spells = null
	granted_actions = null
	spellbook_granted_actions = null
	spellbook_charges = null
	return ..()

/datum/spell_mastery/proc/adjust_technique_points(amount)
	initial_technique_points += amount
	unspent_technique_points += amount

/datum/spell_mastery/proc/adjust_form_points(amount)
	initial_form_points += amount
	unspent_form_points += amount

/datum/spell_mastery/proc/register_parent(atom/movable/new_parent)
	if(parent)
		unregister_parent(parent)
	parent = new_parent
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(remove_spells))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(add_spells))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_deletion))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(open_menu))
	RegisterSignal(parent, COMSIG_MASTERY_ADD_SPELLS, PROC_REF(add_spells))
	RegisterSignal(parent, COMSIG_MASTERY_REMOVE_SPELLS, PROC_REF(remove_spells))

/datum/spell_mastery/proc/unregister_parent(atom/movable/old_parent)
	parent = null
	UnregisterSignal(old_parent, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED, COMSIG_QDELETING,COMSIG_MASTERY_REMOVE_SPELLS, COMSIG_MASTERY_ADD_SPELLS))

/datum/spell_mastery/proc/open_menu(datum/source, mob/living/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(_open_menu), source, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/spell_mastery/proc/_open_menu(datum/source, mob/living/user)
	var/datum/spellbook/book = new(parent, src)
	book.ui_interact(user)

/**
 * Grants a spell directly, bypassing the normal spendable-point cost check.
 * Use this for innate/bonus spells (quest rewards, traits, etc.) rather than
 * mutating unlocked_spells/granted_actions directly.
 */
/datum/spell_mastery/proc/grant_bonus_spell(datum/action/cooldown/spell/spell, mob/living/user)
	if(!istype(spell) || !user)
		return FALSE

	var/spell_path = spell.type
	if(spell_path in unlocked_spells)
		return FALSE

	unlocked_spells += spell_path
	granted_actions[spell_path] = spell

	// Since this wasn't bought via try_learn_spell(), bump the lifetime totals
	// so recalculate_unspent_points() doesn't dock the player for a spell
	// they never paid points for.
	var/req_form = spell.required_form
	var/req_technique = spell.required_technique

	if(req_form)
		form_levels[req_form] = get_form_level(req_form) + 1
		initial_form_points += 1
	if(req_technique)
		technique_levels[req_technique] = get_technique_level(req_technique) + 1
		initial_technique_points += 1

	recalculate_unspent_points()
	return TRUE

/**
 * Instantiates the singleton spell action and grants it to the user.
 * Triggered when the parent item is equipped.
 */
/datum/spell_mastery/proc/add_spells(datum/source, mob/living/user)
	SIGNAL_HANDLER
	holder = user
	if(HAS_TRAIT(holder, TRAIT_SORCERER) || HAS_TRAIT(holder, TRAIT_BLOOD_SORCERER))
		return
	if(parent && (SEND_SIGNAL(parent, COMSIG_MASTERY_CHECK_PARENT) == COMPONENT_MASTERY_CANCEL))
		return
	var/atom/movable/AM = parent
	if(!AM || !istype(user))
		return

	// Avoid double-granting if already active
	if(spellbook_granted_actions[AM])
		return

	var/list/charges = spellbook_charges[AM]
	if(!charges)
		charges = list()
		spellbook_charges[AM] = charges

	var/list/actions = list()
	for(var/spell_path in unlocked_spells)
		if(isnull(charges[spell_path]))
			charges[spell_path] = initial(spell_path:initial_charges) || 0

		// Fetch our persistent singleton spell instance
		var/datum/action/cooldown/spell/existing_spell = granted_actions[spell_path]
		if(!existing_spell)
			existing_spell = new spell_path()
			RegisterSignal(existing_spell, COMSIG_SPELL_CAST, PROC_REF(pass_spell_cast))
			granted_actions[spell_path] = existing_spell

		existing_spell.mastery_source = src
		existing_spell.charge_item = AM
		existing_spell.uses_spellbook_charges = TRUE

		// Grant the persistent instance to the current user
		existing_spell.Grant(user)
		actions[spell_path] = existing_spell

	spellbook_granted_actions[AM] = actions

/**
 * Removes the active spell instance when the parent item is dropped or unequipped.
 * Note: We DO NOT destroy (qdel) the spell here anymore, ensuring cooldowns persist.
 */
/datum/spell_mastery/proc/remove_spells(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(!user)
		user = holder
	holder = null
	var/atom/movable/AM = parent
	var/list/actions = spellbook_granted_actions[AM]
	if(!actions)
		return

	for(var/spell_path in actions)
		var/datum/action/cooldown/spell/granted = actions[spell_path]
		if(granted && user)
			granted.Remove(user)

	spellbook_granted_actions -= AM

/datum/spell_mastery/proc/on_deletion()
	SIGNAL_HANDLER
	remove_spells()
	unregister_parent(parent)

/datum/spell_mastery/proc/get_technique_level(technique)
	if(!technique)
		return 0
	return technique_levels[technique] || 0

/datum/spell_mastery/proc/get_form_level(form)
	if(!form)
		return 0
	return form_levels[form] || 0

/datum/spell_mastery/proc/get_technique_rank_name(technique)
	return get_rank_name_for_level(get_technique_level(technique))

/datum/spell_mastery/proc/get_form_rank_name(form)
	return get_rank_name_for_level(get_form_level(form))

/datum/spell_mastery/proc/get_rank_name_for_level(level)
	var/best_name = "Untrained"
	var/best_threshold = -1
	for(var/threshold_text in GLOB.mastery_rank_names)
		var/threshold = text2num(threshold_text)
		if(level >= threshold && threshold > best_threshold)
			best_threshold = threshold
			best_name = GLOB.mastery_rank_names[threshold_text]
	return best_name

/**
 * Dynamically computes unspent pools by taking total lifetime points (initial_*)
 * and subtracting the points invested into tracks.
 * Additionally recalculates the spendable points for each track based on
 * track level minus currently known spells.
 */
/datum/spell_mastery/proc/recalculate_unspent_points()
	total_form_points_earned = initial_form_points
	total_technique_points_earned = initial_technique_points

	var/spent_on_forms = 0
	var/spent_on_techniques = 0

	spendable_form_points.Cut()
	spendable_technique_points.Cut()

	for(var/form in form_levels)
		var/lvl = form_levels[form]
		spent_on_forms += lvl
		spendable_form_points[form] = lvl

	for(var/technique in technique_levels)
		var/lvl = technique_levels[technique]
		spent_on_techniques += lvl
		spendable_technique_points[technique] = lvl

	for(var/spell_path in unlocked_spells)
		var/req_form = initial(spell_path:required_form)
		if(req_form)
			spendable_form_points[req_form] -= 1

		var/req_technique = initial(spell_path:required_technique)
		if(req_technique)
			spendable_technique_points[req_technique] -= 1

	unspent_form_points = max(0, total_form_points_earned - spent_on_forms)
	unspent_technique_points = max(0, total_technique_points_earned - spent_on_techniques)

/datum/spell_mastery/proc/invest_technique(technique, amount = 1)
	if(!technique || amount <= 0)
		return FALSE
	if(amount > unspent_technique_points)
		return FALSE

	unspent_technique_points -= amount
	technique_levels[technique] = get_technique_level(technique) + amount

	// Gain 1 point specifically for buying spells under this technique track
	spendable_technique_points[technique] = (spendable_technique_points[technique] || 0) + amount
	return TRUE

/datum/spell_mastery/proc/invest_form(form, amount = 1)
	if(!form || amount <= 0)
		return FALSE
	if(amount > unspent_form_points)
		return FALSE
	if(form == FORM_BLOOD)
		var/mob/living/carbon/user = get_mastery_user()

		if(user && !HAS_TRAIT(user, TRAIT_BLOOD_MAGE) && !HAS_TRAIT(user, TRAIT_BLOOD_SORCERER) && !user.mind?.has_antag_datum(/datum/antagonist/vampire))
			to_chat(user, span_bloody("I am not an adept enough blood mage and cannot wield this unholy power."))
			return FALSE
		if(!user && !get_form_level(FORM_BLOOD))//Blood books can get more blood points.
			return FALSE

	unspent_form_points -= amount
	form_levels[form] = get_form_level(form) + amount

	// Gain 1 point specifically for buying spells under this form track
	spendable_form_points[form] = (spendable_form_points[form] || 0) + amount
	return TRUE

/// Returns the {form points, technique points} cost of learning spell_path, as a 2-item list.
/datum/spell_mastery/proc/get_spell_cost(datum/action/cooldown/spell/spell_path)
	var/form_cost = initial(spell_path.required_form) ? 1 : 0
	var/technique_cost = initial(spell_path.required_technique) ? 1 : 0
	return list(form_cost, technique_cost)

/**
 * Checks whether spell_path is currently purchasable (NOT whether it's already known -
 * check unlocked_spells / can_unlearn_spell for that). Reads spell vars via initial()
 * so we never have to instance the spell just to inspect its requirements.
 */
/datum/spell_mastery/proc/can_learn_spell(datum/action/cooldown/spell/spell_path)
	if(!ispath(spell_path, /datum/action/cooldown/spell))
		return FALSE
	if(spell_path in unlocked_spells)
		return FALSE

	var/technique = initial(spell_path.required_technique)
	var/form = initial(spell_path.required_form)
	var/level_req = initial(spell_path.required_level)

	// Check if you have enough specific spell currency remaining for this element
	if(form && (spendable_form_points[form] || 0) < 1)
		return FALSE
	if(technique && (spendable_technique_points[technique] || 0) < 1)
		return FALSE

	// Rank check: Your mastery level in the track must meet the spell's required level
	if(level_req > 0)
		if(form && get_form_level(form) < level_req)
			return FALSE

	var/list/prereqs = initial(spell_path.prerequisite_spells)
	if(length(prereqs))
		for(var/prereq_path in prereqs)
			if(!(prereq_path in unlocked_spells))
				return FALSE

	return TRUE

/datum/spell_mastery/proc/try_learn_spell(datum/action/cooldown/spell/spell_path)
	if(!can_learn_spell(spell_path))
		return FALSE

	var/technique = initial(spell_path.required_technique)
	var/form = initial(spell_path.required_form)

	if(form)
		spendable_form_points[form] -= 1
	if(technique)
		spendable_technique_points[technique] -= 1

	unlocked_spells += spell_path

	if(!parent || spellbook_granted_actions[parent])
		var/atom/movable/AM = parent
		var/list/actions = parent ? spellbook_granted_actions[AM] : granted_actions
		var/list/charges = parent ? spellbook_charges[AM] : null

		if(charges && isnull(charges[spell_path]))
			charges[spell_path] = initial(spell_path.initial_charges) || 0

		var/datum/action/cooldown/spell/new_spell = new spell_path()
		RegisterSignal(new_spell, COMSIG_SPELL_CAST, PROC_REF(pass_spell_cast))
		if(owner)
			new_spell.Grant(owner.parent)
		if(parent)
			new_spell.mastery_source = src
			new_spell.charge_item = parent
			new_spell.uses_spellbook_charges = TRUE
		actions[spell_path] = new_spell

		if(holder)
			var/atom/cached_holder = holder
			if(parent && (SEND_SIGNAL(parent, COMSIG_MASTERY_CHECK_PARENT) == COMPONENT_MASTERY_CANCEL))
				remove_spells(src, cached_holder)
				return
			remove_spells(src, cached_holder)
			add_spells(src, cached_holder)
	return TRUE

/datum/spell_mastery/proc/try_unlearn_spell(datum/action/cooldown/spell/spell_path)
	if(!can_unlearn_spell(spell_path))
		return FALSE

	var/technique = initial(spell_path.required_technique)
	var/form = initial(spell_path.required_form)

	if(form)
		spendable_form_points[form] += 1
	if(technique)
		spendable_technique_points[technique] += 1

	unlocked_spells -= spell_path

	var/atom/movable/AM = parent
	var/list/actions = AM ? spellbook_granted_actions[AM] : granted_actions

	if(actions && actions[spell_path])
		var/datum/action/cooldown/spell/granted = actions[spell_path]
		if(granted)
			UnregisterSignal(granted, COMSIG_SPELL_CAST)
			granted.Remove(owner?.parent)
			qdel(granted)
		actions -= spell_path

	if(AM && spellbook_charges[AM])
		var/list/charges = spellbook_charges[AM]
		charges -= spell_path

	if(holder)
		var/atom/cached_holder = holder
		if(parent && (SEND_SIGNAL(parent, COMSIG_MASTERY_CHECK_PARENT) == COMPONENT_MASTERY_CANCEL))
			remove_spells(src, cached_holder)
			return
		remove_spells(src, cached_holder)
		add_spells(src, cached_holder)

	return TRUE

/// Whether spell_path is currently known and can be unlearned/refunded.
/datum/spell_mastery/proc/can_unlearn_spell(spell_path)
	return (spell_path in unlocked_spells)

/// Checks remaining charges for a spell on the currently attached item.
/datum/spell_mastery/proc/has_spellbook_charges(spell_path)
	var/list/charges = spellbook_charges[parent]
	if(!charges)
		return TRUE
	return (charges[spell_path] || 0) > 0

/// Consumes a charge from the attached item's tracking list.
/datum/spell_mastery/proc/consume_spellbook_charge(spell_path)
	var/list/charges = spellbook_charges[parent]
	if(!charges)
		return TRUE
	if((charges[spell_path] || 0) <= 0)
		return FALSE
	charges[spell_path]--
	return TRUE

/// Resets an item's charge list back to the spell's initial baseline.
/datum/spell_mastery/proc/reset_spellbook_charges(atom/movable/target_item)
	var/atom/movable/AM = target_item || parent
	if(!AM)
		return

	var/list/charges = spellbook_charges[AM]
	if(!charges)
		return

	for(var/spell_path in unlocked_spells)
		charges[spell_path] = initial(spell_path:initial_charges) || 0

	var/list/actions = spellbook_granted_actions[AM]
	if(actions)
		for(var/spell_path in actions)
			var/datum/action/cooldown/spell/granted = actions[spell_path]
			granted?.build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/spell_mastery/proc/reset_all_spellbook_charges()
	for(var/atom/movable/AM in spellbook_charges)
		reset_spellbook_charges(AM)

/datum/spell_mastery/proc/sync_points_to_level(new_level)
	last_synced_level = new_level
	recalculate_unspent_points()

/**
 * adjusts the amount of available form mastery points
 *
 * Args
 * * points - amount of points to grant or reduce
 * * used_points - adjust used/spendable points instead of the lifetime pool
 * * specific_form - if provided, adjusts this form's level directly instead
 *   of the general unspent form pool
*/
/datum/spell_mastery/proc/adjust_form_mastery_points(points, used_points = FALSE, specific_form = null)
	if(QDELETED(src))
		return

	if(specific_form)
		if(used_points)
			// consume from that form's spendable (spell-buying) pool specifically
			spendable_form_points[specific_form] = max(0, (spendable_form_points[specific_form] || 0) - points)
		else
			// actually rank up (or down) that specific form
			form_levels[specific_form] = max(0, get_form_level(specific_form) + points)
			initial_form_points += points
	else
		if(used_points)
			unspent_form_points = max(0, unspent_form_points - points)
		else
			adjust_form_points(points)

	recalculate_unspent_points()

/**
 * adjusts the amount of available technique mastery points
 *
 * Args
 * * points - amount of points to grant or reduce
 * * used_points - adjust used/spendable points instead of the lifetime pool
 * * specific_technique - if provided, adjusts this technique's level directly
 *   instead of the general unspent technique pool
*/
/datum/spell_mastery/proc/adjust_technique_mastery_points(points, used_points = FALSE, specific_technique = null)
	if(QDELETED(src))
		return

	if(specific_technique)
		if(used_points)
			spendable_technique_points[specific_technique] = max(0, (spendable_technique_points[specific_technique] || 0) - points)
		else
			technique_levels[specific_technique] = max(0, get_technique_level(specific_technique) + points)
			initial_technique_points += points
	else
		if(used_points)
			unspent_technique_points = max(0, unspent_technique_points - points)
		else
			adjust_technique_points(points)

	recalculate_unspent_points()

/// Reset form mastery points and used form points
/datum/spell_mastery/proc/reset_form_mastery_points(silent = TRUE)
	if(QDELETED(src))
		return

	initial_form_points = 0
	unspent_form_points = 0

	if(!silent && holder)
		to_chat(holder, span_boldwarning("I lost all my form mastery points!"))

	recalculate_unspent_points()

/// Reset technique mastery points and used technique points
/datum/spell_mastery/proc/reset_technique_mastery_points(silent = TRUE)
	if(QDELETED(src))
		return

	initial_technique_points = 0
	unspent_technique_points = 0

	if(!silent && holder)
		to_chat(holder, span_boldwarning("I lost all my technique mastery points!"))

	recalculate_unspent_points()

/datum/spell_mastery/proc/pass_spell_cast(datum/action/cooldown/spell/spell, atom/cast_on)
	SIGNAL_HANDLER
	if(!parent)
		return
	SEND_SIGNAL(parent, COMSIG_MASTERY_CAST, spell.owner)

/datum/spell_mastery/proc/get_mastery_user()
	if(owner)
		if(ismob(owner.parent))
			return owner.parent
	if(iscarbon(parent))
		return parent
	return
