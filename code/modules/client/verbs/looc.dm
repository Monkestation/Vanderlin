/datum/keybinding/looc
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("U")
	name = "LOOC"
	full_name = "LOOC Chat"
	description = "Local OOC Chat."

/datum/keybinding/looc/down(client/user)
	. = ..()
	user.native_say.open_say_window("LOOC")
	return TRUE

/client/proc/get_looc()
	var/msg = input(src, null, "looc \"text\"") as text|null
	do_looc(msg)

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	do_looc(msg)

/client/proc/do_looc(msg as text)

	if(!GLOB.looc_allowed)
		to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
		return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'> Speech is currently admin-disabled.</span>")
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, "<span class='danger'>I cannot use LOOC (muted).</span>")
		return
	if(is_misc_banned(ckey, BAN_MISC_LOOC))
		to_chat(src, "<span class='danger'>I have been banned from LOOC.</span>")
		return

	if(!mob)
		return

	if(mob.stat && !holder)
		to_chat(src, span_danger("You are unconscious!"))

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, "<span class='danger'> You have OOC muted.</span>")
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return


	msg = emoji_parse(msg)
	msg = parsemarkdown_basic(msg, limited = TRUE, barebones = TRUE)

	mob.log_talk("LOOC: [msg]", LOG_LOOC)

	var/prefix = "LOOC"
	var/list/mobs = list()
	var/muted = prefs.muted
	for(var/mob/M in range(7,src))
		var/added_text
		var/client/C = M.client
		if(!M.client)
			continue
		mobs += C
		if(C in GLOB.admins)
			added_text += " ([mob.ckey]) <A href='?_src_=holder;[HrefToken()];mute=[ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>\[MUTE\]</font></a>"
		if (isobserver(M))
			continue //Also handled later.

		if(C.prefs.chat_toggles & CHAT_OOC)
			to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>")

	for(var/client/C in GLOB.admins)
		if(C in mobs)
			continue
		to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name] ([mob.ckey]) <A href='?_src_=holder;[HrefToken()];mute=[ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>MUTE</font></a>:</EM> <span class='message'>[msg]</span></b></font>")

	if(!(src in GLOB.admins))
		to_chat(usr, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>")
