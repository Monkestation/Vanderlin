//this is mostly a noticeboard clone, but it works!

/obj/structure/fake_machine/hailer
	name = "\improper HAILER"
	desc = "A machine that shares the parchment fed to it to all existing HAILERBOARDs for viewing."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "hailer"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)
	COOLDOWN_DECLARE(speak_cooldown)
	lock = /datum/lock/key/hailer

/obj/structure/fake_machine/hailer/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/hailer/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/hailer/Initialize(mapload)
	. = ..()
	SSroguemachine.hailer = src

/obj/structure/fake_machine/hailer/Destroy()
	SSroguemachine.hailer = null
	return ..()

/obj/structure/fake_machine/hailer/proc/say_cooldown(words)
	if(!COOLDOWN_FINISHED(src, speak_cooldown))
		return
	say(words)
	COOLDOWN_START(src, speak_cooldown, 5 SECONDS)


/obj/structure/fake_machine/hailer/attackby(obj/item/H, mob/user, list/modifiers)
	if(!locked() && istype(H, /obj/item/paper))
		if(!user.transferItemToLoc(H, src))
			return
		user.visible_message(span_notice("[user] feeds [H] to [src]."), span_notice("I feed [H] to [src]."))
		say_cooldown("Bbbllrrr... fffrrrtt... brrrhh...")
		return
	return ..()

/obj/structure/fake_machine/hailer/interact(mob/user)
	. = ..()
	if(locked())
		to_chat(user, span_warning("It's locked. Of course."))
		return
	var/auth = TRUE
	var/dat = "<B>[name]</B><BR>"
	for(var/obj/item/H in src)
		if(istype(H, /obj/item/paper))
			dat += "<A href='byond://?src=[REF(src)];read=[REF(H)]'>[H.name]</A> [auth ? "<A href='byond://?src=[REF(src)];write=[REF(H)]'>Write</A> <A href='byond://?src=[REF(src)];remove=[REF(H)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(H)]'>Rename</A>": ""]<BR>"
		else
			dat += "<A href='byond://?src=[REF(src)];read=[REF(H)]'>[H.name]</A> [auth ? "<A href='byond://?src=[REF(src)];remove=[REF(H)]'>Remove</A>" : ""]<BR>"
	user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=HAILER")
	onclose(user, "HAILER")

/obj/structure/fake_machine/hailer/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list["remove"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/I = locate(href_list["remove"]) in contents
		if(istype(I) && I.loc == src)
			I.forceMove(usr.loc)
			usr.put_in_hands(I)
			say_cooldown("kchaak... khaa...")


	if(href_list["write"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked()) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"]) in contents
		if(istype(P) && P.loc == src)
			var/obj/item/I = usr.is_holding_item_of_type(/obj/item/natural/feather) || usr.is_holding_item_of_type(/obj/item/natural/thorn)
			if(!I)
				to_chat(usr, span_warning("You need something to write with!"))
				return
			add_fingerprint(usr)
			P.attackby(I, usr)
			return

	if(href_list["read"])
		var/obj/item/paper/I = locate(href_list["read"]) in SSroguemachine.hailer.contents
		if(istype(I) && I.loc == SSroguemachine.hailer && in_range(src, usr))
			I.read(usr)

	if(href_list["rename"]) //this doesnt even update the menu in real time, people are gonna think it aint workin' for sure, lol, lmao - the clown
		var/obj/item/I = locate(href_list["rename"]) in contents
		var/obj/item/P = usr.is_holding_item_of_type(/obj/item/natural/feather)
		if(P)
			if(istype(I) && I.loc == src)
				add_fingerprint(usr)
				var/n_name = stripped_input(usr, "give your notice a header!", "Paper Labelling", null, MAX_NAME_LEN)
				I.name = "[(n_name ? text("- '[n_name]'") : null)]"
				return
		to_chat(usr, "<span class='warning'>You'll need something to write with!</span>")

/obj/structure/fake_machine/hailerboard
	name = "HAILER BOARD"
	desc = "A notice board that shows all the notices the Adventurer's Guild has put up."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "hailerboard"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

/obj/structure/fake_machine/hailerboard/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/hailerboard/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/hailerboard/Initialize()
	. = ..()
	START_PROCESSING(SSslowobj, src)

/obj/structure/fake_machine/hailerboard/Destroy()
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/obj/structure/fake_machine/hailerboard/interact(mob/user)
	. = ..()
	var/dat = "<B>[name]</B><BR>"
	for(var/obj/item/H in SSroguemachine.hailer)
		if(istype(H, /obj/item/paper))
			dat += "<A href='byond://?src=[REF(src)];read=[REF(H)]'>[H.name]</A><BR>"

	user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=HAILER BOARD")
	onclose(user, "HAILER BOARD")

/obj/structure/fake_machine/hailerboard/Topic(href, href_list)
	..()
	if(href_list["read"])
		var/obj/item/paper/I = locate(href_list["read"]) in SSroguemachine.hailer.contents
		if(istype(I) && I.loc == SSroguemachine.hailer && in_range(src, usr))
			I.read(usr, TRUE)
