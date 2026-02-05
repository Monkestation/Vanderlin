//N/A lamerd version of the headeater until Aberra actually gives the thumbs up for the real one
//doesnt even give headprices for assassin or bandits like I wanted - the clown

/obj/item/natural/head
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/natural/head/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)

/obj/item/natural/head/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/item/bodypart/head
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/bodypart/head/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/item/painting/lorehead
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/painting/lorehead/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)


/obj/item/painting/lorehead/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/structure/fake_machine/headeater
	name = "head eating HAILER"
	desc = "A machine that feeds on certain heads for coin, this iteration seems unfinished, what a sell out."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

/obj/structure/fake_machine/headeater/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/headeater/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/headeater/attackby(obj/item/H, mob/user, list/modifiers)
	. = ..()
	if(!istype(H, /obj/item/natural/head) && !istype(H, /obj/item/bodypart/head) && !istype(H, /obj/item/painting/lorehead))
		to_chat(user, span_danger("It seems uninterested by the [H]"))
		return

	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("you can't feed the [src] without carrying his burden"))
		return

	if(istype(H, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = H
		if(E.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [E] spitting out coins in its place!"))
			budget2change(E.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, E.headprice)
			qdel(E)
			return

	if(istype(H, /obj/item/natural/head))
		var/obj/item/natural/head/A = H
		if(A.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [A] spitting out coins in its place!"))
			budget2change(A.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, A.headprice)
			qdel(A)
			return

	if(istype(H, /obj/item/painting/lorehead) && is_gaffer_job(user.mind.assigned_role)) //this will hopefully be more thematic when the HEAD EATER is in its real form
		var/obj/item/painting/lorehead/D = H
		if(D.headprice > 0)
			to_chat(user, span_danger("as the [src] consumes [D] without a trace, you are hit with a wistful feeling, your past...gone in an instant."))
			user.add_stress(/datum/stress_event/destroyed_past)
			budget2change(D.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, D.headprice)
			qdel(D)
			return

	if(istype(H, /obj/item/painting/lorehead))
		var/obj/item/painting/lorehead/Y = H
		if(Y.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [Y] spitting out coins in its place!"))
			budget2change(Y.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, Y.headprice)
			qdel(Y)
