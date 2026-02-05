/datum/coven/fae_trickery
	name = "Fae Trickery"
	desc = "This coven typically develops in vampires born near the swamps of Daftmarsh surrounded by the Fae."
	icon_state = "mytherceria"
	power_type = /datum/coven_power/fae_trickery

/datum/coven_power/fae_trickery
	name = "Fae Trickery power name"
	desc = "Fae Trickery power description"

//FEY SIGHT
/datum/coven_power/fae_trickery/fey_sight
	name = "Fey Sight"
	desc = "Sense magical items on another person."

	level = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	target_type = TARGET_MOB
	range = 7

	cooldown_length = 10 SECONDS

/datum/coven_power/fae_trickery/fey_sight/activate(mob/living/target)
	. = ..()
	var/list/total_list = list()
	for(var/obj/item/item in target.contents)
		if(istype(item, /obj/item/storage))
			total_list |= item.contents
		total_list |= item
	to_chat(owner, "<span class='purple'>Your fae senses reach out to detect what they're carrying...</span>")
	for(var/obj/item/item in total_list)
		if(item)
			if(SSenchantment.has_enchantment(item, /datum/enchantment/silver))
				to_chat(owner, "- <span class='danger'>[item.name]</span>")
			else if(SSenchantment.has_any_enchantment(item))
				to_chat(owner, "- <span class='nicegreen'>[item.name]</span>")
			else
				to_chat(owner, "- [item.name]")

//DARKLING TRICKERY
/datum/coven_power/fae_trickery/darkling_trickery
	name = "Darkling Trickery"
	desc = "Steal trinkets from your victims from afar."

	level = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND | COVEN_CHECK_LYING
	target_type = TARGET_MOB
	range = 3

	duration_length = 10 SECONDS
	cooldown_length = 10 SECONDS

/datum/coven_power/fae_trickery/darkling_trickery/activate(mob/living/target)
	. = ..()
	owner.enhanced_strip = TRUE
	target.show_inv(owner)

/datum/coven_power/fae_trickery/darkling_trickery/deactivate(mob/living/target)
	. = ..()
	owner.enhanced_strip = FALSE

//GOBLINISM
/datum/coven_power/fae_trickery/goblinism
	name = "Goblinism"
	desc = "Summon a mischievous goblin to latch onto your enemies' faces."

	level = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 5

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS

/datum/coven_power/fae_trickery/goblinism/activate(mob/living/target)
	. = ..()
	var/obj/item/clothing/face/goblin_mask/goblin = new (get_turf(owner))
	goblin.throw_at(target, 10, 14, owner)

/datum/coven_power/fae_trickery/goblinism/post_gain()
	. = ..()
	var/datum/action/fae_trickery/changeling_rune = new()
	changeling_rune.Grant(owner)

/obj/item/clothing/face/goblin_mask
	name = "goblin"
	desc = "A green changeling creature."
	icon_state = "goblin"
	var/stat = CONSCIOUS
	var/strength = 5
	var/attached = 0

/obj/item/clothing/face/goblin_mask/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	..()
	if(atom_integrity < 90)
		Die()

/obj/item/clothing/face/goblin_mask/proc/Die()
	if(stat == DEAD)
		return

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	visible_message("<span class='danger'>[src] curls up into a ball!</span>")

/obj/item/clothing/face/goblin_mask/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.adjustBruteLoss(5)
		to_chat(user, span_warning("[src] bites!"))
		return
	if((stat == CONSCIOUS))
		if(Leap(user))
			return
	. = ..()

/obj/item/clothing/face/goblin_mask/examine(mob/user)
	. = ..()
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			. += "<span class='boldannounce'>[src] is not moving.</span>"
		if(CONSCIOUS)
			. += "<span class='boldannounce'>[src] seems to be active!</span>"

/obj/item/clothing/face/goblin_mask/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE) //If this returns FALSE then callback will not be called.
	. = ..()
	if(!.)
		return
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		addtimer(CALLBACK(src, PROC_REF(clear_throw_icon_state)), 15)

/obj/item/clothing/face/goblin_mask/proc/clear_throw_icon_state()
	if(icon_state == "[initial(icon_state)]_thrown")
		icon_state = "[initial(icon_state)]"

