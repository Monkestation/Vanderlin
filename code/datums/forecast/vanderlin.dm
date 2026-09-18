/datum/forecast/vanderlin
	day_weather = list(/datum/particle_weather/rain/rain_gentle = 1)
	dawn_weather = list(/datum/particle_weather/rain/rain_gentle = 1)
	dusk_weather = list(/datum/particle_weather/rain/rain_gentle = 20, /datum/particle_weather/rain/rain_storm = 12)
	night_weather = list(/datum/particle_weather/rain/rain_gentle = 20, /datum/particle_weather/rain/rain_storm = 12)

	temp_ranges = list(
		DAWN = list(10, 20),      // Cool morning
		DAY = list(20, 30),       // Warm day
		DUSK = list(15, 25),      // Warm evening
		NIGHT = list(8, 15),      // Cool night
	)

