#define LOOT_EDITOR_MAX_DEPTH 6

/datum/loot_table_editor
	var/list/tables = list()
	var/root_path
	var/selected
	var/notice
	var/list/search_results = list()
	var/list/last_roll
	var/list/tally
	var/tally_runs = 0
	var/tally_nothing = 0
	var/export_text

/client/proc/loot_table_editor()
	set category = "Debug"
	set name = "Loot Table Editor"
	if(!check_rights(R_DEBUG))
		return
	var/datum/loot_table_editor/editor = new()
	editor.ui_interact(mob)

/datum/loot_table_editor/ui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/loot_table_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LootTableEditor")
		ui.open()

/datum/loot_table_editor/ui_static_data(mob/user)
	var/list/loadable = list()
	for(var/type in typesof(/datum/loot_table))
		if(type != /datum/loot_table)
			loadable += "[type]"
	return list("loadable" = loadable)

/datum/loot_table_editor/ui_data(mob/user)
	refresh_odds()
	var/list/table_list = list()
	for(var/path in tables)
		table_list += list(tables[path])
	return list(
		"tables" = table_list,
		"root" = root_path,
		"selected" = selected,
		"notice" = notice,
		"search_results" = search_results,
		"last_roll" = last_roll,
		"tally" = tally,
		"tally_runs" = tally_runs,
		"tally_nothing" = tally_nothing,
		"export_text" = export_text,
	)

/datum/loot_table_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	notice = null

	switch(action)
		if("reset")
			reset()
			return TRUE

		if("new_root")
			var/name_text = trim("[params["name"]]")
			var/slug = loot_editor_slug(name_text)
			if(!length(slug))
				notice = "Give the table a name first."
				return TRUE
			reset()
			root_path = "/datum/loot_table/[slug]"
			make_table(root_path, name_text)
			selected = root_path
			if(ispath(text2path(root_path)))
				notice = "Warning: [root_path] already exists in code. Exporting will collide with it."
			return TRUE

		if("load_table")
			var/typepath = text2path("[params["path"]]")
			if(!ispath(typepath, /datum/loot_table))
				notice = "That isn't a loot table."
				return TRUE
			reset()
			root_path = "[typepath]"
			load_table(typepath)
			selected = root_path
			return TRUE

		if("select")
			if(tables["[params["path"]]"])
				selected = "[params["path"]]"
			return TRUE

		if("set_table_var")
			set_table_var(params)
			return TRUE

		if("add_entry")
			add_entry(params)
			return TRUE

		if("add_subtable")
			add_subtable(params)
			return TRUE

		if("sort_entries")
			var/list/table = tables["[params["table"]]"]
			if(!table || !table["cascading"])
				return TRUE
			var/list/entries = table["entries"]
			if(length(entries) < 2)
				return TRUE

			for(var/i in 2 to length(entries))
				var/list/key = entries[i]
				var/j = i - 1
				while(j >= 1 && entries[j]["value"] > key["value"])
					entries[j + 1] = entries[j]
					j--
				entries[j + 1] = key
			return TRUE

		if("remove_entry")
			var/list/table = tables["[params["table"]]"]
			if(!table)
				return TRUE
			var/list/entries = table["entries"]
			var/index = text2num("[params["index"]]")
			if(index < 1 || index > length(entries))
				return TRUE
			entries.Cut(index, index + 1)
			cleanup_orphans()
			if(!tables[selected])
				selected = root_path
			return TRUE

		if("set_entry")
			var/list/table = tables["[params["table"]]"]
			if(!table)
				return TRUE
			var/list/entries = table["entries"]
			var/index = text2num("[params["index"]]")
			if(index < 1 || index > length(entries))
				return TRUE
			var/list/entry = entries[index]
			var/value = text2num("[params["value"]]")
			if(isnull(value))
				return TRUE
			entry["value"] = table["cascading"] ? clamp(value, 0, 100) : max(0, value)
			return TRUE

		if("move_entry")
			var/list/table = tables["[params["table"]]"]
			if(!table)
				return TRUE
			var/list/entries = table["entries"]
			var/index = text2num("[params["index"]]")
			var/dir_change = text2num("[params["dir"]]") > 0 ? 1 : -1
			var/target = index + dir_change
			if(index < 1 || index > length(entries) || target < 1 || target > length(entries))
				return TRUE
			entries.Swap(index, target)
			return TRUE

		if("search")
			var/query = lowertext(trim("[params["query"]]"))
			search_results = list()
			if(length(query) < 3)
				notice = "Type at least 3 characters to search."
				return TRUE
			for(var/type in typesof(/obj/item))
				var/type_text = "[type]"
				if(findtext(type_text, query))
					search_results += type_text
					if(length(search_results) >= 30)
						break
			if(!length(search_results))
				notice = "No item paths match '[query]'."
			return TRUE

		if("roll")
			if(root_path)
				do_roll()
			return TRUE

		if("roll_many")
			if(root_path)
				do_tally(1000)
			return TRUE

		if("export")
			if(root_path)
				export_text = export_dm()
			return TRUE

		if("close_export")
			export_text = null
			return TRUE

		if("save_export")
			if(!root_path)
				return TRUE
			var/save_path = "data/loot_export/[usr.ckey]_export.dm"
			fdel(save_path)
			text2file(export_dm(), save_path)
			usr << ftp(file(save_path), "[loot_editor_slug(tables[root_path]["name"])].dm")
			return TRUE

