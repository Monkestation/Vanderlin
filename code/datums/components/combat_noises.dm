/datum/component/combat_noise
	var/list/emotes = list()

/datum/component/combat_noise/Initialize(list/combat_noises)
	. = ..()
	if(!length(combat_noises))
		return COMPONENT_INCOMPATIBLE
	emotes = combat_noises

	RegisterSignal(parent, COMSIG_COMBAT_TARGET_SET, PROC_REF(set_process))

/datum/component/combat_noise/process(seconds_per_tick)
	. = ..()
	var/mob/living/mob = parent
	for(var/emote in emotes)
		if(!SPT_PROB(emotes[emote], seconds_per_tick))
			continue
		mob.emote(emote)

/datum/component/combat_noise/proc/set_process(should)
	if(!should)
		STOP_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSobj, src)
