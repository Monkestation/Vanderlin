/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/client/var/datum/tgui_panel/tgui_panel

/client/verb/refresh_tgui()
	set name = "Refresh TGUI"
	set category = "OOC.Fix"

	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()

/client/verb/test_input()
	set name = "TGUI input test"
	set category = "OOC.Test"

	var/list/inputs = list(
		"alert",
		"color",
		"number",
		"text",
		"alert_timer",
		"message",
	)

	var/answer = tgui_input_list(src, "Which interface?", "Test", inputs)

	switch(answer)
		if("alert")
			tgui_alert(src, "Alert", "Alert")
		if("alert_timer")
			tgui_alert(src, "Alert", "Alert", timeout = 10 SECONDS)
		if("color")
			tgui_color_picker(src, "Color", "Color")
		if("number")
			tgui_input_number(src, "Number", "Number")
		if("text")
			tgui_input_text(src, "Text", "Text")
		if("message")
			tgui_input_text(src, "Text", "Text", max_length = 100, multiline = TRUE)
