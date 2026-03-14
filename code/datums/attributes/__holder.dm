/datum/attribute_holder
	/// Mob we are attached to
	var/mob/parent
	/// Default value for non-skill attributes
	var/attribute_default = ATTRIBUTE_DEFAULT
	/// Minimum value for non-skill attributes
	var/attribute_min = ATTRIBUTE_MIN
	/// Maximum value for non-skill attributes
	var/attribute_max = ATTRIBUTE_MAX
	/// Default value for non-specified skills
	var/skill_default = SKILL_DEFAULT
	/// Minimum value for skill attributes
	var/skill_min = SKILL_MIN
	/// Maximum value for skill attributes
	var/skill_max = SKILL_MAX
	/// Attribute list, counting modifiers
	var/list/attribute_list = list()
	/// Associative list, attribute path = value
	var/list/raw_attribute_list = list()
	/// List of attribute modifiers applying to this holder
	var/list/attribute_modification //Lazy list, see attribute_modifier.dm
	/// Attribute modifier immunities
	var/list/attribute_mod_immunities //Lazy list, see attribute_modifier.dm
	/// Diceroll modifier to be added on top of dicerolls
	var/cached_diceroll_modifier = 0
	/// List of diceroll modifiers applying to this holder
	var/list/diceroll_modification //Lazy list, see attribute_modifier.dm
	/// Diceroll modifier immunities
	var/list/diceroll_mod_immunities //Lazy list, see attribute_modifier.dm

/datum/attribute_holder/New(mob/new_parent)
	. = ..()
	for(var/attribute_type in GLOB.all_attributes)
		//attribute equaling null and nonexistent attribute do not mean the same
		if(!(attribute_type in raw_attribute_list))
			if(ispath(attribute_type, SKILL))
				raw_attribute_list[attribute_type] = skill_default
			else
				raw_attribute_list[attribute_type] = attribute_default
		else
			if(ispath(attribute_type, SKILL))
				//clamp converts nulls into zeroes, yet null is treated differently from 0
				if(isnull(raw_attribute_list[attribute_type]) && (skill_min <= 0))
					continue
				raw_attribute_list[attribute_type] = clamp(raw_attribute_list[attribute_type], skill_min, skill_max)
			else
				//clamp converts nulls into zeroes, yet null is treated differently from 0
				if(isnull(raw_attribute_list[attribute_type]) && (attribute_min <= 0))
					continue
				raw_attribute_list[attribute_type] = clamp(raw_attribute_list[attribute_type], attribute_min, attribute_max)
	if(new_parent)
		set_parent(new_parent)

/datum/attribute_holder/Destroy()
	. = ..()
	set_parent(null)
	attribute_list?.Cut()
	raw_attribute_list?.Cut()
	attribute_mod_immunities?.Cut()
	for(var/thing in attribute_modification)
		remove_attribute_modifier(thing, FALSE) //they lazyremove themselves
	closely_inspected_attribute = null

/**
 * Returns the raw value of a skill, taking into account the raw value of the governing attribute and defaulting
 */
/datum/attribute_holder/proc/return_raw_effective_skill(skill_type)
	var/skill_value = raw_attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(istype(skill))
		// we add the value of the primary attribute but only when we have at least attribute+0 skill
		if(skill.governing_attribute && !isnull(skill_value) && (skill_value >= 0))
			var/governing_value = return_raw_calculated_skill(skill.governing_attribute)
			var/governing_multiplier = (governing_value >= 0) ? SKILL_GOVERNING_MULTIPLIER_POSITIVE : SKILL_GOVERNING_MULTIPLIER_NEGATIVE
			var/governing_attribute_value = floor(governing_value * governing_multiplier)
			skill_value += governing_attribute_value
		if(LAZYLEN(skill.default_attributes))
			for(var/attribute_type in skill.default_attributes)
				var/default_value = return_raw_calculated_skill(attribute_type)
				default_value += skill.default_attributes[attribute_type]
				// Rule of 20, maximum for a default is 20
				default_value = min(default_value, ATTRIBUTE_MASTER)
				// Only use this default if it's higher than our previous skill value
				skill_value = max(default_value, skill_value)
	return skill_value

