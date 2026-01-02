SUBSYSTEM_DEF(fake_world)
	name = "Zizo's Fake World"
	flags = SS_NO_INIT
	wait = 3 SECONDS

	var/list/fake_world_constructs = list()
	var/should_bother = FALSE
	var/flicker_cd = 0

/datum/controller/subsystem/fake_world/fire(resumed)
	if(!should_bother || world.time < flicker_cd)
		return

	INVOKE_ASYNC(src, PROC_REF(flicker_world)) // I think if its not async it will break shit
	flicker_cd = world.time + (rand(60, 75) SECONDS)

/datum/controller/subsystem/fake_world/proc/flicker_world()
	for(var/obj/structure/closet/fake_world/closet in fake_world_constructs)
		closet.icon = 'icons/roguetown/misc/structure.dmi'
		closet.icon_state = "closet"

	for(var/obj/structure/fake_door/door in fake_world_constructs)
		door.icon = 'icons/roguetown/misc/doors.dmi'
		door.icon_state = "bars"

	for(var/obj/item/gun/ballistic/revolver/last_resort/gun in fake_world_constructs)
		gun.icon = 'icons/roguetown/weapons/32/bows.dmi'
		gun.icon_state = "bow"

	for(var/turf/closed/wall/mineral/underbrick/wall in fake_world_constructs)
		wall.icon_state = "wood-0"
		wall.icon = 'icons/turf/smooth/walls/wood.dmi'

	for(var/turf/open/floor/plasteel/maniac/floor in fake_world_constructs)
		floor.icon_state = "concretefloor1"
		floor.icon = 'icons/turf/floors.dmi'

	for(var/obj/structure/bed/fake_world/bed in fake_world_constructs)
		bed.icon_state = "inn_bed"
		bed.icon = 'icons/roguetown/misc/structure.dmi'

	for(var/turf/open/floor/underworld/space/sparkle_quiet/fake_world/space in fake_world_constructs)
		space.icon_state = "grass"
		space.icon = 'icons/turf/floors.dmi'

	sleep(rand(0.1, 0.25) SECONDS)

	for(var/atom/movable/listed as anything in fake_world_constructs)
		listed.icon = initial(listed.icon)
		listed.icon_state = initial(listed.icon_state)
