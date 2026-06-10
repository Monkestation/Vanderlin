/datum/component/pollutant
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// The pollutant emitted
	var/datum/pollutant/pollutant_type
	/// How long the pollutant lasts
	var/expiry_time

/datum/component/pollutant/Initialize(type, expiry_time)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.pollutant_type = new type
	src.expiry_time = world.time + expiry_time
	START_PROCESSING(SSobj, src)

/datum/component/pollutant/Destroy()
	if(ismob(parent))
		to_chat(parent, span_notice("The smell that lingered on your body fades."))
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/pollutant/process(seconds_per_tick)
	if(world.time >= expiry_time)
		qdel(src)
		return
	pollutant_type.on_life(parent, seconds_per_tick)
