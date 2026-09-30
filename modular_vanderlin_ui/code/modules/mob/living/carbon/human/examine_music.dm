/mob/living/carbon/human
	var/examine_music_track

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(examine_music_track && user != src)
		playsound(src, examine_music_track, 30, FALSE)