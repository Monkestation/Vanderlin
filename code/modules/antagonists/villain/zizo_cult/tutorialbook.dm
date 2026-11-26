//The recipe book is a total non-metagamable imitation of a normal bible
//Only zizoids can access the recipes, but everybody can read the verses from inside

/obj/item/recipe_book/zizo_cult
	name = "The Book"
	icon_state = "bibble_0"
	base_icon_state = "bibble"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	var/verses_file = "strings/bibble.txt"
	var/can_select_verse_ranges = TRUE
	var/current_verse_range = "Random Verse"
	var/list/verse_ranges = list(           // Patron divied up by line in txt file
		"Seperation" = list(1, 4),
		"Heavens" = list(5, 9),
		"Astrata" = list(10, 12),
		"Dendor" = list(13, 15),
		"Necra" = list(16, 19),
		"Noc" = list(20, 22),
		"Malum" = list(23, 26),
		"Ravox" = list(27, 29),
		"Eora" = list(30, 32),
		"Xylix" = list(33, 36),
		"Pestra" = list(37, 39),
		"Abyssor" = list(40, 42),
		"Random Verse" = null
		)

	types = list(
		/datum/ritual,
		/datum/book_entry/cultprelude
	)
/obj/item/recipe_book/zizo_cult/examine(mob/living/user)
	. = ..()
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		. += SPAN_GOD_ZIZO("Between the verses forbidden notes reveal the path to immortality.")

	if(current_verse_range == "Random Verse")
		. += span_notice("I'm ready to read a random verse.")
	else
		. += span_notice("I'm ready to read a verse from the [current_verse_range] section.")

/obj/item/recipe_book/zizo_cult/get_mechanics_examine(mob/living/user)
	. = ..()
	if(!can_select_verse_ranges)
		return
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		. += SPAN_GOD_ZIZO("Click with Middle Mouse to qoute The Book, allowing you to stay hidden.")
	. += span_notice("Alt click this book to select which section to read verses from.")

/obj/item/recipe_book/zizo_cult/attack_self(mob/living/user, list/modifiers, reading_verse = FALSE)
	if(!open)
		attack_hand_secondary(user, modifiers)
		return
	if(istype(user.patron, /datum/patron/inhumen/zizo) && !reading_verse)
		..()
		return
	if(!user.can_read(src))
		return
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	read(user)
	user.update_inv_hands()

/obj/item/recipe_book/zizo_cult/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		icon_state = "bibble_1"
		playsound(src, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		icon_state = "bibble_0"
		playsound(src, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_appearance(UPDATE_ICON_STATE)
	user.update_inv_hands()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/recipe_book/zizo_cult/MiddleClick(mob/living/user, list/modifiers)
	. = ..()
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		attack_self(user, modifiers, TRUE)
		return

/obj/item/recipe_book/zizo_cult/proc/read(mob/user)
	if(!open)
		to_chat(user, span_info("Open me first."))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)

	var/list/verses = file2list(verses_file)

	if(!verses || !verses.len)
		return

	var/selected_verse
	var/list/range = verse_ranges[current_verse_range]

	if(!range)
		selected_verse = pick(verses)
	else
		var/start = range[1]
		var/end = min(range[2], verses.len)

		if(start <= verses.len)
			selected_verse = pick(verses.Copy(start, end + 1))

	if(selected_verse)
		user.say(selected_verse)

/obj/item/recipe_book/zizo_cult/AltClick(mob/user, list/modifiers)
	if(!can_select_verse_ranges)
		return ..()

	var/choice = tgui_input_list(user, "Choose a section:", "bible", verse_ranges)
	if(!choice)
		return

	current_verse_range = choice

	to_chat(user, span_notice("You will read a section from [choice]."))

/datum/book_entry/cultprelude
	name = "Prelude"
	category = "Introduction"

/datum/book_entry/cultprelude/inner_book_html(mob/user)
	return {"
		<div>
		<h1> To those who have made their choice. </h1>
		I have once thought of her as a madman, but with <b>the</b> ritual succeeding, my doubtful thoughts were proven wrong.<br>
		This codex is my way of penance in Her eyes and all I seek is for <b>you</b> to follow into Her footsteps.<br>
		The rites written pry into the world the Ten fools sought to seal.<br>
		</div>
		<br>

		<div>
		<h2> How to perform a ritual </h2>
		1. Look onto other pages to find an intriguing ritual. You will need the required items, alongside a special requiment is it's mentioned.<br>
		2. Put them on the sigil, if the ritual does not require a specific object or person, the ingredients shall transmute into an item.<br>
		3. If it does need it, make sure it's in the middle of the circle before invoking it.<br>
		<br>
		The rituals' steps ought to be followed to the letter, lest the fragile magick shatter and destroy the materials.
		If you are certain you have properly connected the pieces, chant the words of power 'O'vena tesa', and you shall reap what you sow.
		Yet some might require more insight, a lone person wouldn't have time to learn them from the ground-up, but for that seek Her heralds.<br>
		</div>
		<br>

		<div>
		<h2> Her heralds of ascension </h2>
		Throughout the lands you shall be shunned, for the fools keeping us down react with anger onto what they cannot comprehend.<br>
		But even though She is gone from this mortal world, the Pale Lady left us Her heralds, who shall guide Her followers.<br>
		Seek them out, for they shall grant you knowledge of rites mortals weren't made to learn.<br>
		Only those with their minds open might join you in this crusade.<br>
		<br>
		<br>
		<i>-Herald Krarrukko, written in 2106</i>
		</div>
	"}
