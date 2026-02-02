/mob/living/simple_animal/hostile/retaliate
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"

	gender = MALE
	faction = list("rogueanimal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	speak_chance = 1

	move_to_delay = 8	// basically speed when player controlled. Lower is faster, a lot faster.
	see_in_dark = 6
	robust_searching = TRUE

	botched_butcher_results = list(/obj/item/alch/bone = 1) // 50% chance to get if skill 0 in butchery
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 1)
	perfect_butcher_results = list(/obj/item/natural/hide = 1) // level 5 butchery bonus

	health = 40
	maxHealth = 40
	food_type = list(/obj/item/reagent_containers/food/snacks/produce)
	pooptype = null

	d_intent = INTENT_DODGE
	minbodytemp = 180
	lose_patience_timeout = 150
	vision_range = 5
	aggro_vision_range = 18
	attack_sound = PUNCHWOOSH
	harm_intent_damage = 5
	environment_smash = ENVIRONMENT_SMASH_NONE
	blood_volume = BLOOD_VOLUME_NORMAL

	tame_chance = 0
	retreat_distance = 10
	minimum_distance = 10
	candodge = TRUE
	dodge_sound = 'sound/combat/dodge.ogg'
	can_saddle = FALSE

	//Should turn this into a flag thing but i dont want to touch too many things
	var/body_eater = FALSE
	//If the creature is doing something they should STOP MOVING.
	var/can_act = TRUE
	//Trolls eat more than wolves
	var/deaggroprob = 10
	var/list/enemies = list()

	var/tier = 0
	var/summon_primer = null

	//taming vars
	var/dendor_taming_chance = DENDOR_TAME_PROB_GURANTEED

/mob/living/simple_animal/hostile/retaliate/Move()
	//If you cant act and dont have a player stop moving.
	if(!can_act && !client)
		return FALSE
	..()

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.used_intent.type == INTENT_HELP && tame)
		if(!owner)
			owner = M
		if(owner != M)
			return
		befriend(M)
		if(length(enemies))
			enemies.Cut()
			visible_message(span_notice("[src] calms down."))

/mob/living/simple_animal/hostile/retaliate
	var/aggressive = 0

/mob/living/simple_animal/hostile/retaliate/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE)
	. = ..()
	if(!.)
		return
	if(damagetype == BRUTE)
		if(damage > 5 && prob(damage * 3))
			emote("pain")
		if(damage > 10)
			Immobilize(clamp(damage/2, 1, 30))
			shake_camera(src, 1, 1)
		if(damage < 10)
			flash_fullscreen("redflash1")
		else if(damage < 20)
			flash_fullscreen("redflash2")
		else if(damage >= 20)
			flash_fullscreen("redflash3")
	if(damagetype == BURN)
		if(damage > 10 && prob(damage))
			emote("pain")
			shake_camera(src, 1, 1)
		if(damage < 10)
			flash_fullscreen("redflash1")
		else if(damage < 20)
			flash_fullscreen("redflash2")
		else if(damage >= 20)
			flash_fullscreen("redflash3")

/mob/living/simple_animal/hostile/retaliate/death(gibbed)
	emote("death")
	..()

/mob/living/simple_animal/hostile/retaliate/Initialize()
	. = ..()
	if(tame)
		tamed(owner)
	ADD_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC) //this causes too many mob issues
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC) //this causes too many mob issues

/mob/living/simple_animal/hostile/retaliate/tamed(mob/user)
	. = ..()
	del_on_deaggro = 0
	aggressive = 0
	if(enemies.len)
		if(prob(23))
			enemies = list()
			src.visible_message(span_info("[src] calms down."))

/mob/living/simple_animal/hostile/retaliate/Life()
	. = ..()
	if(!.)
		return

	if(length(enemies))
		if(prob(5))
			emote("cidle")
		if(prob(deaggroprob))
			if(MOBTIMER_EXISTS(src, MT_AGGROTIME))
				if(MOBTIMER_FINISHED(src, MT_AGGROTIME, 30 SECONDS))
					enemies = list()
					src.visible_message(span_info("[src] calms down."))
			else
				MOBTIMER_SET(src, MT_AGGROTIME)
	else
		if(prob(8))
			emote("idle")
		if(adult_growth)
			growth_prog += 0.5
			if(growth_prog >= 100)
				if(isturf(loc))
					var/mob/living/simple_animal/A = new adult_growth(loc)
					if(tame)
						A.tame = TRUE

					var/datum/component/generic_mob_hunger/old_hunger = GetComponent(/datum/component/generic_mob_hunger)
					var/datum/component/generic_mob_hunger/hunger = A.GetComponent(/datum/component/generic_mob_hunger)
					if(old_hunger && hunger)
						var/old_hunger_percentage = old_hunger.current_hunger / old_hunger.max_hunger
						hunger.current_hunger = hunger.max_hunger * old_hunger_percentage

					qdel(src)
					return

/// Prevents certain items from being targeted as food.
/mob/living/simple_animal/hostile/retaliate/proc/PickyEater(atom/thing_to_eat)
	//Yes we eats this.
	. = TRUE
	if(istype(thing_to_eat, /obj/item/bodypart))
		var/obj/item/bodypart/B = thing_to_eat
		//Oh yuck ew dont eat that.
		if(B.status != BODYPART_ORGANIC)
			return FALSE

/*
/mob/living/simple_animal/hostile/retaliate/beckoned(mob/user)
	if(tame && !stop_automated_movement)
		stop_automated_movement = TRUE
		Goto(user,move_to_delay)
		addtimer(CALLBACK(src, PROC_REF(return_action)), 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/food_tempted(obj/item/O, mob/user)
	if(is_type_in_list(O, food_type) && !stop_automated_movement)
		stop_automated_movement = TRUE
		Goto(user,move_to_delay)
		addtimer(CALLBACK(src, PROC_REF(return_action)), 3 SECONDS)
*/

/mob/living/simple_animal/hostile/retaliate/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)
	. = ..()
	if(!is_type_in_list(A, food_type))
		return

	if(!src.CanReach(A))
		return

	face_atom(A)
	playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
	target = null
	qdel(A)
	SEND_SIGNAL(src, COMSIG_MOB_FEED, A, 30, source)
	return TRUE
