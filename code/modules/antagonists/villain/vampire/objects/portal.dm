/obj/structure/vampire/portalmaker
	name = "Rift Gate"
	icon_state = "obelisk"
	var/sending = FALSE

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	var/list/possibleportals = list()

	. = TRUE

	if(sending)
		to_chat(user, "A portal is already active!")
		return
	for(var/obj/item/clothing/neck/portalamulet/P in GLOB.vampire_objects)
		possibleportals += P
	var/atom/choice = tgui_input_list(user, "Choose an area to open the portal to", "Choices", possibleportals)
	if(!choice)
		to_chat(user, span_warning("There are no anchors to open a portal to."))
		return
	user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
	if(do_after(user, 3 SECONDS, src))
		if(istype(choice, /obj/item/clothing/neck/portalamulet))
			var/obj/item/clothing/neck/portalamulet/A = choice
			A.uses -= 1
			var/turf/G = get_turf(A)
			new /obj/effect/landmark/vteleportsenddest(G.loc)
			if(A.uses <= 0)
				A.visible_message("[A] shatters!")
				qdel(A)
			else
				to_chat(user, span_warning("[A.name] has only [A.uses] left before breaking."))
			create_portal()
			user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)


/obj/structure/vampire/portal
	name = "Eerie Portal"
	icon_state = "portal"
	var/duration = 999
	var/spawntime = null
	density = FALSE

/obj/structure/vampire/portal/Initialize()
	. = ..()
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(src, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)

	addtimer(CALLBACK(src, PROC_REF(delete)), 60 SECONDS)

/obj/structure/vampire/portal/proc/delete()
	visible_message(span_boldnotice("[src] shudders before rapidly closing."))
	qdel(src)

/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleport/dest in GLOB.landmarks_list)
			playsound(src, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
			AM.forceMove(dest.loc)
			break

/obj/structure/vampire/portal/sending
	name = "Eerie Portal"
	icon_state = "portal"
	duration = 999
	spawntime = null
	var/turf/destloc

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
			AM.forceMove(V.loc)

/obj/structure/vampire/portal/sending/Destroy()
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		qdel(V)
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		P.sending =  FALSE
	return ..()

/obj/structure/vampire/portalmaker/proc/create_portal_return(aname,duration)
	for(var/obj/effect/landmark/vteleportdestination/Vamp in GLOB.landmarks_list)
		if(Vamp.amuletname == aname)
			var/obj/structure/vampire/portal/P = new(get_turf(Vamp))
			P.duration = duration
			P.spawntime = world.time
			P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))
		qdel(Vamp)

/obj/structure/vampire/portalmaker/proc/create_portal(choice,duration)
	sending = TRUE
	for(var/obj/effect/landmark/vteleportsending/S in GLOB.landmarks_list)
		var/obj/structure/vampire/portal/sending/P = new(S.loc)
		P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))

/obj/item/clothing/neck/portalamulet
	name = "Gate Amulet"
	desc = "Ominous looking necklace, origin of the tooth is impossible to tell. It seems to react to touch..?"
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'
	var/uses = 6
	var/can_local_portal = TRUE

/obj/item/clothing/neck/portalamulet/Initialize()
	GLOB.vampire_objects |= src
	. = ..()

/obj/item/clothing/neck/portalamulet/Destroy()
	GLOB.vampire_objects -= src
	return ..()

/obj/item/clothing/neck/portalamulet/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
		desc = "World anchor, used by the portal in The Mansion. Using it will return you to where it was made, right in the evil's lair. Leave it behind to make a portal to later."
	else
		desc = "Ominous looking necklace, origin of the tooth is impossible to tell. It seems to react to touch..?"

/obj/item/clothing/neck/portalamulet/attack_self(mob/user, list/modifiers)
	. = ..()
	if(!can_local_portal)
		return
	if(tgui_alert(user, "Create a portal?", "PORTAL GEM", list("Yes", "No")) == "Yes")
		uses -= 1
		var/obj/effect/landmark/vteleportdestination/Vamp = new(loc)
		Vamp.amuletname = name
		for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
			P.create_portal_return(name, 3000)
		user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
		to_chat(user, span_danger("[name] has [uses] left."))
		if(uses <= 0)
			visible_message("[src] shatters!")
			qdel(src)

