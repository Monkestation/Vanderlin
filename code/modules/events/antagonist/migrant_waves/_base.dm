/datum/round_event_control/antagonist/migrant_wave
	typepath = /datum/round_event/migrant_wave
	max_occurrences = 2
	secondary_prob = 0
	var/datum/migrant_wave/wave_type

/datum/round_event/migrant_wave
	var/datum/migrant_wave/wave_type

/datum/round_event/migrant_wave/New(my_processing, datum/round_event_control/event_controller)
	. = ..()
	if(istype(event_controller, /datum/round_event_control/antagonist/migrant_wave))
		var/datum/round_event_control/antagonist/migrant_wave/antag_event_controller = event_controller
		if(antag_event_controller)
			wave_type = antag_event_controller.wave_type

/datum/round_event/migrant_wave/start()
	. = ..()
	SSmigrants.set_current_wave(wave_type, 1 MINUTES)
