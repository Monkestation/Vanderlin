SUBSYSTEM_DEF(relics)
	name = "Relics"
	flags = SS_BACKGROUND
	wait = 0.5 SECONDS
	var/list/datum/component/relic/active_relics = list()

/datum/controller/subsystem/relics/fire()
	for(var/datum/component/relic/R in active_relics)
		if(!R || QDELETED(R))
			active_relics -= R
			continue

		// The subsystem simply tells the component to tick.
		// If the component returns FALSE, it means it's done processing and can sleep.
		if(!R.process_tick())
			active_relics -= R
