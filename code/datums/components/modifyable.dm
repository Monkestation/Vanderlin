/datum/component/modifications
	var/sockets = 0
	var/max_sockets = 0
	var/list/socketed_runes = list()
	var/list/combat_gem_effects = list()
	var/datum/runeword/active_runeword = null
	var/runeword_name = ""

	// Cached totals for performance
	var/cold_res = 0
	var/fire_res = 0
	var/lightning_res = 0
	var/max_cold_res = 0
	var/max_fire_res = 0
	var/max_lightning_res = 0
	var/list/status_modifiers = list()

/datum/component/modifications/Initialize(initial_sockets = 0, initial_max_sockets = 0)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	sockets = initial_sockets
	max_sockets = initial_max_sockets

	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_GET_RESISTANCE, PROC_REF(on_get_resistance))
	RegisterSignal(parent, COMSIG_ATOM_GET_MAX_RESISTANCE, PROC_REF(on_get_max_resistance))
	RegisterSignal(parent, COMSIG_ATOM_GET_STATUS_MOD, PROC_REF(on_get_status_mod))
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_apply_combat_effects))
	RegisterSignal(parent, COMSIG_PROJECTILE_ON_HIT, PROC_REF(on_apply_combat_effects_ranged))

/datum/component/modifications/proc/on_attackby(obj/item/source, obj/item/attacking_item, mob/user, params)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/gem))
		socket_gem(attacking_item, user)
		return COMPONENT_NO_AFTERATTACK

	if(istype(attacking_item, /obj/item/rune))
		socket_rune(attacking_item, user)
		return COMPONENT_NO_AFTERATTACK

	return

