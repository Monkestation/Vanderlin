
/datum/asset/simple/namespaced/fonts
	parents = list("fonts.css" = 'interface/fonts/fonts.css')

/datum/asset/simple/namespaced/fonts/New()
	for(var/datum/font/font as anything in subtypesof(/datum/font))
		var/file_string = "[font::font_family]"
		var/file_path = copytext(file_string, findlasttext(file_string, "/") + 1)
		assets[file_path] = file(file_string)
	return ..()