/datum/loot_table_editor/proc/reset()
	tables = list()
	root_path = null
	selected = null
	search_results = list()
	last_roll = null
	tally = null
	tally_runs = 0
	tally_nothing = 0
	export_text = null

/datum/loot_table_editor/proc/make_table(path_text, table_name)
	var/list/table = list(
		"path" = path_text,
		"name" = table_name,
		"cascading" = FALSE,
		"luck_chance_bonus" = 0,
		"req_keys" = list(),
		"min_level" = 0,
		"growth_factor" = null,
		"rolls" = 1,
		"base_min" = 1,
		"base_max" = 3,
		"scaling_factor" = 0.4,
		"entries" = list(),
		"reach" = 0,
		"nothing" = 0,
	)
	tables[path_text] = table
	return table

/datum/loot_table_editor/proc/load_table(table_path, depth = 0)
	var/path_text = "[table_path]"
	if(tables[path_text] || depth > LOOT_EDITOR_MAX_DEPTH)
		return
	var/datum/loot_table/source = get_loot_table(table_path)
	var/list/table = make_table(path_text, source.name)
	table["cascading"] = source.cascading ? TRUE : FALSE
	table["luck_chance_bonus"] = source.luck_chance_bonus
	table["min_level"] = source.min_level
	table["growth_factor"] = source.growth_factor
	table["rolls"] = source.rolls
	table["base_min"] = source.base_min
	table["base_max"] = source.base_max
	table["scaling_factor"] = source.scaling_factor
	var/list/key_list = list()
	for(var/key in source.req_keys)
		key_list += "[key]"
	table["req_keys"] = key_list

	var/list/entries = table["entries"]
	for(var/entry in source.loot_table)
		var/is_table = ispath(entry, /datum/loot_table)
		entries += list(list(
			"path" = "[entry]",
			"value" = source.loot_table[entry],
			"is_table" = is_table,
			"odds" = 0,
			"effective" = 0,
		))
		if(is_table)
			load_table(entry, depth + 1)

/datum/loot_table_editor/proc/set_table_var(list/params)
	var/list/table = tables["[params["table"]]"]
	if(!table)
		return
	var/value = params["value"]
	switch("[params["var"]]")
		if("name")
			table["name"] = copytext(trim("[value]"), 1, 60)
		if("cascading")
			table["cascading"] = text2num("[value]") ? TRUE : FALSE
			if(table["cascading"])
				for(var/list/entry in table["entries"])
					entry["value"] = clamp(entry["value"], 0, 100)
		if("luck_chance_bonus", "scaling_factor")
			table["[params["var"]]"] = text2num("[value]") || 0
		if("min_level", "base_min", "base_max")
			table["[params["var"]]"] = max(0, round(text2num("[value]") || 0))
		if("rolls")
			table["rolls"] = max(1, round(text2num("[value]") || 1))
		if("growth_factor")
			var/growth = text2num("[value]")
			table["growth_factor"] = (growth && growth > 0) ? growth : null // 0 = use default
		if("req_keys")
			var/list/keys = list()
			for(var/token in splittext("[value]", ","))
				var/key = trim(token)
				if(!length(key))
					continue
				if(copytext(key, 1, 2) == "/" && !ispath(text2path(key)))
					notice = "[key] is not a valid path, skipped."
					continue
				keys += key
			table["req_keys"] = keys

