/obj/structure/vampire/scryingorb // Method of spying on the town
	name = "Eye of Night"
	icon_state = "scrying"
	var/datum/component/scrying/vampire/scry_comp //Temporary alternative

/obj/structure/vampire/scryingorb/Initialize()
	. = ..()
	scry_comp = new(src)

/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	if(user?.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		user.visible_message("<font color='red'>[user]'s eyes turn dark red, as they channel the [src]</font>", "<font color='red'>I begin to channel my consciousness into a Predator's Eye.</font>")
		if(do_after(user, 6 SECONDS, src))
			//user.scry(can_reenter_corpse = 1, force_respawn = FALSE)
			scry_comp.activate(user)
	else
		to_chat(user, span_warning("I don't have the power to use this!"))



/mob/proc/scry(can_reenter_corpse = 1, force_respawn = FALSE, drawskip)
	stop_sound_channel(CHANNEL_HEARTBEAT) //Stop heartbeat sounds because You Are A Ghost Now
	var/mob/scry_eye/eye_of_night/eye = new(src)	// Transfer safety to observer spawning proc.
	SStgui.on_transfer(src, eye) // Transfer NanoUIs.
	eye.vampirelord = src
	eye.key = key
	qdel(eye.language_holder)
	eye.language_holder = language_holder.copy(eye)
	return eye
