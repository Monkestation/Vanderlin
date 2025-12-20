SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/currentrun = list()
	var/static/list/clients_by_zlevel[][]
	var/static/list/dead_players_by_zlevel[][] = list(list())
	var/static/list/camera_players_by_zlevel[][] = list(list())
	var/static/list/cubemonkeys = list()
	var/datum/mob_affix_system/affix_system

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[GLOB.mob_living_list.len]")

/datum/controller/subsystem/mobs/proc/MaxZChanged()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len < world.maxz)
		clients_by_zlevel.len++
		clients_by_zlevel[clients_by_zlevel.len] = list()
		dead_players_by_zlevel.len++
		dead_players_by_zlevel[dead_players_by_zlevel.len] = list()
		camera_players_by_zlevel.len++
		camera_players_by_zlevel[camera_players_by_zlevel.len] = list()

/datum/controller/subsystem/mobs/proc/MaxZDec()
	if (!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz,0)
		dead_players_by_zlevel = new /list(world.maxz,0)
		camera_players_by_zlevel = new /list(world.maxz,0)
	while (clients_by_zlevel.len > world.maxz)
		clients_by_zlevel.len--
		dead_players_by_zlevel.len--
		camera_players_by_zlevel.len--

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1

	if (!resumed)
		src.currentrun = GLOB.mob_living_list.Copy()
		// exclude mobs handled by other subsystems
		src.currentrun -= SSmatthios_mobs.matthios_mobs
		src.currentrun -= SSisland_mobs.island_mobs

	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			GLOB.mob_living_list.Remove(L)
			continue

		if(L.stat == DEAD)
			L.DeadLife()
		else
			L.Life(seconds, times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/enhance_mob(mob/living/mob, delve_level = 1)
	if(!affix_system)
		affix_system = new()
	affix_system.enhance_mob(mob, delve_level - 1)
