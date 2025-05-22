

/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	desc = ""
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	throw_speed = 1
	throw_range = 5
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	firefuel = 2 MINUTES

	grid_width = 32
	grid_height = 64

	var/random_cover
	var/category = null

	var/base_icon_state = "basic_book"
	var/open = FALSE
	var/dat				//Actual page content
	var/due_date = 0	//Game time in 1/10th seconds
	var/author			//Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = TRUE		//0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title			//The real name of the book.
	var/window_size = null // Specific window size for the book, i.e: "1920x1080", Size x Width

	var/list/pages = list()
	var/bookfile
	var/curpage = 1
	var/textper = 100
	var/our_font = "Rosemary Roman"
	var/override_find_book = FALSE

/obj/item/book/examine(mob/user)
	. = ..()
	. += "<a href='byond://?src=[REF(src)];read=1'>Read</a>"

/obj/item/book/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// ...... Book Cover Randomizer Code  (gives the book a radom cover when random_cover = TRUE)
/obj/item/book/Initialize()
	. = ..()
	if(random_cover)
		base_icon_state = "book[rand(1,8)]"
		icon_state = "[base_icon_state]_0"

/obj/item/book/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	if(!user.can_read(src))
		return
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	read(user)
	user.update_inv_hands()

/obj/item/book/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/book/proc/read(mob/user)
	if(!open)
		to_chat(user, "<span class='info'>Open me first.</span>")
		return FALSE
	user << browse_rsc('html/book.png')
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
		if(!pages.len)
			if(!override_find_book)
				pages = SSlibrarian.get_book(bookfile)
		if(!pages.len)
			to_chat(user, "<span class='warning'>This book is completely blank.</span>")
		if(curpage > pages.len)
			curpage = 1
//		var/curdat = pages[curpage]
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
					<html><head><style type=\"text/css\">
					body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		for(var/A in pages)
			dat += A
			dat += "<br>"
		dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=1000x700;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
		onclose(user, "reading", src)
	else
		return "<span class='warning'>You're too far away to read it.</span>"


/obj/item/book/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	var/literate = usr.is_literate()
	if(!usr.canUseTopic(src, BE_CLOSE, literate))
		return

	if(href_list["read"])
		read(usr)

	if(href_list["turnpage"])
		if(pages.len >= curpage+2)
			curpage += 2
		else
			curpage = 1
		playsound(loc, 'sound/items/book_page.ogg', 100, TRUE, -1)
		read(usr)

/obj/item/book/attackby(obj/item/I, mob/user, params)
	return

/obj/item/book/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/secret/ledger
	name = "catatoma"
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	title = "Catatoma"
	dat = "To create a shipping order, use a scroll on me."
	var/fence = FALSE

/obj/item/book/secret/ledger/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/paper/scroll/cargo))
		if(!open)
			to_chat(user, "<span class='info'>Open me first.</span>")
			return FALSE
		var/obj/item/paper/scroll/cargo/C = I
		if(C.orders.len >= 6)
			to_chat(user, "<span class='warning'>Too much order.</span>")
			return
		var/picked_cat = input(user, "Categories", "Shipping Ledger") as null|anything in sortList(SSmerchant.supply_cats)
		if(!picked_cat)
			return
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.contraband && !fence)
				continue
			if(PA.group == picked_cat)
				pax += PA

		var/datum/supply_pack/picked_pack = input(user, "Shipments", "Shipping Ledger") as null|anything in sortList(pax)
		if(!picked_pack)
			return
		var/amount = input(user, "How many [picked_pack.name] to order?", null, 1) as null|num
		amount = clamp(amount, 0, 100)
		if(!amount)
			return
		C.orders[picked_pack] += amount
		C.rebuild_info()
		return
	if(I.type == /obj/item/paper/scroll)
		if(!open)
			to_chat(user, "<span class='info'>Open me first.</span>")
			return FALSE
		var/obj/item/paper/scroll/P = I
		if(P.info)
			to_chat(user, "<span class='warning'>Something is written here already.</span>")
			return
		var/picked_cat = input(user, "Categories", "Shipping Ledger") as null|anything in sortList(SSmerchant.supply_cats)
		if(!picked_cat)
			return
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.contraband && !fence)
				continue
			if(PA.group == picked_cat)
				pax += PA
		var/datum/supply_pack/picked_pack = input(user, "Shipments", "Shipping Ledger") as null|anything in sortList(pax)
		if(!picked_pack)
			return
		var/amount = input(user, "How many [picked_pack.name] to order?", null, 1) as null|num
		amount = clamp(amount, 0, 100)
		if(!amount)
			return
		var/obj/item/paper/scroll/cargo/C = new(user.loc)

		C.orders[picked_pack] += amount
		C.rebuild_info()
		user.dropItemToGround(P)
		qdel(P)
		user.put_in_active_hand(C)
	..()

