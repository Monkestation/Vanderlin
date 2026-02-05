/obj/effect/decal/cleanable
	gender = PLURAL
	layer = ABOVE_NORMAL_TURF_LAYER
	var/list/random_icon_states = null
	var/blood_state = "" //I'm sorry but cleanable/blood code is ass, and so is blood_DNA
	var/bloodiness = 0 //0-100, amount of blood in this decal, used for making footprints and affecting the alpha of bloody footprints
	var/mergeable_decal = TRUE //when two of these are on a same tile or do we need to merge them into just one?
	var/beauty = 0
	///The type of cleaning required to clean the decal. See __DEFINES/cleaning.dm for the options
	var/clean_type = CLEAN_TYPE_LIGHT_DECAL
	var/wash_precent = 0
	COOLDOWN_DECLARE(wash_cooldown)

/obj/effect/decal/cleanable/Initialize(mapload)
	. = ..()
	if(random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	create_reagents(300)
	if(loc && isturf(loc))
		for(var/obj/effect/decal/cleanable/C in loc)
			if(C != src && C.type == type && !QDELETED(C))
				if (replace_decal(C))
					return INITIALIZE_HINT_QDEL


//	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, AddComponent), /datum/component/beauty, beauty), 0)

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)

/obj/effect/decal/cleanable/Destroy()
	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	return ..()

/obj/effect/decal/cleanable/proc/lazy_init_reagents()
	return

/obj/effect/decal/cleanable/proc/replace_decal(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(mergeable_decal)
		return TRUE

/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user, list/modifiers)
	lazy_init_reagents()
	if(!reagents)
		return ..()
	if(istype(W, /obj/item/reagent_containers/glass))
		if(src.reagents && W.reagents)
			. = 1 //so the containers don't splash their content on the src while scooping.
			if(!src.reagents.total_volume)
				to_chat(user, "<span class='notice'>[src] isn't thick enough to scoop up!</span>")
				return
			if(W.reagents.total_volume >= W.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[W] is full!</span>")
				return
			to_chat(user, "<span class='notice'>I scoop up [src] into [W]!</span>")
			reagents.trans_to(W, reagents.total_volume, transfered_by = user)
			if(!reagents.total_volume) //scooped up all of it
				qdel(src)
				return
	if(W.get_temperature()) //todo: make heating a reagent holder proc
		if(istype(W, /obj/item/clothing/face/cigarette))
			return
		else
			var/hotness = W.get_temperature()
			reagents.expose_temperature(hotness)
			to_chat(user, "<span class='notice'>I heat [name] with [W]!</span>")
	else
		return ..()

/obj/effect/decal/cleanable/ex_act()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			R.on_ex_act()
	..()

/obj/effect/decal/cleanable/fire_act(added, maxstacks)
	if(reagents)
		reagents.expose_temperature(added)
	..()


//Add "bloodiness" of this blood's type, to the human's shoes
//This is on /cleanable because fuck this ancient mess
/obj/effect/decal/cleanable/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.shoes && blood_state && bloodiness)
			var/obj/item/clothing/shoes/S = H.shoes
			if(!S.can_be_bloody)
				return
			var/add_blood = 0
			if(bloodiness >= BLOOD_GAIN_PER_STEP)
				add_blood = BLOOD_GAIN_PER_STEP
			else
				add_blood = bloodiness
			bloodiness -= add_blood
			S.bloody_shoes[blood_state] = min(MAX_SHOE_BLOODINESS,S.bloody_shoes[blood_state]+add_blood)
			S.add_blood_DNA(GET_ATOM_BLOOD_DNA(src))
			S.blood_state = blood_state
			update_appearance(UPDATE_ICON)
			H.update_inv_shoes()

/obj/effect/decal/cleanable/proc/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return bloodiness
	else
		return 0

/obj/effect/decal/cleanable/wash(clean_types)
	. = ..()
	if (. || (clean_types & clean_type))
		qdel(src)
		return TRUE
	return .

/obj/effect/decal/cleanable/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN || !COOLDOWN_FINISHED(src, wash_cooldown))
		return
	COOLDOWN_START(src, wash_cooldown, 7.5 SECONDS)
	wash_precent += min(25, severity / 2)
	alpha = 255 *((100 - wash_precent) * 0.01)
	if(wash_precent >= 100)
		wash(CLEAN_WASH)
