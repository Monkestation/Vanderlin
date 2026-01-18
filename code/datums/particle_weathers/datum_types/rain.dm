
//Rain - goes down
/particles/weather/rain
	icon_state             = "drop"
	color                  = "#ccffff"
	position               = generator("box", list(-500,-256,0), list(400,500,0))
	grow			       = list(-0.01,-0.01)
	gravity                = list(0, -10, 0.5)
	drift                  = generator("circle", 0, 1) // Some random movement for variation
	friction               = 0.3  // shed 30% of velocity and drift every 0.1s
	transform 			   = null // Rain is directional - so don't make it "3D"
	//Weather effects, max values
	maxSpawning            = 250
	minSpawning            = 50
	wind                   = 2
	spin                   = 0 // explicitly set spin to 0 - there is a bug that seems to carry generators over from old particle effects

/datum/particle_weather/rain/try_weather_act(mob/living/L)
	if(!L.mind)
		return
	if(!can_weather(L))
		stop_weather_sound_effect(L)
		return
	weather_sound_effect(L)
	if(can_weather_effect(L))
		weather_act(L)
		var/mob/living/carbon/C = L
		if(!istype(C))
			return
		var/obj/item/clothing/head/hooded/rainhood = C.head
		if(!istype(rainhood))
			C.SoakMob(FULL_BODY, dirty_water = FALSE, rain = TRUE)
		else
			C.SoakMob(FEET, dirty_water = FALSE, rain = TRUE)

/datum/particle_weather/rain/rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/rain
	indoor_weather_sounds = /datum/looping_sound/indoor_rain

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN
	forecast_tag = "rain"

	temperature_modification = -1

/datum/particle_weather/rain/rain_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/storm
	indoor_weather_sounds = /datum/looping_sound/indoor_rain

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_RAIN
	forecast_tag = "rain"

	temperature_modification = -2

	COOLDOWN_DECLARE(thunder)

/datum/particle_weather/rain/rain_storm/tick()
	if(!COOLDOWN_FINISHED(src, thunder))
		return

	var/lightning_strikes = 1
	for(var/i = 1 to lightning_strikes)
		var/atom/lightning_destination
		if(prob(100))
			var/list/viable_players = list()
			for(var/client/client in GLOB.clients)
				if(!client.mob)
					continue
				var/client_z = client.mob.z
				if(!isliving(client.mob))
					continue
				if(!("[client_z]" in GLOB.weatherproof_z_levels))
					if(SSmapping.level_has_any_trait(client_z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
						GLOB.weatherproof_z_levels |= "[client_z]"
				if("[client_z]" in GLOB.weatherproof_z_levels)
					continue
				viable_players += client.mob

			lightning_destination = DEFAULTPICK(viable_players, null)

		if(lightning_destination)
			var/list/turfs = list()
			for(var/turf/open/turf in range(lightning_destination, 7))
				if(!turf.outdoor_effect || turf.outdoor_effect.weatherproof)
					continue
				turfs |= turf
			if(!length(turfs))
				return
			lightning_destination = pick(turfs)

		else
			lightning_destination = pick(SSParticleWeather.weathered_turfs)

		var/turf/lightning_turf = get_turf(lightning_destination)
		new /obj/effect/temp_visual/target/lightning(lightning_turf)
		COOLDOWN_START(src, thunder, rand(5, 40) * 1 SECONDS)

