/datum/forecast
	var/name = "Base Forecast"

	/// Weather that can happen during dawn, weighted
	var/list/dawn_weather = list()
	/// Weather that can happen during day, weighted
	var/list/day_weather = list()
	/// Weather that can happen during dusk, weighted
	var/list/dusk_weather = list()
	/// Weather that can happen during night, weighted
	var/list/night_weather = list()

	/// Chance of dawn_weather happening when it turns dawn
	var/dawn_prob = 12
	/// Chance of day_weather happening when it turns day
	var/day_prob = 5
	/// Chance of night_weather happening when it turns dusk
	var/dusk_prob = 16
	/// Chance of dusk_weather happening when it turns night
	var/night_prob = 20

	/// Temperature ranges for time of day
	var/list/temp_ranges = list(
		DAWN = list(),
		DAY = list(),
		DUSK = list(),
		NIGHT = list(),
	)

	/// Current chosen temperature
	var/current_ambient_temperature = 0
	/// Last time of day for changing temperature
	var/last_time_of_day

/datum/forecast/proc/pick_weather(time_of_day)
	switch(time_of_day)
		if(DUSK)
			if(!prob(dusk_prob))
				return
			return pickweight(dusk_weather)
		if(NIGHT)
			if(!prob(night_prob))
				return
			return pickweight(night_weather)
		if(DAWN)
			if(!prob(dawn_prob))
				return
			return pickweight(dawn_weather)
		if(DAY)
			if(!prob(day_prob))
				return
			return pickweight(day_weather)

/datum/forecast/proc/set_ambient_temperature(time_of_day)
	if(last_time_of_day == time_of_day)
		return
	last_time_of_day = time_of_day
	var/list/range = temp_ranges[time_of_day]
	current_ambient_temperature = rand(range[1], range[2])
