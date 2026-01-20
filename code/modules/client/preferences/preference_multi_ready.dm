/datum/preferences/proc/open_multi_ready()
	if(!parent)
		return
	if(!multi_ready_panel)
		multi_ready_panel = new /datum/multi_ready_ui(parent)
	multi_ready_panel.open()

/datum/multi_ready_ui
	var/client/owner
	var/datum/preferences/prefs

/datum/multi_ready_ui/New(client/C)
	owner = C
	prefs = C.prefs

/datum/multi_ready_ui/proc/open()
	if(!owner || !prefs)
		return
	var/html = build_html()
	var/datum/browser/popup = new(owner.mob, "multireadyui", "Multi-Character Ready", 450, 550)
	popup.set_content(html)
	popup.open()

/datum/multi_ready_ui/proc/build_html()
	var/list/dat = list()

	dat += {"
<!DOCTYPE html>
<html>
<head>
<style>
body {
	font-family: Verdana, sans-serif;
	font-size: 12px;
	margin: 10px;
}
h2 {
	margin: 0 0 10px 0;
	padding-bottom: 5px;
	border-bottom: 1px solid #e94560;
}
.toggle-section {
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 15px;
}
.toggle-btn {
	display: inline-block;
	padding: 8px 16px;
	border-radius: 4px;
	text-decoration: none;
	font-weight: bold;
	margin-right: 10px;
}
.toggle-on {
	color: #1a1a2e;
}
.toggle-off {
	color: #aaa;
}
.slot-list {
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 15px;
}
.slot-item {
	background: #0f3460;
	padding: 8px 10px;
	margin: 5px 0;
	border-radius: 4px;
	display: flex;
	align-items: center;
	justify-content: space-between;
}
.slot-item.selected {
	background: #1f4068;
	border-left: 3px solid #4ecca3;
}
.slot-item.available {
	background: #1a1a2e;
	border: 1px dashed #393e46;
}
.slot-name {
	flex-grow: 1;
	margin-left: 10px;
}
.slot-priority {
	background: #e94560;
	color: white;
	padding: 2px 8px;
	border-radius: 10px;
	font-size: 10px;
	margin-right: 10px;
}
.slot-actions a {
	color: #4ecca3;
	text-decoration: none;
	padding: 3px 6px;
	margin: 0 2px;
}
.slot-actions a:hover {
	background: #4ecca3;
	color: #1a1a2e;
	border-radius: 3px;
}
.add-btn {
	color: #4ecca3;
	text-decoration: none;
	font-size: 11px;
}
.add-btn:hover {
	text-decoration: underline;
}
.section-title {
	color: #aaa;
	font-size: 11px;
	text-transform: uppercase;
	margin-bottom: 8px;
}
.info-box {
	padding: 10px;
	border-radius: 5px;
	font-size: 11px;
	color: #aaa;
	line-height: 1.5;
}
.job-preview {
	font-size: 10px;
	color: #888;
	margin-top: 3px;
}
</style>
</head>
<body>
"}

	// Toggle section
	dat += {"<div class='toggle-section'>"}
	if(prefs.multi_char_ready)
		dat += {"<a href='?src=[REF(src)];toggle_multi=1' class='toggle-btn toggle-on'>ENABLED</a>"}
		dat += {"<span>Ready up with multiple characters</span>"}
	else
		dat += {"<a href='?src=[REF(src)];toggle_multi=1' class='toggle-btn toggle-off'>DISABLED</a>"}
		dat += {"<span>Using single character mode</span>"}
	dat += {"</div>"}

	if(!prefs.multi_char_ready)
		dat += {"
<div class='info-box'>
Enable multi-character ready to select multiple character slots.
The system will try to assign you a job based on each character's preferences in priority order.
</div>
"}
	else
		// Selected characters section
		dat += {"<div class='slot-list'>"}
		dat += {"<div class='section-title'>Selected Characters (Priority Order)</div>"}

		if(!length(prefs.multi_ready_slots))
			dat += {"<div style='color:#888;padding:10px;text-align:center;'>No characters selected. Add some below!</div>"}
		else
			var/priority = 1
			for(var/slot in prefs.multi_ready_slots)
				var/list/slot_info = get_slot_info(slot)
				var/name = slot_info["name"]
				var/species = slot_info["species"]
				var/jobs = slot_info["jobs"]

				dat += {"<div class='slot-item selected'>"}
				dat += {"<span class='slot-priority'>#[priority]</span>"}
				dat += {"<div class='slot-name'>"}
				dat += {"<b>[name]</b> <span style='color:#888;'>([species])</span>"}
				if(jobs)
					dat += {"<div class='job-preview'>[jobs]</div>"}
				dat += {"</div>"}
				dat += {"<div class='slot-actions'>"}
				if(priority > 1)
					dat += {"<a href='?src=[REF(src)];move_up=[slot]' title='Move Up'>Up</a>"}
				if(priority < length(prefs.multi_ready_slots))
					dat += {"<a href='?src=[REF(src)];move_down=[slot]' title='Move Down'>Down</a>"}
				dat += {"<a href='?src=[REF(src)];remove_slot=[slot]' title='Remove'>Remove</a>"}
				dat += {"</div>"}
				dat += {"</div>"}
				priority++

		dat += {"</div>"}

		// Available characters section
		dat += {"<div class='slot-list'>"}
		dat += {"<div class='section-title'>Available Characters</div>"}

		var/has_available = FALSE
		for(var/slot in 1 to prefs.max_save_slots)
			if(slot in prefs.multi_ready_slots)
				continue
			var/list/slot_info = get_slot_info(slot)
			if(!slot_info["exists"])
				continue
			has_available = TRUE

			var/name = slot_info["name"]
			var/species = slot_info["species"]

			dat += {"<div class='slot-item available'>"}
			dat += {"<div class='slot-name'>"}
			dat += {"<b>[name]</b> <span style='color:#888;'>([species])</span>"}
			dat += {"</div>"}
			dat += {"<a href='?src=[REF(src)];add_slot=[slot]' class='add-btn'>+ Add</a>"}
			dat += {"</div>"}

		if(!has_available)
			dat += {"<div style='color:#888;padding:10px;text-align:center;'>All character slots added or empty.</div>"}

		dat += {"</div>"}

		// Info box
		dat += {"
<div class='info-box'>
<b>How it works:</b><br>
When you ready up, the system will try to assign jobs in this order:<br>
1. First, it checks your #1 priority character's HIGH priority jobs<br>
2. Then #2 character's HIGH priority jobs, and so on<br>
3. Then it repeats for MEDIUM and LOW priorities<br><br>
The first character that gets a job is the one you'll spawn as.
</div>
"}

	dat += {"
</body>
</html>
"}

	return dat.Join("")

/datum/multi_ready_ui/proc/get_slot_info(slot_num)
	var/list/info = list(
		"exists" = FALSE,
		"name" = "Empty Slot",
		"species" = "Unknown",
		"jobs" = ""
	)

	if(!owner || !prefs)
		return info

	// Save current slot
	var/original_slot = prefs.default_slot

	// Try to load the target slot
	if(!prefs.load_character(slot_num))
		prefs.load_character(original_slot)
		return info

	info["exists"] = TRUE
	info["name"] = prefs.real_name ? prefs.real_name : "Unnamed"
	info["species"] = prefs.pref_species ? prefs.pref_species.name : "Human"

	// Get job preferences summary
	var/list/high_jobs = list()
	var/list/med_jobs = list()
	for(var/job_title in prefs.job_preferences)
		var/pref = prefs.job_preferences[job_title]
		if(pref == JP_HIGH)
			high_jobs += job_title
		else if(pref == JP_MEDIUM)
			med_jobs += job_title

	var/list/job_parts = list()
	if(length(high_jobs))
		job_parts += "High: [english_list(high_jobs)]"
	if(length(med_jobs))
		job_parts += "Med: [english_list(med_jobs)]"
	info["jobs"] = job_parts.Join(" | ")

	prefs.load_character(original_slot)

	return info

/datum/multi_ready_ui/Topic(href, list/href_list)
	. = ..()
	if(!owner || !prefs)
		return

	if(href_list["toggle_multi"])
		prefs.multi_char_ready = !prefs.multi_char_ready
		if(!prefs.multi_char_ready)
			prefs.multi_ready_slots = list()
		prefs.save_preferences()
		open()
		return

	if(href_list["add_slot"])
		var/slot = text2num(href_list["add_slot"])
		if(slot && slot > 0 && slot <= prefs.max_save_slots)
			if(!(slot in prefs.multi_ready_slots))
				prefs.multi_ready_slots += slot
				prefs.save_preferences()
		open()
		return

	if(href_list["remove_slot"])
		var/slot = text2num(href_list["remove_slot"])
		prefs.multi_ready_slots -= slot
		prefs.save_preferences()
		open()
		return

	if(href_list["move_up"])
		var/slot = text2num(href_list["move_up"])
		var/idx = prefs.multi_ready_slots.Find(slot)
		if(idx > 1)
			prefs.multi_ready_slots.Swap(idx, idx - 1)
			prefs.save_preferences()
		open()
		return

	if(href_list["move_down"])
		var/slot = text2num(href_list["move_down"])
		var/idx = prefs.multi_ready_slots.Find(slot)
		if(idx > 0 && idx < length(prefs.multi_ready_slots))
			prefs.multi_ready_slots.Swap(idx, idx + 1)
			prefs.save_preferences()
		open()
		return
