SUBSYSTEM_DEF(matthios_mobs)
	name = "Matthios Mobs"
	priority = FIRE_PRIORITY_MOBS - 2 // Lower priority, background task
	flags = SS_KEEP_TIMING | SS_NO_INIT | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/list/currentrun = list()
	var/list/matthios_mobs = list()

	var/list/dungeon_z = list()
	var/looked = FALSE

/datum/controller/subsystem/matthios_mobs/stat_entry()
	..("MM:[matthios_mobs.len]")

/datum/controller/subsystem/matthios_mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if(!length(dungeon_z) && !looked)
		dungeon_z = SSmapping.levels_by_trait(ZTRAIT_MATTHIOS_DUNGEON)
		looked = TRUE

	if(!length(dungeon_z))
		return

	var/should = FALSE

	for(var/level in dungeon_z)
		if(length(SSmobs.clients_by_zlevel[level]))
			for(var/mob/living/mob as anything in SSmobs.clients_by_zlevel[level])
				if(isliving(mob))
					should = TRUE
					break
			if(should)
				break

	if(!should)
		return

	if (!resumed)
		src.currentrun = matthios_mobs.Copy()

	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			matthios_mobs -= L
			GLOB.mob_living_list -= L
			continue

		if(L.stat == DEAD)
			L.DeadLife()
		else
			L.Life(seconds, times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/matthios_mobs/proc/register_mob(mob/living/L)
	if(!L)
		return FALSE

	matthios_mobs |= L
	return TRUE

/datum/controller/subsystem/matthios_mobs/proc/unregister_mob(mob/living/L)
	if(!L)
		return

	matthios_mobs -= L
