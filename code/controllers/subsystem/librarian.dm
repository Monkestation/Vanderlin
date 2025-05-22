SUBSYSTEM_DEF(librarian)
	name = "Librarian"
	init_order = INIT_ORDER_PATH
	flags = SS_NO_FIRE
	var/list/books = list()

/datum/controller/subsystem/librarian/Initialize(start_timeofday)
	update_books()
	return ..()

/datum/controller/subsystem/librarian/proc/get_book(input)
	if(!input)
		return list()
	if(books.Find(input))
		return books[input]
	books[input] = file2book(input)
	return books[input]


/datum/controller/subsystem/librarian/proc/get_books(search_title, search_author, search_category)
	var/list/return_books = list()
	if(!search_title && !search_author && !search_category)
		return list()
	if(books.Find(search_title))
		return_books |= list(books[search_title])

	if(search_author)
		for(var/book in books)
			var/list/book_info = books[book]
			if(book_info["author"] == search_author)
				return_books|= list(books[book])

	if(search_category)
		if(search_category == "Any")
			for(var/book in books)
				return_books |= list(books[book])
		else
			for(var/book in books)
				var/list/book_info = books[book]
				if(book_info["category"] == search_category)
					return_books |= list(books[book])

	return return_books

/proc/file2book(filename)
	if(!filename)
		return list()
	var/json_file = file("strings/books/[filename]")
	if(fexists(json_file))
		var/list/configuration = json_decode(file2text(json_file))
		var/list/contents = configuration["Contents"]
		if(isnull(contents))
			return list()
		return contents
	return list()

/datum/controller/subsystem/librarian/proc/playerbook2file(input, book_title = "Unknown", author = "Unknown", author_ckey = "Unknown", icon = "basic_book", category = "Myths & Tales")
	if(!input)
		return "There is no text in the book!"
	if(fexists("data/player_generated_books/[url_encode(book_title)].json"))
		return "there is already a book by this title!"
	if(!(istext(input) && istext(book_title) && istext(author) && istext(author_ckey) && istext(icon)))
		return "This book is incorrectly formatted!"

	var/list/contents = list("book_title" = "[book_title]", "author" = "[author]", "author_ckey" = "[author_ckey]", "icon" = "[icon]",  "text" = "[input]", "category" = category)
	//url_encode should escape all the characters that do not belong in a file name. If not, god help us
	var/file_name = "data/player_generated_books/[url_encode(book_title)].json"
	text2file(json_encode(contents), file_name)

	if(fexists("data/player_generated_books/_book_titles.json"))
		var/list/_book_titles_contents = json_decode(file2text("data/player_generated_books/_book_titles.json"))
		_book_titles_contents += "[url_encode(book_title)]"
		fdel("data/player_generated_books/_book_titles.json")
		text2file(json_encode(_book_titles_contents), "data/player_generated_books/_book_titles.json")
		message_admins("Book [book_title] has been saved to the player book database by [author_ckey]([author])")
		return "You have a feeling the newly written book will remain in the archive for a very long time..."
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. making a new one without old books... !!!")
		text2file(json_encode(list(book_title)), "data/player_generated_books/_book_titles.json")
		return "_book_titles.json no longer exists, yell at your server host that some books have been lost!"

/datum/controller/subsystem/librarian/proc/file2playerbook(filename)
	if(!filename)
		return list()
	var/json_file = file("data/player_generated_books/[filename].json")
	if(fexists(json_file))
		var/list/contents = json_decode(file2text(json_file))
		if(isnull(contents))
			return list()
		if(!("category" in contents))
			contents |= "category"
			contents["category"] = "Thesis"
		return contents
	return list()

/datum/controller/subsystem/librarian/proc/del_player_book(book_title)
	if(!book_title)
		return FALSE
	var/json_file = file("data/player_generated_books/[book_title].json")
	if(!fexists(json_file))
		return FALSE
	if(fexists("data/player_generated_books/_book_titles.json"))
		fdel(json_file)
		var/list/_book_titles_contents = json_decode(file2text("data/player_generated_books/_book_titles.json"))
		_book_titles_contents -= "[book_title]"
		fdel("data/player_generated_books/_book_titles.json")
		text2file(json_encode(_book_titles_contents), "data/player_generated_books/_book_titles.json")
		return TRUE
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. !!!")
		return FALSE


/datum/controller/subsystem/librarian/proc/pull_player_book_titles()
	if(fexists(file("data/player_generated_books/_book_titles.json")))
		var/json_file = file("data/player_generated_books/_book_titles.json")
		var/json_list = json_decode(file2text(json_file))
		return json_list
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. !!!")

/datum/controller/subsystem/librarian/proc/update_books()
	books = list()
	books = pull_player_book_titles()
	for(var/book in books)
		if(!length(file2playerbook(book)))
			books -= book
			continue
		books[book] = file2playerbook(book)
