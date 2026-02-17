/datum/component/malaguero
	/// Base range of our pulse
	var/base_range = 2
	/// Ranged added / removed per level of stress
	var/stress_range = 1
	/// Cooldown time for the pulse
	var/pulse_cooldown = 30 SECONDS
	COOLDOWN_DECLARE(pulse)

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
		
	COOLDOWN_START(src, pulse, pulse_cooldown)
	
	var/harbinger_stress = harbinger.get_stress_amount()
	var/stress = 0
	switch(harbinger_stress)
		if(STRESS_INSANE to INFINITY)
			stress = 3
		if(STRESS_VBAD to STRESS_INSANE)
			stress = 2
		if(STRESS_BAD to STRESS_VBAD)
			stress = 1
		if(STRESS_VGOOD to STRESS_GOOD)
			stress = -1
		if(-INFINITY to STRESS_VGOOD)
			stress = -2
			
	var/range = base_range + (stress * stress_range)
	if(range <= 0)
		return
		
	for(var/mob/afflicted as anything in viewers(harbinger, range))
		if(afflicted == harbinger)
			continue
		afflicted.add_stress(/datum/stress_event/malaguero)
