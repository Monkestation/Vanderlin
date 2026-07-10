/*
 * A component to allow us to breed. Both parents need this (male initiates through an attack, female gives birth)
 */
/datum/component/breed
	/// additional mobs we can breed with
	var/list/can_breed_with
	///weighted list path of the baby
	var/list/baby_path
	///time to wait after breeding
	var/breed_timer
	///AI key we set when we're ready to breed
	var/breed_key = BB_BREED_READY
	///are we ready to breed?
	var/ready_to_breed = TRUE
	///callback after we give birth to the child. female onlyy.
	var/datum/callback/post_birth
	///callback that overrides the birth ending. prevents baby_path spawn and post_birth callback. female only.
	var/datum/callback/override_baby
	var/pregnant = FALSE

/datum/component/breed/Initialize(list/can_breed_with = list(), breed_timer = 40 SECONDS, list/baby_path = list(), post_birth, override_baby)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(ishuman(parent)) //sin detected
		return COMPONENT_INCOMPATIBLE

	if(!islist(baby_path) && !override_baby)
		stack_trace("attempted to add a breeding component with invalid baby path!")
		return

	src.can_breed_with = can_breed_with
	src.breed_timer = breed_timer
	src.baby_path = baby_path
	src.post_birth = post_birth
	src.override_baby = override_baby


/datum/component/breed/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(breed_with_partner))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_IMPREGNATE, PROC_REF(impregnate))
	ADD_TRAIT(parent, TRAIT_MOB_BREEDER, REF(src))
	var/mob/living/parent_mob = parent
	parent_mob.ai_controller?.set_blackboard_key(breed_key, ready_to_breed)
	parent_mob.ai_controller?.set_blackboard_key(BB_BABIES_PARTNER_TYPES, can_breed_with)
	parent_mob.ai_controller?.set_blackboard_key(BB_BABIES_CHILD_TYPES, baby_path)

/datum/component/breed/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HOSTILE_PRE_ATTACKINGTARGET)
	REMOVE_TRAIT(parent, TRAIT_MOB_BREEDER, REF(src))
	post_birth = null

/// Called by component on male source
/datum/component/breed/proc/breed_with_partner(mob/living/source, mob/living/target)
	if(source.cmode)
		return

	if(!is_type_in_list(target, can_breed_with))
		return

	if(!HAS_TRAIT(target, TRAIT_MOB_BREEDER) || target.gender == source.gender)
		return

	if(!ready_to_breed)
		return COMPONENT_HOSTILE_NO_PREATTACK

	var/datum/component/breed/target_breed = target.GetComponent(/datum/component/breed)
	if(!target_breed || !target_breed.ready_to_breed)
		return
	if(!is_type_in_list(source, target_breed.can_breed_with))
		return

	new /obj/effect/temp_visual/heart(get_turf(source))
	toggle_status(source)
	addtimer(CALLBACK(src, PROC_REF(toggle_status), source), breed_timer)
	if(isanimal(source))
		var/mob/living/simple_animal/simple_animal = source
		SEND_SIGNAL(simple_animal, COMSIG_MOB_DRAIN_HUNGER, 0.2)

	SEND_SIGNAL(target, COMSIG_IMPREGNATE, source)
	return COMPONENT_HOSTILE_NO_PREATTACK

/datum/component/breed/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(pregnant)
		examine_list += span_green("They are pregnant!")

/// Called by component on female source
/datum/component/breed/proc/impregnate(mob/living/source, mob/living/target)
	if(pregnant)
		return

	pregnant = TRUE
	toggle_status(source)
	new /obj/effect/temp_visual/heart(get_turf(source))
	addtimer(CALLBACK(src, PROC_REF(birth_baby), source, target), breed_timer)
	if(isanimal(source))
		var/mob/living/simple_animal/simple_animal = source
		SEND_SIGNAL(simple_animal, COMSIG_MOB_DRAIN_HUNGER, 0.4)

/// Called by component on female source
/datum/component/breed/proc/birth_baby(mob/living/source, mob/living/target)
	var/turf/delivery_destination = get_turf(source)
	new /obj/effect/temp_visual/heart(delivery_destination)
	record_round_statistic(STATS_ANIMALS_BRED)
	pregnant = FALSE
	addtimer(CALLBACK(src, PROC_REF(toggle_status), source), breed_timer)

	if(override_baby)
		override_baby.Invoke()
		return

	var/picked_baby_path = pickweight(baby_path)
	var/mob/living/baby = new picked_baby_path(delivery_destination)
	SEND_SIGNAL(source, COMSIG_FRIENDSHIP_PASS_FRIENDSHIP, baby)
	SEND_SIGNAL(source, COMSIG_HAPPINESS_PASS_HAPPINESS, baby)
	post_birth?.Invoke(baby, target)

/datum/component/breed/proc/toggle_status(mob/living/source)
	ready_to_breed = !ready_to_breed
	source.ai_controller?.set_blackboard_key(BB_BREED_READY, ready_to_breed)

