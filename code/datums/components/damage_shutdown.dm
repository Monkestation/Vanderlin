/datum/component/damage_shutdown
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Total combined damage (brute + burn) that triggers shutdown. Default: 60.
	var/shutdown_threshold = 200
	/// Total combined damage at or below which the mob wakes back up. Default: 20.
	var/recovery_threshold = 40
	/// Whether the mob is currently shut down by this component.
	var/is_shut_down = FALSE

/datum/component/damage_shutdown/Initialize(mapload, shutdown_threshold = 200, recovery_threshold = 20)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.shutdown_threshold = shutdown_threshold
	src.recovery_threshold = recovery_threshold

/datum/component/damage_shutdown/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))

/datum/component/damage_shutdown/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE)

/datum/component/damage_shutdown/proc/on_health_update(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_parent = parent
	var/total_damage = living_parent.getBruteLoss() + living_parent.getFireLoss()

	if(!is_shut_down && total_damage >= shutdown_threshold)
		failure()
	else if(is_shut_down && total_damage <= recovery_threshold)
		revive()

/datum/component/damage_shutdown/proc/failure()
	var/mob/living/living_parent = parent
	is_shut_down = TRUE
	living_parent.SetUnconscious(INFINITY) // holds them unconscious until we clear it through health updates
	living_parent.visible_message(
		span_warning("[living_parent] suddenly goes limp, systems shutting down!")
	)

/datum/component/damage_shutdown/proc/revive()
	var/mob/living/living_parent = parent
	is_shut_down = FALSE
	living_parent.SetUnconscious(0)
	living_parent.visible_message(
		span_notice("[living_parent] stirs, systems coming back online.")
	)
