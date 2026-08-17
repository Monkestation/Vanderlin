/obj/structure/mercstatue
	name = "mercenary statue"
	desc = "A bronze statue of a mercenary from ages long past."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mercstatue"
	density = TRUE
	anchored = TRUE
	max_integrity = 500
	var/message_char_limit = 300
	var/response_timeout = 2 MINUTES
	var/single_cooldown = 5 MINUTES
	var/static/list/sender_cooldowns = list()
	var/static/list/pending_direct_responses = list()
	var/static/response_id_counter = 0

/obj/structure/mercstatue/attack_hand(mob/living/carbon/human/user)
	use(user)

/obj/structure/mercstatue/proc/use(mob/living/carbon/human/user)
	if(!user)
		return
	var/obj/item/mercenary_ring/mercring

	if(ishuman(user) && user.mind && istype(user.mind.assigned_role, /datum/job/advclass/mercenary))
		if(tgui_alert(user, "Do you want to change your mercenary description", "MERCENARY", DEFAULT_INPUT_CHOICES, 20 SECONDS) == CHOICE_YES)
			user.mercdesc = stripped_input(user, "Write a description which will be shown to potential employers.", "Description", "", message_char_limit)

	if(user in GLOB.contracted_mercenaries)
		if(tgui_alert(user, "Do you want to cancel your current contract?", "MERCENARY", DEFAULT_INPUT_CHOICES, 20 SECONDS) == CHOICE_YES)
			GLOB.contracted_mercenaries -= user
			GLOB.available_mercenaries += user

	if(user in GLOB.available_mercenaries)
		if(tgui_alert(user, "Do you want to unregister as an available mercenary for the mercenary statue?", "MERCENARY", DEFAULT_INPUT_CHOICES, 20 SECONDS) == CHOICE_YES)
			GLOB.available_mercenaries -= user
			for(var/obj/item/mercenary_ring/ring in world)
				if(ring.mob_ref)
					var/mob/living/M = ring.mob_ref.resolve()
					if(M == user)
						qdel(ring)
						return
			if(mercring)
				qdel(mercring)
		return

	if(ishuman(user) && user.mind && istype(user.mind.assigned_role, /datum/job/advclass/mercenary))
		if(tgui_alert(user, "Do you want to register as an available mercenary for the mercenary statue?", "MERCENARY", DEFAULT_INPUT_CHOICES, 20 SECONDS) == CHOICE_YES)
			GLOB.available_mercenaries += user
			mercring = new /obj/item/mercenary_ring(src)
			mercring.add_mercenary(user)
			user.put_in_hands(mercring)
			if(user.mercdesc && (user.mercdesc != ""))
				return
			user.mercdesc = stripped_input(user, "Write a description which will be shown to potential employers.", "Description", "", message_char_limit)
			return

	if(length(GLOB.available_mercenaries))
		var/mob/selected_merc = tgui_input_list(user, "Choose an available mercenary", "Mercenaries", GLOB.available_mercenaries)

		if(selected_merc)
			var/cooldown_key = "[user.real_name]_[selected_merc.real_name]"
			if(sender_cooldowns[cooldown_key])
				var/time_left = sender_cooldowns[cooldown_key] + single_cooldown - world.time
				if(time_left > 0)
					var/mins_left = max(1, round(time_left / 600))
					to_chat(user, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before contacting [selected_merc.real_name] again."))
					return

			if(!Adjacent(user))
				to_chat(user, span_warning("I need to stay close to the statue."))
				return

			var/message = stripped_input(user, "Send a message to [selected_merc] detailing your offer. Maximum [message_char_limit] characters.", "Message for the mercenary", "", message_char_limit)
			if(message)
				var/response_id = ++response_id_counter
				var/response_key = "[response_id]"
				sender_cooldowns[cooldown_key] = world.time
				pending_direct_responses[response_key] = list("sender" = user, "target" = selected_merc, "message" = message)
				addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)
				to_chat(selected_merc, span_boldnotice("The mercenary statue whispers in my mind: <i>[message]</i> - [user.real_name]<br><a href='byond://?src=[REF(src)];direct_response=interested;response_id=[response_id]'>\[INTERESTED\]</a> | <a href='byond://?src=[REF(src)];direct_response=notinterested;response_id=[response_id]'>\[NOT INTERESTED\]</a>"))
				playsound(selected_merc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
				to_chat(user, "My message has been sent.")
				return


		return
	to_chat(user, "No mercenaries are currently available!")

/obj/structure/mercstatue/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/responder = usr
	var/response_type = href_list["direct_response"]
	var/response_id = href_list["response_id"]

	if(!pending_direct_responses[response_id])
		to_chat(responder, span_warning("That response link has expired or already been used."))
		return

	var/list/response_data = pending_direct_responses[response_id]
	var/mob/living/carbon/human/sender = response_data["sender"]

	if(!sender || QDELETED(sender))
		to_chat(responder, span_warning("The sender is no longer available."))
		pending_direct_responses -= response_id
		return

	pending_direct_responses -= response_id
	if(response_type == "interested")
		to_chat(sender, span_notice("[responder.real_name] responded in affirmation to my message."))
		to_chat(responder, span_notice("I responded in affirmation to [sender.real_name]."))
		GLOB.available_mercenaries -= responder
		GLOB.contracted_mercenaries += responder
	else
		to_chat(sender, span_notice("[responder.real_name] responded negatively to my message."))
		to_chat(responder, span_notice("I responded negatively to [sender.real_name]."))

	playsound(sender, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
	playsound(responder, 'sound/misc/beep.ogg', 100, FALSE, -1)
	return

/obj/structure/mercstatue/proc/expire_direct_response(response_id)
	var/response_key = "[response_id]"
	if(pending_direct_responses[response_key])
		pending_direct_responses -= response_key

/obj/structure/mercstatue/examine(mob/user)
	. = ..()

	if(GLOB.available_mercenaries)
		. += span_notice("These mercenaries are currently available:")
		for(var/mob/living/carbon/human/merc in GLOB.available_mercenaries)
			if(merc.job)
				. += "[merc.real_name], [merc.job]: [merc.mercdesc]"
			else
				. += "[merc.real_name]: [merc.mercdesc]"
		return
	else
		. += span_notice("No mercenaries are currently available.")
