
/obj/item/textbook
	name = "blank textbook"
	desc = "A blank textbook, ready for the knowledge it will share to be prescribed into it."
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "book_blank"
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 64
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = FLAMMABLE
	force = 5
	throw_speed = 1
	throw_range = 5
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	attack_verb = list("bashed", "whacked", "educated")
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	firefuel = 2 MINUTES
	obj_flags = CAN_BE_HIT

	var/exppercycle = 0
	var/INTneeded = 0
	var/minskill
	var/maxskill
	var/skilltoteach
	var/skill_name = "nobody"
	var/static/list/teachable_skills = list(
		"Reading" = /datum/skill/misc/reading,
		"Mathematics" = /datum/skill/labor/mathematics,
		"Engineering" = /datum/skill/craft/engineering,
		"Alchemy" = /datum/skill/craft/alchemy,
		"Medicine" = /datum/skill/misc/medicine,
		)

/obj/item/textbook/Initialize()
	. = ..()
	if(skilltoteach)
		update_appearance(UPDATE_DESC | UPDATE_NAME)

/obj/item/textbook/update_name()
	. = ..()
	var/title = "nothing"
	switch(skilltoteach)
		if(/datum/skill/misc/reading)
			title = "literature"
		if(/datum/skill/labor/mathematics)
			title = "mathematics"
		if(/datum/skill/craft/engineering)
			title = "engineering"
		if(/datum/skill/craft/alchemy)
			title = "alchemy"
		if(/datum/skill/misc/medicine)
			title = "medicine"
	name = "[skill_name]'s guide to [title]"

/obj/item/textbook/update_desc()
	. = ..()
	switch(skilltoteach)
		if(/datum/skill/misc/reading)
			desc = "A textbook that teaches the alphabet, sentences of varying complexity, and common symbols, allowing readers to train their reading skills."
		if(/datum/skill/labor/mathematics)
			desc = "A textbook focused on teaching mathematic notation and the applications for arithmetic, calculus, and other areas of math."
		if(/datum/skill/craft/engineering)
			desc = "A textbook focused on teaching about engineering, the physical laws that govern our mortal world, and their application."
		if(/datum/skill/craft/alchemy)
			desc = "A textbook that teaches all about alchemy. Ranging from simple differences between mentha and paris, to complex potion brewing."
		if(/datum/skill/misc/medicine)
			desc = "A textbook that teaches medicine. The book is rich in illustrations and notes on how the body functions and how to treat various illnesses and wounds."
	desc += " The higher the complexity, the more skilled the reader must be to study it."

/obj/item/textbook/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/natural/feather))
		if(skilltoteach)
			return
		var/skill = input(user, "What kind of textbook will you write", "NOC") as null|anything in teachable_skills
		if(!skill)
			return
		var/userskill = user.get_skill_level(teachable_skills[skill])
		if(userskill <= 1)
			to_chat(user, span_warning("You aren't skilled enough to write a textbook about [lowertext(skill)]!"))
			return
		var/list/possible_skill_levels = list()
		var/list/skill_names = list("Novice", "Apprentice", "Journeyman", "Expert", "Master", "Legend")
		for(var/level in 1 to length(skill_names))
			if(level > userskill - 1)
				break
			possible_skill_levels[skill_names[level]] = level
		var/level_name = input(user, "What level of difficulty should the textbook be?", "NOC") as null|anything in possible_skill_levels
		if(!level_name)
			return
		if(skilltoteach)
			return
		if(user.stat >= UNCONSCIOUS)
			return
		if(!user.CanReach(src))
			return
		to_chat(user, span_notice("You begin writing in [src] concepts about [lowertext(skill)] of [lowertext(level_name)] difficulty."))
		playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		skilltoteach = teachable_skills[skill]
		if(do_after(user, 10 SECONDS, src))
			skill_name = lowertext(level_name)
			maxskill = possible_skill_levels[level_name]
			minskill = maxskill - 1
			update_appearance(UPDATE_DESC | UPDATE_NAME)
			to_chat(user, span_notice("You finish writing [src]."))
			icon_state = "basic_book_1"
			playsound(src, 'sound/items/write.ogg', 50, FALSE, ignore_walls = FALSE)
		else
			skilltoteach = null
		return TRUE
	. = ..()

/obj/item/textbook/attack_self(mob/user, list/modifiers)
	. = ..()
	attemptlearn(user)

