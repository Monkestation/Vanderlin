
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
	var/list/attack_sounds = list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg')

	COOLDOWN_DECLARE(activity_cooldown)
	/// timer max, when its over we sleep again
	var/sleep_time = 24 SECONDS
	/// when the timer has 16 seconds left (so 8 seconds in), we can eat again
	var/munch_time = 16 SECONDS
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
	if(COOLDOWN_FINISHED(src, activity_cooldown))
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		STOP_PROCESSING(SSobj, src)
		return TRUE
	// we can't munch yet, we're on cooldown
	if(COOLDOWN_TIMELEFT(src, activity_cooldown) > munch_time)
		return
	for(var/mob/living/L as anything in buckled_mobs)
		if(L.status_flags & GODMODE)
			continue
		L.flash_fullscreen("redflash3")
		visible_message(span_danger("[src] starts to rip apart [L]!"))
		playsound(src, pick(attack_sounds), 100, FALSE, -1)
		addtimer(CALLBACK(src, PROC_REF(munch), L), sleep_time - munch_time)
		COOLDOWN_START(src, activity_cooldown, sleep_time)
		return
	//if we made it this far there's no one buckled or theyre eating
	for(var/obj/item/F in view(1, src))
		if(!is_type_in_list(F, eatablez))
			continue
		if(isbodypart(F))
			var/obj/item/bodypart/BP = F
			if(BP.status == BODYPART_ROBOTIC)
				continue // they're still gonna eat that wooden arm off you as a carbon
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(F)
		COOLDOWN_START(src, activity_cooldown, sleep_time)
		return

/obj/structure/flora/grass/maneater/real/proc/munch(mob/living/L)
	if(!(L?.buckled == src))
		return
	playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		var/obj/item/bodypart/limb = C.get_bodypart_complex(list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)) || C.get_bodypart(BODY_ZONE_HEAD)
		if(limb)
			if(limb.dismember())
				qdel(limb)
			return
	L.gib(TRUE,TRUE,TRUE,TRUE) //no organs but drops all the items assuming its carbon

/obj/structure/flora/grass/maneater/real/update_icon_state()
	. = ..()
	if(obj_broken)
		icon_state = "maneater-dead"
	else if(COOLDOWN_FINISHED(src, activity_cooldown))
		icon_state = "maneater-hidden"
	else
		icon_state = "maneater"

/obj/structure/flora/grass/maneater/real/update_name()
	. = ..()
	if(obj_broken || !COOLDOWN_FINISHED(src, activity_cooldown))
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
	if(COOLDOWN_TIMELEFT(src, activity_cooldown) > munch_time)
		return // we just ate so we don't care
	var/list/around = view(src, 1) // scan for enemies
	if(!(AM in around))
		return
	if(isliving(AM))
		var/mob/living/L = AM
		if(COOLDOWN_FINISHED(src, activity_cooldown) && L.m_intent == MOVE_INTENT_SNEAK)
			return
		if(L.status_flags & GODMODE)
			return
		if(L.buckling)
			return // Something else is buckling them, maybe another maneater even
		buckle_mob(L, TRUE, check_loc = FALSE)
		START_PROCESSING(SSobj, src)
		if(!HAS_TRAIT(L, TRAIT_NOPAIN))
			L.emote("painscream", forced = TRUE)
		visible_message(span_danger("[src] snatches [L]!"))
		playsound(src, pick(attack_sounds), 100, FALSE, -1)
		COOLDOWN_START(src, activity_cooldown, sleep_time)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		return
	if(is_type_in_list(AM, eatablez))
		if(isbodypart(AM))
			var/obj/item/bodypart/BP = AM
			if(BP.status == BODYPART_ROBOTIC)
				return
		START_PROCESSING(SSobj, src)
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(AM)
		COOLDOWN_START(src, activity_cooldown, sleep_time)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/structure/flora/grass/maneater/real/attackby(obj/item/W, mob/user, list/modifiers)
	. = ..()
	if(COOLDOWN_TIMELEFT(src, activity_cooldown) < munch_time)
		COOLDOWN_START(src, activity_cooldown, munch_time)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
