// This shit sucks ass

/*	..................   Spider stuff   ................... */
/obj/structure/spider/attacked_by(obj/item/I, mob/living/user) //Snipping action for webs, scissors turning webs into silk fast!
	if(user.used_intent.type != /datum/intent/snip)
		return ..()
	var/sewing_skill = user.get_skill_level(/datum/skill/misc/sewing, TRUE)
	var/snip_time = 5 SECONDS - (sewing_skill * 10)
	var/amount = rand(1, 2)
	if(!do_after(user, snip_time))
		return TRUE
	for(var/i in 1 to amount)
		new /obj/item/natural/silk (get_turf(src))
	user.visible_message(span_notice("[user] snips [src] up into silk."))
	user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT / 2)) //We're getting experience for harvesting silk!
	playsound(src, 'sound/items/flint.ogg', 100, TRUE)
	qdel(src)
	return TRUE

/obj/structure/spider/stickyweb
	name = "web"
	icon = 'icons/roguetown/misc/webbing.dmi'
	icon_state = "stickyweb1"
	resistance_flags = FLAMMABLE
	alpha = 109
	max_integrity = 50
	opacity = TRUE

/obj/structure/spider/stickyweb/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!HAS_TRAIT(mover, TRAIT_WEBWALK) && isliving(mover))
		if(prob(50))
			to_chat(mover, "<span class='danger'>I get stuck in \the [src] for a moment.</span>")
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/spider/stickyweb/fire_act(added, maxstacks)
	visible_message("<span class='warning'>[src] catches fire!</span>")
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/effect/hotspot(T)

/obj/structure/spider/stickyweb/solo
	icon_state = "stickyweb3"

/obj/structure/spider/stickyweb/Initialize()
	if(icon_state == "stickyweb1")
		if(prob(50))
			icon_state = "stickyweb2"
	dir = pick(GLOB.cardinals)
	alpha = rand(80,109)
	switch(pick(1,2))
		if (1)
			static_debris = FALSE
		if (2)
			static_debris = list(/obj/item/natural/silk = 1)
	. = ..()

/obj/structure/spider/cocoon
	name = "cocoon"
	desc = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "cocoon1"
	max_integrity = 40

/obj/structure/spider/cocoon/Initialize(mapload, ...)
	. = ..()
	switch(pick(1,2,3,4,5))
		if(1)
			static_debris = list(/obj/item/natural/silk = 3)
			icon_state = pick("cocoon1","cocoon2")
		if(2)
			static_debris = list(/obj/item/natural/silk = 2, /obj/effect/decal/remains/bigrat = 1)
			icon_state = pick("cocoon2","cocoon3")
		if(3)
			static_debris = list(/obj/item/natural/silk = 2, /obj/effect/decal/remains/human = 1)
			icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
		if(4)
			static_debris = list(/obj/item/natural/silk = 2, /obj/effect/decal/cleanable/blood/gibs = 1)
			icon_state = pick("cocoon1","cocoon2","cocoon3")
		if(5)
			static_debris = list(/obj/item/natural/silk = 2, /obj/item/natural/stone = 1)
			icon_state = pick("cocoon1","cocoon2")

/obj/structure/spider/cocoon/deconstruct(disassembled)
	. = ..()
	var/turf/T = get_turf(src)
	visible_message("<span class='warning'>\The [src] splits open.</span>")
	for(var/atom/movable/A in contents)
		A.forceMove(T)

/obj/structure/spider/cocoon/container_resist(mob/living/user)
	var/breakout_time = 1 MINUTES
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, "<span class='notice'>I struggle against the tight bonds... (This will take about [DisplayTimeText(breakout_time)].)</span>")
	visible_message("<span class='notice'>I see something struggling and writhing in \the [src]!</span>")
	if(do_after(user, breakout_time, src))
		if(!user || user.stat != CONSCIOUS || user.loc != src)
			return
		qdel(src)
