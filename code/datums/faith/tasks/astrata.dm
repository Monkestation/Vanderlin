/datum/devotion_task/astrata_purge
	name = "Purge Undead"
	desc = "Purge the undead"
	devotion_reward = 60
	progression_reward = 4
	cooldown_time = 0 SECONDS
	signal_type = COMSIG_LIVING_COMBAT_KILL

/datum/devotion_task/astrata_purge/on_signal_received(datum/source, mob/living/dead)
	if(!(dead.mob_biotypes & MOB_UNDEAD))
		return
	. = ..()
