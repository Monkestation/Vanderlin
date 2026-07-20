/obj/item/speaker //base class for speaker
	name = "base whisperer"
	sellprice = 20
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scomite"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	possible_item_intents = list(INTENT_GENERIC)
	sleeved = 'icons/roguetown/clothing/onmob/neck.dmi'
	grid_width = 32
	grid_height = 32
	item_weight = 50 GRAMS
	var/speaking = FALSE
	var/fakename = "base whisperer"

/obj/item/speaker/Initialize()
	. = ..()
	SSroguemachine.scomm_machines += src

/obj/item/speaker/Destroy()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/speaker/attack_self(mob/user, list/modifiers)
	. = ..()
	user.changeNext_move(6)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	update_appearance(UPDATE_ICON_STATE)

/obj/item/speaker/update_icon_state()
	. = ..()
	if(speaking)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/obj/item/speaker/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 20, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/speaker/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)

/obj/item/speaker/dropped(mob/user, silent)
	. = ..()
	name = initial(name)
	sleeved = null
	mob_overlay_icon = null

/obj/item/listeningdevice //base class for listener
	name = "base listener"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "listenstone"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	item_weight = 80 GRAMS
	var/fulldesc
	var/label = null
	var/hidden = FALSE
	var/active = FALSE
	var/datum/status_effect/bugged/effect

/obj/item/listeningdevice/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/item/listeningdevice/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/attack_hand_secondary(mob/user, list/modifiers)
	if(!hidden)
		alpha = 30
		name = "thing"
		desc = "What is that thing?.."
		hidden = TRUE
		return TRUE
	alpha = 255
	name = initial(name)
	desc = initial(desc)
	hidden = FALSE
	return TRUE

/* - REVISIT IN A FUTURE PR. ATTACHABLE LISTENERS.
/obj/item/listeningdevice/attack(mob/living/M, mob/living/user, list/modifiers)
	if(!active)
		to_chat(user, span_warning("[src] is inactive.."))
		return FALSE

	to_chat(user, span_notice("I attach [src] to [M]."))
	effect = M.apply_status_effect(/datum/status_effect/bugged)
	effect.device = src
	forceMove(M)
	M.contents.Add(src)

	if(GET_MOB_ATTRIBUTE_VALUE(M, STAT_PERCEPTION) > GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED))
		to_chat(M, span_hidden("I feel something brush against mine own self. It stings."))

	..()
*/

/obj/item/listeningdevice/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	update_appearance(UPDATE_ICON_STATE)

/obj/item/listeningdevice/update_icon_state()
	. = ..()
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/*
	INQUISITOR LISTENING DEVICES
*/

/obj/item/speaker/inq
	name = "secret whisperer"
	desc = "Sweet secrets whispered so freely."
	icon_state = "scomite"
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_RING

/obj/item/speaker/inq/attack_self(mob/user, list/modifiers)
	. = ..()
	to_chat(user, span_info("I [speaking ? "unsilence" : "silence"] the whisperer"))

/obj/item/speaker/inq/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(ITEM_SLOT_RING)
			fakename = "silver signet ring"
			name = fakename
	return TRUE

/obj/item/listeningdevice/inq
	name = "listener"
	desc = "An ever-attentive ear..."
	icon_state = "listenstone"

/obj/item/listeningdevice/inq/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = fulldesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/inq/Initialize()
	. = ..()
	fulldesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"

/obj/item/listeningdevice/inq/attack_self(mob/living/user)
	. = ..()
	var/input = input(user, "SIX LETTERS", "BEND AN EAR")
	if(!input)
		label = null
		fulldesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"
		desc = fulldesc
	label = uppertext(trim(input, 7))
	fulldesc = "An ever-attentive ear... [span_notice("This ear's been bent. It's labelled as [label].")]"
	desc = fulldesc

/obj/item/listeningdevice/inq/MiddleClick(mob/user)
	. = ..()
	to_chat(user, span_info("I [active ? "undeafen" : "deafen"] the Listener"))

/obj/item/listeningdevice/inq/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speaker/inq/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language)
		S.name = (S.fakename)

/*
	COURT AGENT LISTENING DEVICES
*/

/obj/item/speaker/agent
	name = "whispering clam"
	desc = "Ever whispering secrets into your ears..."
	icon_state = "cosmic_clam"
	slot_flags = ITEM_SLOT_HIP

/obj/item/speaker/agent/attack_self(mob/user, list/modifiers)
	. = ..()
	to_chat(user, span_info("I [speaking ? "unsilence" : "silence"] the whispering clam"))

/obj/item/speaker/agent/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(ITEM_SLOT_BELT_L)
			fakename = "clam"
			name = fakename
		if(ITEM_SLOT_BELT_R)
			fakename = "clam"
			name = fakename
	return TRUE

/obj/item/listeningdevice/agent
	name = "listening pearl"
	desc = "A black pearl..."
	icon_state = "midnight_pearl"

/obj/item/listeningdevice/agent/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_COURTAGENT))
		desc = fulldesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/agent/Initialize()
	. = ..()
	fulldesc = "A black pearl... [span_notice("This pearl hasn't been activated. It's unlabelled.")]"

/obj/item/listeningdevice/agent/attack_self(mob/living/user)
	. = ..()
	var/input = input(user, "SIX LETTERS", "HEAR ALL SECRETS")
	if(!input)
		label = null
		fulldesc = "A black pearl... [span_notice("This pearl hasn't been activated. It's unlabelled.")]"
		desc = fulldesc
	label = uppertext(trim(input, 7))
	fulldesc = "An black pearl... [span_notice("This pearl has been activated. It's labelled as [label].")]"
	desc = fulldesc

/obj/item/listeningdevice/agent/MiddleClick(mob/user)
	. = ..()
	to_chat(user, span_info("I [active ? "undeafen" : "deafen"] the Pearl"))

/obj/item/listeningdevice/agent/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speaker/agent/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language)
		S.name = (S.fakename)
