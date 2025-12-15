/obj/structure/flora/grass/tangler
	name = "twisting shrub"
	desc = "Green, spiky and... I think I saw it move!"
	icon = 'icons/roguetown/mob/monster/tangler.dmi'
	icon_state = "tangler_hidden"
	num_random_icons = 0
	var/faction = list(FACTION_PLANTS)

/obj/structure/flora/grass/tangler/real
	max_integrity = 40
	integrity_failure = 0.15
	attacked_sound = 'sound/misc/woodhit.ogg'
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/list/eatablez = list(/obj/item/organ, /obj/item/reagent_containers/food/snacks/meat, /obj/item/fertilizer/compost, /obj/item/natural/poo)
	var/last_eat
	var/aggroed = TRUE
	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor
	var/list/activation_words = list("rise","awake", "rush", "bloom")
	var/list/deactivation_words = list("rest", "sleep", "hush", "hide")
	var/speaking_distance = 4

/obj/structure/flora/grass/tangler/real/Initialize()
	. = ..()
	proximity_monitor = new(src, 1)
	become_hearing_sensitive()
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/structure/flora/grass/tangler/real/Destroy()
	lose_hearing_sensitivity()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/flora/grass/tangler/real/atom_break(damage_flag)
	. = ..()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	STOP_PROCESSING(SSobj, src)
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/structure/flora/grass/tangler/real/atom_fix()
	. = ..()
	proximity_monitor = new(src, 1)

/obj/structure/flora/grass/tangler/real/process()
	if(!has_buckled_mobs())
		if(world.time > last_eat + 5)
			var/list/around = view(1, src)
			for(var/obj/item/F in around)
				if(is_type_in_list(F, eatablez))
					aggroed = world.time
					last_eat = world.time
					playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
					qdel(F)
					return
		if(world.time > aggroed + 15 SECONDS)
			aggroed = 0
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			STOP_PROCESSING(SSobj, src)
			return TRUE

/obj/structure/flora/grass/tangler/real/update_icon_state()
	. = ..()
	if(obj_broken)
		icon_state = "tangler-dead"
	else if(aggroed)
		icon_state = pick("tangler_1", "tangler_2", "tangler_3")
	else
		icon_state = "tangler-hidden"

/obj/structure/flora/grass/tangler/real/update_name()
	. = ..()
	if(obj_broken)
		name = "dry vine"
	else if(aggroed)
		name = "twisting vine"
	else
		name = "twisting shrub"

/obj/structure/flora/grass/tangler/real/update_desc()
	. = ..()
	if(obj_broken)
		desc = ""

/obj/structure/flora/grass/tangler/real/user_unbuckle_mob(mob/living/M, mob/user)
	if(obj_broken)
		..()
		return
	if(isliving(user))
		var/mob/living/L = user
		var/time2mount = CLAMP((L.STASTR * 2), 1, 99)
		user.changeNext_move(CLICK_CD_RAPID)
		if(user != M)
			if(prob(time2mount))
				..()
			else
				user.visible_message("<span class='warning'>[user] tries to pull [M] free of [src]!</span>")
			return
		if(prob(time2mount))
			..()
		else
			user.visible_message("<span class='warning'>[user] tries to break free of [src]!</span>")

/obj/structure/flora/grass/tangler/real/user_buckle_mob(mob/living/M, mob/living/user)
	return

/obj/structure/flora/grass/tangler/real/HasProximity(atom/movable/AM)
	if(has_buckled_mobs())
		return
	if(!(world.time > last_eat + 5 SECONDS) && !aggroed)
		return
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, TRAIT_ENTANGLER_IMMUNE))
			return
		if(FACTION_PLANTS in L.faction)
			return
		if(!aggroed)
			if(L.m_intent != MOVE_INTENT_RUN)
				return
		aggroed = world.time
		last_eat = world.time
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		buckle_mob(L, TRUE, check_loc = FALSE)
		START_PROCESSING(SSobj, src)
		if(!HAS_TRAIT(L, TRAIT_NOPAIN))
			L.emote("painscream", forced = FALSE)
		src.visible_message("<span class='danger'>[src] snatches [L]!</span>")
		playsound(src.loc, "plantcross", 100, FALSE, -1)
	else if(istype(AM, /obj/item))
		if(is_type_in_list(AM, eatablez))
			aggroed = world.time
			last_eat = world.time
			START_PROCESSING(SSobj, src)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
			qdel(AM)
			return
		aggroed = world.time

/obj/structure/flora/grass/tangler/real/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		if(prob(50) && !HAS_TRAIT(mover, TRAIT_BRUSHWALK))
			to_chat(mover, "<span class='danger'>I get stuck in \the [src] for a moment.</span>")
			return FALSE
	else if(istype(mover, /obj/projectile) && prob(30))
		return ..()
	return ..()

/obj/structure/flora/grass/tangler/real/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	if(!isliving(speaker))
		return FALSE
	var/mob/living/L = speaker
	if(get_dist(L, src) > speaking_distance)
		return FALSE
	if(obj_broken)
		return FALSE
	if(!HAS_TRAIT(L, TRAIT_DENDOR_GROWING))
		return FALSE

	var/message2recognize = SANITIZE_HEAR_MESSAGE(raw_message)

	for(var/word in deactivation_words)
		if(findtext(message2recognize, word))
			if(aggroed)
				aggroed = 0
				update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
				unbuckle_all_mobs()
				STOP_PROCESSING(SSobj, src)
				return TRUE

	for(var/word in activation_words)
		if(findtext(message2recognize, word))
			if(!aggroed)
				aggroed = world.time
				last_eat = world.time
				update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
				START_PROCESSING(SSobj, src)
				return TRUE

	return FALSE
