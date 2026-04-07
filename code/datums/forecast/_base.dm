/datum/forecast
	var/name = "Base Forecast"

	var/list/dusk_weather = list()
	var/list/day_weather = list()
	var/list/night_weather = list()
	var/list/dawn_weather = list()

	var/dawn_prob  = 25
	var/day_prob  = 5
	var/night_prob  = 40
	var/dusk_prob = 33

	var/list/temp_ranges = list(
		DAWN = list(),
		DAY = list(),
		DUSK = list(),
		NIGHT = list(),
	)

	var/current_ambient_temperature = 0
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
