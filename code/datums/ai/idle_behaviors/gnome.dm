
/datum/idle_behavior/gnome_enhanced_idle
	///Chance that the mob random walks per second
	var/walk_chance = 25
	///Chance for playful behavior when happy
	var/play_chance = 10
	///Chance for emotion-based talking
	var/emotion_talk_chance = 15
	///Chance to check for death messages to deliver
	var/death_message_check_chance = 20
	///Chance to speak from emotion buffer
	var/emotion_buffer_speak_chance = 8

	var/cooldown = 20 SECONDS
	var/next_time = 0

/datum/idle_behavior/gnome_enhanced_idle/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome_pawn = controller.pawn
	if(!istype(gnome_pawn))
		return
	// Check for death messages to deliver (highest priority)
	if(prob(death_message_check_chance))
		check_for_death_messages(gnome_pawn)
		return // Only do one thing per cycle for death messages
	if(next_time > world.time)
		return
	if(controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]) // this means we are likely eating a corpse
		return
	if(controller.blackboard[BB_RESISTING]) //we are trying to resist
		return


	if(gnome_pawn.binded)
		return

	next_time = world.time + cooldown

	// Emotion-based talking
	if(prob(emotion_talk_chance))
		emotion_talk(gnome_pawn)

	// Playful actions when happy and idle
	var/datum/component/emotion_buffer/emotions = gnome_pawn.GetComponent(/datum/component/emotion_buffer)
	if(emotions && emotions.current_emotion == EMOTION_HAPPY && prob(play_chance))
		do_playful_action(gnome_pawn)
		return // Don't walk if we're playing

	// Sometimes speak from emotion buffer
	if(prob(emotion_buffer_speak_chance))
		SEND_SIGNAL(gnome_pawn, EMOTION_BUFFER_SPEAK_FROM_BUFFER)

	// Standard random walk behavior
	if(prob(walk_chance) && !HAS_TRAIT(gnome_pawn, TRAIT_IMMOBILIZED) && isturf(gnome_pawn.loc) && !gnome_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		var/turf/step_turf = get_step(gnome_pawn, move_dir)
		if(is_type_in_typecache(step_turf, GLOB.dangerous_turfs))
			return
		gnome_pawn.Move(step_turf, move_dir)

	if(prob(8))
		gnome_pawn.emote("idle")


/datum/idle_behavior/gnome_enhanced_idle/proc/do_playful_action(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	if(gnome.stat != CONSCIOUS)
		return

	var/list/play_actions = list()
	var/list/nearby_items = list()
	var/list/nearby_gnomes = list()

	// Find things to play with
	for(var/obj/item/I in range(2, gnome))
		if(I.anchored || I.w_class > WEIGHT_CLASS_NORMAL)
			continue
		nearby_items += I

	// Find other gnomes to play with
	for(var/mob/living/simple_animal/hostile/gnome_homunculus/G in range(3, gnome))
		if(G == gnome || G.stat != CONSCIOUS)
			continue
		nearby_gnomes += G

	// Build action list based on what's available
	if(length(nearby_gnomes))
		play_actions += "play_with_gnome"
	if(length(nearby_items))
		play_actions += "play_with_item"

	// Always available actions
	play_actions += list("silly_dance", "tumble", "hop_around", "make_faces")

	var/chosen_action = pick(play_actions)

	switch(chosen_action)
		if("play_with_gnome")
			var/mob/living/simple_animal/hostile/gnome_homunculus/friend = pick(nearby_gnomes)
			do_gnome_social_play(gnome, friend)
		if("play_with_item")
			var/obj/item/toy = pick(nearby_items)
			do_item_play(gnome, toy)
		if("silly_dance")
			do_silly_dance(gnome)
		if("tumble")
			do_tumble(gnome)
		if("hop_around")
			do_hop_around(gnome)
		if("make_faces")
			do_make_faces(gnome)

/datum/idle_behavior/gnome_enhanced_idle/proc/do_gnome_social_play(mob/living/simple_animal/hostile/gnome_homunculus/gnome, mob/living/simple_animal/hostile/gnome_homunculus/friend)
	if(!friend || friend.stat != CONSCIOUS)
		return

	var/list/social_plays = list(
		"chase" = list("*chases [friend] playfully*", "*giggles while running*"),
		"peek_a_boo" = list("*hides behind something*", "*pops out* Peek-a-boo!"),
		"copy_cat" = list("*tries to copy [friend]'s movements*", "*mimics [friend] silly-like*"),
		"tag" = list("*taps [friend]* Tag! You're it!", "*runs away giggling*")
	)

	var/play_type = pick(social_plays)
	var/list/actions = social_plays[play_type]

	gnome.say(pick(actions))

	// Give both gnomes a happiness boost
	SEND_SIGNAL(gnome, COMSIG_EMOTION_STORE, friend, EMOTION_FUNNY, "played with me!", 2)
	SEND_SIGNAL(friend, COMSIG_EMOTION_STORE, gnome, EMOTION_FUNNY, "played with me!", 2)

	// Sometimes the other gnome responds
	if(prob(60))
		addtimer(CALLBACK(friend, TYPE_PROC_REF(/atom/movable, say), pick("*giggles*", "Fun!", "*plays back*", "*happy chirp*")), rand(1, 3) SECONDS)

/datum/idle_behavior/gnome_enhanced_idle/proc/do_item_play(mob/living/simple_animal/hostile/gnome_homunculus/gnome, obj/item/toy)
	if(!toy || QDELETED(toy))
		return

	var/list/item_plays = list(
		"*picks up [toy] and examines it curiously*",
		"*rolls [toy] around playfully*",
		"*hugs [toy] affectionately*",
		"*makes [toy] dance*",
		"*tosses [toy] in the air and catches it*"
	)

	gnome.face_atom(toy)
	gnome.say(pick(item_plays))

	// Sometimes move the item around
	if(prob(40) && !toy.anchored)
		var/turf/nearby = get_step(gnome, pick(GLOB.cardinals))
		if(nearby && nearby.density == FALSE)
			toy.forceMove(nearby)

/datum/idle_behavior/gnome_enhanced_idle/proc/do_silly_dance(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	gnome.say(pick("*does a little jig*", "*spins around happily*", "*dances to unheard music*", "*wiggles about cheerfully*"))
	SEND_SIGNAL(gnome, COMSIG_EMOTION_STORE, null, EMOTION_HAPPY, "danced!", 1)

/datum/idle_behavior/gnome_enhanced_idle/proc/do_tumble(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	gnome.say(pick("*tumbles forward*", "*does a somersault*", "*rolls around*", "*flops dramatically*"))

/datum/idle_behavior/gnome_enhanced_idle/proc/do_hop_around(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	gnome.say(pick("*hops excitedly*", "*bounces up and down*", "*springs about*", "*does happy little jumps*"))

	// Actually move around a bit
	if(prob(70))
		var/turf/target = get_step(gnome, pick(GLOB.cardinals))
		if(target && target.density == FALSE)
			gnome.Move(target)

/datum/idle_behavior/gnome_enhanced_idle/proc/do_make_faces(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	gnome.say(pick("*makes silly faces*", "*sticks tongue out*", "*crosses eyes comically*", "*puffs out cheeks*"))

// Enhanced emotion-based talking
/datum/idle_behavior/gnome_enhanced_idle/proc/emotion_talk(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	var/datum/component/emotion_buffer/emotions = gnome.GetComponent(/datum/component/emotion_buffer)
	if(!emotions)
		return

	var/current_emotion = emotions.current_emotion
	var/list/emotion_phrases = list()

	switch(current_emotion)
		if(EMOTION_HAPPY)
			emotion_phrases = list(
				"*chirps happily*", "Good day!", "Everything nice!",
				"*hums contentedly*", "Friends good!",
				"*does little skip*", "Happy gnome!"
			)
			if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/daytime))
				emotion_phrases |= "Sun Shiny!"

		if(EMOTION_SAD)
			emotion_phrases = list(
				"*sniffles*", "Why sad?", "*whimpers*",
				"Miss friends...", "*looks gloomy*", "No good...",
				"*sighs deeply*", "Gnome sad..."
			)
		if(EMOTION_ANGER)
			emotion_phrases = list(
				"*grumbles*", "No fair!", "*stamps foot*",
				"Grr!", "*scowls*", "Mean things!",
				"*crosses arms*", "Not happy!"
			)
		if(EMOTION_FUNNY)
			emotion_phrases = list(
				"*giggles*", "Hee hee!", "*snickers*",
				"Funny funny!", "*laughs*", "So silly!",
				"*chuckles*", "Make gnome laugh!"
			)
		if(EMOTION_SCARED)
			emotion_phrases = list(
				"*trembles*", "Scary!", "*hides*",
				"No like!", "*whimpers fearfully*", "Go away!",
				"*cowers*", "Gnome scared!"
			)
		if(EMOTION_SUPRISED)
			emotion_phrases = list(
				"Oh!", "*gasps*", "What that?!",
				"*eyes widen*", "Surprise!", "Didn't expect!",
				"*jumps*", "Woah!"
			)
		if(EMOTION_HUNGRY)
			emotion_phrases = list(
				"*stomach rumbles*", "Need food!", "So hungry...",
				"*looks for food*", "Gnome empty!", "Where food?",
				"*sniffs around*", "Eat soon?"
			)

	if(length(emotion_phrases))
		gnome.say(pick(emotion_phrases))

// Death message checking
/datum/idle_behavior/gnome_enhanced_idle/proc/check_for_death_messages(mob/living/simple_animal/hostile/gnome_homunculus/gnome)
	if(!length(gnome.pending_death_messages))
		return

	// Look for friends of dead gnomes nearby
	for(var/dead_gnome_name in gnome.pending_death_messages)
		var/list/message_data = gnome.pending_death_messages[dead_gnome_name]
		var/message = message_data["message"]
		var/list/friends_to_tell = message_data["friends"]

		for(var/mob/living/potential_friend in range(3, gnome))
			if(potential_friend == gnome || potential_friend.stat != CONSCIOUS)
				continue

			// Check if this mob was a friend of the dead gnome
			if(!(potential_friend in friends_to_tell))
				continue

			// Check if we already delivered this message to this person
			var/message_key = "[dead_gnome_name]_[message]"
			if(!gnome.delivered_death_messages[message_key])
				gnome.delivered_death_messages[message_key] = list()

			if(potential_friend in gnome.delivered_death_messages[message_key])
				continue

			// Deliver the message!
			deliver_death_message(gnome, potential_friend, dead_gnome_name, message)
			gnome.delivered_death_messages[message_key] += potential_friend

			// Remove from pending if we've told all friends
			var/all_told = TRUE
			for(var/mob/living/friend in friends_to_tell)
				if(!(friend in gnome.delivered_death_messages[message_key]))
					all_told = FALSE
					break

			if(all_told)
				gnome.pending_death_messages -= dead_gnome_name

			return // Only deliver one message at a time

/datum/idle_behavior/gnome_enhanced_idle/proc/deliver_death_message(mob/living/simple_animal/hostile/gnome_homunculus/gnome, mob/living/friend, dead_gnome_name, message)
	gnome.face_atom(friend)
	gnome.say("[friend], [dead_gnome_name] wanted you know... [dead_gnome_name] [message].")

	addtimer(CALLBACK(src, PROC_REF(give_comfort_hug), gnome, friend), 2 SECONDS)

	// Both get emotional responses
	SEND_SIGNAL(gnome, COMSIG_EMOTION_STORE, friend, EMOTION_SAD, "told about [dead_gnome_name]", 2)
	SEND_SIGNAL(friend, COMSIG_EMOTION_STORE, gnome, EMOTION_SAD, "heard about [dead_gnome_name]", 1)

/datum/idle_behavior/gnome_enhanced_idle/proc/give_comfort_hug(mob/living/simple_animal/hostile/gnome_homunculus/gnome, mob/living/friend)
	if(QDELETED(friend) || get_dist(gnome, friend) > 1)
		return

	gnome.say("*gives [friend] gentle hug*")
	friend.visible_message(span_notice("[gnome] gives [friend] a comforting hug."))

	// Hugs make both parties feel a bit better
	SEND_SIGNAL(gnome, COMSIG_EMOTION_STORE, friend, EMOTION_HAPPY, "hugged me for comfort", 3)
	if(ismob(friend))
		SEND_SIGNAL(friend, COMSIG_EMOTION_STORE, gnome, EMOTION_HAPPY, "gave comfort hug", 3)