/obj/item/textbook/proc/attemptlearn(mob/user)
	if(!skilltoteach)
		return
	if(user.mind && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/userskill = H.get_skill_level(skilltoteach)
		var/intbonus = H.STAINT / 2
		var/true_experience = exppercycle + intbonus
		if(true_experience <= INTneeded)
			to_chat(user, span_warning("I can't understand anything from this theory! Practice should do me better."))
			return
		if(userskill < minskill)
			to_chat(user, span_warning("This textbook is too advanced for me to study!"))
			return
		if(userskill < maxskill)
			to_chat(user, span_info("You begin to study the [src.name]."))
			if(do_after(H, 5 SECONDS))
				user.adjust_experience(skilltoteach, true_experience)
				attemptlearn(user)
		else
			to_chat(user, span_warning("This textbook is too simple for me to learn any more from!"))
			return
	else
		return

/*.............. READING ..............*/

/obj/item/textbook/novice
	icon_state = "book_1"
	minskill = SKILL_LEVEL_NONE
	maxskill = SKILL_LEVEL_NOVICE
	exppercycle = 5
	skilltoteach = /datum/skill/misc/reading
	skill_name = "novice"
	INTneeded = 2

/obj/item/textbook/apprentice
	icon_state = "book2_1"
	minskill = SKILL_LEVEL_NOVICE
	maxskill = SKILL_LEVEL_APPRENTICE
	exppercycle = 10
	skilltoteach = /datum/skill/misc/reading
	skill_name = "apprentice"
	INTneeded = 5

/obj/item/textbook/journeyman
	icon_state = "book3_1"
	minskill = SKILL_LEVEL_APPRENTICE
	maxskill = SKILL_LEVEL_JOURNEYMAN
	exppercycle = 25
	skilltoteach = /datum/skill/misc/reading
	skill_name = "journeyman"
	INTneeded = 10

/obj/item/textbook/expert
	icon_state = "book4_1"
	minskill = SKILL_LEVEL_JOURNEYMAN
	maxskill = SKILL_LEVEL_EXPERT
	exppercycle = 40
	skilltoteach = /datum/skill/misc/reading
	skill_name = "expert"
	INTneeded = 13

/obj/item/textbook/master
	icon_state = "book5_1"
	minskill = SKILL_LEVEL_EXPERT
	maxskill = SKILL_LEVEL_MASTER
	exppercycle = 55
	skilltoteach = /datum/skill/misc/reading
	skill_name = "master"
	INTneeded = 15

/obj/item/textbook/legendary //uncraftable
	icon_state = "book6_1"
	minskill = SKILL_LEVEL_MASTER
	maxskill = SKILL_LEVEL_LEGENDARY
	exppercycle = 70
	skilltoteach = /datum/skill/misc/reading
	skill_name = "legend"
	INTneeded = 18

/*.............. MATHEMATICS ..............*/

/obj/item/textbook/novice/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/obj/item/textbook/apprentice/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/obj/item/textbook/journeyman/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/obj/item/textbook/expert/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/obj/item/textbook/master/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/obj/item/textbook/legendary/mathematics
	skilltoteach = /datum/skill/labor/mathematics

/*.............. ENGINEERING ..............*/

/obj/item/textbook/novice/engineering
	skilltoteach = /datum/skill/craft/engineering

/obj/item/textbook/apprentice/engineering
	skilltoteach = /datum/skill/craft/engineering

/obj/item/textbook/journeyman/engineering
	skilltoteach = /datum/skill/craft/engineering

/obj/item/textbook/expert/engineering
	skilltoteach = /datum/skill/craft/engineering

/obj/item/textbook/master/engineering
	skilltoteach = /datum/skill/craft/engineering

/obj/item/textbook/legendary/engineering
	skilltoteach = /datum/skill/craft/engineering

/*.............. ALCHEMY ..............*/

/obj/item/textbook/novice/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/obj/item/textbook/apprentice/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/obj/item/textbook/journeyman/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/obj/item/textbook/expert/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/obj/item/textbook/master/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/obj/item/textbook/legendary/alchemy
	skilltoteach = /datum/skill/craft/alchemy

/*.............. MEDICINE ..............*/

/obj/item/textbook/novice/medicine
	skilltoteach = /datum/skill/misc/medicine

/obj/item/textbook/apprentice/medicine
	skilltoteach = /datum/skill/misc/medicine

/obj/item/textbook/journeyman/medicine
	skilltoteach = /datum/skill/misc/medicine

/obj/item/textbook/expert/medicine
	skilltoteach = /datum/skill/misc/medicine

/obj/item/textbook/master/medicine
	skilltoteach = /datum/skill/misc/medicine

/obj/item/textbook/legendary/medicine
	skilltoteach = /datum/skill/misc/medicine
