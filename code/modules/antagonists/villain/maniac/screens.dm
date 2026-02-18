
/atom/movable/screen/fullscreen/maniac
	icon = 'icons/roguetown/maniac/fullscreen.dmi'
	icon_state = "hall0"
	alpha = 0
	/// Amount of hallucination icon states we have
	var/hall_amount = 13

/atom/movable/screen/fullscreen/maniac/proc/jumpscare(mob/living/scared, silent = FALSE, fade_in = 0.2 SECONDS, duration = 0.5 SECONDS, fade_out = 1 SECONDS)
	if(!silent)
		var/static/list/spookies = list(
			'sound/villain/hall_appear1.ogg',
			'sound/villain/hall_appear2.ogg',
			'sound/villain/hall_appear3.ogg',
		)
		scared.playsound_local(scared, pick(spookies), vol = 100, vary = FALSE)
	icon_state = "hall[rand(1, 9)]"
	if(prob(5))
		icon_state = "squidward" // thank you spongebob
		scared.remove_stress(/datum/stress_event/saw_wonder)
	animate(src, alpha = 255, time = fade_in, easing = BOUNCE_EASING | EASE_IN | EASE_OUT)
	animate(time = duration, easing = BOUNCE_EASING | EASE_IN | EASE_OUT)
	animate(alpha = 0, time = fade_out, easing = LINEAR_EASING)

/atom/movable/screen/fullscreen/dreaming
	icon = 'icons/roguetown/maniac/fullscreen_wakeup.dmi'
	icon_state = "dream"

/atom/movable/screen/fullscreen/dreaming/waking_up
	icon_state = "wake_up"