/obj/item/book/secret/ledger/fence
	name = "Smuggler's Manifest"
	title = " Smuggler's Manifest"
	fence = TRUE

/obj/item/book/bibble
	name = "The Book"
	icon_state = "bibble_0"
	base_icon_state = "bibble"
	title = "bible"
	dat = "gott.json"
	force = 2
	force_wielded = 4
	throwforce = 1
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)

/obj/item/book/bibble/read(mob/user)
	if(!open)
		to_chat(user, "<span class='info'>Open me first.</span>")
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		var/list/verses = world.file2list("strings/bibble.txt")
		m = pick(verses)
		if(m)
			user.say(m)

/obj/item/book/bibble/attack(mob/living/M, mob/user)
	if(is_priest_job(user.mind?.assigned_role))
		if(!user.can_read(src))
			return
		M.apply_status_effect(/datum/status_effect/buff/blessed)
		user.visible_message("<span class='notice'>[user] blesses [M].</span>")
		playsound(user, 'sound/magic/bless.ogg', 100, FALSE)
		return

/datum/status_effect/buff/blessed
	id = "blessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blessed
	effectedstats = list(STATKEY_LCK = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/blessed
	name = "Blessed"
	desc = ""
	icon_state = "buff"

/datum/status_effect/buff/blessed/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/blessed)

/datum/status_effect/buff/blessed/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/blessed)

/obj/item/book/law
	name = "Tome of Justice"
	desc = ""
	icon_state ="lawtome_0"
	base_icon_state = "lawtome"
	bookfile = "law.json"

/obj/item/book/knowledge1
	name = "Book of Knowledge"
	desc = ""
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "knowledge.json"

/obj/item/book/secret/xylix
	name = "Book of Gold"
	desc = "{<font color='red'><blink>An ominous book with untold powers.</blink></font>}"
	icon_state ="xylix_0"
	base_icon_state = "xylix"
	icon_state ="spellbookmimic_0"
	base_icon_state = "pellbookmimic"
	bookfile = "xylix.json"

/obj/item/book/xylix/attack_self(mob/user)
	user.update_inv_hands()
	to_chat(user, "<span class='notice'>You feel laughter echo in your head.</span>")

//player made books
/obj/item/book/tales1
	name = "Assorted Tales From Yester Yils"
	desc = "By Alamere J Wevensworth"
	icon_state ="book_0"
	base_icon_state = "book"
	bookfile = "tales1.json"

/obj/item/book/festus
	name = "Book of Festus"
	desc = "Unknown Author"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales2.json"

/obj/item/book/tales3
	name = "Myths & Legends of Rockhill & Beyond Volume I"
	desc = "Arbalius The Younger"
	icon_state ="book3_0"
	base_icon_state = "book3"
	bookfile = "tales3.json"

/obj/item/book/bookofpriests
	name = "Holy Book of Saphria"
	desc = ""
	icon_state ="knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "holyguide.json"

/obj/item/book/robber
	name = "Reading for Robbers"
	desc = "By Flavius of Dendor"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales4.json"

