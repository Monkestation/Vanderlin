/obj/structure/flora/grass/tangler
	name = "twisting shrub"
	desc = "Green, spiky and....I think I saw it move!"
	icon = 'icons/roguetown/mob/monster/tangler.dmi'
	icon_state = "tangler_hidden"
	var/faction = list(FACTION_PLANTS)

/obj/structure/flora/grass/tangler/update_icon()
	return

/obj/structure/flora/grass/tangler/real
	max_integrity = 40
	integrity_failure = 0.15
	attacked_sound = 'sound/misc/woodhit.ogg'
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/list/eatablez = list(/obj/item/organ, /obj/item/reagent_containers/food/snacks/meat, /obj/item/compost, /obj/item/natural/poo)
	var/last_eat
	var/aggroed = TRUE
	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor

/obj/structure/flora/grass/tangler/real/Initialize()
	. = ..()
	proximity_monitor = new(src, 1)

/obj/structure/flora/grass/tangler/real/Destroy()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/flora/grass/tangler/real/obj_break(damage_flag, silent)
	..()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/flora/grass/tangler/real/process()
	if(!has_buckled_mobs())
		if(world.time > last_eat + 5)
			var/list/around = view(1, src)
			for(var/mob/living/M in around)
				HasProximity(M)
				return
			for(var/obj/item/F in around)
				if(is_type_in_list(F, eatablez))
					aggroed = world.time
					last_eat = world.time
					playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
					qdel(F)
					return
		if(world.time > aggroed + 10 SECONDS)
			aggroed = 0
			update_icon()
			STOP_PROCESSING(SSobj, src)
			return TRUE

/obj/structure/flora/grass/tangler/real/update_icon()
	if(obj_broken)
		name = "dry vine"
		desc = ""
		icon_state = "tangler-dead"
		return
	if(aggroed)
		name = "twisting vine"
		var/list/icon_states = list("tangler_1", "tangler_2", "tangler_3")
		icon_state = pick(icon_states)
	else
		name = "twisting shrub"
		icon_state = "tangler-hidden"

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
	if(world.time > last_eat + 5)
		var/list/around = view(src, 1)
		if(!(AM in around))
			return
		if(istype(AM, /mob/living))
			var/mob/living/L = AM
			if(FACTION_PLANTS in L.faction)
				return
			if(!aggroed)
				if(L.m_intent != MOVE_INTENT_RUN)
					return
			aggroed = world.time
			last_eat = world.time
			update_icon()
			buckle_mob(L, TRUE, check_loc = FALSE)
			START_PROCESSING(SSobj, src)
			if(!HAS_TRAIT(L, TRAIT_NOPAIN))
				L.emote("painscream", forced = FALSE)
			src.visible_message("<span class='danger'>[src] snatches [L]!</span>")
			playsound(src.loc, "plantcross", 100, FALSE, -1)
		if(istype(AM, /obj/item))
			if(is_type_in_list(AM, eatablez))
				aggroed = world.time
				last_eat = world.time
				START_PROCESSING(SSobj, src)
				update_icon()
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				qdel(AM)
				return
			aggroed = world.time
