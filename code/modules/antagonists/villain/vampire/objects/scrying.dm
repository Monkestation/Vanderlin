/obj/structure/vampire/scryingorb // Method of spying on the town
	name = "Eye of Night"
	icon_state = "scrying"

/obj/structure/vampire/scryingorb/Initialize()
	. = ..()
	AddComponent(/datum/component/scrying, 12 SECONDS, 3 SECONDS, FALSE, FALSE) //Temporary alternative

/*
/mob/proc/enter_night_eye()
	stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
	var/mob/scry_eye/eye_of_night/eye = new(src)	// Transfer safety to observer spawning proc.
	SStgui.on_transfer(src, eye) // Transfer NanoUIs.
	eye.vampirelord = src
	eye.key = key
	qdel(eye.language_holder)
	eye.language_holder = language_holder.copy(eye)
	return eye
*/
