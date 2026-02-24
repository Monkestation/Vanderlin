//this is mostly a noticeboard clone, but it works!

/obj/structure/fake_machine/hailer
	name = "HAILER"
	desc = "A machine that shares the parchment fed to it to all existing HAILERBOARDs for viewing"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "hailer"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

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

/obj/structure/fake_machine/hailer/attackby(obj/item/H, mob/user, list/modifiers)
	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("you can't feed the [src] without carrying his burden"))
		return
	if(istype(H, /obj/item/reagent_containers/powder/salt)) //mmmm, salt.
		to_chat(user, "<span class='notice'>the [src]'s tongue slips between its bronze teeth to lap at the salt in [user]'s hand, finishing with effectionate licks across their palm... gross </span>")
		say("mmmpphh... grrrrrhh... hhhrrrnnn...")
		qdel(H)
		return
	if(!istype(H, /obj/item/paper))
		to_chat(user, "<span class='notice'>the [src] only accepts paper</span>")
		say("GRRRRHHH!!...GRAAAAGH")
		return
	if(istype(H, /obj/item/paper) && (HAS_TRAIT(user, TRAIT_BURDEN)))
		if(!user.transferItemToLoc(H, src))
			return
		to_chat(user, "<span class='notice'>I feed the [H] to the [src].</span>")
		say("Bbbllrrr... fffrrrtt... brrrhh...")
	return ..()

/obj/structure/fake_machine/hailer/interact(mob/user)
	. = ..()
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
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/I = locate(href_list["remove"]) in contents
		if(istype(I) && I.loc == src)
			I.forceMove(usr.loc)
			usr.put_in_hands(I)
			say("kchaak... khaa...")


	if(href_list["write"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH)) //For when a player is handcuffed while they have the notice window open
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
	desc = "A notice board that shows all the notices the Gaffer has put up"
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

/obj/structure/fake_machine/hailerboard/process()//hailer hails? damn
	. = ..()
	var/message = pick(
		"BbbRRRMMMPHHH... GGRRRRNNN!!",
		"GGGGRRRRR... BLLRRTTT!!",
		"NNNGGGRRBB... MMPHHH!!",
		"Hhbbbh...Mhhaamm--maaahrhh...")
	message = span_danger(message)
	say(message)

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
