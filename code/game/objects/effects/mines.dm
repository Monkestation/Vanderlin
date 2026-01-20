/obj/effect/mine
	name = "dummy mine"
	desc = ""
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0

/obj/effect/mine/proc/mineEffect(mob/victim)
	to_chat(victim, "<span class='danger'>*click*</span>")

/obj/effect/mine/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(ismob(AM))
			var/mob/MM = AM
			if(!(MM.movement_type & FLYING))
				triggermine(AM)
		else
			triggermine(AM)

/obj/effect/mine/proc/triggermine(mob/victim)
	if(triggered)
		return
	visible_message("<span class='danger'>[victim] sets off [icon2html(src, viewers(src))] [src]!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1
	qdel(src)


/obj/effect/mine/explosive
	name = "explosive mine"
	var/range_devastation = 0
	var/range_heavy = 1
	var/range_light = 2
	var/range_flash = 3

/obj/effect/mine/explosive/mineEffect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash)


/obj/effect/mine/stun
	name = "stun mine"
	var/stun_time = 80

/obj/effect/mine/stun/mineEffect(mob/living/victim)
	if(isliving(victim))
		victim.Paralyze(stun_time)

/obj/effect/mine/kickmine
	name = "kick mine"

/obj/effect/mine/kickmine/mineEffect(mob/victim)
	if(isliving(victim) && victim.client)
		to_chat(victim, "<span class='danger'>I have been kicked FOR NO REISIN!</span>")
		qdel(victim.client)

/obj/effect/mine/sound
	name = "honkblaster 1000"
	var/sound = 'sound/blank.ogg'

/obj/effect/mine/sound/mineEffect(mob/victim)
	playsound(src, sound, 100, TRUE)


/obj/effect/mine/sound/bwoink
	name = "bwoink mine"
	sound = 'sound/blank.ogg'

/obj/effect/mine/pickup
	name = "pickup"
	desc = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"
	density = FALSE
	var/duration = 0

/obj/effect/mine/pickup/Initialize()
	. = ..()
	animate(src, pixel_y = 4, time = 20, loop = -1)

/obj/effect/mine/pickup/triggermine(mob/victim)
	if(triggered)
		return
	triggered = 1
	invisibility = INVISIBILITY_ABSTRACT
	mineEffect(victim)
	qdel(src)

/obj/effect/mine/pickup/healing
	name = "Blue Orb"
	desc = ""
	color = "#0000FF"

/obj/effect/mine/pickup/healing/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>I feel great!</span>")
	victim.revive(ADMIN_HEAL_ALL)

/obj/effect/mine/pickup/speed
	name = "Yellow Orb"
	desc = ""
	color = "#FFFF00"
	duration = 300

/obj/effect/mine/pickup/speed/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>I feel fast!</span>")
	victim.add_movespeed_modifier(MOVESPEED_ID_YELLOW_ORB, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))
	sleep(duration)
	victim.remove_movespeed_modifier(MOVESPEED_ID_YELLOW_ORB)
	to_chat(victim, "<span class='notice'>I slow down.</span>")
