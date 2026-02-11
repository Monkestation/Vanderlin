GLOBAL_VAR_INIT(year, time2text(world.realtime,"YYYY"))
GLOBAL_VAR_INIT(year_integer, text2num(year)) // = 2013???

/mob/living/carbon/human/Topic(href, href_list)

	if(href_list["task"] == "view_flavor_text" && (isobserver(usr) || usr.can_perform_action(src, NEED_LIGHT)))
		if(!ismob(usr))
			return
		var/mob/user = usr
		var/list/dat = list()
		if(headshot_link)
			dat += "<br>"
			dat += ("<div align='center'><img src='[headshot_link]' width='325px' height='325px'></div>")
		if(flavortext)
			dat += "<div align='left' style='line-height: 1.2;'>[flavortext_display]</div>"
		if(ooc_notes)
			dat += "<br>"
			dat += "<div align='center'><b>OOC notes</b></div>"
			dat += "<div align='left' style='line-height: 1.2;'>[ooc_notes_display]</div>"
		if(ooc_extra)
			dat += "[ooc_extra]"
		var/datum/browser/popup = new(user, "[src]", "<center>[src]</center>", 480, 700)

		popup.set_content(dat.Join())
		popup.open(FALSE)
		return

	if(href_list["view_descriptors"] && (isobserver(usr) || usr.can_perform_action(src, NEED_LIGHT)))
		if(!ismob(usr))
			return
		var/obscure_name
		if(name == "Unknown" || name == "Unknown Man" || name == "Unknown Woman")
			obscure_name = TRUE
		if(isobserver(usr))
			obscure_name = FALSE
		var/list/lines = build_cool_description(get_mob_descriptors(obscure_name, usr), src)
		to_chat(usr, span_info("[lines.Join("\n")]"))
		return

	if(href_list["inspect_limb"] && (isobserver(usr) || usr.can_perform_action(src, FORBID_TELEKINESIS_REACH)))
		var/list/msg = list()
		var/mob/user = usr
		var/checked_zone = check_zone(href_list["inspect_limb"])
		var/obj/item/bodypart/bodypart = get_bodypart(checked_zone)
		if(bodypart)
			var/list/bodypart_status = bodypart.inspect_limb(user)
			if(length(bodypart_status))
				msg += bodypart_status
			else
				msg += "<B>[capitalize(bodypart.name)]:</B>"
				msg += "[bodypart] is healthy."
		else
			msg += "<B>[capitalize(parse_zone(checked_zone))]:</B>"
			msg += span_dead("Limb is missing!")
		to_chat(usr, span_info("[msg.Join("\n")]"))

	if(href_list["check_hb"] && (isobserver(usr) || usr.can_perform_action(src, FORBID_TELEKINESIS_REACH)))
		if(!isobserver(usr))
			usr.visible_message(span_info("[usr] tries to hear [src]'s heartbeat."))
			if(!do_after(usr, 3 SECONDS, src))
				return
		var/list/following_my_heart = check_heartbeat(usr)
		to_chat(usr, span_info("[following_my_heart.Join("\n")]"))

	if(href_list["embedded_object"] && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		var/obj/item/bodypart/L = locate(href_list["embedded_limb"]) in bodyparts
		if(!L)
			return
		var/obj/item/I = locate(href_list["embedded_object"]) in L.embedded_objects
		if(!I) //no item, no limb, or item is not in limb or in the person anymore
			return
		var/time_taken = I.embedding.embedded_unsafe_removal_time*I.w_class
		if(usr == src)
			usr.visible_message(span_warning("[usr] attempts to remove [I] from [usr.p_their()] [L.name]."),span_warning("I attempt to remove [I] from my [L.name]..."))
		else
			usr.visible_message(span_warning("[usr] attempts to remove [I] from [src]'s [L.name]."),span_warning("I attempt to remove [I] from [src]'s [L.name]..."))
		if(do_after(usr, time_taken, src))
			if(QDELETED(I) || QDELETED(L) || !L.remove_embedded_object(I))
				return
			L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class)//It hurts to rip it out, get surgery you dingus.
			usr.put_in_hands(I)
			emote("pain", TRUE)
			playsound(src, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
			if(usr == src)
				usr.visible_message(span_notice("[usr] rips [I] out of [usr.p_their()] [L.name]!"), span_notice("I successfully remove [I] from my [L.name]."))
			else
				usr.visible_message(span_notice("[usr] rips [I] out of [src]'s [L.name]!"), span_notice("I successfully remove [I] from [src]'s [L.name]."))

	if(href_list["bandage"] && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		var/obj/item/bodypart/L = locate(href_list["bandaged_limb"]) in bodyparts
		if(!L)
			return
		var/obj/item/I = L.bandage
		if(!I)
			return

		var/time_to_unbandage = 5 SECONDS * (1 - (usr.get_skill_level(/datum/skill/misc/medicine, TRUE) * 0.15))
		if(usr == src)
			usr.visible_message(span_warning("[usr] starts unbandaging [usr.p_their()] [L.name]."),span_warning("I start unbandaging [L.name]..."))
		else
			usr.visible_message(span_warning("[usr] starts unbandaging [src]'s [L.name]."),span_warning("I start unbandaging [src]'s [L.name]..."))
		if(do_after(usr, time_to_unbandage, src))
			if(QDELETED(I) || QDELETED(L) || (L.bandage != I))
				return
			L.remove_bandage()
			usr.put_in_hands(I)

	if(href_list["item"]) //canUseTopic check for this is handled by mob/Topic()
		var/slot = text2num(href_list["item"])
		if(slot & check_obscured_slots(TRUE))
			to_chat(usr, span_warning("I can't reach that! Something is covering it."))
			return

	if(href_list["undiesthing"]) //canUseTopic check for this is handled by mob/Topic()
		if(!get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			to_chat(usr, span_warning("I can't reach that! Something is covering it."))
			return
		if(underwear == "Nude")
			return
		if(do_after(usr, 5 SECONDS, src))
			cached_underwear = underwear
			underwear = "Nude"
			update_body()
			var/obj/item/undies/U
			if(gender == MALE)
				U = new/obj/item/undies(get_turf(src))
			else
				U = new/obj/item/undies/f(get_turf(src))
			U.color = underwear_color
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.put_in_hands(U)
	return ..() //end of this massive fucking chain. TODO: make the hud chain not spooky. - Yeah, great job doing that.

/mob/living/proc/check_heartbeat(mob/user)
	var/list/message = list()
	if(stat >= DEAD)
		message += "<B>No heartbeat...</B>"
	else
		message += "<B>The heart is still beating.</B>"
	var/list/soul_message = soul_examine(user)
	if(soul_message)
		message += soul_message
	return message

/mob/living/proc/soul_examine(mob/user)
	var/list/message = list()
	if(stat >= DEAD)
		if(suiciding)
			message += span_deadsay("[p_they(TRUE)] commited suicide... Nothing can be done...")
		if(isobserver(user) || HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
			if(!key && !get_ghost(TRUE))
				message += span_deadsay("[p_their(TRUE)] soul has departed for the Underworld.")
			else
				message += span_deadsay("[p_they(TRUE)] [p_are()] still earthbound.")
	return message
