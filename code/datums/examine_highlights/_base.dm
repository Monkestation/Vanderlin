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
	///this is for subtypes basically the examine desc of that specific item
	var/item_examine_desc = ""
	///if this is set we check whoevers examining for this matching trait
	var/required_trait
