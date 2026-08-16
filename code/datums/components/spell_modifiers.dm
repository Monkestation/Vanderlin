/datum/component/spell_modifier
	dupe_mode = COMPONENT_DUPE_ALLOWED

	/// list(FORM_FIRE = 1.2, FORM_ICE = 0.8, ...) - missing form = 1
	var/list/form_cost_multipliers
	var/list/form_cast_speed_multipliers
	var/list/form_magnitude_modifications

	/// list(TECHNIQUE_X = 1.2, ...) - missing technique = 1
	var/list/technique_cost_multipliers
	var/list/technique_cast_speed_multipliers
	var/list/technique_magnitude_modifications

/datum/component/spell_modifier/Initialize(
	list/form_cost_multipliers,
	list/form_cast_speed_multipliers,
	list/form_magnitude_modifications,
	list/technique_cost_multipliers,
	list/technique_cast_speed_multipliers,
	list/technique_magnitude_modifications,
)
	if(!isitem(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE
	src.form_cost_multipliers = form_cost_multipliers || list()
	src.form_cast_speed_multipliers = form_cast_speed_multipliers || list()
	src.form_magnitude_modifications = form_magnitude_modifications || list()
	src.technique_cost_multipliers = technique_cost_multipliers || list()
	src.technique_cast_speed_multipliers = technique_cast_speed_multipliers || list()
	src.technique_magnitude_modifications = technique_magnitude_modifications || list()

/datum/component/spell_modifier/RegisterWithParent()
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	RegisterSignal(parent, COMSIG_SPELL_REQUEST_MODIFIERS, PROC_REF(on_request_modifiers))

/datum/component/spell_modifier/UnregisterFromParent()
	if(isitem(parent))
		UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_SPELL_REQUEST_MODIFIERS))
	else
		UnregisterSignal(parent, list(COMSIG_SPELL_REQUEST_MODIFIERS))

/datum/component/spell_modifier/proc/on_equipped(datum/source, mob/user)
	SIGNAL_HANDLER
	RegisterSignal(user, COMSIG_SPELL_REQUEST_MODIFIERS, PROC_REF(on_request_modifiers), override = TRUE)

/datum/component/spell_modifier/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_SPELL_REQUEST_MODIFIERS)

/datum/component/spell_modifier/proc/on_request_modifiers(datum/source, list/modifiers)
	SIGNAL_HANDLER
	add_modifier_entries(modifiers, "form", form_cost_multipliers, form_cast_speed_multipliers, form_magnitude_modifications)
	add_modifier_entries(modifiers, "technique", technique_cost_multipliers, technique_cast_speed_multipliers, technique_magnitude_modifications)

/datum/component/spell_modifier/proc/add_modifier_entries(list/modifiers, key, list/cost_multipliers, list/cast_speed_multipliers, list/magnitude_modifications)
	var/list/keys = cost_multipliers | cast_speed_multipliers | magnitude_modifications
	for(var/entry_key in keys)
		var/cost = cost_multipliers[entry_key] || 1
		var/cast_speed = cast_speed_multipliers[entry_key] || 1
		var/magnitude = magnitude_modifications[entry_key] || 0
		if(cost == 1 && cast_speed == 1 && magnitude == 0)
			continue
		var/list/entry = list(
			SPELLMOD_COST = cost,
			SPELLMOD_CASTSPEED = cast_speed,
			SPELLMOD_MAGNITUDE = magnitude,
		)
		entry[key] = entry_key
		modifiers += list(entry)
