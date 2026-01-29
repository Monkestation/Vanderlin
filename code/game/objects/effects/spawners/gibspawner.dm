
/obj/effect/gibspawner
	icon = 'icons/effects/blood.dmi'
	icon_state = MAP_SWITCH("", "gib1")
	var/sparks = 0 //whether sparks spread
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/gib_mob_type  //generate a fake mob to transfer DNA from if we weren't passed a mob.
	var/sound_to_play = 'sound/blank.ogg'
	var/sound_vol = 60
	var/list/gibtypes = list() //typepaths of the gib decals to spawn
	var/list/gibamounts = list() //amount to spawn for each gib decal type we'll spawn.
	var/list/gibdirections = list() //of lists of possible directions to spread each gib decal type towards.

/obj/effect/gibspawner/Initialize(mapload, mob/living/source_mob)
	. = ..()

	if(gibtypes.len != gibamounts.len)
		stack_trace("Gib list amount length mismatch!")
		return
	if(gibamounts.len != gibdirections.len)
		stack_trace("Gib list dir length mismatch!")
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(!mapload && sound_to_play && isnum(sound_vol))
		playsound(src, sound_to_play, sound_vol, TRUE)

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, loc)
		s.start()


	var/list/dna_to_add //find the dna to pass to the spawned gibs. do note this can be null if the mob doesn't have blood. add_blood_DNA() has built in null handling.
	if(source_mob)
		dna_to_add = source_mob.get_blood_dna_list() //ez pz
	else if(gib_mob_type)
		var/mob/living/temp_mob = new gib_mob_type(src) //generate a fake mob so that we pull the right type of DNA for the gibs.
		dna_to_add = temp_mob.get_blood_dna_list()
		qdel(temp_mob)
	else
		dna_to_add = list("Non-human DNA" = random_human_blood_type()) //else, generate a random bloodtype for it.


	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc)

				gib.add_blood_DNA(dna_to_add)

				var/list/directions = gibdirections[i]
				if(isturf(loc))
					if(directions.len)
						gib.streak(directions)

	return INITIALIZE_HINT_QDEL


/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2, 2, 1)
	sound_vol = 40

/obj/effect/gibspawner/generic/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	return ..()

/obj/effect/gibspawner/generic/animal
	gib_mob_type = /mob/living/simple_animal/pet



/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/up, /obj/effect/decal/cleanable/blood/gibs/down, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/body, /obj/effect/decal/cleanable/blood/gibs/limb, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/human
	sound_vol = 50

/obj/effect/gibspawner/human/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()


/obj/effect/gibspawner/human/bodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/human/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()
