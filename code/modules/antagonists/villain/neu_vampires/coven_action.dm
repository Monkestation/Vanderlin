/datum/action/coven
	check_flags = NONE
	background_icon_state = "spell" //And this is the state for the background icon
	button_icon_state = "coven" //And this is the state for the action icon
	overlay_icon = 'icons/mob/actions/roguespells.dmi'

	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/coven/coven
	var/targeting = FALSE
	var/active = FALSE

/datum/action/coven/New(target, datum/coven/coven)
	. = ..()
	src.coven = coven
	coven.coven_action = src

/datum/action/coven/Grant(mob/M)
	. = ..()
	coven.assign(M)

	register_to_availability_signals()

/datum/action/coven/proc/register_to_availability_signals()
	//this should only go through if it's the first Coven gained by the mob
	for (var/datum/action/action in owner.actions)
		if (action == src)
			continue
		if (istype(action, /datum/action/coven))
			return

	//irrelevant for NPCs
	if (!owner.client)
		return

	var/list/relevant_signals = list(
		SIGNAL_ADDTRAIT(TRAIT_TORPOR),
		SIGNAL_REMOVETRAIT(TRAIT_TORPOR),
		SIGNAL_ADDTRAIT(TRAIT_KNOCKEDOUT),
		SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT),
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
		SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED),
		SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED),
		SIGNAL_REMOVETRAIT(TRAIT_IMMOBILIZED),
		SIGNAL_ADDTRAIT(TRAIT_FLOORED),
		SIGNAL_REMOVETRAIT(TRAIT_FLOORED),
		// SIGNAL_ADDTRAIT(TRAIT_BLIND),
		// SIGNAL_REMOVETRAIT(TRAIT_BLIND),
		SIGNAL_ADDTRAIT(TRAIT_MUTE),
		SIGNAL_REMOVETRAIT(TRAIT_MUTE),
		SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_REMOVETRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_ADDTRAIT(TRAIT_PACIFISM),
		SIGNAL_REMOVETRAIT(TRAIT_PACIFISM),
	)

	RegisterSignal(owner, relevant_signals, PROC_REF(update_mob_buttons))

/datum/action/coven/proc/update_mob_buttons()
	owner.update_action_buttons()

/datum/action/coven/IsAvailable()
	return coven.current_power.can_activate_untargeted()

/datum/action/coven/Trigger(trigger_flags)
	. = ..()

	build_all_button_icons()

	//easy de-targeting
	if (targeting)
		end_targeting()
		. = FALSE
		return .

	//cancel targeting of other Covens when one is activated
	for (var/datum/action/action in owner.actions)
		if (istype(action, /datum/action/coven))
			var/datum/action/coven/other_coven = action
			other_coven.end_targeting()

	//ensure it's actually possible to trigger this
	if (!coven?.current_power || !isliving(owner))
		. = FALSE
		return .

	var/datum/coven_power/power = coven.current_power
	if (power.active) //deactivation logic
		if (power.cancelable || power.toggled)
			power.try_deactivate(direct = TRUE, alert = TRUE)
			active = FALSE
		else
			to_chat(owner, span_warning("[power] is already active!"))
	else //activate
		if (power.target_type == NONE) //self activation
			if(power.try_activate())
				active = TRUE
		else //ranged targeted activation
			begin_targeting()
			active = TRUE

	build_all_button_icons()

	return .


/datum/action/coven/update_button_name(atom/movable/screen/movable/action_button/button, force)
	. = ..()
	if(coven)
		name = coven.current_power.name
		desc = coven.current_power.desc

/datum/action/coven/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	if(coven)
		button_icon_state = coven.icon_state
		background_icon_state = "[initial(background_icon_state)][active]"
	else
		button_icon_state = initial(button_icon_state)
		background_icon_state = "[initial(background_icon_state)][active]"
	. = ..()

/datum/action/coven/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force)
	if(coven)
		overlay_icon_state = "[coven.level_casting]"
	else
		overlay_icon_state = initial(overlay_icon_state)

	. = ..()



/datum/action/coven/proc/switch_level(to_advance = 1)
	if (coven.level_casting + to_advance > length(coven.known_powers))
		coven.level_casting = 1
	else if (coven.level_casting + to_advance < 1)
		coven.level_casting = length(coven.known_powers)
	else
		coven.level_casting += to_advance

	if (targeting)
		end_targeting()

	coven.current_power = coven.known_powers[coven.level_casting]
	build_all_button_icons()

/datum/action/coven/proc/end_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (!targeting)
		return

	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	targeting = FALSE
	active = FALSE
	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	build_all_button_icons()

/datum/action/coven/proc/handle_click(mob/source, atom/target, list/modifiers)
	SIGNAL_HANDLER

	//ensure we actually need a target, or cancel on right click
	if (!targeting || LAZYACCESS(modifiers, RIGHT_CLICK))
		end_targeting()
		return

	//actually try to use the Coven on the target
	spawn()
		if (coven.current_power.try_activate(target))
			end_targeting()

	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/coven/proc/begin_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (targeting)
		return
	if (!coven.current_power.can_activate_untargeted(TRUE))
		return
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	client.mouse_pointer_icon = 'icons/effects/mousemice/charge/spell_charged.dmi'
	targeting = TRUE

/atom/movable/screen/movable/action_button/Click(location, control, params)
	if(istype(linked_action, /datum/action/coven))
		var/list/modifiers = params2list(params)
		//increase on right click, decrease on shift right click
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			var/datum/action/coven/coven = linked_action
			if (LAZYACCESS(modifiers, ALT_CLICKED))
				coven.switch_level(-1)
			else
				coven.switch_level(1)
			return
		//TODO: middle click to swap loadout
	. = ..()