/obj/item/clothing/face/goblin_mask/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		Leap(hit_atom)

/obj/item/clothing/face/goblin_mask/proc/valid_to_attach(mob/living/M)
	// valid targets: carbons
	if(stat != CONSCIOUS)
		return FALSE
	if(attached)
		return FALSE
	if(iscarbon(M))
		var/mob/living/carbon/target = M
		// gotta have a head to be implanted (no changelings or sentient plants)
		if(!target.get_bodypart(BODY_ZONE_HEAD))
			return FALSE
		// carbon, has head, not alien or devil, has no hivenode or embryo: valid
		return TRUE

	return FALSE


/obj/item/clothing/face/goblin_mask/equipped(mob/M)
	. = ..()
	Attach(M)

/obj/item/clothing/face/goblin_mask/Crossed(atom/target)
	. = ..()
	HasProximity(target)

/obj/item/clothing/face/goblin_mask/attack(mob/living/M, mob/user, list/modifiers)
	..()
	if(user.transferItemToLoc(src, get_turf(M)))
		Leap(M)

/obj/item/clothing/face/goblin_mask/proc/Attach(mob/living/M)
	if(!valid_to_attach(M))
		return
	// early returns and validity checks done: attach.
	attached++
	//ensure we detach once we no longer need to be attached
	addtimer(CALLBACK(src, PROC_REF(detach)), 30 SECONDS)


	GoIdle() //so it doesn't jump the people that tear it off


/obj/item/clothing/face/goblin_mask/proc/GoIdle()
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	addtimer(CALLBACK(src, PROC_REF(GoActive)), rand(20 SECONDS, 40 SECONDS))

/obj/item/clothing/face/goblin_mask/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

/obj/item/clothing/face/goblin_mask/proc/detach()
	attached = 0

/obj/item/clothing/face/goblin_mask/proc/Leap(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/target = M
		if(target.wear_mask && istype(target.wear_mask, /obj/item/clothing/face/goblin_mask))
			return FALSE
	M.visible_message(span_danger("[src] leaps at [M]'s face!"), \
		"<span class='userdanger'>[src] leaps at your face!</span>")
	if(iscarbon(M))
		var/mob/living/carbon/target = M

		if(target.head)
			var/obj/item/clothing/W = target.head
			target.dropItemToGround(W, TRUE)

		if(target.wear_mask)
			var/obj/item/clothing/W = target.wear_mask
			if(target.dropItemToGround(W, TRUE))
				target.visible_message(
					span_danger("[src] tears [W] off of [target]'s face!"), \
					"<span class='userdanger'>[src] tears [W] off of your face!</span>")
		target.equip_to_slot_if_possible(src, ITEM_SLOT_MASK, 0, 1, 1)
		var/datum/cb = CALLBACK(src, TYPE_PROC_REF(/obj/item/clothing/face/goblin_mask, eat_head))
		for(var/i in 1 to 10)
			addtimer(cb, (i - 1) * 1.5 SECONDS)
		spawn(16 SECONDS)
			qdel(src)
	return TRUE

/obj/item/clothing/face/goblin_mask/proc/eat_head()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		to_chat(C, span_warning("[src] is eating your face!"))
		C.apply_damage(5, BRUTE)

/datum/action/fae_trickery
	name = "Mytherceria Traps"
	desc = "Create a trap."
	button_icon_state = "mytherceria"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/fae_trickery/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/try_trap = input(H, "Select a Trap:", "Trap") as null|anything in list("Brutal", "Spin", "Drop")
	if(try_trap)
		if(H.bloodpool < 1)
			to_chat(owner, span_warning("You don't have enough <b>BLOOD</b> to do that!"))
			return
		H.adjust_bloodpool(-15)
		switch(try_trap)
			if("Brutal")
				var/obj/fae_trickery_trap/trap = new (get_turf(owner))
				trap.owner = owner
			if("Spin")
				var/obj/fae_trickery_trap/disorient/trap = new (get_turf(owner))
				trap.owner = owner
			if("Drop")
				var/obj/fae_trickery_trap/drop/trap = new (get_turf(owner))
				trap.owner = owner
		to_chat(owner, span_notice("You've created a trap!"))

/obj/fae_trickery_trap
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	alpha = 64
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune1"
	color = "#4182ad"
	var/unique = FALSE
	var/mob/owner

/obj/fae_trickery_trap/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && owner)
		if(AM != owner)
			if(!unique)
				var/mob/living/L = AM
				var/atom/throw_target = get_edge_target_turf(AM, get_dir(src, AM))
				L.apply_damage(30, BRUTE)
				AM.throw_at(throw_target, rand(8,10), 14, owner)
				qdel(src)

