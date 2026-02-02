GLOBAL_LIST_INIT(vanderlin_weather, list(PARTICLEWEATHER_RAIN))
SUBSYSTEM_DEF(ParticleWeather)
	name = "Particle Weather"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/elligble_weather = list()
	var/datum/particle_weather/runningWeather
	var/datum/weather_effect/weather_special_effect
	// var/list/next_hit = list() //Used by barometers to know when the next storm is coming

	var/particles/weather/particleEffect
	var/obj/weatherEffect

	var/list/turfs_to_process = list()
	var/list/weathered_turfs = list()

	var/datum/forecast/selected_forecast

/datum/controller/subsystem/ParticleWeather/fire()
	// process active weather
	if(runningWeather)
		if(runningWeather.running)
			runningWeather.tick()
			for(var/mob/act_on as anything in GLOB.mob_living_list) //yikes. this should probably be a client scan not all mobs. it already checks for minds
				runningWeather.try_weather_act(act_on)
			for(var/obj/act_on as anything in GLOB.weather_act_upon_list)
				runningWeather.weather_obj_act(act_on)

			if(weather_special_effect)
				if(!length(turfs_to_process))
					if(!weathered_turfs)
						return
					turfs_to_process = weathered_turfs.Copy()
				for(var/turf/turf in turfs_to_process)
					if(QDELETED(weather_special_effect))
						break
					turfs_to_process -= turf
					if(prob(weather_special_effect.probability))
						turf.apply_weather_effect(weather_special_effect)
					CHECK_TICK_LOW

//This has been mangled - currently only supports 1 weather effect serverwide so I can finish this
/datum/controller/subsystem/ParticleWeather/Initialize(start_timeofday)
	for(var/datum/particle_weather/W as anything in subtypesof(/datum/particle_weather))
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (probability && (target_trait in GLOB.vanderlin_weather)) //TODO VANDERLIN: Map trait this.
			LAZYINITLIST(elligble_weather)
			elligble_weather[W] = probability

	switch(SSmapping.config.map_name)
		if("Rosewood")
			selected_forecast = new /datum/forecast/rosewood()
		else
			selected_forecast = new /datum/forecast/vanderlin()
	selected_forecast.set_ambient_temperature(SSnightshift.current_tod ? SSnightshift.current_tod : settod())
	return ..()

/datum/controller/subsystem/ParticleWeather/proc/run_weather(datum/particle_weather/weather_datum_type, force = 0)
	if(runningWeather)
		if(force)
			end_current_weather()
		else
			return
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/particle_weather))
			var/datum/particle_weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/particle_weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	runningWeather = new weather_datum_type()

	if(force)
		runningWeather.start()
	else
		var/randTime = rand(0, 6000) + initial(runningWeather.weather_duration_upper)
		addtimer(CALLBACK(runningWeather, TYPE_PROC_REF(/datum/particle_weather, start)), randTime, TIMER_UNIQUE|TIMER_STOPPABLE) //Around 0-10 minutes between weathers

/datum/controller/subsystem/ParticleWeather/proc/end_current_weather()
	runningWeather?.end()

/datum/controller/subsystem/ParticleWeather/proc/get_current_weather()
	return runningWeather || "none"

/datum/controller/subsystem/ParticleWeather/proc/make_eligible(possible_weather)
	elligble_weather = possible_weather
// 	next_hit = null

/datum/controller/subsystem/ParticleWeather/proc/getweatherEffect()
	if(!weatherEffect)
		weatherEffect = new /obj()
		weatherEffect.particles = particleEffect
		weatherEffect.filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
		weatherEffect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	return weatherEffect

/datum/controller/subsystem/ParticleWeather/proc/SetparticleEffect(particles/P, blend_type, filter_type, secondary_filter_type)
	particleEffect = P
	weatherEffect.particles = particleEffect
	if(!blend_type)
		weatherEffect.blend_mode = BLEND_DEFAULT
	else
		weatherEffect.blend_mode = blend_type
	weatherEffect.filters = list()
	weatherEffect.filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
	if(filter_type)
		weatherEffect.filters += filter_type
	if(secondary_filter_type)
		weatherEffect.filters += secondary_filter_type

/datum/controller/subsystem/ParticleWeather/proc/stopWeather()
	for(var/obj/act_on as anything in GLOB.weather_act_upon_list)
		act_on.weather = FALSE
	weatherEffect.particles = null
	QDEL_NULL(runningWeather)
	particleEffect = null
	QDEL_NULL(weather_special_effect)

/datum/controller/subsystem/ParticleWeather/proc/check_forecast(time_of_day)
	if(GLOB.forecast)
		GLOB.forecast = null
		return
	var/datum/particle_weather/weather = selected_forecast.pick_weather(time_of_day)
	if(!weather)
		return
	if(runningWeather && runningWeather.target_trait == initial(weather.target_trait))
		return
	GLOB.forecast = initial(weather.forecast_tag)
	run_weather(weather)