/**
 * Returns the effective value of a skill, taking into account the raw value of the governing attribute and defaulting
 */
/datum/attribute_holder/proc/return_effective_skill(skill_type)
	var/skill_value = attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(istype(skill))
		// we add the value of the primary attribute but only when we have the skill (skill is not null)
		if(skill.governing_attribute && !isnull(skill_value) && (skill_value > 0))
			var/governing_raw = return_raw_calculated_skill(skill.governing_attribute)
			var/governing_effective = return_calculated_skill(skill.governing_attribute)
			var/governing_delta = governing_effective - governing_raw
			if(governing_delta < 0)
				// debuffs on the governing attribute hurt more than buffs help
				skill_value += floor((governing_raw * SKILL_GOVERNING_MULTIPLIER_POSITIVE) + (governing_delta * SKILL_GOVERNING_MULTIPLIER_NEGATIVE))
			else
				skill_value += floor(governing_effective * SKILL_GOVERNING_MULTIPLIER_POSITIVE)
		if(LAZYLEN(skill.default_attributes))
			for(var/attribute_type in skill.default_attributes)
				var/default_value = return_calculated_skill(attribute_type)
				default_value += skill.default_attributes[attribute_type]
				// Rule of 20, maximum for a default is 20
				default_value = min(default_value, ATTRIBUTE_MASTER)
				// Only use this default if it's higher than our previous skill value
				skill_value = max(default_value, skill_value)
	return skill_value

/**
 * Returns the raw value of a skill, only taking the governing attribute into account
 */
/datum/attribute_holder/proc/return_raw_calculated_skill(skill_type)
	var/skill_value = raw_attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(istype(skill) && !isnull(skill_value) && skill.governing_attribute)
		// we add the value of the primary attribute but only when we have the skill (skill is not null)
		var/governing_value = return_raw_calculated_skill(skill.governing_attribute)
		var/governing_multiplier = (governing_value >= 0) ? SKILL_GOVERNING_MULTIPLIER_POSITIVE : SKILL_GOVERNING_MULTIPLIER_NEGATIVE
		skill_value += floor(governing_value * governing_multiplier)
	return skill_value

/**
 * Returns the effective value of a skill, only taking the governing attribute into account
 */
/datum/attribute_holder/proc/return_calculated_skill(skill_type)
	var/skill_value = attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	if(istype(skill) && !isnull(skill_value) && skill.governing_attribute)
		// equal or worse than default associated with governing attribute = we don't know this at all
		skill_value = max(skill.default_attributes[skill.governing_attribute], skill_value)
		if(skill.default_attributes[skill.governing_attribute] \
			&& (skill_value <= skill.default_attributes[skill.governing_attribute] * SKILL_GOVERNING_MULTIPLIER_POSITIVE))
			return
		// we add the value of the primary attribute but only when we have the skill (skill is not null)
		var/governing_raw = return_raw_calculated_skill(skill.governing_attribute)
		var/governing_effective = return_calculated_skill(skill.governing_attribute)
		var/governing_delta = governing_effective - governing_raw
		if(governing_delta < 0)
			// debuffs on the governing attribute hurt more than buffs help
			skill_value += floor((governing_raw * SKILL_GOVERNING_MULTIPLIER_POSITIVE) + (governing_delta * SKILL_GOVERNING_MULTIPLIER_NEGATIVE))
		else
			skill_value += floor(governing_effective * SKILL_GOVERNING_MULTIPLIER_POSITIVE)
	return skill_value

/**
 * Sets a mob as our owner
 */
/datum/attribute_holder/proc/set_parent(mob/new_parent)
	if(new_parent)
		parent = new_parent
		new_parent.attributes = src
	else
		parent.attributes = null
		parent = null
	update_attributes()
	RegisterSignal(parent, COMSIG_SHARE_APPRENTICE_XP, PROC_REF(onshare_apprentice_xp))

