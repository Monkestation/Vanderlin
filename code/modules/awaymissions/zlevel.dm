// How much "space" we give the edge of the map
GLOBAL_LIST_INIT(potentialRandomZlevels, generateMapList(filename = "[global.config.directory]/awaymissionconfig.txt"))

/proc/createRandomZlevel()
	if(GLOB.potentialRandomZlevels && GLOB.potentialRandomZlevels.len)
		to_chat(world, "<span class='boldannounce'>Loading away mission...</span>")
		var/map = pick(GLOB.potentialRandomZlevels)
		load_new_z_level(map, "Away Mission")
		to_chat(world, "<span class='boldannounce'>Away mission loaded.</span>")

/obj/effect/landmark/awaystart
	name = "away mission spawn"
	desc = ""

/proc/generateMapList(filename)
	. = list()
	var/list/Lines = file2list(filename)

	if(!Lines.len)
		return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))

		else
			name = lowertext(t)

		if (!name)
			continue

		. += t
