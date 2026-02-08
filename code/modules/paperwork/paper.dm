/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */

#ifdef TESTSERVER

/client/verb/textperp()
	set category = "PAPER"
	set name = "textper+"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper++
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper++
			P.read(mob)

/client/verb/textperm()
	set category = "PAPER"
	set name = "textper-"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper--
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper--
			P.read(mob)

#endif

/obj/item/paper
	name = "parchment"
	gender = NEUTER
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 2
	throw_speed = 1
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = HEAD
	resistance_flags = FLAMMABLE
	max_integrity = 30
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'


	var/extra_headers //For additional styling or other js features.

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped
	var/rigged = 0
	var/spam_flag = 0
	var/contact_poison // Reagent ID to transfer on contact
	var/contact_poison_volume = 0
	dropshrink = 0.5
	var/textper = 100
	var/maxlen = 2000
	var/writable = TRUE

	var/cached_mailer
	var/cached_mailedto
	var/trapped

/obj/item/paper/get_real_price()
	if(info)
		return 0
	else
		return sellprice

/obj/item/paper/spark_act()
	fire_act()

/obj/item/paper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/pickup(user)
	if(contact_poison && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(!istype(G) || G.transfer_prints)
			H.reagents.add_reagent(contact_poison,contact_poison_volume)
			contact_poison = null
	..()

/obj/item/paper/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(-9, 9)
	pixel_y = base_pixel_y + rand(-8, 8)
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
	updateinfolinks()

/obj/item/paper/Destroy()
	info = null
	stamps = null
	LAZYCLEARLIST(stamped)
	updateinfolinks()
	return ..()

/obj/item/paper/update_icon_state()
	if(mailer)
		icon_state = "paper_prep"
		throw_range = 7
		return ..()
	throw_range = initial(throw_range)
	if(info)
		icon_state = "paperwrite"
		return ..()
	icon_state = "paper"
	return ..()

/obj/item/paper/update_name()
	if(mailer)
		name = "letter"
		return ..()
	name = initial(name)
	return ..()

/obj/item/paper/examine(mob/user)
	. = ..()
	if(!mailer)
		. += "<a href='byond://?src=[REF(src)];read=1'>Read</a> (<a href='byond://?src=[REF(src)];Help=1'>Help</a>)"
	else
		. += "It's from [mailer], addressed to [mailedto].</a>"

/obj/item/paper/proc/read(mob/user, ignore_distance = FALSE)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		if(info)
			user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		return
	if(mailer)
		return
	if(ignore_distance || in_range(user, src) || isobserver(user))
		show_paper_hud(user)
	else
		return span_warning("I'm too far away to read it.")

/obj/item/paper/proc/show_paper_hud(mob/user)
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html><head><style type=\"text/css\">
		body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
	dat += info
	dat += "<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
	onclose(user, "reading", src)

/*
	if(in_range(user, src) || isobserver(user))
		if(user.is_literate())
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE>[extra_headers]</HEAD><BODY>[info]<HR></BODY></HTML>", "window=paper[md5(name)]")
			onclose(user, "paper[md5(name)]")
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE>[extra_headers]</HEAD><BODY>[stars(info)]<HR></BODY></HTML>", "window=paper[md5(name)]")
			onclose(user, "paper[md5(name)]")
	else
		return "<span class='warning'>You're too far away to read it.</span>"
*/

/obj/item/paper/proc/format_browse(t, mob/user)
	user << browse_rsc('html/book.png')
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head>
			<meta charset=\"UTF-8\">
			<style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
	dat += "[t]<br>"
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;border=0")

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set hidden = 1
	set src in usr

	if(usr.incapacitated(IGNORE_GRAB) || !usr.is_literate())
		return
	var/n_name = stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN)
	if((loc == usr && usr.stat == CONSCIOUS))
		name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(usr)


/obj/item/paper/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] scratches a grid on [user.p_their()] wrist with the paper! It looks like [user.p_theyre()] trying to commit sudoku...</span>")
	return (BRUTELOSS)

/obj/item/paper/proc/reset_spamflag()
	spam_flag = FALSE

/obj/item/paper/attack_self(mob/user, list/modifiers)
	if(mailer)
		user.visible_message("<span class='notice'>[user] opens the letter from [mailer].</span>")
		cached_mailer = mailer
		cached_mailedto = mailedto
		mailer = null
		mailedto = null
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		return
	if(trapped)
		var/mob/living/victim = user
		victim.visible_message(span_notice("[user] opens the [src]."))
		to_chat(user, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
		sleep(5)
		victim.adjust_fire_stacks(15)
		victim.IgniteMob()
		victim.visible_message(span_danger("[user] bursts into flames upon reading [src]!"))
	read(user)
	if(rigged && (SSevents.holidays && SSevents.holidays[APRIL_FOOLS]))
		if(!spam_flag)
			spam_flag = TRUE
			playsound(src, 'sound/blank.ogg', 50, TRUE)
			addtimer(CALLBACK(src, PROC_REF(reset_spamflag)), 20)

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < 15)	//hey whoever decided a while(1) was a good idea here, i hate you
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i in 1 to min(fields, 15))
		addtofield(i, "<A href='byond://?src=[REF(src)];write=[i]'>write</A> (<A href='byond://?src=[REF(src)];help=1'>\[?\]</A>)", 1)
	info_links = info_links + "<A href='byond://?src=[REF(src)];write=end'>write</A> <A href='byond://?src=[REF(src)];help=1'>\[?\]</A>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	LAZYCLEARLIST(stamped)
	cut_overlays()
	updateinfolinks()
	update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/item/paper/proc/parsepencode(t, obj/item/P, mob/user, iscrayon = 0)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

	t = parsemarkdown(t, user, iscrayon)

	if(istype(P, /obj/item/natural/thorn))
		t = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#862f20>[t]</font>"
	else if(istype(P, /obj/item/natural/feather))
		t = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>[t]</font>"

	// Count the fields
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++

	return t

