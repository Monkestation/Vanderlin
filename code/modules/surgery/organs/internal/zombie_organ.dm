/obj/item/organ/zombie_infection
	name = "festering ooze"
	desc = "A black web of pus and viscera."
	zone = BODY_ZONE_HEAD
	organ_flags = ORGAN_INDESTRUCTIBLE|ORGAN_NO_VIOLENT_DAMAGE
	organ_efficiency = list(ORGAN_SLOT_ZOMBIE = 100)
	icon_state = "blacktumor"
	var/converts_living = FALSE
	var/timer_id
	///how long we want this to wait before converting
	var/revive_time = 4 MINUTES

/obj/item/organ/zombie_infection/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE, new_zone = null)
	. = ..()
	RegisterSignal(M, COMSIG_BODYPART_ROTTEN_CHANGE, PROC_REF(on_rotten_state_change))
	RegisterSignal(M, COMSIG_ENTER_AREA, PROC_REF(is_valid_starter))
	RegisterSignal(M, COMSIG_MOB_LOGIN, PROC_REF(is_valid_starter))
	on_rotten_state_change()
	if(converts_living)
		START_PROCESSING(SSobj, src)

/obj/item/organ/zombie_infection/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	UnregisterSignal(M, COMSIG_BODYPART_ROTTEN_CHANGE)
	UnregisterSignal(M, COMSIG_ENTER_AREA)
	UnregisterSignal(M, COMSIG_MOB_LOGIN)
	if(timer_id)
		deltimer(timer_id)
	addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living, attempt_infect)), 2 MINUTES)
	STOP_PROCESSING(SSobj, src)

/obj/item/organ/zombie_infection/process(delta_time, times_fired)
	var/valid_part = FALSE
	if(!owner)
		return PROCESS_KILL
	for(var/obj/item/bodypart/part as anything in owner?.bodyparts)
		if(HAS_TRAIT(part, TRAIT_ROTTEN) || !part.is_organic_limb())
			continue
		part.adjust_germ_level((INFECTION_LEVEL_THREE / (10 MINUTES)) * (0.1 * delta_time) * rand(0.5, 1.2))
		valid_part = TRUE

	if(!valid_part)
		STOP_PROCESSING(SSobj, src)

	if(!MOBTIMER_FINISHED(owner, MT_PUKE, 2 MINUTES))
		return

	if(owner.get_blood_volume() && prob(11))
		MOBTIMER_SET(owner, MT_PUKE)
		owner.vomit(1, blood = TRUE, stun = FALSE)

/*
/obj/item/organ/zombie_infection/on_find(mob/living/finder)
	to_chat(finder, "<span class='warning'>Inside the head is a disgusting black \
		web of pus and viscera, bound tightly around the brain like some \
		biological harness.</span>")
*/

/obj/item/organ/zombie_infection/proc/is_valid_starter()
	if(timer_id)
		return
	if(is_in_roguetown(owner) && !has_world_trait(/datum/world_trait/zizo_defilement))
		return
	on_rotten_state_change()

/obj/item/organ/zombie_infection/proc/on_rotten_state_change()
	SIGNAL_HANDLER
	if(!owner)
		if(timer_id)
			deltimer(timer_id)
		return

	if((owner.stat > DEAD) && !converts_living)
		if(timer_id)
			deltimer(timer_id)
		return

	for(var/obj/item/bodypart/part as anything in owner.bodyparts)
		if(!HAS_TRAIT(part, TRAIT_ROTTEN) && part.is_organic_limb())
			if(timer_id)
				deltimer(timer_id)
			return FALSE
	if(timer_id)
		return FALSE
	timer_id = addtimer(CALLBACK(src, PROC_REF(zombify)), revive_time, TIMER_STOPPABLE)

/obj/item/organ/zombie_infection/proc/zombify()
	timer_id = null
	if(!owner)
		return

	if(!converts_living && owner.stat != DEAD)
		return
	owner.wake_zombie()
