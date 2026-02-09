/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 *		Barcode Scanner
 */

/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/roguetown/misc/bookshelf.dmi'
	icon_state = "bookcase"
	var/based = "a"
	desc = ""
	anchored = FALSE
	density = TRUE
	opacity = 1
	resistance_flags = FLAMMABLE
	max_integrity = 200
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = 50, "acid" = 0)
	var/state = 0
	var/list/allowed_books = list(/obj/item/book, /obj/item/recipe_book) //Things allowed in the bookcase

/obj/structure/bookcase/examine(mob/user)
	. = ..()
//	if(!anchored)
//		. += "<span class='notice'>The <i>bolts</i> on the bottom are unsecured.</span>"
//	else
//		. += "<span class='notice'>It's secured in place with <b>bolts</b>.</span>"
//	switch(state)
///		if(0)
//	//		. += "<span class='notice'>There's a <b>small crack</b> visible on the back panel.</span>"
//	//	if(1)
//	//		. += "<span class='notice'>There's space inside for a <i>wooden</i> shelf.</span>"
//	//	if(2)
//	//		. += "<span class='notice'>There's a <b>small crack</b> visible on the shelf.</span>"

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	based = pick("a","b","c","d","e","f","g","h")
	state = 2
	anchored = TRUE
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
		if(istype(I, /obj/item/recipe_book))
			I.forceMove(src)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/bookcase/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!istype(user))
		return
	if(contents.len)
		var/obj/item/book/choice = input(user, "Which book would you like to remove from the shelf?") as null|obj in contents.Copy()
		if(choice)
			if(!(user.mobility_flags & MOBILITY_USE) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.forceMove(drop_location())
			update_appearance(UPDATE_ICON_STATE)

/obj/structure/bookcase/deconstruct(disassembled = TRUE)
	for(var/obj/item/B in contents)
		B.forceMove(get_turf(src))
	qdel(src)

/obj/structure/bookcase/update_icon_state()
	if((length(contents) >= 1) && (length(contents) <= 15))
		icon_state = "[based][length(contents)]"
	else
		icon_state = "bookcase"
	return ..()

/obj/structure/bookcase/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(!is_type_in_list(I, allowed_books))
		return
	if(length(contents) >= 15)
		return
	user.visible_message("[user] starts to put [I] into [src].", "You start to put [I] into [src].")
	if(!do_after(user, 0.75 SECONDS, src))
		return
	I.forceMove(src)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/bookcase/random_recipes
	var/random_books = 4

/obj/structure/bookcase/random_recipes/Initialize(mapload)
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