/obj/fae_trickery_trap/disorient
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune2"

/obj/fae_trickery_trap/disorient/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && owner)
		if(AM != owner)
			var/mob/living/L = AM
			var/list/screens = list(L.hud_used.plane_masters["[FLOOR_PLANE]"], L.hud_used.plane_masters["[GAME_PLANE]"], L.hud_used.plane_masters["[LIGHTING_PLANE]"])
			var/rotation = 50
			for(var/whole_screen in screens)
				animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING)
			spawn(15 SECONDS)
				for(var/whole_screen in screens)
					animate(whole_screen, transform = matrix(), time = 0.5 SECONDS, easing = QUAD_EASING)
			qdel(src)

/obj/fae_trickery_trap/drop
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune3"

/obj/fae_trickery_trap/drop/Crossed(atom/movable/AM)
	..()
	if(iscarbon(AM) && owner)
		if(AM != owner)
			var/mob/living/carbon/L = AM
			L.drop_all_held_items()
			qdel(src)

//CHANJELIN WARD
/datum/coven_power/fae_trickery/chanjelin_ward
	name = "Chanjelin Ward"
	desc = "Create a symbol that disorientates your victim."

	level = 4
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 5

	aggravating = TRUE
	hostile = TRUE

	duration_length = 5 SECONDS
	cooldown_length = 10 SECONDS

/datum/coven_power/fae_trickery/chanjelin_ward/activate(mob/living/target)
	. = ..()
	var/list/screens = list(target.hud_used.plane_masters["[FLOOR_PLANE]"], target.hud_used.plane_masters["[GAME_PLANE]"], target.hud_used.plane_masters["[LIGHTING_PLANE]"])
	var/rotation = 50
	for(var/whole_screen in screens)
		animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING)

/datum/coven_power/fae_trickery/chanjelin_ward/deactivate(mob/living/target)
	. = ..()
	var/list/screens = list(target.hud_used.plane_masters["[FLOOR_PLANE]"], target.hud_used.plane_masters["[GAME_PLANE]"], target.hud_used.plane_masters["[LIGHTING_PLANE]"])
	for(var/whole_screen in screens)
		animate(whole_screen, transform = matrix(), time = 0.5 SECONDS, easing = QUAD_EASING)

/datum/coven_power/fae_trickery/chanjelin_ward/can_activate(mob/living/target, alert)
	. = ..()
	if (!.)
		return .

	if (!target.client)
		to_chat(owner, span_warning("You cannot cast [src] on mindless entities!"))
		return FALSE

	return .

//RIDDLE PHANTASTIQUE
/datum/coven_power/fae_trickery/riddle_phantastique
	name = "Riddle Phantastique"
	desc = "Pose a confounding riddle to your victim, forcing them to answer it before they can do anything else."

	level = 5
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING
	range = 7

	cooldown_length = 0

	var/list/datum/riddle/stored_riddles = list()

