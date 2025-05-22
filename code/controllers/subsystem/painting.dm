SUBSYSTEM_DEF(paintings)
	name = "Paintings"
	init_order = INIT_ORDER_PATH
	flags = SS_NO_FIRE

	var/list/paintings = list()

/datum/controller/subsystem/paintings/Initialize(start_timeofday)
	update_paintings()
	return ..()

/datum/controller/subsystem/paintings/proc/update_paintings()
	paintings = list()

	paintings = pull_player_painting_titles()
	for(var/painting in paintings)
		if(!length(file2playerpainting(painting)))
			paintings -= painting
			continue
		paintings[painting] = file2playerpainting(painting)

/datum/controller/subsystem/paintings/proc/pull_player_painting_titles()
	if(fexists(file("data/player_generated_paintings/_painting_titles.json")))
		var/json_file = file("data/player_generated_paintings/_painting_titles.json")
		var/json_list = json_decode(file2text(json_file))
		return json_list
	else
		message_admins("!!! _painting_titles.json no longer exists, previous painting title list has been lost. !!!")

/datum/controller/subsystem/paintings/proc/file2playerpainting(filename)
	if(!filename)
		return list()
	var/json_file = file("data/player_generated_paintings/[filename].json")
	if(fexists(json_file))
		var/list/contents = json_decode(file2text(json_file))
		if(isnull(contents))
			return list()
		return contents
	return list()


/datum/controller/subsystem/paintings/proc/playerpainting2file(icon/painting, painting_title = "Unknown", author = "Unknown", author_ckey = "Unknown", canvas_size, obj/item/canvas/canvas)
	if(!painting)
		return "There is no provided painting!"
	if(fexists("data/player_generated_paintings/[url_encode(painting_title)].json"))
		var/list/painting_data = paintings[painting_title]
		if(painting_data["author_ckey"] == author_ckey)
			if(!canvas.reject)
				for(var/client/client in GLOB.clients)
					if(client.ckey == author_ckey)
						if(!(istext(painting_title) && istext(author) && istext(author_ckey)))
							return "This painting is incorrectly formatted!"
						var/replace = input(client, "Someone wants to replace [painting_title] with another one by you, do you want to replace this?") as anything in list("Yes", "No")
						if(replace != "Yes")
							canvas.reject = TRUE
							return "there is already a painting by this title!"
						else
							del_player_painting(painting_title)
	if(!(istext(painting_title) && istext(author) && istext(author_ckey)))
		return "This painting is incorrectly formatted!"

	var/list/contents = list("painting_title" = "[painting_title]", "author" = "[author]", "author_ckey" = "[author_ckey]", "canvas_size" = canvas_size)
	//url_encode should escape all the characters that do not belong in a file name. If not, god help us
	var/file_name = "data/player_generated_paintings/[url_encode(painting_title)].json"
	text2file(json_encode(contents), file_name)

	if(fexists("data/player_generated_paintings/_painting_titles.json"))
		var/list/_painting_titles_contents = json_decode(file2text("data/player_generated_paintings/_painting_titles.json"))
		_painting_titles_contents += "[url_encode(painting_title)]"
		fdel("data/player_generated_paintings/_painting_titles.json")
		text2file(json_encode(_painting_titles_contents), "data/player_generated_paintings/_painting_titles.json")
		message_admins("Book [painting_title] has been saved to the player book database by [author_ckey]([author])")
		fcopy(painting, "data/player_generated_paintings/paintings/[painting_title].png")
		return "You have a feeling the newly written book will remain in the archive for a very long time..."
	else
		message_admins("!!! _painting_titles.json no longer exists, previous book title list has been lost. making a new one without old books... !!!")
		text2file(json_encode(list(painting_title)), "data/player_generated_paintings/_painting_titles.json")
		fcopy(painting, "data/player_generated_paintings/paintings/[painting_title].png")
		return "_painting_titles.json no longer exists, yell at your server host that some paintings have been lost!"

/datum/controller/subsystem/paintings/proc/get_random_painting(canvas_size)
	var/list/painting_titles = pull_player_painting_titles()
	if(!length(painting_titles))
		return
	var/list/paint_list = file2playerpainting(pick_n_take(painting_titles))

	while((paint_list["canvas_size"] != canvas_size) && length(painting_titles))
		paint_list = file2playerpainting(pick_n_take(painting_titles))

	var/icon/painting = icon("data/player_generated_paintings/paintings/[paint_list["painting_title"]].png")
	return painting

/datum/controller/subsystem/paintings/proc/del_player_painting(painting_title)
	if(!painting_title)
		return FALSE
	var/json_file = file("data/player_generated_paintings/[painting_title].json")
	var/png = file("data/player_generated_paintings/paintings/[painting_title].png")
	if(!fexists(json_file))
		return FALSE
	if(fexists("data/player_generated_paintings/_painting_titles.json"))
		fdel(json_file)
		if(fexists(png))
			fdel("data/player_generated_paintings/paintings/[painting_title].png")
		var/list/_painting_titles_contents = json_decode(file2text("data/player_generated_paintings/_painting_titles.json"))
		_painting_titles_contents -= "[painting_title]"
		fdel("data/player_generated_paintings/_painting_titles.json")
		text2file(json_encode(_painting_titles_contents), "data/player_generated_paintings/_painting_titles.json")
		return TRUE
	else
		message_admins("!!! _painting_titles.json no longer exists, previous painting title list has been lost. !!!")
		return FALSE
