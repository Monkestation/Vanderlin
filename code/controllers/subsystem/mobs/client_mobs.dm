/// Used for any mob with a client
MOBS_SUBSYSTEM_DEF(client_mobs)
	name = "Client Mobs"
	priority = FIRE_PRIORITY_CLIENT_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT

/datum/controller/subsystem/mobs/client_mobs/stat_entry(msg)
	msg = "P:[length(processing)]"
	return ..()

/datum/controller/subsystem/mobs/client_mobs/build_currentrun()
	return processing.Copy() // Only cliented mobs process always
