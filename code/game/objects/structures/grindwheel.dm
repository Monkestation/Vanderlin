/obj/structure/grindwheel
	name = "grind wheel"
	desc = ""
	icon = 'icons/roguetown/misc/forge.dmi'
	icon_state = "grindwheel"
	density = TRUE
	anchored = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 400

/obj/structure/grindwheel/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(I.max_blade_int)
		playsound(src,'sound/foley/grindblade.ogg', 100, FALSE)
		if(do_after(user, 4.1 SECONDS, src)) //oddly specific time
			I.restore_bintegrity()
		return
	if(istype(I, /obj/item/grown/log/tree/small))
		var/skill_level = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/labor/lumberjacking)
		var/wood_time = (4 SECONDS - (skill_level * 5))
		playsound(src, pick('sound/misc/slide_wood (2).ogg', 'sound/misc/slide_wood (1).ogg'), 100, FALSE)
		if(do_after(user, wood_time, src))
			if(prob(max(40 - (skill_level * 10), 0)) || !skill_level) //Chance maxes at level 4 (standard woodcutter)
				to_chat(user, span_info("Curses! I ruined this piece of wood..."))
				playsound(src,'sound/combat/hits/onwood/destroyfurniture.ogg', 100, FALSE)
			else
				new /obj/item/natural/wood/plank(get_turf(src))
			user.mind.add_sleep_experience(/datum/attribute/skill/labor/lumberjacking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
			qdel(I)
			return
	. = ..()
