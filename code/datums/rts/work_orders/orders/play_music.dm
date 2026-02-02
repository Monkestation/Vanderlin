/datum/work_order/play_music
	name = "Playing Instrument"
	stamina_cost = 0
	work_time_left = 60 SECONDS

	var/obj/item/instrument/instrument

/datum/work_order/play_music/New(mob/living/new_worker, datum/work_order/type, atom/movement_target, obj/item/instrument/instrument)
	. = ..()
	src.instrument = instrument
	set_movement_target(movement_target)

/datum/work_order/play_music/start_working(mob/living/worker_mob)
	var/song = pick(instrument.song_list)
	song = instrument.song_list[song]
	worker.controller_mind.update_stat_panel()
	instrument.playing = TRUE
	instrument.soundloop.mid_sounds = list(song)
	instrument.soundloop.cursound = null
	instrument.soundloop.start(worker_mob)
	. = ..()

/datum/work_order/play_music/stop_work(reason = "unknown")
	. = ..()
	stop_music()

/datum/work_order/play_music/finish_work()
	. = ..()
	stop_music()

/datum/work_order/play_music/proc/stop_music()
	instrument.playing = FALSE
	instrument.soundloop.stop()
