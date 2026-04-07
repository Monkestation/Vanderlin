/*	..................   Innocent Bush   ................... */
/obj/structure/innocent_bush
	name = "bush"
	desc = "These large bushes are known to be well-liked by silkworms who make their nests in their dark depths."
	icon = 'icons/mob/creacher/trolls/troll.dmi'
	icon_state = "troll_hide"
	SET_BASE_PIXEL(-16, 0)
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 500
	density = TRUE

/obj/structure/innocent_bush/attack_hand(mob/living/carbon/human/user)
	playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	new /mob/living/simple_animal/hostile/retaliate/troll/bog (get_turf(src))
	qdel(src)

/obj/structure/innocent_bush/attackby(obj/item, /mob/living/user, list/modifiers)
	playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	new /mob/living/simple_animal/hostile/retaliate/troll/bog (get_turf(src))
	qdel(src)

/obj/structure/innocent_bush/Bumped(atom/movable/AM)
	playsound(src, "plantcross", 80, FALSE, -1)
	playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	new /mob/living/simple_animal/hostile/retaliate/troll/bog (get_turf(src))
	qdel(src)

/obj/structure/innocent_bush/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(src, "plantcross", 80, FALSE, -1)
	sleep(4)
	playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	new /mob/living/simple_animal/hostile/retaliate/troll/bog (get_turf(src))
	qdel(src)

/obj/structure/innouous_rock
	name = "mana crystal deposit"
	desc = "These large mana crystals deposit are known to bring fortune to miners who venture into the deep dark depths of the world."
	icon = 'icons/mob/creacher/trolls/troll_cave.dmi'
	icon_state = "troll_hide"
	SET_BASE_PIXEL(-16, 0)
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 500
	density = TRUE
	///overrides the probability of it being a troll at init
	var/safe_rock = FALSE
	/// does it spawns a troll? varedit this for funsies!
	var/fake_rock = FALSE

/obj/structure/innouous_rock/safe
	safe_rock = TRUE

/obj/structure/innouous_rock/Initialize()
	. = ..()
	if(!safe_rock && prob(50))
		fake_rock = TRUE // 50/50 of it being real. have fun :)

/obj/structure/innouous_rock/attack_hand(mob/living/carbon/human/user)
	if(fake_rock)
		spawn_troll()
		return

	to_chat(user, span_notice("You carefully detach the crystals from the rock..."))
	if(!do_after(user, 3 SECONDS, src))
		to_chat(user, span_warning("The crystals crumble as you try to detach it!"))
		qdel(src)
		return

	to_chat(user, span_warning("You successfully detach the crystals from the rock!"))
	for(var/i in 1 to 3)
		new /obj/item/mana_battery/mana_crystal/standard(loc)
	qdel(src)

/obj/structure/innouous_rock/attackby(obj/item, mob/living/user, list/modifiers)
	. = ..()
	if(fake_rock)
		spawn_troll()
		return
	if(!istype(item, /obj/item/weapon/pick/paxe))
		return

	to_chat(user, span_notice("You carefully detach the crystals from the rock..."))
	if(!do_after(user, 1.5 SECONDS, src))
		to_chat(user, span_warning("The crystals crumble as you try to detach it!"))
		qdel(src)
		return

	to_chat(user, span_warning("You successfully detach the crystals from the rock!"))
	for(var/i in 1 to 3)
		new /obj/item/mana_battery/mana_crystal/standard(loc)
	qdel(src)

/obj/structure/innouous_rock/Bumped(atom/movable/AM)
	if(fake_rock)
		spawn_troll()

/obj/structure/innouous_rock/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(fake_rock)
		spawn_troll()

/obj/structure/innouous_rock/proc/spawn_troll()
	playsound(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	new /mob/living/simple_animal/hostile/retaliate/troll/cave/ambush (get_turf(src))
	qdel(src)

