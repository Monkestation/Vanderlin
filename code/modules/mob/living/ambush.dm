// Mobs shouldn't consider their own ambush.
// This should be it's own system. Please.

#define AMBUSH_CHANCE 5

/mob/living/proc/ambushable()
	if(!mind)
		return FALSE
	if(stat) //what?
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	if(!MOBTIMER_FINISHED(src, MT_AMBUSHLAST, 5 MINUTES))
		return FALSE
	return ambushable && !HAS_TRAIT(src, TRAIT_NOAMBUSH)

/mob/living/proc/consider_ambush()
	if(!prob(AMBUSH_CHANCE))
		return
	if(!MOBTIMER_FINISHED(src, MT_AMBUSHCHECK, 15 SECONDS))
		return
	MOBTIMER_SET(src, MT_AMBUSHCHECK)

	if(!ambushable())
		return
	var/area/AR = get_area(src)
	if(!length(AR.ambush_mobs))
		return
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(!(T.type in AR.ambush_types))
		return
	for(var/obj/machinery/light/fueled/RF in view(5, src))
		if(RF.on)
			return
	var/victims = 1
	var/list/victims_list
	for(var/mob/living/V in view(5, src))
		if(V != src)
			if(V.ambushable())
				victims++
				LAZYADD(victims_list, V)
			if(victims > 3)
				return
	var/static/list/valid_targets = list(
		/obj/structure/flora/tree, \
		/obj/structure/flora/shroom_tree, \
		/obj/structure/flora/newtree
	)
	var/list/possible_targets
	for(var/obj/structure/object in oview(5, src)) //do not count the player
		if(is_type_in_list(object, valid_targets))
			LAZYADD(possible_targets, get_turf(object))
	if(!LAZYLEN(possible_targets))
		return
	MOBTIMER_SET(src, MT_AMBUSHLAST)
	for(var/mob/living/V as anything in victims_list)
		MOBTIMER_SET(V, MT_AMBUSHLAST)
	var/spawnedtype = pickweight(AR.ambush_mobs)
	var/mustype = 1
	for(var/i in 1 to clamp(victims, 2, 3))
		var/spawnloc = safepick(possible_targets)
		if(!spawnloc)
			return
		var/mob/spawnedmob = new spawnedtype(spawnloc)
		if(istype(spawnedmob, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/M = spawnedmob
			M.del_on_deaggro = 44 SECONDS
			M.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, src)
		if(istype(spawnedmob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = spawnedmob
			H.del_on_deaggro = 44 SECONDS
			H.last_aggro_loss = world.time
			H.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, src)
			mustype = 2

	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/heart_value = 30
		if(HAS_TRAIT(C, TRAIT_WEAK_HEART))
			heart_value *= 0.5
		if(C.stress >= heart_value && (prob(50)))
			C.heart_attack()
			if(mustype == 1)
				playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
			else
				playsound(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
			shake_camera(src, 2, 2)

#undef AMBUSH_CHANCE
