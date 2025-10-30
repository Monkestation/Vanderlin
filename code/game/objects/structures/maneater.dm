
/obj/structure/flora/grass/maneater
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	num_random_icons = 0

/obj/structure/flora/grass/maneater/real
	icon_state = MAP_SWITCH("maneater-hidden", "maneater")
	max_integrity = 100
	integrity_failure = 0.15
	attacked_sound = list('sound/vo/mobs/plant/pain (1).ogg','sound/vo/mobs/plant/pain (2).ogg','sound/vo/mobs/plant/pain (3).ogg','sound/vo/mobs/plant/pain (4).ogg')
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/list/eatablez = list(/obj/item/bodypart, /obj/item/organ, /obj/item/reagent_containers/food/snacks/meat)
	var/last_eat
	var/aggroed = FALSE

	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor

/obj/structure/flora/grass/maneater/real/Initialize()
	. = ..()
	proximity_monitor = new(src, 1)

/obj/structure/flora/grass/maneater/real/Destroy()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	. = ..()

/obj/structure/flora/grass/maneater/real/atom_break(damage_flag)
	. = ..()
	QDEL_NULL(proximity_monitor)
	unbuckle_all_mobs()
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/structure/flora/grass/maneater/real/atom_fix()
	. = ..()
	proximity_monitor = new(src, 1)

/obj/structure/flora/grass/maneater/real/process()
	if(!has_buckled_mobs())
		if(world.time > last_eat + 8 SECONDS)
			var/list/around = view(1, src)
			for(var/obj/item/F in around)
				if(is_type_in_list(F, eatablez))
					aggroed = world.time
					last_eat = world.time
					playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
					qdel(F)
					return
		if(world.time > aggroed + 30 SECONDS)
			aggroed = 0
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			STOP_PROCESSING(SSobj, src)
			return TRUE
		return
	for(var/mob/living/L as anything in buckled_mobs)
		if(world.time > last_eat + 8 SECONDS)
			if(L.status_flags & GODMODE)
				continue
			last_eat = world.time
			L.flash_fullscreen("redflash3")
			playsound(src.loc, pick('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				src.visible_message("<span class='danger'>[src] starts to rip apart [C]!</span>")
				spawn(8 SECONDS)
					if(C && (C.buckled == src))
						var/obj/item/bodypart/limb
						var/list/limb_list = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
						for(var/zone in limb_list)
							limb = C.get_bodypart(zone)
							if(limb)
								playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
								limb.dismember()
								qdel(limb)
								return
						limb = C.get_bodypart(BODY_ZONE_HEAD)
						if(limb)
							playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
							limb.dismember()
							qdel(limb)
							return
						limb = C.get_bodypart(BODY_ZONE_CHEST)
						if(limb)
							if(!limb.dismember())
								C.death()
								C.gib()
							return
			else
				src.visible_message("<span class='danger'>[src] starts to rip apart [L]!</span>")
				spawn(8 SECONDS)
					if(L && (L.buckled == src))
						L.gib()
						return

/obj/structure/flora/grass/maneater/real/update_icon_state()
	. = ..()
	if(obj_broken)
		icon_state = "maneater-dead"
	else if(aggroed)
		icon_state = "maneater"
	else
		icon_state = "maneater-hidden"

/obj/structure/flora/grass/maneater/real/update_name()
	. = ..()
	if(obj_broken || aggroed)
		name = "MANEATER"
	else
		name = "grass"

/obj/structure/flora/grass/maneater/real/user_unbuckle_mob(mob/living/M, mob/user)
	if(obj_broken)
		..()
		return
	if(isliving(user))
		var/mob/living/L = user
		var/time2mount = CLAMP((L.STASTR), 1, 99)
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

/obj/structure/flora/grass/maneater/real/user_buckle_mob(mob/living/M, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/flora/grass/maneater/real/HasProximity(atom/movable/AM)
	if(has_buckled_mobs())
		return
	if(world.time > last_eat + 8 SECONDS)
		var/list/around = view(src, 1) // scan for enemies
		if(!(AM in around))
			return
		if(istype(AM, /mob/living))
			var/mob/living/L = AM
			if(!aggroed)
				if(L.m_intent == MOVE_INTENT_SNEAK)
					return
			if(L.status_flags & GODMODE)
				return
			aggroed = world.time
			last_eat = world.time
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			buckle_mob(L, TRUE, check_loc = FALSE)
			START_PROCESSING(SSobj, src)
			if(!HAS_TRAIT(L, TRAIT_NOPAIN))
				L.emote("painscream", forced = TRUE)
			src.visible_message("<span class='danger'>[src] snatches [L]!</span>")
			playsound(src.loc, pick('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		if(istype(AM, /obj/item))
			if(is_type_in_list(AM, eatablez))
				aggroed = world.time
				last_eat = world.time
				START_PROCESSING(SSobj, src)
				update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				qdel(AM)
				return

/obj/structure/flora/grass/maneater/real/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!aggroed)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
	aggroed = world.time
