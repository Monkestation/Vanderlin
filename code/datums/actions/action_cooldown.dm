#define COOLDOWN_NO_DISPLAY_TIME (180 SECONDS)

/// Preset for an action that has a cooldown.
/datum/action/cooldown
	check_flags = NONE
	transparent_when_unavailable = FALSE

	/// The actual next time this ability can be used
	var/next_use_time = 0
	/// The stat panel this action shows up in the stat panel in. If null, will not show up.
	var/panel
	/// The default cooldown applied when StartCooldown() is called
	var/cooldown_time = 0
	/// Whether or not you want the cooldown for the ability to display in text form
	var/text_cooldown = TRUE
	/// Shares cooldowns with other cooldown abilities of the same value, not active if null
	var/shared_cooldown

	// These are only used for click_to_activate actions
	/// Setting for intercepting clicks before activating the ability
	var/click_to_activate = FALSE
	/// The cooldown added onto the user's next click.
	var/click_cd_override = CLICK_CD_CLICK_ABILITY
	/// If TRUE, we will unset after using our click intercept.
	var/unset_after_click = TRUE
	/// If TRUE, after the cooldown finishes naturally we re trigger the spell if possible.
	var/retrigger_after_cooldown = TRUE
	/// What icon to replace our mouse cursor with when active. Optional
	var/ranged_mousepointer
	/// The base icon_state of this action's background
	var/base_background_icon_state
	/// The icon state the background uses when active
	var/active_background_icon_state
	/// The base icon_state of the overlay we apply
	var/base_overlay_icon_state
	/// The active icon_state of the overlay we apply
	var/active_overlay_icon_state
	/// The base icon state of the spell's button icon, used for editing the icon "off"
	var/base_icon_state
	/// The active icon state of the spell's button icon, used for editing the icon "on"
	var/active_icon_state
	/// Timer for retriggering the spell
	var/retrigger_timer

/datum/action/cooldown/New(Target)
	. = ..()

	if(active_background_icon_state)
		base_background_icon_state ||= background_icon_state
	if(active_overlay_icon_state)
		base_overlay_icon_state ||= overlay_icon_state
	if(active_icon_state)
		base_icon_state ||= button_icon_state

/datum/action/cooldown/create_button()
	var/atom/movable/screen/movable/action_button/button = ..()
	button.maptext = ""
	button.maptext_x = 4
	button.maptext_y = 2
	button.maptext_width = 32
	button.maptext_height = 16
	return button

/datum/action/cooldown/update_button_status(atom/movable/screen/movable/action_button/button, force = FALSE)
	. = ..()
	var/time_left = max(next_use_time - world.time, 0)
	if(!text_cooldown || !owner || time_left == 0 || time_left >= COOLDOWN_NO_DISPLAY_TIME)
		button.maptext = ""
	else
		button.maptext = MAPTEXT_PIXELIFY("[round(time_left/10, 0.1)]")

	if(!IsAvailable() || !is_action_active(button))
		return
	// If we don't change the icon state, or don't apply a special overlay,
	if(active_background_icon_state || active_icon_state || active_overlay_icon_state)
		return
	// ...we need to show it's active somehow. So, make it greeeen
	button.color = COLOR_GREEN

/datum/action/cooldown/apply_button_background(atom/movable/screen/movable/action_button/current_button, force)
	if(active_background_icon_state)
		background_icon_state = is_action_active(current_button) ? active_background_icon_state : base_background_icon_state
	return ..()

/datum/action/cooldown/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	if(active_icon_state)
		button_icon_state = is_action_active(current_button) ? active_icon_state : base_icon_state
	return ..()

/datum/action/cooldown/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force)
	if(active_overlay_icon_state)
		overlay_icon_state = is_action_active(current_button) ? active_overlay_icon_state : base_overlay_icon_state
	return ..()

/datum/action/cooldown/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return click_to_activate && current_button.our_hud?.mymob?.click_intercept == src

/datum/action/cooldown/IsAvailable()
	return ..() && (next_use_time <= world.time)

/datum/action/cooldown/Grant(mob/granted_to)
	. = ..()
	if(!owner)
		return
	build_all_button_icons()
	if(next_use_time > world.time)
		START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/Remove(mob/living/remove_from)
	if(click_to_activate && remove_from.click_intercept == src)
		unset_click_ability(remove_from, refund_cooldown = FALSE)
	return ..()

/// Starts a cooldown time to be shared with similar abilities
/// Will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldown(override_cooldown_time)
	// "Shared cooldowns" covers actions which are not the same type,
	// but have the same cooldown group and are on the same mob
	if(shared_cooldown)
		for(var/datum/action/cooldown/shared_ability in owner.actions - src)
			if(shared_cooldown != shared_ability.shared_cooldown)
				continue
			shared_ability.StartCooldownSelf(override_cooldown_time)

	StartCooldownSelf(override_cooldown_time)

