
/datum/mapGeneratorModule
	var/datum/mapGenerator/mother = null
	var/list/spawnableAtoms = list()
	var/list/spawnableTurfs = list()
	var/clusterMax = 5
	var/clusterMin = 1
	var/clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	var/checkdensity = TRUE
	var/list/excluded_turfs = list()
	var/list/allowed_turfs = list()
	var/list/allowed_areas = list()
	var/include_subtypes = TRUE

//Syncs the module up with its mother
/datum/mapGeneratorModule/proc/sync(datum/mapGenerator/mum)
	mother = null
	if(mum)
		mother = mum


//Generates its spawnable atoms and turfs
/datum/mapGeneratorModule/proc/generate()
	SHOULD_NOT_SLEEP(TRUE)
	if(!mother)
		return
	excluded_turfs = typecacheof(excluded_turfs)
	allowed_turfs = typecacheof(allowed_turfs)
	allowed_areas = typecacheof(allowed_areas, only_root_path = !include_subtypes)
	var/list/map = mother.map
	for(var/turf/T as anything in map)
		place(T)


//Place a spawnable atom or turf on this turf
/datum/mapGeneratorModule/proc/place(turf/T)
	SHOULD_NOT_SLEEP(TRUE)
	var/clustering = FALSE
	var/skipLoopIteration = FALSE

	if(excluded_turfs?[T.type])
		return

	if(!allowed_turfs?[T.type])
		return

	// no need for get_area, that has an extra get_turf we don't need
	if(!allowed_areas?[T.loc?.type])
		return

	// cache these as local (non-datum) vars
	var/list/spawnableTurfs = src.spawnableTurfs
	var/list/spawnableAtoms = src.spawnableAtoms
	// Don't recheck the flags in every iteration.
	var/cluster_same_turfs = clusterCheckFlags & CLUSTER_CHECK_SAME_TURFS
	var/cluster_diff_turfs = clusterCheckFlags & CLUSTER_CHECK_DIFFERENT_TURFS
	//Turfs don't care whether atoms can be placed here
	for(var/turfPath in spawnableTurfs)
		var/spawn_prob = spawnableTurfs[turfPath]
		if(spawn_prob <= 0) // impossible, skip
			continue
		//Clustering!
		if(clusterMax && clusterMin)
			//You're the same as me? I hate you I'm going home
			if(cluster_same_turfs)
				clustering = rand(clusterMin,clusterMax)
				if(locate(turfPath) in RANGE_TURFS(clustering,T))
					continue

			//You're DIFFERENT to me? I hate you I'm going home
			if(cluster_diff_turfs)
				clustering = rand(clusterMin,clusterMax)
				for(var/turf/F as anything in RANGE_TURFS(clustering,T))
					if(!(istype(F,turfPath)))
						skipLoopIteration = TRUE
						break
				if(skipLoopIteration)
					skipLoopIteration = FALSE
					continue

		//Success!
		if(prob(spawn_prob))
			T.ChangeTurf(turfPath)


	//Atoms DO care whether atoms can be placed here
	if(length(spawnableAtoms) && checkPlaceAtom(T)) // don't check if we don't have atoms to place
		// Don't recheck the flags in every loop.
		var/cluster_same_atoms = clusterCheckFlags & CLUSTER_CHECK_SAME_ATOMS
		var/cluster_diff_atoms = clusterCheckFlags & CLUSTER_CHECK_DIFFERENT_ATOMS
		for(var/atomPath in spawnableAtoms)
			var/spawn_prob = spawnableAtoms[atomPath]
			if(spawn_prob <= 0) // impossible, don't bother checking
				continue

			//Clustering!
			if(clusterMax && clusterMin)
				//You're the same as me? I hate you I'm going home
				if(cluster_same_atoms)
					clustering = rand(clusterMin, clusterMax)
					for(var/atom/movable/M in range(clustering,T))
						if(istype(M,atomPath))
							skipLoopIteration = TRUE
							break
					if(skipLoopIteration)
						skipLoopIteration = FALSE
						continue

				//You're DIFFERENT from me? I hate you I'm going home
				if(cluster_diff_atoms)
					clustering = rand(clusterMin, clusterMax)
					for(var/atom/movable/M in range(clustering,T))
						if(!(istype(M,atomPath)))
							skipLoopIteration = TRUE
							break
					if(skipLoopIteration)
						skipLoopIteration = FALSE
						continue

			//Success!
			if(prob(spawn_prob))
				new atomPath(T)

	. = 1


//Checks and Rejects dense turfs
/datum/mapGeneratorModule/proc/checkPlaceAtom(turf/T)
	. = 1
	if(!T)
		return 0
	if(checkdensity)
		if(T.density)
			. = 0
		for(var/atom/A in T)
			if(A.density)
				. = 0
				break


///////////////////////////////////////////////////////////
//                 PREMADE BASE TEMPLATES                //
//           Appropriate settings for usable types       //
// Not usable types themselves, use them as parent types //
// Seriously, don't use these on their own, just parents //
///////////////////////////////////////////////////////////
//The /atom and /turf examples are just so these compile, replace those with your typepaths in your subtypes.

//Settings appropriate for a turf that covers the entire map region, eg a fill colour on a bottom layer in a graphics program.
//Should only have one of these in your mapGenerator unless you want to waste CPU
/datum/mapGeneratorModule/bottomLayer
	clusterCheckFlags = CLUSTER_CHECK_NONE
	spawnableAtoms = list()//Recommended: No atoms.
	spawnableTurfs = list(/turf = 100)

//Settings appropriate for turfs/atoms that cover SOME of the map region, sometimes referred to as a splatter layer.
/datum/mapGeneratorModule/splatterLayer
	clusterCheckFlags = CLUSTER_CHECK_ALL
	spawnableAtoms = list(/atom = 30)
	spawnableTurfs = list(/turf = 30)

//Settings appropriate for turfs/atoms that cover a lot of the map region, eg a dense forest.
/datum/mapGeneratorModule/denseLayer
	clusterCheckFlags = CLUSTER_CHECK_NONE
	spawnableAtoms = list(/atom = 75)
	spawnableTurfs = list(/turf = 75)