/datum/coven_power/fae_trickery/riddle_phantastique/activate(mob/living/target)
	. = ..()
	if(length(stored_riddles))
		var/list/riddle_list = list("Create a new riddle...")
		for(var/datum/riddle/riddle in stored_riddles)
			riddle_list += riddle.riddle_text
		var/try_riddle = input(owner, "Select a Riddle:", "Riddle") as null|anything in riddle_list
		if(try_riddle)
			if(try_riddle == "Create a new riddle...")
				var/datum/riddle/riddle = new ()
				if(riddle.create_riddle(owner))
					stored_riddles += riddle
					riddle.ask(target)
					owner.say(riddle.riddle_text)
				return
			var/datum/riddle/actual_riddle
			for(var/datum/riddle/RIDDLE in stored_riddles)
				if(RIDDLE)
					if(RIDDLE.riddle_text == try_riddle)
						actual_riddle = RIDDLE
			target.add_movespeed_modifier("riddle", 5)
			actual_riddle.ask(target)
			owner.say(actual_riddle.riddle_text)
	else
		var/datum/riddle/riddle = new ()
		if(riddle.create_riddle(owner))
			stored_riddles += riddle
			riddle.ask(target)
			owner.say(riddle.riddle_text)
		else
			qdel(riddle)

/datum/riddle
	var/riddle_text
	var/list/riddle_options = list()
	var/riddle_answer

/atom/movable/screen/alert/riddle
	name = "Riddle"
	desc = "You have a riddle to solve!"
	icon_state = "riddle"

	var/datum/riddle/riddle
	var/bad_answers = 0

/atom/movable/screen/alert/riddle/Click()
	if(iscarbon(usr) && (usr == mob_viewer))
		var/mob/living/carbon/M = usr
		if(riddle)
			riddle.try_answer(M, src)

/datum/riddle/proc/try_answer(mob/living/answerer, atom/movable/screen/alert/riddle/new_alert)
	var/try_answer = input(answerer, riddle_text, "Riddle") as null|anything in riddle_options
	if(try_answer)
		answer_riddle(answerer, try_answer, new_alert)

/datum/riddle/proc/ask(mob/living/asking)
	var/atom/movable/screen/alert/riddle/alert = asking.throw_alert("riddle", /atom/movable/screen/alert/riddle)
	alert.riddle = src

/datum/riddle/proc/create_riddle(mob/living/carbon/human/riddler)
	var/proceed = FALSE
	var/text_riddle = input(riddler, "Create a riddle:", "Riddle", "Is it something?") as null|text
	if(text_riddle)
		riddle_text = trim(copytext_char(sanitize(text_riddle), 1, MAX_MESSAGE_LEN))
		var/right_answer = input(riddler, "Create a right answer:", "Riddle", "Something") as null|text
		if(right_answer)
			riddle_answer = trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			riddle_options += trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			proceed = TRUE
			var/answer1 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
			if(answer1)
				riddle_options += trim(copytext_char(sanitize(answer1), 1, MAX_MESSAGE_LEN))
				var/answer2 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
				if(answer2)
					riddle_options += trim(copytext_char(sanitize(answer2), 1, MAX_MESSAGE_LEN))
					var/answer3 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
					if(answer3)
						riddle_options += trim(copytext_char(sanitize(answer3), 1, MAX_MESSAGE_LEN))
						var/answer4 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
						if(answer4)
							riddle_options += trim(copytext_char(sanitize(answer4), 1, MAX_MESSAGE_LEN))
	if(proceed)
		to_chat(riddler, "New riddle created.")
		return src
	else
		to_chat(riddler, span_danger("Your riddle is too complicated."))
		return FALSE

/datum/riddle/proc/answer_riddle(mob/living/answerer, the_answer, atom/movable/screen/alert/riddle/alert)
	if(the_answer != riddle_answer)
		alert.bad_answers++
		to_chat(answerer,
			span_danger("WRONG ANSWER."))
		if(alert.bad_answers >= round(length(riddle_options)/2))
			if(iscarbon(answerer))
				var/mob/living/carbon/C = answerer
				var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue) in C.internal_organs
				if(tongue)
					tongue.Remove(C)
			to_chat(answerer,
				span_danger("THE RIDDLE REMOVES YOUR LYING TONGUE AS IT FLEES."))
			answerer.remove_movespeed_modifier("riddle")
			alert.bad_answers = 0
			alert.riddle = null
			answerer.clear_alert("riddle")
	else
		to_chat(answerer,
			"<span class='nicegreen'>You feel the riddle's hold over you vanish.</span>")
		alert.riddle = null
		answerer.remove_movespeed_modifier("riddle")
		answerer.say(the_answer)
		answerer.clear_alert("riddle")
