/datum/status_effect/purpose
	id = "purpose"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/purpose

/atom/movable/screen/alert/status_effect/purpose
	name = "Tasks"
	desc = "I have things to do."
	icon_state = "purpose"
	alert_group = ALERT_STATUS

/atom/movable/screen/alert/status_effect/purpose/Click(location, control, params)
	. = ..()
	show_task_ui()

/atom/movable/screen/alert/status_effect/purpose/proc/show_task_ui(category_to_show = null)
	var/mob/living/carbon/human/user = usr
	if(!user?.mind || !length(user.mind.personal_objectives))
		return

	var/list/categories = list()
	for(var/datum/objective/personal/objective in user.mind.personal_objectives)
		if(!categories[objective.category])
			categories[objective.category] = list()
		categories[objective.category] += objective

	var/list/category_keys = categories
	var/current_category = category_to_show

	if(!current_category || !categories[current_category])
		current_category = category_keys[1]

	var/current_index = category_keys.Find(current_category)
	var/next_category = category_keys[(current_index % length(category_keys)) + 1]
	var/prev_category = category_keys[current_index == 1 ? length(category_keys) : (current_index - 1)]

	var/list/data = list()

	data += "<div style='text-align: center; padding-top: 30px; margin-bottom: 15px;'>"

	if(length(category_keys) > 1)
		data += "<a href='byond://?src=[REF(src)];purpose_category=[url_encode(prev_category)]' style='color: #e6b327; text-decoration: none; font-weight: bold; margin-right: 10px; font-size: 1.2em;'>&#9664;</a>"

	data += "<a href='byond://?src=[REF(src)];select_purpose_category=1' style='font-weight: bold; color: #bd1717; text-decoration: none; font-size: 1.4em;'>[current_category]</a>"

	if(length(category_keys) > 1)
		data += "<a href='byond://?src=[REF(src)];purpose_category=[url_encode(next_category)]' style='color: #e6b327; text-decoration: none; font-weight: bold; margin-left: 10px; font-size: 1.2em;'>&#9654;</a>"

	data += "</div>"
	data += "<div style='border-top: 1px solid #444; width: 80%; margin: 0 auto 15px auto;'></div>"

	data += "<div style='padding: 0 20px;'>"
	for(var/datum/objective/personal/objective in categories[current_category])
		var/completed = objective.completed
		data += "<B>[objective.name]</B>:<br><ul style='margin: 1px 0;'><li> [objective.explanation_text] "
		data += "<span style='color:[completed ? "#5cb85c" : "#d9534f"]'>"
		data += "[completed ? "(COMPLETED)" : "(NOT COMPLETED)"]</span></li></ul>"

		if(length(objective.immediate_effects))
			data += "<br><span style='color: #f1d669;'><B>Immediate Effects:</B></span>"
			data += "<ul style='color: #f1d669; margin: 1px 0;'>"
			for(var/effect in objective.immediate_effects)
				data += "<li>[effect]</li>"
			data += "</ul>"

		if(length(objective.rewards))
			data += "<br><span style='color: #80b077;'><B>Rewards:</B></span>"
			data += "<ul style='color: #80b077; margin: 1px 0;'>"
			for(var/reward in objective.rewards)
				data += "<li>[reward]</li>"
			data += "</ul>"

		data += "<br>"
	data += "</div>"

	var/datum/browser/popup = new(user, "purpose_menu", "", 430, 500)
	popup.set_content(data.Join())
	popup.open()

/atom/movable/screen/alert/status_effect/purpose/Topic(href, href_list)
	var/mob/living/carbon/human/user = usr
	if(!user?.mind || !length(user.mind.personal_objectives))
		return

	if(href_list["purpose_category"])
		var/new_category = url_decode(href_list["purpose_category"])
		show_task_ui(new_category)

	if(href_list["select_purpose_category"])
		var/list/available_categories = list()
		for(var/datum/objective/personal/objective in user.mind.personal_objectives)
			available_categories[objective.category] = objective.category

		if(length(available_categories))
			var/chosen = browser_input_list(user, "Select destiny to view", "Destinies", available_categories)
			if(chosen)
				show_task_ui(chosen)

	return ..()
