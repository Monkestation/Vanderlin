GLOBAL_LIST_INIT(examine_highlights, build_examine_highlights())

/proc/build_examine_highlights()
	. = list()
	for(var/path in subtypesof(/datum/examine_highlight))
		.[path] = path

/datum/examine_highlight
	var/adjective
	var/leader = "It is "
	var/explanation
	var/color
	var/symbol

/datum/examine_highlight/heresy_alarming
	adjective = "HERETICAL"
	explanation = "<span style='color: #c43535;'><b>This is a blatantly dangerous heretical item!</b></span><br>Carrying this out in the open is tantamount to declaring myself an enemy to Tennite and Psydonite faith. Those who serve the Ten and the One are likely to respond in kind."
	color = COLOR_HERESYSEVERITY_ALARMING
	symbol = EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ALARMING

/datum/examine_highlight/heresy_suspicious
	adjective = "SUSPICIOUS"
	explanation = "<span style='color: #c49337;'><b>This is a suspicious heretical item!</b></span><br>It is considered heretical by Tennite and Psydonite faith. Those who serve the Ten and the One are likely to view me with suspicion and distrust <b>at best</b> if I am caught with it."
	color = COLOR_HERESYSEVERITY_SUSPICIOUS
	symbol = EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_SUSPICIOUS
