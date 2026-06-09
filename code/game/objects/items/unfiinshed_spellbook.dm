
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

/obj/item/spellbook_unfinished/pre_arcyne
	name = "tome in waiting"
	icon_state = "spellbook_unfinished"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcyne energy."

/obj/item/spellbook_unfinished/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	if(!istype(P, /obj/item/paper/scroll))
		return ..()
	if(!isturf(loc) || !locate(/obj/structure/table) in loc)
		to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
		return
	var/crafttime = max(0, 60 - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) * 5)
	if(!do_after(user, crafttime, target = src))
		return
	pages_left--
	if(pages_left > 0)
		playsound(src, 'sound/items/book_page.ogg', 100, TRUE)
		to_chat(user, span_notice("[pages_left] left..."))
		qdel(P)
		return
	//promote to pre_arcyne.
	playsound(src, 'sound/items/book_open.ogg', 100, TRUE)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		to_chat(user, span_notice("The book is bound. I must find a catalyst to channel the arcyne into it now."))
	else
		to_chat(user, span_notice("I've made an empty book of thick, useless scroll paper. I can't even thumb through it!"))
	new /obj/item/spellbook_unfinished/pre_arcyne(loc)
	qdel(P)
	qdel(src)


/obj/item/spellbook_unfinished/pre_arcyne/attackby(obj/item/P, mob/living/carbon/human/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in loc

	if(istype(P, /obj/item/gem/amethyst))
		user.visible_message(span_notice("I run my arcyne energy into the crystal. Its artificial lattices pulse and then fall dormant. It must not be strong enough to make a spellbook with!"))
		return

	if(isturf(loc) && !found_table)
		to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
		return TRUE

	if(istype(P, /obj/item/gem/violet))
		apply_gem_catalyst(user, P, /obj/item/book/granter/spellbook/expert, found_table)
		return

	if(istype(P, /obj/item/gem))
		apply_gem_catalyst(user, P, /obj/item/book/granter/spellbook/adept, found_table)
		return

	if(istype(P, /obj/item/natural/stone))
		var/obj/item/natural/stone/the_rock = P
		if(!the_rock.magic_power)
			to_chat(user, span_notice("This is a mere rock — it has no arcyne potential. Bah!"))
			return ..()
		apply_stone_catalyst(user, the_rock, found_table)
		return

	if(istype(P, /obj/item/natural/melded))
		var/obj/item/natural/melded/meld = P
		apply_melded_catalyst(user, P, meld.melded_quality, meld.shock_damage)
		return
	return ..()

/// Spawns a finished book, sets owner, and cleans up catalyst + self.
/obj/item/spellbook_unfinished/pre_arcyne/proc/finish_book(mob/user, obj/item/catalyst, book_type, born_of_rock = FALSE, extra_desc = null)
	playsound(src, 'sound/magic/crystal.ogg', 100, TRUE)
	var/obj/item/book/granter/spellbook/newbook = new book_type(get_turf(loc))
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

/// Handles gem catalysts. Unskilled readers just get a cosmetic press.
/obj/item/spellbook_unfinished/pre_arcyne/proc/apply_gem_catalyst(mob/user, obj/item/gem/gem, book_type, found_table)
	if(!do_after(user, max(0, 100 - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) * 5), target = src))
		return
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		user.visible_message(
			span_warning("[user] crushes [user.p_their()] [gem]! Its powder seeps into the [src]."),
			span_notice("I run my arcyne energy into the crystal. It shatters and seeps into the cover of the tome! Runes and symbols of an unknowable language cover its pages now...")
		)
		finish_book(user, gem, book_type)
	else
		to_chat(user, span_notice("I press the gem into the cover of the book. What a pretty design this would make!"))
		return TRUE

/// Handles magic stone catalysts. Quality tier is determined by magic_power.
/// Unskilled users have a prob() chance; failure destroys the stone and shocks.
/obj/item/spellbook_unfinished/pre_arcyne/proc/apply_stone_catalyst(mob/living/user, obj/item/natural/stone/the_rock, found_table)
	var/crafttime = max(0, (130 - the_rock.magic_power) - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) * 5)
	if(!do_after(user, crafttime, target = src))
		return

	var/book_type = stone_quality_to_book(the_rock.magic_power)

	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		user.visible_message(
			span_warning("[user] crushes [user.p_their()] [the_rock]! Its powder seeps into the [src]."),
			span_notice("I join my arcyne energy with that of the magical stone in my hands, which shudders briefly before dissolving into motes of ash. Runes and symbols of an unknowable language cover its pages now...")
		)
		to_chat(user, span_notice("...yet even for an enigma of the arcyne, these characters are unlike anything I've seen before. They're going to be -much- harder to understand..."))
		finish_book(user, the_rock, book_type, born_of_rock = TRUE, extra_desc = " Traces of multicolored stone limn its margins.")
	else
		// Unskilled: prob chance proportional to magic_power (capped at ~15%).
		if(prob(the_rock.magic_power * 5))
			user.visible_message(
				span_warning("[user] carefully sets down [the_rock] upon [src]. Nothing happens for a moment or three, then suddenly, the glow surrounding the stone becomes as liquid, seeps down and soaks into the tome!"),
				span_notice("I knew this stone was special! Its colourful magick has soaked into my tome and given me gift of mystery!")
			)
			to_chat(user, span_notice("...what in the world does any of this scribbling possibly mean?"))
			finish_book(user, the_rock, book_type, born_of_rock = TRUE, extra_desc = " Traces of multicolored stone limn its margins.")
		else
			user.visible_message(
				span_warning("[user] sets down [the_rock] upon the surface of [src] and watches expectantly. Without warning, the rock violently pops like a squashed gourd!"),
				span_notice("No! My precious stone! It mustn't have wanted to share its mysteries with me...")
			)
			user.electrocute_act(5, src)
			qdel(the_rock)

/// Maps a stone's magic_power to the appropriate book subtype.
/obj/item/spellbook_unfinished/pre_arcyne/proc/stone_quality_to_book(magic_power)
	if(magic_power >= 10)
		return /obj/item/book/granter/spellbook/apprentice
	if(magic_power > 5)
		return /obj/item/book/granter/spellbook/mid
	return /obj/item/book/granter/spellbook/horrible

/// Handles melded catalysts. Unskilled users take escalating shock damage.
/obj/item/spellbook_unfinished/pre_arcyne/proc/apply_melded_catalyst(mob/living/user, obj/item/P, book_type, shock_damage)
	if(!do_after(user, max(0, 100 - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) * 5), target = src))
		return
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		user.visible_message(
			span_warning("[user] imbues [user.p_their()] [P]! It fuses into the [src]."),
			span_notice("I join my arcyne energy with that of the [P] in my hands, which shudders briefly before dissolving into motes of energy. Runes and symbols of an unknowable language cover its pages now...")
		)
		to_chat(user, span_notice("...yet even for an enigma of the arcyne, these characters are unlike anything I've seen before. They're going to be -much- harder to understand..."))
		finish_book(user, P, book_type)
	else
		user.visible_message(
			span_warning("[user] sets down [P] upon the surface of [src] and watches expectantly. Without warning, the [P] violently explodes!"),
			span_notice("I should have known messing with the arcyne was dangerous!")
		)
		user.electrocute_act(shock_damage, src)
		qdel(P)
