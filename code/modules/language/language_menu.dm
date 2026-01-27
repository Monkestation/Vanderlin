/datum/language_menu
	var/datum/language_holder/language_holder

/datum/language_menu/New(language_holder)
	src.language_holder = language_holder

/datum/language_menu/Destroy()
	language_holder = null
	return ..()

/datum/language_menu/ui_interact(mob/user)
	if(!user || !user.client)
		return

	var/datum/browser/popup = new(user, "language_menu", "Language Menu", 700, 600)
	popup.set_content(get_html(user))
	popup.open()

/datum/language_menu/proc/get_html(mob/user)
	var/atom/movable/AM = language_holder.get_atom()
	var/is_living = isliving(AM)
	var/is_admin = check_rights_for(user.client, R_ADMIN) || isobserver(AM)

	var/list/partial_languages = language_holder.get_partially_understood_languages()

	var/list/language_data = list()
	for(var/datum/language/LD as anything in GLOB.all_languages)
		var/result = language_holder.has_language(LD)
		var/partial_understanding = partial_languages[LD] || 0

		// Only show if we know it, understand it partially, or we're admin
		if(!result && !partial_understanding && !is_admin)
			continue

		var/list/lang_info = list()
		lang_info["type"] = LD
		lang_info["name"] = initial(LD.name)
		lang_info["desc"] = initial(LD.desc)
		lang_info["key"] = initial(LD.key)
		lang_info["is_default"] = (LD == language_holder.selected_default_language)
		lang_info["can_speak"] = result ? TRUE : FALSE
		lang_info["can_understand"] = result ? TRUE : FALSE
		lang_info["partial_understanding"] = partial_understanding
		lang_info["icon"] = initial(LD.icon)
		lang_info["icon_state"] = initial(LD.icon_state)

		if(AM)
			lang_info["could_speak"] = AM.could_speak_in_language(LD)
			if(!lang_info["could_speak"] && !language_holder.omnitongue)
				lang_info["can_speak"] = FALSE
		else
			lang_info["could_speak"] = TRUE

		language_data += list(lang_info)

	// Sort: speakable first, then by name
	language_data = sortTim(language_data, GLOBAL_PROC_REF(cmp_language_data))

	var/html = {"
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<style>
		body {
			font-family: Verdana, sans-serif;
			font-size: 13px;
			background-color: #1a1a1a;
			color: #d4d4d4;
			margin: 0;
			padding: 10px;
		}
		.header {
			background-color: #2a2a2a;
			padding: 10px;
			margin-bottom: 10px;
			border-radius: 3px;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}
		.admin-badge {
			color: #ff6b6b;
			font-style: italic;
		}
		table {
			width: 100%;
			border-collapse: collapse;
		}
		th {
			background-color: #2a2a2a;
			padding: 8px;
			text-align: left;
			border-bottom: 2px solid #3a3a3a;
		}
		td {
			padding: 8px;
			border-bottom: 1px solid #2a2a2a;
			vertical-align: middle;
		}
		tr.candystripe:nth-child(even) {
			background-color: #1e1e1e;
		}
		tr.candystripe:nth-child(odd) {
			background-color: #1a1a1a;
		}
		.tooltip {
			position: relative;
			display: inline-block;
			border-bottom: 2px dotted rgba(255, 255, 255, 0.8);
			cursor: help;
		}
		.status-indicator {
			display: inline-block;
			width: 12px;
			height: 12px;
			border-radius: 50%;
			margin: 0 auto;
		}
		.status-good { background-color: #4caf50; }
		.status-bad { background-color: #f44336; }
		.status-average { background-color: #ff9800; }
		.status-grey { background-color: #9e9e9e; }

		button {
			background-color: #3a3a3a;
			color: #d4d4d4;
			border: 1px solid #4a4a4a;
			padding: 4px 12px;
			cursor: pointer;
			border-radius: 3px;
			margin: 0 2px;
			font-size: 12px;
		}
		button:hover {
			background-color: #4a4a4a;
		}
		button:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}
		button.selected {
			background-color: #4caf50;
			border-color: #66bb6a;
		}
		.checkbox {
			width: 18px;
			height: 18px;
			display: inline-block;
			border: 2px solid #4a4a4a;
			border-radius: 3px;
			background-color: #2a2a2a;
			cursor: pointer;
			position: relative;
			vertical-align: middle;
		}
		.checkbox.checked {
			background-color: #4caf50;
			border-color: #66bb6a;
		}
		.checkbox.checked::after {
			content: 'X';
			position: absolute;
			color: white;
			font-weight: bold;
			left: 4px;
			top: 0px;
			font-size: 14px;
		}
		.checkbox.disabled {
			opacity: 0.3;
			cursor: not-allowed;
		}
		.partial-understanding {
			display: inline-block;
			border-bottom: 2px dotted rgba(255, 255, 255, 0.8);
			cursor: help;
		}
		.center-content {
			text-align: center;
		}
	</style>
</head>
<body>
	<div class="header">
		[is_admin ? "<span class='admin-badge'>- Admin Mode -</span>" : "<span>Language Menu</span>"]
		[is_admin ? "<button class='[language_holder.omnitongue ? "selected" : ""]' onclick=\"omnitongueToggle();\">Omnitongue [language_holder.omnitongue ? "Enabled" : "Disabled"]</button>" : ""]
	</div>

	<table>
		<thead>
			<tr>
				<th>Name</th>
				<th class="center-content">Speak</th>
				<th class="center-content">Understand</th>
				<th><span class="tooltip" title="Use this key in your message to speak in this language.">Key</span></th>
				[is_living ? "<th class=\"center-content\"><span class='tooltip' title=\"Determines which language you speak naturally, without using the 'key'.\">Default</span></th>" : ""]
				[is_admin ? "<th>Actions</th>" : ""]
			</tr>
		</thead>
		<tbody>
	"}

	for(var/list/lang in language_data)
		html += get_language_row_html(lang, is_living, is_admin)

	html += {"
		</tbody>
	</table>

	<script>
		function selectDefault(langName) {
			window.location = 'byond://?src=[REF(src)];action=select_default;language_name=' + encodeURIComponent(langName);
		}

		function grantLanguage(langName) {
			window.location = 'byond://?src=[REF(src)];action=grant_language;language_name=' + encodeURIComponent(langName);
		}

		function removeLanguage(langName) {
			window.location = 'byond://?src=[REF(src)];action=remove_language;language_name=' + encodeURIComponent(langName);
		}

		function omnitongueToggle() {
			window.location = 'byond://?src=[REF(src)];action=toggle_omnitongue';
		}
	</script>
</body>
</html>
	"}

	return html

/datum/language_menu/proc/get_language_row_html(list/lang, is_living, is_admin)
	var/speak_color = "grey"
	var/speak_tooltip = ""

	if(lang["could_speak"])
		if(lang["can_speak"])
			speak_color = "good"
		else
			speak_color = "bad"
	else
		if(lang["can_speak"])
			speak_color = "average"
			speak_tooltip = "title='Despite knowing how to speak [lang["name"]], you are unable due to physical limitations (usually, your tongue).'"
		else
			speak_color = "grey"
			speak_tooltip = "title='Even if you were to learn how to speak [lang["name"]], you would be unable due to physical limitations (usually, your tongue).'"

	var/understand_html = ""
	if(!lang["can_understand"] && lang["partial_understanding"] > 0)
		understand_html = "<span class='partial-understanding' title='You can only partially understand [lang["name"]].'>[lang["partial_understanding"]]%</span>"
	else
		var/understand_color = lang["can_understand"] ? "good" : "bad"
		understand_html = "<div class='status-indicator status-[understand_color]'></div>"

	var/name_html = lang["desc"] ? "<span class='tooltip' title='[lang["desc"]]'>[lang["name"]]</span>" : lang["name"]

	var/default_html = ""
	if(is_living)
		var/can_set_default = lang["could_speak"] && lang["can_speak"]
		var/checkbox_class = lang["is_default"] ? "checked" : ""
		if(!can_set_default && !lang["is_default"])
			checkbox_class += " disabled"

		if(can_set_default)
			default_html = "<td class='center-content'><div class='checkbox [checkbox_class]' onclick=\"selectDefault('[lang["name"]]');\"></div></td>"
		else if(lang["is_default"])
			default_html = "<td class='center-content'><div class='checkbox [checkbox_class]'></div></td>"
		else
			default_html = "<td class='center-content'><div class='checkbox disabled'></div></td>"

	var/admin_html = ""
	if(is_admin)
		var/grant_disabled = (lang["can_speak"] && lang["can_understand"]) ? "disabled" : ""
		var/remove_disabled = (!lang["can_speak"] && !lang["can_understand"]) ? "disabled" : ""
		admin_html = {"
			<td>
				<button [grant_disabled] onclick="grantLanguage('[lang["name"]]');">Grant</button>
				<button [remove_disabled] onclick="removeLanguage('[lang["name"]]');">Remove</button>
			</td>
		"}

	return {"
		<tr class="candystripe">
			<td>[name_html]</td>
			<td class="center-content"><div class='status-indicator status-[speak_color]' [speak_tooltip]></div></td>
			<td class="center-content">[understand_html]</td>
			<td>,[lang["key"]]</td>
			[default_html]
			[admin_html]
		</tr>
	"}

/datum/language_menu/Topic(href, href_list)
	if(..())
		return TRUE

	var/mob/user = usr
	if(!user || !user.client)
		return TRUE

	var/atom/movable/AM = language_holder.get_atom()
	var/language_name = href_list["language_name"]
	var/datum/language/language_datum
	for(var/datum/language/LD as anything in GLOB.all_languages)
		if(language_name == initial(LD.name))
			language_datum = LD
			break

	var/is_admin = check_rights_for(user.client, R_ADMIN)

	switch(href_list["action"])
		if("select_default")
			if(language_datum && AM)
				if(AM.could_speak_in_language(language_datum) && language_holder.has_language(language_datum))
					language_holder.selected_default_language = language_datum
					ui_interact(user)

		if("grant_language")
			if((is_admin || isobserver(AM)) && language_datum)
				language_holder.grant_language(language_datum)
				if(is_admin)
					message_admins("[key_name_admin(user)] granted the [language_name] language to [key_name_admin(AM)].")
					log_admin("[key_name(user)] granted the language [language_name] to [key_name(AM)].")
				ui_interact(user)

		if("remove_language")
			if((is_admin || isobserver(AM)) && language_datum)
				language_holder.remove_language(language_datum)
				if(is_admin)
					message_admins("[key_name_admin(user)] removed the [language_name] language from [key_name_admin(AM)].")
					log_admin("[key_name(user)] removed the language [language_name] from [key_name(AM)].")
				ui_interact(user)

		if("toggle_omnitongue")
			if(is_admin || isobserver(AM))
				language_holder.omnitongue = !language_holder.omnitongue
				if(is_admin)
					message_admins("[key_name_admin(user)] [language_holder.omnitongue ? "enabled" : "disabled"] the ability to speak all languages (that they know) of [key_name_admin(AM)].")
					log_admin("[key_name(user)] [language_holder.omnitongue ? "enabled" : "disabled"] the ability to speak all languages (that they know) of [key_name(AM)].")
				ui_interact(user)

	return TRUE

/proc/cmp_language_data(list/a, list/b)
	var/a_speak = a["can_speak"] ? 1 : 0
	var/b_speak = b["can_speak"] ? 1 : 0

	if(a_speak != b_speak)
		return b_speak - a_speak

	return sorttext(a["name"], b["name"])
