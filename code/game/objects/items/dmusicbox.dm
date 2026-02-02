
/datum/looping_sound/dmusloop
	mid_sounds = list()
	mid_length = 2400
	volume = 100
	falloff_exponent = 2
	extra_range = 5
	var/stress2give = /datum/stress_event/music
	persistent_loop = TRUE
	sound_group = /datum/sound_group/instruments

/datum/looping_sound/dmusloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/obj/item/dmusicbox
	name = "dwarven music box"
	desc = "A personal device heralding the new era of machine and steam. Dwarven artificers both prize and fear this device for its broad musical range, which notably have made it an object of great value to Baothans' newfound 'Star-Song' rituals."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mbox0"
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 20
	throw_range = 2
	var/datum/looping_sound/dmusloop/soundloop
	var/curfile
	var/playing = FALSE
	var/loaded = FALSE
	var/lastfilechange = 0
	var/curvol = 100

/obj/item/dmusicbox/Initialize()
	. = ..()
	soundloop = new(src, FALSE)
	update_appearance(UPDATE_ICON_STATE)

/obj/item/dmusicbox/examine(mob/user)
	. = ..()
	. += span_notice("Right click [src] to select a .ogg file. Interact with self to toggle music.")

/obj/item/dmusicbox/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/obj/item/dmusicbox/update_icon_state()
	. = ..()
	if(playing)
		icon_state = "mboxon"
	else
		icon_state = "mbox[loaded]"

/obj/item/dmusicbox/attackby(obj/item/P, mob/user, list/modifiers)
	if(!loaded)
		if(istype(P, /obj/item/coin/gold))
			loaded=TRUE
			qdel(P)
			update_appearance(UPDATE_ICON_STATE)
			playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
	return ..()

/obj/item/dmusicbox/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	attack_hand_secondary(user, modifiers)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/dmusicbox/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(loc != user)
		return
	if(!user.ckey)
		return
	if(playing)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(lastfilechange)
		if(world.time < lastfilechange + 3 MINUTES)
			say("NOT YET!")
			return
	if(!loaded)
		say("A GOLD COIN FOR A CAROL!")
		return
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/infile = input(user, "CHOOSE A NEW SONG", src) as null|file

	if(!infile)
		return

	if(!loaded)
		return

	var/filename = "[infile]"
	var/file_ext = lowertext(copytext(filename, -4))
	var/file_size = length(infile)

	if(file_ext != ".ogg")
		to_chat(user, "<span class='warning'>SONG MUST BE AN OGG.</span>")
		return
	if(file_size > 6485760)
		to_chat(user, "<span class='warning'>TOO BIG. 6 MEGS OR LESS.</span>")
		return
	lastfilechange = world.time
	fcopy(infile,"data/jukeboxuploads/[user.ckey]/[filename]")
	curfile = file("data/jukeboxuploads/[user.ckey]/[filename]")

	loaded = FALSE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/dmusicbox/attack_self(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(!playing)
		if(curfile)
			playing = TRUE
			soundloop.mid_sounds = list(curfile)
			soundloop.cursound = null
			soundloop.start()
	else
		playing = FALSE
		soundloop.stop()
	update_appearance(UPDATE_ICON_STATE)
