/datum/mapGenerator

	//Map information
	var/list/map = list()

	//mapGeneratorModule information
	var/list/modules = list()

	var/buildmode_name = "Undocumented"

/datum/mapGenerator/New()
	..()
	if(buildmode_name == "Undocumented")
		buildmode_name = copytext("[type]", 20)	// / d a t u m / m a p g e n e r a t o r / = 20 characters.

#ifndef TESTING
	initialiseModules()
#endif
//Defines the region the map represents, sets map
//Returns the map
/datum/mapGenerator/proc/defineRegion(turf/Start, turf/End, replace = 0)
	if(!checkRegion(Start, End))
		return 0

	if(replace)
		undefineRegion()
	map |= block(Start,End)
	return map


//Defines the region the map represents, as a CIRCLE!, sets map
//Returns the map
/datum/mapGenerator/proc/defineCircularRegion(turf/Start, turf/End, replace = 0)
	if(!checkRegion(Start, End))
		return 0

	var/centerX = max(abs((End.x+Start.x)/2),1)
	var/centerY = max(abs((End.y+Start.y)/2),1)

	var/lilZ = min(Start.z,End.z)
	var/bigZ = max(Start.z,End.z)

	var/sphereMagic = max(abs(bigZ-(lilZ/2)),1) //Spherical maps! woo!

	var/radius = abs(max(centerX,centerY)) //take the biggest displacement as the radius

	if(replace)
		undefineRegion()

	//Even sphere correction engage
	var/offByOneOffset = 1
	if(bigZ % 2 == 0)
		offByOneOffset = 0

	for(var/i = lilZ, i <= bigZ+offByOneOffset, i++)
		var/theRadius = radius
		if(i != sphereMagic)
			theRadius = max(radius/max((2*abs(sphereMagic-i)),1),1)


		map |= circle_range(locate(centerX,centerY,i),theRadius)


	return map


//Empties the map list, he's dead jim.
/datum/mapGenerator/proc/undefineRegion()
	map = list() //bai bai


//Checks for and Rejects bad region coordinates
//Returns 1/0
/datum/mapGenerator/proc/checkRegion(turf/Start, turf/End)
	. = 1

	if(!Start || !End)
		return 0 //Just bail

	if(Start.x > world.maxx || End.x > world.maxx)
		. = 0
	if(Start.y > world.maxy || End.y > world.maxy)
		. = 0
	if(Start.z > world.maxz || End.z > world.maxz)
		. = 0


//Requests the mapGeneratorModule(s) to (re)generate
/datum/mapGenerator/proc/generate()
	SHOULD_NOT_SLEEP(TRUE)
	syncModules()
	if(!LAZYLEN(modules))
		return
	for(var/datum/mapGeneratorModule/mod in modules)
		mod.generate()


//Requests the mapGeneratorModule(s) to (re)generate this one turf
/datum/mapGenerator/proc/generateOneTurf(turf/T)
	if(!T)
		return
	syncModules()
	if(!modules || !modules.len)
		return
	for(var/datum/mapGeneratorModule/mod in modules)
		INVOKE_ASYNC(mod, TYPE_PROC_REF(/datum/mapGeneratorModule, place), T)


//Replaces all paths in the module list with actual module datums
/datum/mapGenerator/proc/initialiseModules()
	for(var/path in modules)
		if(ispath(path))
			modules.Remove(path)
			modules |= new path
	syncModules()


//Sync mapGeneratorModule(s) to mapGenerator
/datum/mapGenerator/proc/syncModules()
	for(var/datum/mapGeneratorModule/mod in modules)
		mod.sync(src)
