/client/proc/cmd_admin_say(msg as text)
    set category = "Admin.Admin"
    set name = "Asay"
    set hidden = 0
    if(!check_rights(0))
        return
    msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
    if(!msg)
        return
    SSplexora.relay_admin_say(src, html_decode(msg))
    mob.log_talk(msg, LOG_ASAY)

    // Parse emoji before checking for links
    msg = emoji_parse(msg)

    // Check for admin pings with @ or #
    var/list/pinged_admin_clients
    if(findtext(msg, "@") || findtext(msg, "#"))
        var/list/link_results = check_asay_links(msg)
        if(length(link_results))
            msg = link_results[ASAY_LINK_NEW_MESSAGE_INDEX]
            link_results[ASAY_LINK_NEW_MESSAGE_INDEX] = null
            pinged_admin_clients = link_results[ASAY_LINK_PINGED_ADMINS_INDEX]

            // Ping admins who were mentioned
            for(var/iter_ckey in pinged_admin_clients)
                var/client/iter_admin_client = pinged_admin_clients[iter_ckey]
                if(!iter_admin_client?.holder)
                    continue
                window_flash(iter_admin_client)
                SEND_SOUND(iter_admin_client.mob, sound('sound/misc/asay_ping.ogg'))

    msg = keywords_lookup(msg)
    msg = parsemarkdown_basic(msg, limited = TRUE, barebones = TRUE)
    var/custom_asay_color = (CONFIG_GET(flag/allow_admin_asaycolor) && prefs.asaycolor) ? "<font color=[prefs.asaycolor]>" : "<font color='#FF4500'>"
    msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> [ADMIN_FLW(mob)]: [custom_asay_color]<span class='message linkify'>[msg]</span></span>[custom_asay_color ? "</font>":null]"
    to_chat(GLOB.admins, msg)
    SSblackbox.record_feedback("tally", "admin_verb", 1, "Asay")

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)