/obj/item/paper/proc/reload_fields() // Useful if you made the paper programicly and want to include fields. Also runs updateinfolinks() for you.
	fields = 0
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(info, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++
	updateinfolinks()


/obj/item/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><TITLE>Paper Help</TITLE></HEAD>
	<BODY>
		You can use backslash (\\) to escape special characters.<br>
		<br>
		# text : Defines a header.<br>
		|text| : Centers the text.<br>
		**text** : Makes the text <b>bold</b>.<br>
		*text* : Makes the text <i>italic</i>.<br>
		^text^ : Increases the <font size = \"4\">size</font> of the text.<br>
		%s : Inserts a signature of your name in a foolproof way.<br>
		%f : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
		((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>
		* item : An unordered list item.<br>
		&nbsp;&nbsp;* item: An unordered list child item.<br>
		--- : Adds a horizontal rule.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/paper/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	if(!usr.can_read())
		return
	if(!usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	if(href_list["read"])
		read(usr)
		if(trapped)
			var/mob/living/victim = usr
			victim.visible_message(span_notice("[usr] opens the [src]."))
			to_chat(usr, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
			sleep(5)
			victim.adjust_fire_stacks(15)
			victim.IgniteMob()
			victim.visible_message(span_danger("[usr] bursts into flames upon reading [src]!"))

	if(href_list["help"])
		openhelp(usr)
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  browser_input_text(usr, "Enter what you want to write:", "Write", multiline = TRUE)
		if(!t || !usr.can_perform_action(src, NEED_DEXTERITY|NEED_LITERACY|FORBID_TELEKINESIS_REACH))
			return
		var/obj/item/i = usr.get_active_held_item()	//Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		if(!istype(i, /obj/item/natural/thorn))
			if(!istype(i, /obj/item/natural/feather))
				return

		if(!in_range(src, usr) && loc != usr && loc.loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return

		log_paper("[key_name(usr)] writing to paper [t]")
		t = parsepencode(t, i, usr, FALSE) // Encode everything from pencode to html

		if(t != null)	//No input from the user means nothing needs to be added
			if((length(info) + length(t)) > maxlen)
				to_chat(usr, "<span class='warning'>Too long. Try again.</span>")
				return
			if(id!="end")
				addtofield(text2num(id), t) // He wants to edit a field, let him.
			else
				info += t // Oh, he wants to edit to the end of the file, let him.
				updateinfolinks()
			playsound(src, 'sound/items/write.ogg', 100, FALSE)
			format_browse(info_links, usr)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)

/obj/item/paper/attackby(obj/item/P, mob/living/user, list/modifiers)
	if(resistance_flags & ON_FIRE)
		return ..()

	if(mailer)
		return ..()

	if(P.type == /obj/item/paper) //Make a manuscript
		if(user.get_skill_level(/datum/skill/misc/reading) <= 0)
			to_chat(user, span_warning("I fumble with [src] and fail to form the manuscript!"))
			user.changeNext_move(2 SECONDS, user.active_hand_index) //lmao
			return

		var/obj/item/paper/combining_page = P

		user.visible_message( \
			span_notice("[user] begins to make a manuscript..."), \
			span_notice("I begin to combine [src] and [combining_page] to make a manuscript..."), \
			span_hear("I hear pages being rattled and shuffled.") \
		)
		var/obj/item/manuscript/new_manuscript = new(null, list(src, combining_page))
		if(QDELETED(new_manuscript)) //make sure it didn't hint_qdel
			to_chat(user, span_warning("I can not make a manuscript, something is preventing me...!"))
			stack_trace("tried to make a manuscript but it was qdeleted")
			return

		user.put_in_hands(new_manuscript)
		return

	if(istype(P, /obj/item/natural/feather/infernal))
		if(!writable)
			return
		if(trapped)
			to_chat(user, span_warning("[src] is already trapped."))
		else
			to_chat(user, span_warning("I draw infernal symbols on this [src], rigging it to explode."))
			trapped = TRUE

	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!writable)
			return
		if(user.is_blind())
			to_chat(user, span_warning("I want to write on [src], but I cannot."))
			return

		if(length(info) > maxlen)
			to_chat(user, "<span class='warning'>[src] is full of verba.</span>")
			return
		if(user.can_read(src))
			format_browse(info_links, user)
			update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
			return
		else
			to_chat(user, "<span class='warning'>I can't write.</span>")
			return

	add_fingerprint(user)
	return ..()

/obj/item/paper/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")
		info = "[stars(info)]"


/obj/item/paper/extinguish()
	..()
	cut_overlay("paper_onfire_overlay")

/*
 * Construction paper
 */

/obj/item/paper/construction

/obj/item/paper/construction/Initialize()
	. = ..()
	color = pick("FF0000", "#33cc33", "#ffb366", "#551A8B", "#ff80d5", "#4d94ff")

/*
 * Natural paper
 */

/obj/item/paper/natural/Initialize()
	. = ..()
	color = "#FFF5ED"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"
	slot_flags = null

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/crumpled/muddy
	icon_state = "scrap_mud"
