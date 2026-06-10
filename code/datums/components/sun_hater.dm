
/datum/component/sunlight_vulnerability
	/// How much damage per second in sunlight
	var/burn_damage = 2.5
	/// How much bloodpool drain per second
	var/bloodpool_drain = 5

/datum/component/sunlight_vulnerability/Initialize(damage = 2.5, drain = 5)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	burn_damage = damage
	bloodpool_drain = drain

	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_sunlight))

/datum/component/sunlight_vulnerability/proc/check_sunlight(mob/living/source, seconds_per_tick)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/H = source
	if(!H || H.stat == DEAD || H.advsetup)
		return

	// Only check during day
	if(GLOB.tod != DAY)
		return

	// Check if outside and in light
	if(!isturf(H.loc))
		return

	var/turf/T = H.loc
	if(!T.can_see_sky())
		return

	if(SPT_PROB(3, seconds_per_tick))
		to_chat(H, span_danger("The sunlight burns my flesh!"))

	apply_sunlight_damage(H, seconds_per_tick)

/datum/component/sunlight_vulnerability/proc/apply_sunlight_damage(mob/living/carbon/human/H, seconds_per_tick)
	H.adjust_bloodpool(-bloodpool_drain * seconds_per_tick)

	var/datum/component/vampire_disguise/disguise_comp = H.GetComponent(/datum/component/vampire_disguise)
	if(disguise_comp && disguise_comp.disguised)
		if(H.bloodpool > disguise_comp.min_bloodpool * 2)
			return
		disguise_comp.force_undisguise(H)
		to_chat(H, span_warning("The sunlight breaks my disguise!"))

	// Apply fire damage
	H.fire_act(1, burn_damage * seconds_per_tick)

	// Freak out if on fire
	if(H.on_fire && SPT_PROB(10, seconds_per_tick))
		H.freak_out()
