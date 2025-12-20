/datum/action/cooldown/meatvine/personal
	name = "Personal Ability"
	desc = "Uses personal resources"
	button_icon = 'icons/obj/cellular/putrid_abilities.dmi'
	background_icon = 'icons/obj/cellular/putrid_abilities.dmi'
	base_background_icon_state = "button_bg"
	active_background_icon_state = "button_bg1"
	check_flags = NONE
	var/personal_resource_cost = 10

/datum/action/cooldown/meatvine/personal/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(owner, COMSIG_MEATVINE_PERSONAL_RESOURCE_CHANGE, PROC_REF(update_status_on_signal))

/datum/action/cooldown/meatvine/personal/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	if(consumed.personal_resource_pool < personal_resource_cost)
		return FALSE

	return TRUE

/datum/action/cooldown/meatvine/personal/Activate(atom/target)
	StartCooldown()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	consumed.personal_resource_pool -= personal_resource_cost
	return TRUE

/datum/action/cooldown/meatvine/personal/proc/evaluate_ai_score(datum/ai_controller/controller)
	// Base implementation - override in subtypes
	// Return 0 to not use, higher scores = higher priority
	return 0

/datum/action/cooldown/meatvine/personal/proc/ai_use_ability(datum/ai_controller/controller)
	// Base implementation - override in subtypes
	// Return TRUE if ability was successfully used
	return FALSE

/datum/action/cooldown/meatvine/personal/proc/get_movement_target(datum/ai_controller/controller)
    // Override in subtypes that need movement
    // Return the atom to move toward, or null if no movement needed
    return null

/datum/action/cooldown/meatvine/personal/proc/get_required_range()
    // How close do we need to be to the movement target?
    return 1 // Default: adjacent