/// Starts a cooldown time for this ability only
/// Will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldownSelf(override_cooldown_time)
	var/real_time = cooldown_time
	if(isnum(override_cooldown_time))
		real_time = override_cooldown_time
	next_use_time = world.time + real_time
	addtimer(CALLBACK(src, PROC_REF(CooldownEnded)), real_time)
	if(retrigger_after_cooldown && click_to_activate)
		if(real_time > 0)
			RegisterSignal(owner, COMSIG_MOB_SPELL_ACTIVATED, PROC_REF(cancel_retrigger))
			retrigger_timer = addtimer(CALLBACK(src, PROC_REF(retrigger)), real_time, TIMER_STOPPABLE)
		else
			retrigger()
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	START_PROCESSING(SSfastprocess, src)

/// Callback proc for when the cooldown of the spell would naturally end,
/// may not actually end at this time or may have already ended.
/datum/action/cooldown/proc/CooldownEnded()
	if(QDELETED(src) || QDELETED(owner))
		return

	SEND_SIGNAL(src, COMSIG_ACTION_COOLDOWN_ENDED)

/// Retrigger the spell after starting the cooldown if possible
/datum/action/cooldown/proc/retrigger()
	if(QDELETED(src) || QDELETED(owner))
		return

	UnregisterSignal(owner, COMSIG_MOB_SPELL_ACTIVATED)

	// Lets just have a cut off for reset
	if(cooldown_time > 1 MINUTES)
		return

	// Another spell is been selected or another click intercept is active
	if(owner.click_intercept)
		return

	Trigger()

/// Cancel retriggering by removing the timer
/datum/action/cooldown/proc/cancel_retrigger()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_SPELL_ACTIVATED)

	deltimer(retrigger_timer)

/datum/action/cooldown/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(!owner)
		return FALSE

	var/mob/user = usr || owner

	// If our cooldown action is a click_to_activate action:
	// The actual action is activated on whatever the user clicks on -
	// the target is what the action is being used on
	// In trigger, we handle setting the click intercept
	if(click_to_activate)
		if(target)
			// For automatic / mob handling
			return InterceptClickOn(user, null, target)

		var/datum/action/cooldown/already_set = user.click_intercept
		if(already_set == src)
			// if we clicked ourself and we're already set, unset and return
			return unset_click_ability(user, refund_cooldown = TRUE)

		else if(istype(already_set))
			// if we have an active set already, unset it before we set our's
			already_set.unset_click_ability(user, refund_cooldown = TRUE)

		return set_click_ability(user)

	// If our cooldown action is not a click_to_activate action:
	// We can just continue on and use the action
	// the target is the user of the action (often, the owner)
	return PreActivate(user)

/// Intercepts client owner clicks to activate the ability
/datum/action/cooldown/proc/InterceptClickOn(mob/living/clicker, list/modifiers, atom/target)
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return FALSE
	if(!IsAvailable(TRUE))
		return FALSE
	if(!target)
		return FALSE
	// The actual action begins here
	if(!PreActivate(target))
		return FALSE

	// And if we reach here, the action was completed successfully
	if(unset_after_click)
		unset_click_ability(clicker, refund_cooldown = FALSE)
	clicker.next_click = world.time + click_cd_override

	return TRUE

/// For signal calling
/datum/action/cooldown/proc/PreActivate(atom/target)
	if(SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_STARTED, src) & COMPONENT_BLOCK_ABILITY_START)
		return
	. = Activate(target)
	// There is a possibility our action (or owner) is qdeleted in Activate().
	if(!QDELETED(src) && !QDELETED(owner))
		SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_FINISHED, src)

/// To be implemented by subtypes
/datum/action/cooldown/proc/Activate(atom/target)
	StartCooldown()

/**
 * Set our action as the click override on the passed mob.
 */
/datum/action/cooldown/proc/set_click_ability(mob/on_who)
	SHOULD_CALL_PARENT(TRUE)

	on_who.click_intercept = src
	if(ranged_mousepointer)
		on_who.client?.mouse_override_icon = ranged_mousepointer
		on_who.update_mouse_pointer()
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)
	return TRUE

/**
 * Unset our action as the click override of the passed mob.
 *
 * if refund_cooldown is TRUE, we are being unset by the user clicking the action off
 * if refund_cooldown is FALSE, we are being forcefully unset, likely by someone actually using the action
 */
/datum/action/cooldown/proc/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	on_who.click_intercept = null
	if(ranged_mousepointer)
		on_who.client?.mouse_override_icon = initial(on_who.client?.mouse_override_icon)
		on_who.update_mouse_pointer()
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)
	return TRUE

/datum/action/cooldown/process()
	if(!owner || (next_use_time - world.time) <= 0)
		build_all_button_icons(UPDATE_BUTTON_STATUS)
		STOP_PROCESSING(SSfastprocess, src)
		return

	build_all_button_icons(UPDATE_BUTTON_STATUS)

#undef COOLDOWN_NO_DISPLAY_TIME
