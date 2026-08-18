/obj/item/spellbook_unfinished
	name = "bound scrollpaper"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	/// Pages still needed before the binding is complete
	var/pages_left = 4
	///wahhhh
	var/datum/spellcraft_session/session

/obj/item/spellbook_unfinished/Destroy()
	. = ..()
	QDEL_NULL(session)

/obj/item/spellbook_unfinished/pre_arcyne
	name = "tome in waiting"
	icon_state = "spellbook_unfinished"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcyne energy."

/obj/item/spellbook_unfinished/pre_arcyne/attack_self(mob/living/user)
	if(!session)
		session = new /datum/spellcraft_session()
		session.book_base = src
		session.user = user
	var/datum/visual_ui/spellcraft_star/ui
	if("spellcraft_star" in user.mind.active_uis)
		ui = user.mind.active_uis["spellcraft_star"]
		ui.remove_from_client()
		user.mind.active_uis -= "spellcraft_star"
		qdel(ui)
		return
	else
		ui = new(user.mind, src)
		ui.display()

/obj/item/spellbook_unfinished/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/paper/scroll))
		return NONE

	if(!isturf(loc) || !locate(/obj/structure/table) in loc)
		to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
		return ITEM_INTERACT_BLOCKING

	var/crafttime = max(0, 60 - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) * 5)
	if(!do_after(user, crafttime, target = src))
		return ITEM_INTERACT_BLOCKING

	pages_left--
	if(pages_left > 0)
		playsound(src, 'sound/items/book_page.ogg', 100, TRUE)
		to_chat(user, span_notice("[pages_left] left..."))
		qdel(tool)
		return ITEM_INTERACT_SUCCESS

	//promote to pre_arcyne.
	playsound(src, 'sound/items/book_open.ogg', 100, TRUE)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		to_chat(user, span_notice("The book is bound. I must find a catalyst to channel the arcyne into it now."))
	else
		to_chat(user, span_notice("I've made an empty book of thick, useless scroll paper. I can't even thumb through it!"))
	new /obj/item/spellbook_unfinished/pre_arcyne(loc)
	qdel(tool)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/// Spawns a finished book, sets owner, and cleans up catalyst + self.
/obj/item/spellbook_unfinished/pre_arcyne/proc/finish_book(mob/user, obj/item/catalyst, book_type, born_of_rock = FALSE, extra_desc = null)
	playsound(src, 'sound/magic/crystal.ogg', 100, TRUE)
	var/obj/item/spellbook/newbook = new book_type(get_turf(loc))
	var/atom/old_loc = loc
	newbook.owner = user
	if(born_of_rock)
		newbook.born_of_rock = TRUE
	if(extra_desc)
		newbook.desc += extra_desc
	qdel(catalyst)
	qdel(src)
	if(ismob(old_loc))
		var/mob/living/mob = old_loc
		mob.put_in_hands(newbook)
	var/datum/visual_ui/spellcraft_star/ui
	if("spellcraft_star" in user.mind.active_uis)
		ui = user.mind.active_uis["spellcraft_star"]
		ui.remove_from_client()
		user.mind.active_uis -= "spellcraft_star"
		qdel(ui)
	return newbook
