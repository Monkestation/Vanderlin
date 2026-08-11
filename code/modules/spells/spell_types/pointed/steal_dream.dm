
/datum/action/cooldown/spell/stealdream
	name = "STEAL DREAM"
	spell_flags = SPELL_STAMINA
	spell_cost = 1
	charge_time = 10
	cast_range = 1
	sound = 'sound/magic/stealdream.ogg'
	charge_sound = 'sound/magic/dreamchannel.ogg'
	invocation_type = INVOCATION_NONE
	cooldown_time = 5 SECONDS
	button_icon_state = "stealdream"

/datum/action/cooldown/spell/stealdream/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/stealdream/cast(mob/living/carbon/human/H, client/player_client)
	. = ..()
	var/mob/living/user = owner
	if(!H.mind)
		to_chat(user, span_warning("They have no thoughts in which to form dreams. Homonculus. Useless."))
		return FALSE // mind check? doublecheck this

	if(!iscarbon(H)) //Rocks don't dream
		to_chat(user, span_warning("Only those that think can make me real."))
		return FALSE

	if(H.stat <= CONSCIOUS) // Sleep check.
		to_chat(user, span_warning("They're not dreaming yet. They have to be asleep."))
		return FALSE

	if(H == user) // Nice job targeting yourself dumb-dumb.
		to_chat(user, span_warning("What's the point in stealing my own dreams, stupid?"))
		return FALSE

	if(H.stat >= DEAD) // Deathcheck
		to_chat(user, span_warning("[H] is a corpse. I do not commune with the dead."))
		return FALSE

	if(HAS_TRAIT(H,TRAIT_DREAMSTOLEN)) // If they've been targeted before, they cannot be targeted again.
		to_chat(user, span_warning("[H] already sees me in their dreams."))
		return FALSE

	// This is structured so poorly man. It's vestigial.
	if(H.stat >= CONSCIOUS)
		if(H.stat >= CONSCIOUS)
			to_chat(user, span_warning("You attempt to eat the dreams of [H]!"))
			// Dramatic effect
			user.visible_message(span_danger("[user] grabs [H] by the forehead, gripping it tight!"))
			var/static/list/messages = list(
				"<span class='boldwarning'>THIS ISN'T A DREAM. THIS ISN'T A DREAM I HAVE TO WAKE UP NOW!</span>",
				"<span class='boldwarning'>GONNA DIE. GONNA DIE. GONNA DIE.</span>",
				"<span class='boldwarning'>I TASTE BLOOD. AM I DYING? IS THIS WHAT IT FEELS LIKE TO DIE?</span>",
				"<span class='boldwarning'>WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP </span>",
			)
				//return FALSE
			H.add_nausea(rand(15,20))
			H.emote("whimper")
			H.adjust_jitter(100 SECONDS)
			ADD_TRAIT(H, TRAIT_DREAMSTOLEN, TRAIT_GENERIC)
			H.visible_message(span_notice("[H] has awoken into an eternal nightmare."), span_animatedpain("I had a dream last night. I was cold and wet. I felt heavy, like \
			I'd been drugged. And when I woke up, the sensations didn't go. I was feeling sick and confused and I was starting to get scared. I needed to see my mother, to \
			talk to her. I stumbled to her room and as I stood there at the bed watching them, I was overcome with this intense sadness. Then the sadness turned to fear. I \
			just stood there paralyzed with fear and I realized that there was nothing that she could do for me anymore. I've never felt so utterly alone. Everything felt \
			wrong-my body, the way things looked. Then I realized that there was something wrong with me. I started to cry standing there at the foot of her bed."))
			// VISUALS
			H.add_stress(/datum/stress_event/phantasm)
			ADD_TRAIT(H, TRAIT_DREAMWEAVERPHANTASM, "[type]")
			H.visible_message(SPAN_GOD_ZIZO("It's over."))
			H.set_eye_blur_if_lower(60 SECONDS)
			H.emote("agony", forced = TRUE)
			//
			H.playsound_local(H, 'sound/magic/dreamdevoured.ogg', vol = 80, vary = FALSE)

			// SKILL ADJUSTMENT. This is temporary until it isn't.
			var/static/list/dreamwboon = list("STRENGTH", "SPEED", "ENDURANCE", "CONSTITUTION", "INTELLIGENCE", "PERCEPTION", "FORTUNE",)
			var/boon_choice = tgui_input_list(player_client, "DIVINE LIGHT SEVERED", "ETERNAL NIGHTMARE", dreamwboon)
			switch(boon_choice)
				if("STRENGTH")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_STRENGTH = 1)
				if("SPEED")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_SPEED = 1)
				if("ENDURANCE")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_ENDURANCE = 1)
				if("CONSTITUTION")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_CONSTITUTION = 1)
				if("INTELLIGENCE")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_INTELLIGENCE = 1)
				if("PERCEPTION")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_PERCEPTION = 1)
				if("FORTUNE")
					user.adjust_stat_modifier(STATMOD_DREAMWEAVER, STAT_FORTUNE = 1)
			return TRUE
		else
			to_chat(user, span_warning("[H] I have no idea how you triggered this message but good job. Something's probably broken!"))
			return FALSE


	// Visual effects

	new /obj/effect/temp_visual/curse(get_turf(user), "#0a43dd")
	new /obj/effect/temp_visual/curse(get_turf(user), "#0a43dd")
	new /obj/effect/temp_visual/curse(get_turf(user), "#0a43dd")

	return TRUE