/datum/loot_table_editor/proc/add_entry(list/params)
	var/list/table = tables["[params["table"]]"]
	var/path_text = trim("[params["path"]]")
	if(!table || !length(path_text))
		return
	var/list/entries = table["entries"]
	for(var/list/entry in entries)
		if(entry["path"] == path_text)
			notice = "That entry is already in this table."
			return

	var/typepath = text2path(path_text)
	var/is_table = FALSE
	if(tables[path_text])
		is_table = TRUE
	else if(ispath(typepath, /datum/loot_table))
		is_table = TRUE
		load_table(typepath)
	else if(!ispath(typepath, /atom/movable))
		notice = "[path_text] isn't a valid item or loot table path."
		return

	if(is_table && (path_text == table["path"] || table_reaches(path_text, table["path"])))
		notice = "That would create a loop."
		return

	entries += list(list(
		"path" = path_text,
		"value" = table["cascading"] ? 25 : 10,
		"is_table" = is_table,
		"odds" = 0,
		"effective" = 0,
	))

/datum/loot_table_editor/proc/add_subtable(list/params)
	var/list/table = tables["[params["table"]]"]
	if(!table)
		return
	var/slug = loot_editor_slug("[params["name"]]")
	if(!length(slug))
		notice = "Give the sub-table a name."
		return
	var/new_path = "[table["path"]]/[slug]"
	if(tables[new_path])
		notice = "A sub-table with that name already exists."
		return
	make_table(new_path, trim("[params["name"]]"))
	var/list/entries = table["entries"]
	entries += list(list(
		"path" = new_path,
		"value" = table["cascading"] ? 25 : 10,
		"is_table" = TRUE,
		"odds" = 0,
		"effective" = 0,
	))
	selected = new_path

/datum/loot_table_editor/proc/table_reaches(from_path, target, depth = 0)
	var/list/table = tables[from_path]
	if(!table || depth > LOOT_EDITOR_MAX_DEPTH)
		return FALSE
	for(var/list/entry in table["entries"])
		if(!entry["is_table"])
			continue
		if(entry["path"] == target || table_reaches(entry["path"], target, depth + 1))
			return TRUE
	return FALSE

/datum/loot_table_editor/proc/cleanup_orphans()
	var/list/order = list()
	collect_order(root_path, order)
	for(var/path in tables.Copy())
		if(!(path in order))
			tables -= path

/datum/loot_table_editor/proc/collect_order(path, list/order, depth = 0)
	if(!tables[path] || (path in order) || depth > LOOT_EDITOR_MAX_DEPTH)
		return
	order += path
	var/list/table = tables[path]
	for(var/list/entry in table["entries"])
		if(entry["is_table"])
			collect_order(entry["path"], order, depth + 1)

/datum/loot_table_editor/proc/refresh_odds()
	for(var/path in tables)
		var/list/table = tables[path]
		var/list/entries = table["entries"]
		table["reach"] = 0
		if(table["cascading"])
			var/remaining = 100
			for(var/list/entry in entries)
				var/share = remaining * clamp(entry["value"], 0, 100) / 100
				entry["odds"] = share
				remaining -= share
			table["nothing"] = remaining
		else
			var/total = 0
			for(var/list/entry in entries)
				total += max(0, entry["value"])
			for(var/list/entry in entries)
				entry["odds"] = total > 0 ? max(0, entry["value"]) / total * 100 : 0
			table["nothing"] = total > 0 ? 0 : 100

	if(root_path && tables[root_path])
		accumulate_reach(root_path, 100, 0)

	for(var/path in tables)
		var/list/table = tables[path]
		for(var/list/entry in table["entries"])
			entry["effective"] = table["reach"] * entry["odds"] / 100

/datum/loot_table_editor/proc/accumulate_reach(path, probability, depth)
	var/list/table = tables[path]
	if(!table || depth > LOOT_EDITOR_MAX_DEPTH)
		return
	table["reach"] += probability
	for(var/list/entry in table["entries"])
		if(entry["is_table"])
			accumulate_reach(entry["path"], probability * entry["odds"] / 100, depth + 1)

/datum/loot_table_editor/proc/roll_table(path, list/route, depth = 0)
	var/list/table = tables[path]
	if(!table || depth > LOOT_EDITOR_MAX_DEPTH)
		return null
	route += table["name"]
	var/list/entries = table["entries"]
	var/list/picked

	if(table["cascading"])
		for(var/list/entry in entries)
			if(prob(clamp(entry["value"], 0, 100)))
				picked = entry
				break
	else
		var/list/pool = list()
		for(var/i in 1 to length(entries))
			var/list/entry = entries[i]
			if(entry["value"] > 0)
				pool["[i]"] = entry["value"]
		if(length(pool))
			picked = entries[text2num(pickweight(pool))]

	if(!picked)
		return null
	if(picked["is_table"])
		return roll_table(picked["path"], route, depth + 1)
	return picked["path"]