/obj/item/book/cardgame
	name = "Graystone's Torment Basic Rules"
	desc = "By Johnus of Doe"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales5.json"

/obj/item/book/blackmountain
	name = "Zabrekalrek, The Black Mountain Saga: Part One"
	desc = "Written by Gorrek Tale-Writer, translated by Hargrid Men-Speaker."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales6.json"

/obj/item/book/beardling
	name = "Rock and Stone - ABC & Tales for Beardlings"
	desc = "Distributed by the Dwarven Federation"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales7.json"

/obj/item/book/abyssor
	name = "A Tale of Those Who Live At Sea"
	desc = "By Bellum Aegir"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales8.json"

/obj/item/book/necra
	name = "Burial Rites for Necra"
	desc = "By Hunlaf, Gravedigger. Revised by Lenore, Priest of Necra."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales9.json"

/obj/item/book/noc
	name = "Dreamseeker"
	desc = "By Hunlaf, Gravedigger. Revised by Lenore, Priest of Necra."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales10.json"

/obj/item/book/fishing
	name = "Fontaine's Advanced Guide to Fishery"
	desc = "By Ford Fontaine"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales11.json"

/obj/item/book/sword
	name = "The Six Follies: How To Survive by the Sword"
	desc = "By Theodore Spillguts"
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "tales12.json"

/obj/item/book/arcyne
	name = "Latent Magicks, where does Arcyne Power come from?"
	desc = "By Kildren Birchwood, scholar of Magicks"
	icon_state ="book4_0"
	base_icon_state = "book4"
	bookfile = "tales13.json"

/obj/item/book/nitebeast
	name = "Legend of the Nitebeast"
	desc = "By Paquetto the Scholar"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales14.json"

/obj/item/book/mysticalfog
	name = "Studie of the Etheral Foge phenomenon"
	desc = "By Roubert the Elder"
	icon_state ="book7_0"
	base_icon_state = "book8"
	bookfile = "tales15.json"

/obj/item/book/playerbook
	var/player_book_text = "moisture in the air or water leaks have rendered the carefully written caligraphy of this book unreadable"
	var/player_book_title = "unknown title"
	var/player_book_author = "unknown author"
	var/player_book_icon = "basic_book"
	var/player_book_author_ckey = "unknown"
	var/is_in_round_player_generated
	var/list/player_book_titles
	var/list/player_book_content
	var/list/book_icons = list(
	"Sickly green with embossed bronze" = "book8",
	"White with embossed obsidian" = "book7",
	"Black with embossed quartz" = "book6",
	"Blue with embossed ruby" = "book5",
	"Green with embossed amethyst" = "book4",
	"Purple with embossed emerald" = "book3",
	"Red with embossed sapphire" = "book2",
	"Brown with embossed gold" = "book1",
	"Brown without embossed material" = "basic_book")
	name = "unknown title"
	desc = "by an unknown author"
	icon_state = "basic_book_0"
	base_icon_state = "basic_book"
	override_find_book = TRUE

/obj/item/book/playerbook/proc/get_player_input(mob/living/in_round_player_mob, text)
	player_book_author_ckey = in_round_player_mob.ckey
	player_book_title = dd_limittext(capitalize(sanitize_hear_message(input(in_round_player_mob, "What title do you want to give the book? (max 42 characters)", "Title", "Unknown"))), MAX_NAME_LEN)
	player_book_author = "[dd_limittext(sanitize_hear_message(input(in_round_player_mob, "Do you want to preface your author name with an author title? (max 42 characters)", "Author Title", "")), MAX_NAME_LEN)] [in_round_player_mob.real_name]"
	player_book_icon = book_icons[input(in_round_player_mob, "Choose a book style", "Book Style") as anything in book_icons]
	player_book_text = text
	message_admins("[player_book_author_ckey]([in_round_player_mob.real_name]) has generated the player book: [player_book_title]")
	update_book_data()

