/datum/component/rot
	var/amount = 0
	var/rot_amount_per_process = 10 //1 second
	var/last_process = 0
	var/datum/looping_sound/fliesloop/soundloop

/datum/component/rot/Initialize(new_amount)
	..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_amount)
		amount = new_amount

	soundloop = new(parent, FALSE)

	START_PROCESSING(SSroguerot, src)

/datum/component/rot/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/datum/component/rot/process()
	if(HAS_TRAIT(parent, TRAIT_STASIS)) // No rot
		return
	var/amt2add = rot_amount_per_process
	if(last_process)
		amt2add = ((world.time - last_process)/10) * amt2add
	last_process = world.time
	amount += amt2add
	return

/datum/component/rot/corpse/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/rot/corpse/process()
	if(HAS_TRAIT(parent, TRAIT_STASIS)) // No rot
		return
	var/time_elapsed = last_process ? (world.time - last_process)/10 : 1
	..()
	if(has_world_trait(/datum/world_trait/pestra_mercy))
		amount -= (is_ascendant(PESTRA) ? 2.5 : 5) * time_elapsed

	var/mob/living/carbon/C = parent
	var/is_zombie = IS_DEADITE(C)
	if(C.stat != DEAD && !is_zombie)
		qdel(src)
		return
	if(!(C.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		qdel(src)
		return

	if(!is_zombie && amount > 2 MINUTES)
		if(!has_world_trait(/datum/world_trait/necra_requiem) && (!is_in_roguetown(C) || has_world_trait(/datum/world_trait/zizo_defilement)))
			if(istype(C.loc, /obj/structure/closet/dirthole) || istype(C.loc, /obj/structure/closet/crate/coffin))
				if(amount > 3 MINUTES)
					C.zombie_check()
			else
				C.zombie_check()

	var/findonerotten = FALSE
	var/shouldupdate = FALSE
	for(var/obj/item/bodypart/B in C.bodyparts)
		if(!B.skeletonized && B.is_organic_limb())
			if(!HAS_TRAIT(B, TRAIT_ROTTEN))
				if(amount > 25 MINUTES)
					B.kill_limb()
					findonerotten = TRUE
					shouldupdate = TRUE
					C.change_stat(STAT_CONSTITUTION, -8)
			else
				if(amount > 45 MINUTES)
					if(!is_zombie)
						B.skeletonize()
						ADD_TRAIT(C, TRAIT_NOBLOOD, TRAIT_GENERIC)
						C.change_stat(STAT_CONSTITUTION, -99)
						shouldupdate = TRUE
				else
					findonerotten = TRUE
	if(findonerotten)
		var/turf/open/T = C.loc
		if(istype(T) && amount < 16 MINUTES && !C.has_faction(FACTION_MATTHIOS))
			T.pollute_turf(/datum/pollutant/rot, 9)
			if(soundloop && soundloop.stopped && !is_zombie)
				soundloop.start()
		else
			if(soundloop && !soundloop.stopped)
				soundloop.stop()
	else
		if(soundloop && !soundloop.stopped)
			soundloop.stop()
	if(shouldupdate)
		if(findonerotten)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				H.skin_tone = "878f79" //elf ears
			if(soundloop && soundloop.stopped && !is_zombie)
				soundloop.start()
		C.update_body()

/datum/component/rot/simple
	rot_amount_per_process = 5

/datum/component/rot/simple/process()
	..()
	var/mob/living/L = parent
	var/datum/component/rot/R = src
	if(L.stat != DEAD)
		qdel(R)
		return
	if(amount > 10 MINUTES)
		if(soundloop && soundloop.stopped)
			soundloop.start()
		var/turf/open/T = get_turf(L)
		if(istype(T)  && amount < 16 MINUTES && !L.has_faction(FACTION_MATTHIOS))
			T.pollute_turf(/datum/pollutant/rot, 9)
	if(amount > 20 MINUTES)
		qdel(R)
		return L.dust(drop_items=TRUE)

/datum/component/rot/gibs
	amount = 0.005

/datum/component/rot/stinky_person
	soundloop = null
	var/static/list/clean_moodlets = list(/datum/stress_event/clean, /datum/stress_event/clean_plus)

/datum/component/rot/stinky_person/process()
	..()
	var/mob/living/L = parent
	var/turf/open/T = L.loc
	if(istype(T))
		if(iscarbon(L))
			var/mob/living/carbon/stinky = L
			for(clean_moodlets in stinky.get_positive_stressors())
				return
		T.pollute_turf(/datum/pollutant/rot, 0.25)

/datum/looping_sound/fliesloop
	mid_sounds = list('sound/misc/fliesloop.ogg')
	mid_length = 60
	volume = 50
	extra_range = 0