/**
 * Seeds the XP pool to match the current raw skill level.
 * Call this any time raw_attribute_list is written to directly
 * without going through adjust_experience/set_skill_level.
 *
 * Arguments:
 *   skill_type - typepath of the skill to seed, or null to seed all skills
 */
/datum/attribute_holder/proc/seed_skill_xp(skill_type = null)
	if(skill_type)
		if(!ispath(skill_type, SKILL))
			return
		_seed_single_skill_xp(skill_type)
	else
		for(var/stype in raw_attribute_list)
			if(!ispath(stype, SKILL))
				continue
			_seed_single_skill_xp(stype)

/datum/attribute_holder/proc/_seed_single_skill_xp(skill_type)
	var/current_level = nulltozero(raw_attribute_list[skill_type])
	var/current_xp = get_skill_xp(skill_type)
	var/xp_implied_level = level_for_xp(current_xp)

	if(xp_implied_level == current_level)
		return // already in sync, nothing to do

	// Calculate XP progress within the old level and carry it into the new level
	var/old_level_floor_xp = xp_for_level(xp_implied_level)
	var/old_level_ceiling_xp = xp_for_level(xp_implied_level + 1)
	var/progress = (current_xp - old_level_floor_xp) / max(1, old_level_ceiling_xp - old_level_floor_xp)

	var/new_floor_xp = xp_for_level(current_level)
	var/new_ceiling_xp = xp_for_level(current_level + 1)
	LAZYSET(skill_xp, skill_type, new_floor_xp + progress * (new_ceiling_xp - new_floor_xp))

/**
 * Adds up attributes from a sheet
 */
/datum/attribute_holder/proc/add_sheet(datum/attribute_holder/sheet/to_add)
	if(ispath(to_add, /datum/attribute_holder/sheet))
		if(GLOB.attribute_sheets[to_add])
			to_add = GLOB.attribute_sheets[to_add]
		else
			to_add = GLOB.attribute_sheets[to_add] = new to_add()
	else if(!istype(to_add))
		return
	add_holder(to_add)

/**
 * Adds up another holder's attributes
 */
/datum/attribute_holder/proc/add_holder(datum/attribute_holder/to_add)
	for(var/thing in to_add.raw_attribute_list)
		//null does not mean the same as 0!
		if(isnull(to_add.raw_attribute_list[thing]))
			continue
		if(ispath(thing, SKILL))
			raw_attribute_list[thing] = clamp(raw_attribute_list[thing] + to_add.raw_attribute_list[thing], skill_min, skill_max)
		else
			raw_attribute_list[thing] = clamp(raw_attribute_list[thing] + to_add.raw_attribute_list[thing], attribute_min, attribute_max)
	if(LAZYLEN(to_add.skill_xp_multipliers))
		for(var/skill_type in to_add.skill_xp_multipliers)
			adjust_skill_xp_multiplier(skill_type, to_add.skill_xp_multipliers[skill_type] - 1.0)
	to_add.on_add(src)
	update_attributes()
	seed_skill_xp()

/**
 * Stuff we do when another holder adds us
 */
/datum/attribute_holder/proc/on_add(datum/attribute_holder/plagiarist)
	return

/**
 * Adds up attributes from a sheet
 */
/datum/attribute_holder/proc/subtract_sheet(datum/attribute_holder/sheet/to_remove)
	if(ispath(to_remove, /datum/attribute_holder/sheet))
		if(GLOB.attribute_sheets[to_remove])
			to_remove = GLOB.attribute_sheets[to_remove]
		else
			to_remove = GLOB.attribute_sheets[to_remove] = new to_remove()
	else if(!istype(to_remove))
		return
	subtract_holder(to_remove)

/**
 * Subtracts another holder's attributes
 */
