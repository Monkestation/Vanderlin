/datum/component/malaguero
	var/base_range = 2
	var/stress_range = 1

	COOLDOWN_DECLARE(pulse)
	var/pulse_cooldown = 30 SECONDS


/datum/component/malaguero/Initialize(range, stress_scaling, cooldown)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	base_range = range
	stress_range = stress_scaling
	pulse_cooldown = cooldown
	COOLDOWN_START(src, pulse, pulse_cooldown)

/datum/component/malaguero/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(stress_pulse))

/datum/component/malaguero/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_HUMAN_LIFE))

/datum/component/malaguero/proc/stress_pulse(mob/living/carbon/human/harbinger)
	SIGNAL_HANDLER
	if(!COOLDOWN_FINISHED(src, pulse))
		return
	var/harbinger_stress = harbinger.get_stress_amount()
	var/stress = 0
	if(harbinger_stress < STRESS_NEUTRAL)
		if(harbinger_stress <= STRESS_GOOD)
			stress--
		if(harbinger_stress <= STRESS_VGOOD)
			stress--
	else if(harbinger_stress > STRESS_NEUTRAL)
		if(harbinger_stress >= STRESS_BAD)
			stress++
		if(harbinger_stress >= STRESS_VBAD)
			stress++
		if(harbinger_stress >= STRESS_INSANE)
			stress++
	var/range = max(0, base_range + (stress * stress_range))
	for(var/mob/living/carbon/afflicted in view(get_turf(harbinger), range))
		if(afflicted == harbinger)
			continue
		afflicted.add_stress(/datum/stress_event/malaguero)
	COOLDOWN_START(src, pulse, pulse_cooldown)



