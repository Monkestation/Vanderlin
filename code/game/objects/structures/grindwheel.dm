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
			if(has_world_trait(/datum/world_trait/delver))
				handle_profession_sharpen(I, user)
			else
				I.add_bintegrity(999)
		return
	if(!has_world_trait(/datum/world_trait/delver))
		if(istype(I, /obj/item/grown/log/tree/small))
			var/skill_level = user.get_skill_level(/datum/skill/labor/lumberjacking, TRUE)
			var/wood_time = (4 SECONDS - (skill_level * 5))
			playsound(src, pick('sound/misc/slide_wood (2).ogg', 'sound/misc/slide_wood (1).ogg'), 100, FALSE)
			if(do_after(user, wood_time, src))
				if(prob(max(40 - (skill_level * 10), 0)) || !skill_level) //Chance maxes at level 4 (standard woodcutter)
					to_chat(user, span_info("Curses! I ruined this piece of wood..."))
					playsound(src,'sound/combat/hits/onwood/destroyfurniture.ogg', 100, FALSE)
				else
					new /obj/item/natural/wood/plank(get_turf(src))
				user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
				qdel(I)
				return
	. = ..()

/obj/structure/grindwheel/proc/handle_profession_sharpen(obj/item/weapon, mob/user)
	var/sharpen_level = get_mob_highest_passive_level(user, /datum/passive/sharpening)
	if(!sharpen_level)
		to_chat(user, span_notice("Try as I might I can't figure out how to use this thing."))
		return

	var/maxium_repair = weapon.max_blade_int * (0.25 * sharpen_level)
	var/repair = max(0, maxium_repair - weapon.blade_int)
	weapon.add_bintegrity(repair)