/datum/attribute_holder/proc/subtract_holder(datum/attribute_holder/to_remove)
	for(var/thing in to_remove.raw_attribute_list)
		//null does not mean the same as 0!
		if(isnull(to_remove.raw_attribute_list[thing]))
			continue
		if(ispath(thing, SKILL))
			raw_attribute_list[thing] = clamp(raw_attribute_list[thing] - to_remove.raw_attribute_list[thing], skill_min, skill_max)
		else
			raw_attribute_list[thing] = clamp(raw_attribute_list[thing] - to_remove.raw_attribute_list[thing], attribute_min, attribute_max)
	if(LAZYLEN(to_remove.skill_xp_multipliers))
		for(var/skill_type in to_remove.skill_xp_multipliers)
			adjust_skill_xp_multiplier(skill_type, -(to_remove.skill_xp_multipliers[skill_type] - 1.0))
	to_remove.on_remove(src)
	update_attributes()
	seed_skill_xp()

/**
 * Stuff we do when another holder removes us
 */
/datum/attribute_holder/proc/on_remove(datum/attribute_holder/plagiarist)
	return

/**
 * Copies attributes from a sheet
 */
/datum/attribute_holder/proc/copy_sheet(datum/attribute_holder/sheet/to_copy)
	if(ispath(to_copy, /datum/attribute_holder/sheet))
		if(GLOB.attribute_sheets[to_copy])
			to_copy = GLOB.attribute_sheets[to_copy]
		else
			to_copy = GLOB.attribute_sheets[to_copy] = new to_copy()
	else if(!istype(to_copy))
		return
	copy_holder(to_copy)

/**
 * Copies another holder's raw attributes & xp multipliers
 */
/datum/attribute_holder/proc/copy_holder(datum/attribute_holder/to_copy)
	raw_attribute_list = to_copy.raw_attribute_list.Copy()
	skill_xp_multipliers = LAZYLEN(to_copy.skill_xp_multipliers) ? to_copy.skill_xp_multipliers.Copy() : null
	to_copy.on_copy(src)
	update_attributes()
	seed_skill_xp()

/**
 * Stuff we do when another holder copies us
 */
/datum/attribute_holder/proc/on_copy(datum/attribute_holder/plagiarist)
	return

/**
 * Returns a probability value from an attribute, to be used in prob()
 * You should use the diceroll proc instead, but yeah this works too.
 */
/datum/attribute_holder/proc/attribute_probability(modifier = ATTRIBUTE_MIDDLING, base_prob = 50, delta_value = ATTRIBUTE_MIDDLING, increment = 5)
	return (base_prob + (modifier - delta_value) * increment)

/**
 * DICE ROLL
 * Add this to the action and specify what will happen in each outcome.
 * Modifier should be the get_value() of an attribute.
 *
 * Important! you should not use more than one stat in proc but if you really want to,
 * you should multiply amount of dices and crit according to how many of them you added to the formula.
 *
 * If you don't care about crits, just count them as being the same as normal successes/failures.
 */
/datum/attribute_holder/proc/diceroll(requirement = 0, \
									crit = 10, \
									dice_num = 3, \
									dice_sides = 6, \
									count_modifiers = TRUE, \
									context = DICE_CONTEXT_DEFAULT, \
									return_flags = RETURN_DICE_SUCCESS)
	//Get our dice result
	var/dice = roll(dice_num, dice_sides)

	//Get the necessary number to pass the roll
	var/requirement_sum = requirement
	if(count_modifiers)
		//diceroll modifiers assume you use 1d18, so we gotta account for that
		var/final_modifier = (get_diceroll_modifier()/18)*dice_num*dice_sides
		if(final_modifier >= 0)
			final_modifier = CEILING(final_modifier, 1)
		else
			final_modifier = FLOOR(final_modifier, 1)
		requirement_sum += final_modifier

	//Get the difference, might be necessary
	var/difference = (dice - requirement_sum)

	//Return whether it was a failure or a success
	var/success_result
	if(dice <= requirement_sum)
		var/bonus = 0
		//god forgive me for writing this
		if((dice_num == 3) && (dice_sides == 6))
			bonus = 1
			if(requirement_sum >= 15)
				bonus = 2
			if(requirement_sum >= 16)
				bonus = 3
		if(dice <= max(dice_num+bonus, requirement_sum - crit))
			success_result = DICE_CRIT_SUCCESS
		else
			success_result = DICE_SUCCESS
	else
		var/malus = 0
		//god forgive me for writing this, especially
		if((dice_num == 3) && (dice_sides == 6) && (requirement_sum <= 15))
			malus = 1
		if(dice >= min((dice_num*dice_sides)-malus, requirement_sum + crit))
			success_result = DICE_CRIT_FAILURE
		else
			success_result = DICE_FAILURE
	if(CHECK_MULTIPLE_BITFIELDS(return_flags, RETURN_DICE_SUCCESS|RETURN_DICE_DIFFERENCE))
		return list(RETURN_DICE_INDEX_SUCCESS = success_result, \
					RETURN_DICE_INDEX_DIFFERENCE = difference)
	else if(return_flags & RETURN_DICE_DIFFERENCE)
		return difference
	return success_result