/datum/loot_table_editor/proc/do_roll()
	var/list/route = list()
	var/result = roll_table(root_path, route)
	if(!result)
		last_roll = list("found" = FALSE, "route" = route)
		return
	var/typepath = text2path(result)
	last_roll = list(
		"found" = TRUE,
		"path" = result,
		"name" = item_name(typepath),
		"icon" = item_icon(typepath),
		"route" = route,
	)

/datum/loot_table_editor/proc/do_tally(runs)
	var/list/counts = list()
	var/nothing = 0
	for(var/i in 1 to runs)
		var/result = roll_table(root_path, list())
		if(result)
			counts[result] = (counts[result] || 0) + 1
		else
			nothing++

	var/list/top = list()
	var/list/remaining = counts.Copy()
	for(var/n in 1 to 15)
		var/best_path
		var/best_count = 0
		for(var/path in remaining)
			if(remaining[path] > best_count)
				best_count = remaining[path]
				best_path = path
		if(!best_path)
			break
		top += list(list(
			"path" = best_path,
			"name" = item_name(text2path(best_path)),
			"count" = best_count,
			"pct" = best_count / runs * 100,
		))
		remaining -= best_path

	tally = top
	tally_runs = runs
	tally_nothing = nothing

/datum/loot_table_editor/proc/item_name(typepath)
	var/atom/A = typepath
	return initial(A.name)

/datum/loot_table_editor/proc/item_icon(typepath)
	var/atom/A = typepath
	var/icon_file = initial(A.icon)
	if(!icon_file)
		return null
	try
		return icon2base64(icon(icon_file, initial(A.icon_state), SOUTH, 1))
	catch
		return null

/datum/loot_table_editor/proc/export_dm()
	var/list/order = list()
	collect_order(root_path, order)
	var/list/out = list()
	for(var/path in order)
		out += export_table(tables[path], path == root_path)
	return jointext(out, "\n\n")

//this could probably be in the tsx but its better it gets sanitized server side first.
/datum/loot_table_editor/proc/export_table(list/table, is_root)
	var/list/lines = list()
	lines += "[table["path"]]"
	lines += "\tname = \"[replacetext(table["name"], "\"", "\\\"")]\""
	if(table["cascading"])
		lines += "\tcascading = TRUE"
		if(table["luck_chance_bonus"])
			lines += "\tluck_chance_bonus = [table["luck_chance_bonus"]]"

	if(!is_root)
		var/list/keys = table["req_keys"]
		if(length(keys))
			var/list/tokens = list()
			for(var/key in keys)
				tokens += key_token(key)
			lines += "\treq_keys = list([jointext(tokens, ", ")])"
		if(table["min_level"])
			lines += "\tmin_level = [table["min_level"]]"
		if(!isnull(table["growth_factor"]))
			lines += "\tgrowth_factor = [table["growth_factor"]]"
		if(table["rolls"] != 1)
			lines += "\trolls = [table["rolls"]]"

	lines += "\tloot_table = list("
	var/list/entries = table["entries"]
	for(var/i in 1 to length(entries))
		var/list/entry = entries[i]
		lines += "\t\t[entry["path"]] = [entry["value"]][i < length(entries) ? "," : ""]"
	lines += "\t)"

	if(is_root)
		var/list/root_vars = list()
		if(table["base_min"] != 1)
			root_vars += "\tbase_min = [table["base_min"]]"
		if(table["base_max"] != 3)
			root_vars += "\tbase_max = [table["base_max"]]"
		if(table["scaling_factor"] != 0.4)
			root_vars += "\tscaling_factor = [table["scaling_factor"]]"
		if(length(root_vars))
			lines += ""
			lines += root_vars
	return jointext(lines, "\n")

/// Paths and STAT_ macros are written raw, anything else as a string.
/datum/loot_table_editor/proc/key_token(key)
	if(copytext(key, 1, 2) == "/" || findtext(key, "STAT_") == 1)
		return key
	return "\"[key]\""

//this is just for exporting easier
/proc/loot_editor_slug(text)
	var/static/regex/bad_chars = regex(@"[^a-z0-9_]", "g")
	return bad_chars.Replace(lowertext(trim("[text]")), "_")
