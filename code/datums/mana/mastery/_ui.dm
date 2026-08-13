/datum/spellbook
	var/mob/living/owner
	var/datum/spell_mastery/mastery
	///can we unlearn form and technique spells, kept within the form school though.
	var/unlearn_mode = FALSE
	/// If TRUE, this instance auto-closes the moment the owner stops sleeping
	var/require_sleeping = FALSE

/datum/spellbook/New(mob/living/owner, datum/spell_mastery/_mastery)
	src.owner = owner
	if(owner?.mana_pool)
		mastery = owner.mana_pool.get_mastery()
	if(_mastery)
		mastery = _mastery

/datum/spellbook/Destroy(force)
	owner = null
	mastery = null
	return ..()

/datum/spellbook/ui_state(mob/user)
	return GLOB.always_state

/datum/spellbook/ui_status(mob/user, datum/ui_state/state)
	if(require_sleeping && !is_owner_sleeping())
		return UI_CLOSE
	return ..()

/datum/spellbook/proc/is_owner_sleeping()
	if(!owner)
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_VAMP_DREAMS))
		return TRUE
	return owner.IsSleeping()

/datum/spellbook/proc/open_unlearn(mob/user)
	unlearn_mode = TRUE
	ui_interact(user)

/datum/spellbook/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpellBook")
		ui.open()

/datum/spellbook/ui_static_data(mob/user)
	var/list/data = list()
	data["techniques"] = GLOB.all_techniques
	data["forms"] = GLOB.all_forms
	return data

/datum/spellbook/ui_data(mob/user)
	var/list/data = list()

	if(!mastery)
		return data

	data["unspentFormPoints"] = mastery.unspent_form_points
	data["unspentTechniquePoints"] = mastery.unspent_technique_points
	data["unlearnMode"] = unlearn_mode

	var/list/form_modifiers = get_modifiers_by_form()
	var/list/technique_modifiers = get_modifiers_by_technique()

	var/list/technique_data = list()
	for(var/technique in GLOB.all_techniques)
		technique_data += list(list(
			"id" = technique,
			"name" = technique,
			"level" = mastery.get_technique_level(technique),
			"rank" = mastery.get_technique_rank_name(technique),
			"modifiers" = technique_modifiers[technique],
		))
	data["techniqueLevels"] = technique_data

	var/list/form_data = list()
	for(var/form in GLOB.all_forms)
		form_data += list(list(
			"id" = form,
			"name" = form,
			"level" = mastery.get_form_level(form),
			"rank" = mastery.get_form_rank_name(form),
			"modifiers" = form_modifiers[form],
		))
	data["formLevels"] = form_data


	var/list/spell_data = list()
	for(var/datum/action/cooldown/spell/spell_path as anything in subtypesof(/datum/action/cooldown/spell))
		if(IS_ABSTRACT(spell_path))
			continue
		if(!initial(spell_path.learnable))
			continue
		var/technique = initial(spell_path:required_technique)
		var/form = initial(spell_path:required_form)
		if(!form)
			continue
		var/is_unlocked = (spell_path in mastery.unlocked_spells)

		spell_data += list(list(
			"path" = "[spell_path]",
			"name" = initial(spell_path.name),
			"desc" = initial(spell_path.desc),
			"technique" = technique,
			"form" = form,
			"level" = initial(spell_path.required_level),
			"formCost" = form ? 1 : 0,
			"techniqueCost" = technique ? 1 : 0,
			"unlocked" = is_unlocked,
			"canLearn" = mastery.can_learn_spell(spell_path),
			"canUnlearn" = is_unlocked, // any unlocked spell can be unlearned
			"icon" = "[initial(spell_path.button_icon)]",
			"iconState" = initial(spell_path.button_icon_state),
		))
	data["spells"] = spell_data
	return data

/datum/spellbook/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!mastery)
		return

	switch(action)
		if("invest_technique")
			var/technique = params["technique"]
			if(!(technique in GLOB.all_techniques))
				return
			. = mastery.invest_technique(technique, 1)

		if("invest_form")
			var/form = params["form"]
			if(!(form in GLOB.all_forms))
				return
			. = mastery.invest_form(form, 1)

		if("learn_spell")
			var/spell_path = text2path(params["path"])
			. = mastery.try_learn_spell(spell_path)

		if("unlearn_spell")
			var/spell_path = text2path(params["path"])
			. = mastery.try_unlearn_spell(spell_path)

/datum/spellbook/proc/get_modifiers_by_form()
	return get_modifiers_by_key("form")

/datum/spellbook/proc/get_modifiers_by_technique()
	return get_modifiers_by_key("technique")

/datum/spellbook/proc/get_modifiers_by_key(key)
	if(!mastery?.parent)
		return list()
	var/list/modifiers = list()
	SEND_SIGNAL(mastery.parent, COMSIG_SPELL_REQUEST_MODIFIERS, modifiers)

	var/list/by_key = list()
	for(var/list/entry in modifiers)
		var/id = entry[key]
		if(!id)
			continue
		if(!by_key[id])
			by_key[id] = list(SPELLMOD_COST = 1, SPELLMOD_CASTSPEED = 1, SPELLMOD_MAGNITUDE = 0)
		by_key[id][SPELLMOD_COST] *= entry[SPELLMOD_COST]
		by_key[id][SPELLMOD_CASTSPEED] *= entry[SPELLMOD_CASTSPEED]
		by_key[id][SPELLMOD_MAGNITUDE] += entry[SPELLMOD_MAGNITUDE]
	return by_key

/mob/living/proc/open_spellbook()
	set name = "Open Innate Spells"
	set category = "RoleUnique.Magic"

	var/datum/spellbook/book = new(src)
	book.ui_interact(src)
