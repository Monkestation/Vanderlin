/datum/forecast/vanderlin
	day_weather = list(/datum/particle_weather/rain/rain_gentle = 10)
	dawn_weather = list(/datum/particle_weather/rain/rain_gentle = 10)
	dusk_weather = list(/datum/particle_weather/rain/rain_gentle = 20, /datum/particle_weather/rain/rain_storm = 12, /datum/particle_weather/fog = 4)
	night_weather = list(/datum/particle_weather/rain/rain_gentle = 20, /datum/particle_weather/rain/rain_storm = 12, /datum/particle_weather/fog = 4)

	temp_ranges = list(
		DAWN = list(10, 20),      // Cool morning
		DAY = list(20, 30),       // Warm day
		DUSK = list(15, 25),      // Warm evening
		NIGHT = list(8, 15),      // Cool night
	)