/datum/component/modifications/proc/on_examine(obj/item/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(sockets > 0)
		examine_list += "<span class='notice'>This item has [sockets] socket[sockets > 1 ? "s" : ""].</span>"

		if(length(socketed_runes) > 0)
			examine_list += "<span class='notice'>Socketed gems: [english_list(socketed_runes)]</span>"

			// Show gem effect details
			if(length(combat_gem_effects) || active_runeword)
				examine_list += "<span class='info'>Gem Effects:</span>"
				var/list/grouped_effects = get_grouped_gem_effects()
				for(var/effect_desc in grouped_effects)
					examine_list += "<span class='info'>  [effect_desc]</span>"

		if(active_runeword)
			examine_list += "<span class='boldnotice'>This item contains the [active_runeword.name] runeword!</span>"

/datum/component/modifications/proc/on_get_resistance(obj/item/source, resistance_type)
	SIGNAL_HANDLER

	switch(resistance_type)
		if(COLD_DAMAGE)
			return cold_res
		if(FIRE_DAMAGE)
			return fire_res
		if(LIGHTNING_DAMAGE)
			return lightning_res
	return 0

/datum/component/modifications/proc/on_get_max_resistance(obj/item/source, resistance_type)
	SIGNAL_HANDLER

	switch(resistance_type)
		if(COLD_DAMAGE)
			return max_cold_res
		if(FIRE_DAMAGE)
			return max_fire_res
		if(LIGHTNING_DAMAGE)
			return max_lightning_res
	return 0

/datum/component/modifications/proc/on_get_status_mod(obj/item/source, status_key)
	SIGNAL_HANDLER

	return LAZYACCESS(status_modifiers, status_key)

/datum/component/modifications/proc/on_apply_combat_effects_ranged(obj/item/source, mob/living/user, mob/living/target, angle)
	SIGNAL_HANDLER

	if(!length(combat_gem_effects))
		return

	for(var/datum/rune_effect/effect in combat_gem_effects)
		if(!effect.ranged)
			continue
		effect.apply_combat_effect(target, user)

/datum/component/modifications/proc/on_apply_combat_effects(obj/item/source, mob/living/target, mob/living/user, proximity_flag, list/modifiers)
	SIGNAL_HANDLER
	if(!proximity_flag)
		return

	if(!length(combat_gem_effects))
		return

	for(var/datum/rune_effect/effect in combat_gem_effects)
		effect.apply_combat_effect(target, user, 0)

/datum/component/modifications/proc/can_socket_gem(obj/item/gem/G)
	if(!G || !istype(G, /obj/item/gem))
		return FALSE
	if(length(socketed_runes) >= sockets)
		return FALSE
	return TRUE

/datum/component/modifications/proc/socket_gem(obj/item/gem/G, mob/user)
	if(!can_socket_gem(G))
		if(user)
			to_chat(user, "<span class='warning'>This item cannot accept another gem!</span>")
		return FALSE

	// Get the appropriate slot type and create rune effect
	var/slot_type = G.get_slot_type(parent)
	var/datum/rune_effect/gem_effect = G.create_rune_effect_for_slot(slot_type)

	if(!gem_effect)
		if(user)
			to_chat(user, "<span class='warning'>This gem has no effect on this type of item!</span>")
		return FALSE

	// Add gem name to socketed list for tracking
	LAZYADD(socketed_runes, G.name)

	// Apply the gem's effect
	apply_gem_effect(gem_effect, G)

	qdel(G)
	if(user)
		to_chat(user, "<span class='notice'>You socket the [G.name] into [parent].</span>")
	return TRUE

/datum/component/modifications/proc/can_socket_rune(obj/item/rune/R)
	if(!R || !istype(R, /obj/item/rune))
		return FALSE
	if(length(socketed_runes) >= sockets)
		return FALSE
	return TRUE

/datum/component/modifications/proc/socket_rune(obj/item/rune/R, mob/user)
	if(!can_socket_rune(R))
		to_chat(user, "<span class='warning'>This item cannot accept another rune!</span>")
		return FALSE

	LAZYADD(socketed_runes, R.rune_type)
	qdel(R)

	to_chat(user, "<span class='notice'>You socket the [R.name] into [parent].</span>")

	// Check if we've completed a runeword
	check_runeword_completion(user)
	return TRUE

/datum/component/modifications/proc/apply_gem_effect(datum/rune_effect/effect, obj/item/gem/source_gem)
	// Apply stat effects and cache the values
	apply_effect_to_cache(effect)

	// Store combat effects
	if(!combat_gem_effects)
		combat_gem_effects = list()
	combat_gem_effects += effect

/datum/component/modifications/proc/apply_effect_to_cache(datum/rune_effect/effect)
	// Update cached resistance values
	effect.apply_stat_effect(src, parent)

/datum/component/modifications/proc/check_runeword_completion(mob/user)
	initialize_runewords()

	for(var/runeword_type in GLOB.all_runewords)
		var/datum/runeword/template = GLOB.all_runewords[runeword_type]

		if(template.sockets_required != length(socketed_runes))
			continue

		// Check if our socketed runes match the runeword sequence
		var/match = TRUE
		for(var/i = 1 to length(template.runes))
			if(LAZYACCESS(socketed_runes, i) != template.runes[i])
				match = FALSE
				break

		if(!match)
			continue

		// Check if this item type is allowed for this runeword
		var/type_allowed = FALSE
		for(var/allowed_type in template.allowed_items)
			if(istype(parent, allowed_type))
				type_allowed = TRUE
				break

		if(!type_allowed)
			continue

		// We have a match! Apply the runeword
		apply_runeword(runeword_type, user)
		return TRUE

	return FALSE

/datum/component/modifications/proc/apply_runeword(runeword_type, mob/user)
	var/obj/item/item_parent = parent

	// Create the runeword instance and attach it to this item
	active_runeword = new runeword_type(parent)
	runeword_name = active_runeword.name

	item_parent.name = "[active_runeword.name] [item_parent.name]"

	// Apply stat bonuses to cache
	apply_runeword_stats(active_runeword)

	// Add spell actions
	apply_runeword_spells(active_runeword)

	to_chat(user, "<span class='boldnotice'>[parent] transforms into the [active_runeword.name] runeword!</span>")

/datum/component/modifications/proc/apply_runeword_stats(datum/runeword/RW)
	for(var/datum/rune_effect/effect as anything in RW.stat_bonuses)
		apply_effect_to_cache(effect)

/datum/component/modifications/proc/apply_runeword_spells(datum/runeword/RW)
	var/obj/item/item_parent = parent
	for(var/spell_type in RW.spell_actions)
		item_parent.add_item_action(spell_type)

/datum/component/modifications/proc/add_socket()
	if(sockets >= max_sockets)
		return FALSE
	sockets++
	return TRUE

/datum/component/modifications/proc/get_grouped_gem_effects()
	var/list/all_effects = list()

	// Add gem effects
	if(combat_gem_effects && combat_gem_effects.len)
		all_effects += combat_gem_effects

	// Add runeword effects
	if(active_runeword)
		if(active_runeword.stat_bonuses && length(active_runeword.stat_bonuses))
			all_effects += active_runeword.stat_bonuses
		if(active_runeword.combat_effects && length(active_runeword.combat_effects))
			all_effects += active_runeword.combat_effects

	if(!length(all_effects))
		return list()

	var/list/effect_groups = list()
	for(var/datum/rune_effect/effect in all_effects)
		var/group_key = effect.get_group_key()
		if(!effect_groups[group_key])
			effect_groups[group_key] = list()
		effect_groups[group_key] += effect

	var/list/descriptions = list()
	for(var/group_key in effect_groups)
		var/list/effects_in_group = effect_groups[group_key]
		var/datum/rune_effect/first_effect = effects_in_group[1]
		descriptions += first_effect.get_combined_description(effects_in_group)

	if(active_runeword && active_runeword.spell_actions && length(active_runeword.spell_actions))
		for(var/datum/action/spell_action as anything in active_runeword.spell_actions)
			descriptions += "Gives [initial(spell_action.name)]"

	return descriptions