/obj/item/book/playerbook/proc/update_book_data()
	name = "[player_book_title]"
	desc = "By [player_book_author]"
	icon_state = "[player_book_icon]_0"
	base_icon_state = "[player_book_icon]"
	pages = list("<b3><h3>Title: [player_book_title]<br>Author: [player_book_author]</b><h3>[player_book_text]")

/obj/item/book/playerbook/Initialize(mapload, in_round_player_generated, mob/living/in_round_player_mob, text, title)
	. = ..()
	is_in_round_player_generated = in_round_player_generated
	if(is_in_round_player_generated)
		INVOKE_ASYNC(src, PROC_REF(update_book_data), in_round_player_mob, text)
	else
		player_book_titles = SSlibrarian.pull_player_book_titles()
		if(title)
			player_book_content = SSlibrarian.file2playerbook(title)
		else
			player_book_content = SSlibrarian.file2playerbook(pick(player_book_titles))
		player_book_title = player_book_content["book_title"]
		player_book_author = player_book_content["author"]
		player_book_author_ckey = player_book_content["author_ckey"]
		player_book_icon = player_book_content["icon"]
		player_book_text = player_book_content["text"]
		update_book_data()

/obj/item/manuscript
	name = "manuscript"
	desc = "A written piece with aspirations of becoming a book."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "manuscript"
	dir = 2 //! dir is used to decide how many pages are displayed in the icon
	resistance_flags = FLAMMABLE
	var/number_of_pages = 2
	var/compiled_pages = null
	var/list/obj/item/paper/pages = new/list(2) //very intentional constructor

	var/author = "anonymous"
	var/content = ""
	var/category = "Unspecified"
	var/ckey = ""
	var/newicon = "basic_book_0"
	var/written = FALSE
	var/select_icon = "basic_book"
	var/list/book_icons = list(
		"Simple green" = "basic_book",
		"Simple black" = "book",
		"Simple red" = "book2",
		"Simple blue" = "book3",
		"Simple dark yellow" = "book4",
		"Brown with dark corners" = "book5",
		"Heavy purple with dark corners" = "book6",
		"Light purple with gold leaf" = "book7",
		"Light blue with gold leaf" = "book8",
		"Grey with gold leaf" = "knowledge")

/obj/item/manuscript/Initialize(mapload, list/obj/item/paper/preset_pages)
	. = ..()

	if(mapload || !preset_pages)
		for(var/i in 1 to length(pages))
			pages[i] = new /obj/item/paper(src)
	else
		for(var/i in 1 to length(preset_pages))
			pages[i] = preset_pages[i]
			preset_pages[i].forceMove(src) //lol

	update_pages()

/// Called when our pages have been updated.
/obj/item/manuscript/proc/update_pages()
	number_of_pages = length(pages)
	//name = "[number_of_pages] page manuscript"
	desc = "A [number_of_pages]-page written piece, with aspirations of becoming a book."
	update_icon()

	compiled_pages = null
	for(var/obj/item/paper/page as anything in pages)
		compiled_pages += "<p>[page.info]</p>\n"

/obj/item/manuscript/attackby(obj/item/I, mob/living/user)
	// why is a book crafting kit using the craft system, but crafting a book isn't?
	// Well, *for some reason*, the crafting system is made in such a way
	// as to make reworking it to allow you to put reqs vars in the crafted item near *impossible.*
	if(istype(I, /obj/item/book_crafting_kit))
		var/obj/item/book/playerbook/PB = new /obj/item/book/playerbook(get_turf(I.loc), TRUE, user, compiled_pages)
		qdel(I)
		if(user.Adjacent(PB))
			PB.add_fingerprint(user)
			user.put_in_hands(PB)
		return qdel(src)

	if((I.type == /obj/item/paper) || (I.type == /obj/item/paper/scroll))
		var/obj/item/paper/inserted_paper = I
		if(length(pages) == 8)
			to_chat(user, span_warning("I can not find a place to put [inserted_paper] into [src]..."))
			return

		inserted_paper.forceMove(src)
		pages += inserted_paper
		to_chat(user, span_notice("I put [inserted_paper] into [src]."))
		update_pages()
		updateUsrDialog()

	return ..()

