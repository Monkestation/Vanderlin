/datum/browser
	/// The mob that is using this browser.
	var/tmp/mob/user
	/// The object that owns this browser.
	var/tmp/datum/owner = null
	/// The window's title.
	var/final/title
	/// The ID used for browse and onclose.
	var/final/window_id
	/// The window's width in pixels.
	var/final/width
	/// The window's height in pixels.
	var/final/height
	/// Params for the window on creation.
	VAR_PROTECTED/window_options = "can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;"
	/// A list of paths to CSS files.
	VAR_PRIVATE/final/list/stylesheets = list()
	/// A list of paths to JavaScript files.
	VAR_PRIVATE/final/list/scripts = list()
	/// Text containing the contents of the \<head\> element.
	VAR_PRIVATE/final/head = ""
	/// Text containing the contents of the \<body\> element.
	VAR_PRIVATE/final/body = ""

/datum/browser/New(mob/user, window_id, title = "", width = 0, height = 0, atom/owner = null)
	if(!user)
		CRASH("created a browser for no user")
	if(!window_id)
		CRASH("created a browser with no window id")
	src.user = user
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(user_deleted))
	src.owner = owner
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(owner_deleted))
	src.window_id = window_id
	src.title = format_text(title)
	src.width = width
	src.height = height

/datum/browser/Destroy(force, ...)
	if(!isnull(user))
		var/client/user_client = isclient(user) ? user : user.client
		UnregisterSignal(user_client, COMSIG_MOB_CLIENT_MOVED)
	user = null
	owner = null
	return ..()

/datum/browser/noclose
/datum/browser/noclose/New(mob/user, window_id, title = "", width, height, atom/owner)
	. = ..()
	var/client/user_client = isclient(user) ? user : user.client
	UnregisterSignal(user_client, COMSIG_MOB_CLIENT_MOVED)

/datum/browser/proc/set_window_options(
	can_close = TRUE,
	can_minimize = TRUE,
	can_maximize = TRUE, //does this do anything?
	can_resize = TRUE,
	titlebar = TRUE,
	border = 0
)
	window_options = list2params(args)

/datum/browser/proc/add_stylesheet(name, file)
	if (istype(name, /datum/asset/spritesheet))
		var/datum/asset/spritesheet/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else if (istype(name, /datum/asset/spritesheet_batched))
		var/datum/asset/spritesheet_batched/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else
		var/asset_name = "[name].css"

		stylesheets[asset_name] = file

		if (!SSassets.cache[asset_name])
			SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_head_content(head_content)
	head = head_content

/datum/browser/proc/set_content(content)
	body = content

/datum/browser/proc/add_content(content)
	body += content

/datum/browser/proc/build_page()
	var/head_content = head
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	head_content += "<link rel='stylesheet' type='text/css' href='[common_asset.get_url_mappings()["common.css"]]'>"
	for(var/file in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"

	for(var/file in scripts)
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	return {"
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<head>
				[head_content]
			</head>
			<body scroll=auto>
				<div class='uiWrapper'>
					[title ? "<div class='uiTitle'><tt>[title]</tt></div>" : ""]
					<div class='[title ? "uiContent" : ""]'>
						[body]
					</div>
				</div>
			</body>
		</html>"}

/datum/browser/proc/open(use_onclose = TRUE)
	if(!user)
		return
	if(isnull(window_id))	//null check because this can potentially nuke goonchat
		stack_trace("Browser [title] tried to open with a null ID")
		to_chat(user, "<span class='danger'>The [title] browser you tried to open failed a sanity check! Please report this on github!</span>")
		return
	var/window_size = ""
	var/scaling = 1
	var/client/user_client = isclient(user) ? user : user.client
	if(user_client?.window_scaling)
		scaling = user_client.window_scaling
	if(width && height)
		window_size = "size=[width * scaling]x[height * scaling];"
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	common_asset.send(user)
	if(length(stylesheets))
		SSassets.transport.send_assets(user, stylesheets)
	if(length(scripts))
		SSassets.transport.send_assets(user, scripts)
	user << browse(build_page(), "window=[window_id];[window_size][window_options]")
	if (use_onclose)
		setup_onclose()

/datum/browser/proc/setup_onclose()
	set waitfor = 0 //winexists sleeps, so we don't need to.
	for (var/i in 1 to 10)
		if(isclient(user) && winexists(user, window_id))
			var/client/client_user = user
			onclose(client_user.mob, window_id, owner)
			break
		else
			if (user?.client && winexists(user?.client, window_id))
				onclose(user, window_id, owner)
				break

/datum/browser/proc/close()
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		user << browse(null, "window=[window_id]")
	else
		stack_trace("Browser [title] tried to close with a null ID")

/datum/browser/proc/user_deleted(datum/source)
	SIGNAL_HANDLER
	user = null

/datum/browser/proc/owner_deleted(datum/source)
	SIGNAL_HANDLER
	owner = null

/**
 * Registers the on-close verb for a browse window (client/verb/.windowclose)
 * this will be called when the close-button of a window is pressed.
 *
 * This is usually only needed for devices that regularly update the browse window,
 * e.g. canisters, timers, etc.
 *
 * windowid should be the specified window name
 * e.g. code is	: user << browse(text, "window=fred")
 * then use 	: onclose(user, "fred")
 *
 * Optionally, specify the "ref" parameter as the controlled atom (usually src)
 * to pass a "close=1" parameter to the atom's Topic() proc for special handling.
 * Otherwise, the user mob's machine var will be reset directly.
 **/
/proc/onclose(mob/user, windowid, atom/ref=null)
	if(!user.client)
		return
	var/param = "null"
	if(ref)
		param = "[REF(ref)]"

	winset(user, windowid, "on-close=\".windowclose [param]\"")

/**
 * the on-close client verb
 * called when a browser popup window is closed after registering with proc/onclose()
 *
 * if a valid atom reference is supplied, call the atom's Topic() with "close=1"
 * otherwise, just reset the client mob's machine var.
 **/
/client/verb/windowclose(atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		var/href = "close=1"
		if(hsrc)
			usr = src.mob
			src.Topic(href, params2list(href), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
		src.mob.unset_machine()
