/**
 * I absolutely HATE this but i could not get this to work with defines, because i don't know how to get
 * a return from a fucking define - i gave up and turned all of the defines into procs too
 */
/mob/living/proc/increase_chem_effect(chem_effect, power, source)
	if(power < 0)
		return decrease_chem_effect(chem_effect, abs(power), source)
	else if(!(LAZYACCESSASSOC(chem_effects, chem_effect, source)))
		return add_chem_effect(chem_effect, power, source)
	chem_effects[chem_effect][source] += power
	SEND_SIGNAL(src, SIGNAL_INCREASECHEMEFFECT(chem_effect), power, source)

/mob/living/proc/decrease_chem_effect(chem_effect, power, source)
	if(power < 0)
		return increase_chem_effect(chem_effect, abs(power), source)
	else if(!(LAZYACCESSASSOC(chem_effects, chem_effect, source)))
		return remove_chem_effect(chem_effect, source)
	chem_effects[chem_effect][source] -= power
	SEND_SIGNAL(src, SIGNAL_DECREASECHEMEFFECT(chem_effect), power, source)

/mob/living/proc/add_chem_effect(chem_effect, power, source)
	if(!chem_effects)
		chem_effects = list()
		chem_effects[chem_effect] = list()
		chem_effects[chem_effect][source] = power
		SEND_SIGNAL(src, SIGNAL_ADDCHEMEFFECT(chem_effect), power, source)
		return
	if(chem_effects[chem_effect])
		chem_effects[chem_effect][source] = power
	else
		chem_effects[chem_effect] = list()
		chem_effects[chem_effect][source] = power
		SEND_SIGNAL(src, SIGNAL_ADDCHEMEFFECT(chem_effect), power, source)

/mob/living/proc/remove_chem_effect(chem_effect, list/sources)
	var/list/srcs
	if(sources && !islist(sources))
		srcs = list(sources)
	else
		srcs = sources
	if(!LAZYACCESS(chem_effects, chem_effect))
		return
	for(var/source in chem_effects[chem_effect])
		if(!srcs || (source in srcs))
			chem_effects[chem_effect] -= source
	if(!length(chem_effects[chem_effect]))
		chem_effects -= chem_effect
		SEND_SIGNAL(src, SIGNAL_REMOVECHEMEFFECT(chem_effect), sources)
	if(!length(chem_effects))
		chem_effects = null

/mob/living/proc/get_chem_effect(chem_effect)
	. = 0
	if(LAZYACCESS(chem_effects, chem_effect))
		for(var/source in chem_effects[chem_effect])
			. += chem_effects[chem_effect][source]

/mob/living/proc/get_chem_effect_from(chem_effect, list/sources)
	. = 0
	if(!islist(sources))
		sources = list(sources)
	if(!LAZYACCESS(chem_effects, chem_effect))
		return
	for(var/source in chem_effects[chem_effect])
		if(!(source in sources))
			continue
		. += chem_effects[chem_effect][source]