/obj/item/manuscript/examine(mob/user)
	. = ..()
	. += span_info("<a href='byond://?src=[REF(src)];read=1'>Read</a>")

/obj/item/manuscript/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	var/literate = usr.is_literate()
	if(!usr.canUseTopic(src, BE_CLOSE, literate))
		return

	if(href_list["read"])
		read(usr)

/obj/item/manuscript/attack_self(mob/user)
	read(user)

/obj/item/manuscript/proc/read(mob/user)
	user << browse_rsc('html/book.png')
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(span_warning("I study [src], but this verba still eludes me..."))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE) //?
		return
	if(!in_range(user, src) && !isobserver(user))
		to_chat(user, span_warning("I am too far away to read [src]."))
		return

	var/dat = {"
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<style type="text/css">
				body {
					background-image:url('book.png');
					background-repeat: repeat;
				}
			</style>
		</head>
		<body scroll=yes>
			[compiled_pages]
		</body>
	</html>
	"}
	user << browse(dat, "window=reading;size=1000x700;can_close=1;can_minimize=0;can_maximize=0;can_resize=0;")
	onclose(user, "reading", src)


/obj/item/manuscript/attack_right(mob/user)
	. = ..()
	var/obj/item/P = user.get_active_held_item()
	if(istype(P, /obj/item/natural/feather))
		// Prompt user to populate manuscript fields
		var/newtitle = dd_limittext(sanitize_hear_message(input(user, "Enter the title of the manuscript:") as text|null), MAX_CHARTER_LEN)
		var/newauthor = dd_limittext(sanitize_hear_message(input(user, "Enter the author's name:") as text|null), MAX_CHARTER_LEN)
		var/newcategory = input(user, "Select the category of the manuscript:") in list("Apocrypha & Grimoires", "Myths & Tales", "Legends & Accounts", "Thesis", "Eoratica")
		var/newicon = book_icons[input(user, "Choose a book style", "Book Style") as anything in book_icons]

		if (newtitle && newauthor && newcategory)
			name = newtitle
			author = newauthor
			category = newcategory
			ckey = user.ckey
			select_icon = newicon
			icon_state = "paperwrite"
			to_chat(user, "<span class='notice'>You have successfully authored and titled the manuscript.</span>")
			var/complete = input(user, "Is the manuscript finished?") in list("Yes", "No")
			if(complete == "Yes" && compiled_pages)
				written = TRUE
		else
			to_chat(user, "<span class='notice'>You must fill out all fields to complete the manuscript.</span>")
		return
	else if(istype(P, /obj/item/natural/feather) && written)
		to_chat(user, "<span class='notice'>The manuscript has already been authored and titled.</span>")
		return
	return ..()

/obj/item/manuscript/update_icon()
	. = ..()
	switch(length(pages))
		if(2)
			dir = SOUTH
		if(3)
			dir = NORTH
		if(4)
			dir = EAST
		if(5)
			dir = WEST
		if(6)
			dir = SOUTHEAST
		if(7)
			dir = SOUTHWEST
		else //8
			dir = NORTHWEST

/obj/item/manuscript/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")

/obj/item/manuscript/attack_hand(mob/living/user)
	if(isliving(user) && user.is_holding(src))
		var/obj/item/paper/pulled_page = pop(pages)
		user.put_in_inactive_hand(src) //move this to the side
		user.put_in_active_hand(pulled_page)

		if(number_of_pages > 2)
			to_chat(user, span_notice("I pull out \a [pulled_page] from [src]."))
			update_pages()
		else
			to_chat(user, span_notice("I pull apart the final entries of [src]."))
			var/obj/item/paper/last_page = pop(pages)
			user.temporarilyRemoveItemFromInventory(src, TRUE)
			user.put_in_hands(last_page)
			qdel(src)
			return

		return

	. = ..()

/obj/item/book_crafting_kit
	name = "book crafting kit"
	desc = "Apply on a written manuscript to create a book"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "book_crafting_kit"




// ...... Books made by the Stonekeep community within #lore channel, approved & pushed by Guayo (current staff incharge of adding ingame books)

/* ______Example of layout of added in book

/obj/item/book/book_name_here
	name = "Title of your book here"
	desc = "Who wrote it or maybe some flavor here"
	bookfile = "filenamehere.json"
	random_cover = TRUE

____________End of Example*/

/obj/item/book/magicaltheory
	name = "Arcane Foundations - A historie of Magicks"
	desc = "Written by the rector of the Valerian College of Magick"
	icon_state ="knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "MagicalTheory.json"

/obj/item/book/vownecrapage
	name = "Necra's Vow of Silence"
	desc = "A faded page, with seemingly no author."
	icon_state = "book8_0"
	base_icon_state = "book8"
	bookfile = "VowOfNecraPage.json"

/obj/item/book/godofdreamsandnightmares
	name = "God of Dreams & Nightmares"
	desc = "An old decrepit book, with seemingly no author."
	bookfile = "GodDreams.json"
	random_cover = TRUE

/obj/item/book/psybibleplayerbook
	name = "Psybible"
	desc = "An old tome, authored by Father Ambrose of Grenzelhoft."
	bookfile = "PsyBible.json"
	random_cover = TRUE

/obj/item/book/manners
	name = "Manners of Gentlemen"
	desc = "A popular guide for young people of genteel birth."
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "manners.json"

/obj/item/book/advice_soup
	name = "Soup de Rattus"
	desc = "Weathered book containing advice on surviving a famine."
	bookfile = "AdviceSoup.json"
	random_cover = TRUE

/obj/item/book/advice_farming
	name = "The Secrets of the Agronome"
	desc = "Soilson bible."
	bookfile = "AdviceFarming.json"
	random_cover = TRUE

/obj/item/book/advice_weaving
	name = "A hundred kinds of stitches"
	desc = "Howe to weave, tailor, and sundry tailoring. By Agnea Corazzani."
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "AdviceWeaving.json"

/obj/item/book/yeoldecookingmanual // new book with some tips to learn
	name = "Ye olde ways of cookinge"
	desc = "Penned by Svend Fatbeard, butler in the fourth generation"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "Neu_cooking.json"

/obj/item/book/psybibble
	name = "The Book"
	icon_state = "psybibble_0"
	base_icon_state = "psybibble"
	title = "bible"
	dat = "gott.json"
	force = 2
	force_wielded = 4
	throwforce = 1
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)

/obj/item/book/psybibble/read(mob/user)
	if(!open)
		to_chat(user, "<span class='info'>Open me first.</span>")
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		var/list/verses = world.file2list("strings/psybibble.txt")
		m = pick(verses)
		if(m)
			user.say(m)

/obj/item/book/psybibble/attack(mob/living/M, mob/user)
	if(is_priest_job(user.mind.assigned_role))
		if(!user.can_read(src))
			return
		M.apply_status_effect(/datum/status_effect/buff/blessed)
		user.visible_message("<span class='notice'>[user] blesses [M].</span>")
		playsound(user, 'sound/magic/bless.ogg', 100, FALSE)
		return

/datum/status_effect/buff/blessed
	id = "blessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blessed
	effectedstats = list(STATKEY_LCK = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/blessed
	name = "Blessed"
	desc = "Astrata's light flows through me."
	icon_state = "buff"

/datum/status_effect/buff/blessed/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/blessed)

/datum/status_effect/buff/blessed/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/blessed)

/obj/item/book/rogue/howtogaffer
	name = "Dont be a gaff, the guild masters manual"
	desc = "the author page has rotted off with time"
	bookfile = "Gaff.json"
	random_cover = TRUE
