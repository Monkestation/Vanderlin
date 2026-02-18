
/obj/structure/fake_machine/scomm
	name = "SCOM"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)
	anchored = TRUE
	var/next_decree = 0
	var/listening = TRUE
	var/speaking = TRUE
	var/dictating = FALSE

/obj/structure/fake_machine/scomm/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SHAKY_SPEECH, TRAIT_GENERIC)
	become_hearing_sensitive()

/obj/structure/fake_machine/scomm/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/structure/fake_machine/scomm/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/scomm/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/scomm/examine(mob/user)
	. = ..()
	. += "<b>THE LAWS OF THE LAND:</b>"
	if(!length(GLOB.laws_of_the_land))
		. += "<span class='danger'>The land has no laws! <b>We are doomed!</b></span>"
		return
	if(!user.is_literate())
		. += "<span class='warning'>Uhhh... I can't read them...</span>"
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		. += span_info("[i]. [GLOB.laws_of_the_land[i]]")

/obj/structure/fake_machine/scomm/process()
	if(obj_broken)
		return
	if(world.time > next_decree)
		next_decree = world.time + rand(3 MINUTES, 8 MINUTES)
		if(GLOB.lord_decrees.len)
			say("The King Decrees: [pick(GLOB.lord_decrees)]", spans = list("info"))

/obj/structure/fake_machine/scomm/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(obj_broken)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, "<span class='info'>I [speaking ? "unmute" : "mute"] the SCOM.</span>")
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fake_machine/scomm/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	var/datum/job/lord/ruler_job = SSjob.GetJobType(/datum/job/lord)
	contents += "<center>[ruler_job.get_informed_title(SSticker.rulermob)]'s DECREES<BR>"

	contents += "-----------<BR><BR></center>"
	for(var/i = GLOB.lord_decrees.len to 1 step -1)
		contents += "[i]. <span class='info'>[GLOB.lord_decrees[i]]</span><BR>"
	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

/obj/structure/fake_machine/scomm/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	SSroguemachine.scomm_machines += src

/obj/structure/fake_machine/scomm/update_icon_state()
	. = ..()
	icon_state = "scomm[listening]"

/obj/structure/fake_machine/scomm/atom_break(damage_flag)
	. = ..()
	set_light(0)
	speaking = FALSE
	listening = FALSE

/obj/structure/fake_machine/scomm/atom_fix()
	. = ..()
	speaking = TRUE
	listening = TRUE

/obj/structure/fake_machine/scomm/Destroy()
	SSroguemachine.scomm_machines -= src
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/fake_machine/scomm/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/structure/fake_machine/scomm/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	if(!listening)
		return
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(raw_message)
		if(lowertext(raw_message) == "say laws")
			dictate_laws()
			return
		for(var/obj/structure/fake_machine/scomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language)
		for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language)

/obj/structure/fake_machine/scomm/proc/dictate_laws()
	if(dictating)
		return
	dictating = TRUE
	repeat_message("THE LAWS OF THE LAND ARE...", tcolor = COLOR_RED)
	INVOKE_ASYNC(src, PROC_REF(dictation))

/obj/structure/fake_machine/scomm/proc/dictation()
	if(!length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("THE LAND HAS NO LAWS!", tcolor = COLOR_RED)
		dictating = FALSE
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("[i]. [GLOB.laws_of_the_land[i]]", tcolor = COLOR_RED)
	dictating = FALSE

/proc/scom_announce(message)
	for(var/obj/structure/fake_machine/scomm/S in SSroguemachine.scomm_machines)
		S.say(message, spans = list("info"))



//SCOMSTONE                 SCOMSTONE

/obj/item/scomstone
	name = "scomstone ring"
	desc = "Gold and glittering green."
	icon = 'icons/roguetown/clothing/rings.dmi'
	icon_state = "ring_emerald"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING

	w_class = WEIGHT_CLASS_SMALL
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 35

/obj/item/scomstone/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/item/scomstone/Destroy()
	lose_hearing_sensitivity()
	return ..()

//wip
/obj/item/scomstone/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.changeNext_move(CLICK_CD_MELEE)
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		for(var/obj/structure/fake_machine/scomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text)
		for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text)

/obj/item/scomstone/MiddleClick(mob/user, list/modifiers)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, "<span class='info'>I [speaking ? "unmute" : "mute"] the scomstone.</span>")

/obj/item/scomstone/Destroy()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/scomstone/Initialize()
	. = ..()
	SSroguemachine.scomm_machines += src

/obj/item/scomstone/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(src, 'sound/misc/scom.ogg', 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null


/obj/item/scomstone/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language=language)
	else
		send_speech(message, 1, src, , spans, message_language=language)

/obj/item/scomstone/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(speaker == src)
		return
	if(loc != speaker)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	if(!listening)
		return
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(raw_message)
		for(var/obj/structure/fake_machine/scomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language)
		for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language)

/obj/item/scomstone/bad
	name = "serfstone"
	icon_state = "ring_emerald"
	listening = FALSE
	sellprice = 2

/obj/item/scomstone/bad/Hear()
	return
