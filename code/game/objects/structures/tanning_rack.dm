/obj/machinery/tanningrack
	name = "drying rack"
	desc = "A drying rack for the preparation of food or curing of hides into leather, it can be moved with the help of a wooden stake."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "dryrack"
	var/obj/item/natural/hide/hide
	max_integrity = 200
	density = TRUE
	climbable = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/machinery/tanningrack/examine(mob/user)
	. = ..()
	if(hide)
		. += span_warning("There is a piece of hide ready to be worked. I might need a knife for this.")
	if(!anchored)
		. += span_warning("It is unanchored and able to be moved.")

/obj/machinery/tanningrack/attack_hand(mob/user, list/modifiers)
	if(hide)
		var/obj/item/I = hide
		hide = null
		I.loc = user.loc
		user.put_in_active_hand(I)
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/tanningrack/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(istype(I, /obj/item/natural/hide) && !istype(I, /obj/item/natural/hide/cured))
		if(!hide)
			I.forceMove(src)
			hide = I
			update_appearance(UPDATE_OVERLAYS)
			return
		else
			to_chat(user, span_warning("The rack is already occupied!"))
			return
	if((user.used_intent.type == /datum/intent/dagger/cut || user.used_intent.type == /datum/intent/sword/cut || user.used_intent.type == /datum/intent/axe/cut) && hide)
		if(anchored)
			var/skill_level = user.get_skill_level(/datum/skill/craft/tanning, TRUE)
			var/work_time = (12 SECONDS - (skill_level * 15))
			var/pieces_to_spawn = rand(1, min(skill_level + 1, 6)) //Random number from 1 to skill level
			var/sound_played = FALSE
			to_chat(user, span_warning("I begin scraping the hide's skin..."))
			if(!do_after(user, work_time))
				return
			playsound(src,pick('sound/items/book_open.ogg','sound/items/book_page.ogg'), 100, FALSE)
			QDEL_NULL(hide)
			user.mind.add_sleep_experience(/datum/skill/craft/tanning, user.STAINT * 2) //these numbers may need some revision
			update_appearance(UPDATE_OVERLAYS)
			for(var/i = 0; i < pieces_to_spawn; i++)
				if(prob(skill_level + CLAMP((user.STALUC - 10)*2,0,100)))
					new /obj/item/natural/cured/essence(get_turf(user))
					if(!sound_played)
						sound_played = TRUE
						to_chat(user, span_warning("Dendor provides..."))
						playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
				else
					new /obj/item/natural/hide/cured(get_turf(user))
			return
		else
			to_chat(user, span_warning("I need to anchor this down with a wooden stake before I can work this hide."))
			return
	if(istype(I, /obj/item/grown/log/tree/stake))
		if(anchored)
			anchored = FALSE
			to_chat(user, span_warning("The [src] can now be moved."))
		else
			anchored = TRUE
			to_chat(user, span_warning("You anchor [src]."))
		playsound(src,pick('sound/foley/woodclimb.ogg'), 100, TRUE)
		return
	. = ..()

/obj/machinery/tanningrack/update_overlays()
	. = ..()
	if(!hide)
		return
	var/obj/item/I = hide
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	var/mutable_appearance/M = new /mutable_appearance(I)
	M.pixel_y = I.pixel_x
	M.pixel_x = I.pixel_y
	. += M
