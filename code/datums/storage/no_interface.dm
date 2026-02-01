// More or less solely for things that don't need to use the grid, such as sheaths
// Will use old storage vars for storing rather than grid logic
/datum/storage/no_interface
	max_slots = 7
	max_total_storage = WEIGHT_CLASS_SMALL * 7
	no_interface = TRUE
	quickdraw = TRUE

/datum/storage/no_interface/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	if(!no_interface)
		stack_trace("no_interface storage ([type]) has an interface, use a regular storage if you want the interface.")
		no_interface = TRUE
