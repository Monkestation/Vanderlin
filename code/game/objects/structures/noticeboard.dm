/obj/structure/noticeboard
	name = "notice board"
	desc = ""
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	density = FALSE
	anchored = TRUE
	max_integrity = 150
	var/notices = 0

/obj/structure/noticeboard/Initialize(mapload)
	. = ..()

	if(!mapload)
		return

	for(var/obj/item/I in loc)
		if(notices > 4)
			break
		if(istype(I, /obj/item/paper))
			I.forceMove(src)
			notices++
	icon_state = "nboard0[notices]"

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/O, mob/user, list/modifiers)
	if(istype(O, /obj/item/paper))
		if(notices < 5)
			if(!user.transferItemToLoc(O, src))
				return
			notices++
			icon_state = "nboard0[notices]"
			to_chat(user, "<span class='notice'>I pin the [O] to the noticeboard.</span>")
		else
			to_chat(user, "<span class='warning'>The notice board is full!</span>")
	else
		return ..()

/obj/structure/noticeboard/interact(mob/user)
	. = ..()
	var/auth = TRUE
	var/dat = "<B>[name]</B><BR>"
	for(var/obj/item/P in src)
		if(istype(P, /obj/item/paper))
			dat += "<A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A> [auth ? "<A href='byond://?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A>" : ""]<BR>"
		else
			dat += "<A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A> [auth ? "<A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A>" : ""]<BR>"
	user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=noticeboard")
	onclose(user, "noticeboard")

/obj/structure/noticeboard/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list["remove"])
		if((usr.stat || HAS_TRAIT(usr, TRAIT_RESTRAINED)))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/I = locate(href_list["remove"]) in contents
		if(istype(I) && I.loc == src)
			I.forceMove(usr.loc)
			usr.put_in_hands(I)
			notices--
			icon_state = "nboard0[notices]"

	if(href_list["write"])
		if((usr.stat || HAS_TRAIT(usr, TRAIT_RESTRAINED))) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"]) in contents
		if(istype(P) && P.loc == src)
			var/obj/item/I = usr.is_holding_item_of_type(/obj/item/natural/feather)
			if(I)
				add_fingerprint(usr)
				P.attackby(I, usr)
			else
				to_chat(usr, "<span class='warning'>You'll need something to write with!</span>")

	if(href_list["read"])
		var/obj/item/I = locate(href_list["read"]) in contents
		if(istype(I) && I.loc == src)
			usr.examinate(I)