/datum/attribute_holder/proc/print_skills(mob/user, show_all = FALSE)
	var/list/output = list()
	output += "<span class='infoplain'><div class='infobox'>"
	var/list/skills_by_category = list()
	for(var/thing in attribute_list)
		if(ispath(thing,  SKILL))
			var/datum/attribute/skill/skill = GLOB.all_skills[thing]
			//Only gather the skills we actually have, unless we want to be shown regardless (null means we don't have it, 0 means we do)
			var/calculated_skill = return_calculated_skill(skill.type)
			if(show_all || !isnull(calculated_skill))
				if(skills_by_category[skill.category])
					skills_by_category[skill.category] += skill
				else
					skills_by_category[skill.category] = list(skill)

	for(var/category in skills_by_category)
		if(skills_by_category.Find(category) == 1)
			output += span_notice("<EM>[category]</EM>")
		else
			output += span_notice("\n<EM>[category]</EM>")
		for(var/thing in skills_by_category[category])
			var/datum/attribute/skill/skill = thing
			var/calculated_raw_skill = return_raw_calculated_skill(skill.type)
			var/calculated_skill = return_calculated_skill(skill.type)
			var/raw_skill = isnull(calculated_raw_skill) ? "NA" : calculated_raw_skill
			var/total_skill = isnull(calculated_skill) ? "NA" : calculated_skill
			var/total_style = "class='info'"
			if(isnum(total_skill) && isnum(raw_skill))
				if(total_skill > raw_skill)
					total_style =  "class='green'"
				else if(total_skill < raw_skill)
					total_style = "class='red'"
			else if(isnum(total_skill))
				total_style =  "class='green'"
			else if(isnum(raw_skill))
				total_style = "class='red'"
			output += "\n<span class='info'>\
				• <b>[capitalize_like_old_man(skill.name)] \[[capitalize_like_old_man(skill.difficulty)]\]:</b> \
				[capitalize_like_old_man(skill.description_from_level(calculated_skill))] \
				(<span [total_style]>[total_skill]</span>/[raw_skill]).\
				</span>"
	if(!LAZYLEN(skills_by_category))
		output += span_info("• I am genuinely, absolutely and completely useless.")
	output += "</div></span>" //div infobox
	to_chat(user, jointext(output, ""))

/datum/attribute_holder/proc/print_stats(mob/user)
	var/list/output = list()
	output += "<span class='infoplain'><div class='infobox'>"
	var/list/stats = list()
	for(var/thing in attribute_list)
		if(ispath(thing, STAT))
			var/datum/attribute/attribute = GLOB.all_stats[thing]
			stats += attribute
	output += span_notice("<EM>Stats</EM>")
	for(var/thing in stats)
		var/datum/attribute/stat/stat = thing
		var/raw_attribute = nulltozero(raw_attribute_list[stat.type])
		var/total_attribute = nulltozero(attribute_list[stat.type])
		var/total_style = "class='info'"
		if(total_attribute > raw_attribute)
			total_style =  "class='green'"
		else if(total_attribute < raw_attribute)
			total_style = "class='red'"
		output += "\n<span class='info'>\
			• <b>[capitalize_like_old_man(stat.name)] ([stat.shorthand]):</b> \
			[capitalize(stat.description_from_level(attribute_list[stat.type]))] \
			(<span [total_style]>[total_attribute]</span>/[raw_attribute]).\
			</span>"
	output += "</div></span>" //div infobox
	to_chat(user, jointext(output, ""))

