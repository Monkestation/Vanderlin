/obj/structure/meatvine/healing_well
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "heal_pool"
	name = "healing well"
	desc = "A pulsating mass of flesh that emanates a regenerative aura."
	density = FALSE
	opacity = FALSE
	pass_flags = LETPASSTHROW
	max_integrity = 30
	resistance_flags = CAN_BE_HIT
	layer = LOW_SIGIL_LAYER
	var/obj/structure/meatvine/floor/floor_vine = null
	var/heal_range = 3
	var/brute_heal_amount = 2
	var/burn_heal_amount = 2
	var/toxin_heal_amount = 1
	var/suffocation_heal_amount = 1
	var/is_being_drained = FALSE
	var/mob/living/simple_animal/hostile/retaliate/meatvine/drainer = null

/obj/structure/meatvine/healing_well/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	floor_vine = locate(/obj/structure/meatvine/floor) in T

	if(!floor_vine)
		// No floor vine, we die
		qdel(src)
		return INITIALIZE_HINT_QDEL

	RegisterSignal(floor_vine, COMSIG_PARENT_QDELETING, PROC_REF(on_floor_destroyed))
	AddComponent(/datum/component/aura_healing, \
		range = heal_range, \
		requires_visibility = TRUE, \
		brute_heal = brute_heal_amount, \
		burn_heal = burn_heal_amount, \
		toxin_heal = toxin_heal_amount, \
		suffocation_heal = suffocation_heal_amount, \
		simple_heal = 2, \
		healing_color = "#ff6533", \
		limit_to_trait = TRAIT_PUTRID, \
	)

	set_light(3, 2, 2, l_color = "#ff6533")

	return .

/obj/structure/meatvine/healing_well/Destroy()
	if(floor_vine)
		UnregisterSignal(floor_vine, COMSIG_PARENT_QDELETING)
	floor_vine = null
	return ..()


/obj/structure/meatvine/healing_well/proc/start_drain(mob/living/simple_animal/hostile/retaliate/meatvine/draining_mob)
	is_being_drained = TRUE
	drainer = draining_mob
	qdel(GetComponent(/datum/component/aura_healing))
	animate(src, alpha = 100, time = 1 SECONDS)
	set_light(1, 1, 1, l_color = "#ff6533")

/obj/structure/meatvine/healing_well/proc/finish_drain()
	is_being_drained = FALSE
	drainer = null
	icon_state = "heal_pool_drained"

	addtimer(CALLBACK(src, PROC_REF(restore_healing)), HEALING_WELL_DRAIN_COOLDOWN)

/obj/structure/meatvine/healing_well/proc/restore_healing()
	if(QDELETED(src) || is_being_drained)
		return
	icon_state = "heal_pool"

	AddComponent(/datum/component/aura_healing, \
		range = heal_range, \
		requires_visibility = TRUE, \
		brute_heal = brute_heal_amount, \
		burn_heal = burn_heal_amount, \
		toxin_heal = toxin_heal_amount, \
		suffocation_heal = suffocation_heal_amount, \
		simple_heal = 2, \
		healing_color = "#ff6533", \
		limit_to_trait = TRAIT_PUTRID, \
	)
	animate(src, alpha = 255, time = 1 SECONDS)
	set_light(3, 2, 2, l_color = "#ff6533")

/obj/structure/meatvine/healing_well/proc/on_floor_destroyed(datum/source)
	SIGNAL_HANDLER
	floor_vine = null
	qdel(src)

/obj/structure/meatvine/healing_well/grow()
	if(!master)
		return
	if(master.isdying)
		return
	if(!floor_vine || QDELETED(floor_vine))
		qdel(src)
		return
	// Healing wells don't grow on their own, they're built
	return
