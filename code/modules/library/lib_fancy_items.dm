// Everything is inherited from the main bookshelf type, doesn't need more.

/obj/structure/bookcase/fancy
	name = "fancy bookcase"
	icon = 'icons/roguetown/misc/fancybookshelf.dmi'
	icon_state = "fancybookcase"
	desc = ""
	anchored = FALSE
	density = TRUE
	opacity = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 200

/obj/structure/bookcase/fancy/examine(mob/user)
	. = ..()

/obj/structure/bookcase/fancy/random_recipes
	var/random_books = 4

/obj/structure/bookcase/fancy/random_recipes/Initialize(mapload)
	. = ..()
	var/list/books = subtypesof(/obj/item/recipe_book)
	for(var/obj/item/recipe_book/listed_book as anything in books)
		if(initial(listed_book.can_spawn))
			continue
		books -= listed_book

	for(var/i = 1 to random_books)
		var/obj/item/recipe_book/book = pick_n_take(books)
		new book(src)
	update_appearance(UPDATE_ICON_STATE)