/**
 * Directly set a skill to a specific level, adjusting the XP pool to match.
 * Equivalent to the old set_skillrank().
 *
 * Arguments:
 *   skill_type - typepath of the skill
 *   level      - target level (0-60)
 *   silent     - suppress messages
 */
/datum/attribute_holder/proc/set_skill_level(skill_type, level, silent = TRUE)
	if(!ispath(skill_type, SKILL))
		return
	level = clamp(level, skill_min, skill_max)
	var/old_level = nulltozero(raw_attribute_list[skill_type])
	// Sync the XP pool to the floor of this level so further XP gain is clean
	LAZYSET(skill_xp, skill_type, xp_for_level(level))
	if(level != old_level)
		apply_skill_level(skill_type, level, old_level, silent)

/**
 * Adjust a skill level by a delta, optionally capped at a maximum.
 * Equivalent to old adjust_skillrank() / clamped_adjust_skill_level(). this is just legacy stuff to avoid the billion issues
 *
 * Arguments:
 *   skill_type - typepath of the skill
 *   delta      - levels to add (can be negative)
 *   max_level  - optional ceiling; pass null for no cap
 *   silent     - suppress messages
 */
/datum/attribute_holder/proc/adjust_skill_level(skill_type, delta, max_level = null, silent = FALSE)
	if(!ispath(skill_type, SKILL))
		return
	var/current = nulltozero(raw_attribute_list[skill_type])
	var/target = clamp(current + delta, skill_min, skill_max)
	if(!isnull(max_level))
		target = min(target, max_level)
	if(target == current)
		return
	set_skill_level(skill_type, target, silent)

/**
 * Wipes all skill levels and XP back to zero.
 * Equivalent to old purge_all_skills().
 */
/datum/attribute_holder/proc/purge_all_skills(silent = TRUE)
	for(var/skill_type in raw_attribute_list)
		if(!ispath(skill_type, SKILL))
			continue
		var/old_level = nulltozero(raw_attribute_list[skill_type])
		if(!old_level)
			continue
		LAZYSET(skill_xp, skill_type, 0)
		apply_skill_level(skill_type, SKILL_LEVEL_NONE, old_level, silent)
	if(!silent)
		to_chat(parent, span_boldwarning("I forget all my skills!"))

/**
 * Writes the new level into raw_attribute_list, fires signals, handles
 * per-skill side-effects (arcane spell points, alchemy trait), and
 * optionally messages the player.
 */
/datum/attribute_holder/proc/apply_skill_level(skill_type, new_level, old_level, silent)
	raw_attribute_list[skill_type] = new_level
	update_attributes()

	SEND_SIGNAL(parent, COMSIG_SKILL_RANK_CHANGE, skill_type, new_level * 0.1, old_level * 0.1)
	SEND_SIGNAL(parent, COMSIG_SKILL_LEVEL_CHANGE, skill_type, new_level, old_level)

	// Per-skill side-effects
	on_skill_level_changed(skill_type, new_level, old_level)

	if(silent)
		return

	var/old_tier = floor(old_level / 10)
	var/new_tier = floor(new_level / 10)
	if(old_tier == new_tier)
		return

	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	var/skill_name = istype(skill) ? skill.name : "[skill_type]"
	if(new_level > old_level)
		var/tier_name = skill.description_from_level(return_raw_effective_skill(skill_type))
		to_chat(parent, span_nicegreen("My proficiency in [skill_name] grows to [tier_name]!"))
		record_round_statistic(STATS_SKILLS_LEARNED)
		if(ispath(skill_type, /datum/attribute/skill/combat))
			record_round_statistic(STATS_COMBAT_SKILLS)
	else
		var/display_level = return_raw_effective_skill(skill_type)
		var/tier_name = display_level > 0 ? skill.description_from_level(display_level) : "nothing"
		to_chat(parent, span_warning("My [skill_name] has weakened to [tier_name]!"))
