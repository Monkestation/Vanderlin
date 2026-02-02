// ===============================
// GNOME HOMUNCULUS MOB
// ===============================

/mob/living/simple_animal/hostile/gnome_homunculus
	name = "gnome homunculus"
	desc = "A small, industrious magical construct that resembles a tiny gnome. Its eyes glow with alchemical energy, and it seems eager to help with menial tasks."
	icon = 'icons/mob/gnome2.dmi' // You'll need appropriate sprites
	icon_state = "gnome"
	icon_living = "gnome"
	icon_dead = "gnome_dead"

	pass_flags = PASSMOB

	maxHealth = 50
	health = 50
	harm_intent_damage = 8
	obj_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 8
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	density = FALSE

	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"

	speed = 1
	move_to_delay = 3

	faction = list("neutral", "silicon", "homunculus")

	gold_core_spawnable = FRIENDLY_SPAWN

	ai_controller = /datum/ai_controller/basic_controller/gnome_homunculus

	var/list/waypoints = list()
	var/max_carry_size = WEIGHT_CLASS_NORMAL
	var/list/item_filters = list()

	var/hat_state

	var/static/list/pet_commands = list(
		/datum/pet_command/follow,
		/datum/pet_command/idle,
		/datum/pet_command/fetch,
		/datum/pet_command/gnome/search_range,

		/datum/pet_command/gnome/set_waypoint,
		/datum/pet_command/gnome/set_waypoint/b,

		/datum/pet_command/gnome/set_filter,
		/datum/pet_command/gnome/clear_filter,

		/datum/pet_command/gnome/use_splitter,
		/datum/pet_command/gnome/stop_splitter,

		/datum/pet_command/gnome/move_item,
		/datum/pet_command/gnome/stop_move_item,

		/datum/pet_command/gnome/tend_crops,
		/datum/pet_command/gnome/stop_tending,

		/datum/pet_command/gnome/select_recipe,
		/datum/pet_command/gnome/start_alchemy,
		/datum/pet_command/gnome/stop_alchemy,
	)

	var/list/gnome_friendship_levels = list(
		"enemy" = -50,
		"dislike" = -10,
		"neutral" = 0,
		"like" = 25,
		"friend" = 50,
		"best_friend" = 100
	)

	// Learned words from friends (stored as word = times_heard)
	var/list/learned_words = list()

	// Pending death messages to deliver (dying_gnome_name = list("message" = text, "friends" = list))
	var/list/pending_death_messages = list()

	// Track delivered death messages to avoid repeats (message_key = list(delivered_to))
	var/list/delivered_death_messages = list()


/mob/living/simple_animal/hostile/gnome_homunculus/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands
	AddComponent(/datum/component/emotion_buffer)
	AddComponent(/datum/component/friendship_container, gnome_friendship_levels, "friend", FALSE)
	AddComponent(/datum/component/scared_of_item, 5)
	AddComponent(/datum/component/hovering_information, /datum/hover_data/gnome_status)
	. = ..()

	setup_emotional_responses()

/mob/living/simple_animal/hostile/gnome_homunculus/update_overlays()
	. = ..()
	if(hat_state)
		. += mutable_appearance(icon, hat_state)

/mob/living/simple_animal/hostile/gnome_homunculus/proc/item_matches_filter(obj/item/target_item)
	if(!length(item_filters))
		return TRUE
	return (is_type_in_list(target_item, item_filters))


/mob/living/simple_animal/hostile/gnome_homunculus/proc/setup_emotional_responses()
	RegisterSignal(src, COMSIG_LIVING_BEFRIENDED, PROC_REF(on_befriended))
	RegisterSignal(src, COMSIG_LIVING_UNFRIENDED, PROC_REF(on_unfriended))
	RegisterSignal(src, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attacked))
	RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(on_death))


/mob/living/simple_animal/hostile/gnome_homunculus/proc/on_befriended(datum/source, mob/living/new_friend)
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, new_friend, EMOTION_HAPPY, "is new friend", 5)
	// Gnomes get excited when they make friends
	say(pick("*chirps happily*", "*does a little dance*", "Friend! Friend!"))

/mob/living/simple_animal/hostile/gnome_homunculus/proc/on_unfriended(datum/source, mob/living/former_friend)
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, former_friend, EMOTION_SAD, "is no longer friend...", -5)
	say(pick("*whimpers sadly*", "*looks dejected*", "Why friend leave?"))

/mob/living/simple_animal/hostile/gnome_homunculus/proc/on_attacked(datum/source, obj/item/weapon, mob/living/attacker)
	if(!attacker)
		return

	// Check if this is a friend attacking us - extra sad!
	var/friendship_check = SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHECK_LEVEL, attacker, "friend")
	if(friendship_check)
		SEND_SIGNAL(src, COMSIG_EMOTION_STORE, attacker, EMOTION_SAD, "hurt me!", -10)
		say(pick("Why hurt friend?!", "*cries*", "Friend... why?"))
	else
		SEND_SIGNAL(src, COMSIG_EMOTION_STORE, attacker, EMOTION_ANGER, "attacked me with [weapon]!", -3)
		say(pick("*growls angrily*", "Ow! Mean!", "*hisses*"))

/mob/living/simple_animal/hostile/gnome_homunculus/proc/on_death(datum/source)
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, null, EMOTION_SCARED, "is dying!", 0)

	// Collect friends before dying - PROPERLY using befriended_refs
	var/list/my_friends = list()
	var/datum/component/friendship_container/friendships = GetComponent(/datum/component/friendship_container)
	if(friendships)
		// Get friends from the befriended_refs list
		for(var/datum/weakref/friend_ref in friendships.befriended_refs)
			if(QDELETED(friend_ref))
				continue
			var/mob/living/friend_mob = friend_ref.resolve()
			if(friend_mob && !QDELETED(friend_mob))
				my_friends += friend_mob

	// Create death message for nearby gnomes to remember
	var/death_message = pick(
		"loved all friends very much",\
		"said friends were best thing ever",\
		"always happy when with friends",\
		"thought friends were wonderful",\
		"wanted friends to be happy always",\
	)

	// Tell nearby gnomes about our death message
	for(var/mob/living/simple_animal/hostile/gnome_homunculus/nearby_gnome in range(10, src))
		if(nearby_gnome == src || nearby_gnome.stat != CONSCIOUS)
			continue

		// Store this death message for later delivery
		nearby_gnome.pending_death_messages[name] = list(
			"message" = death_message,
			"friends" = my_friends.Copy()
		)

		// The witnessing gnome becomes sad
		SEND_SIGNAL(nearby_gnome, COMSIG_EMOTION_STORE, src, EMOTION_SAD, "saw friend [name] die...", -3)
		nearby_gnome.say(pick("*cries for [name]*", "[name] no!", "*whimpers sadly*"))

	say(pick("*death rattle*", "Tell friends... gnome loved...", "*wheezes*", "Friends... remember gnome..."))

/mob/living/simple_animal/hostile/gnome_homunculus/proc/hat()
	hat_state = pick("spike_helm", "fungi_helm", "fungi_helm_bog", "gnome_helm", null)
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/gnome_homunculus/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type)
	. = ..()
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, throwingdatum?.thrower, EMOTION_SCARED, "[throwingdatum.thrower] throw thing at me!", 0)

/mob/living/simple_animal/hostile/gnome_homunculus/attackby(obj/item/item, mob/living/user, list/modifiers)
	// Check what kind of item interaction this is
	if(istype(item, /obj/item/reagent_containers/food))
		handle_food_gift(item, user)
		return
	if(istype(item, /obj/item/grown/log)) //idk man we don't got toys
		handle_toy_interaction(item, user)
		return

	return ..()

/mob/living/simple_animal/hostile/gnome_homunculus/proc/handle_food_gift(obj/item/reagent_containers/food/food_item, mob/living/giver)
	SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHANGE, giver, 5)
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, giver, EMOTION_HAPPY, "gave me delicious [food_item]!", 3)

	say(pick("Food!", "Yum!", "Good!", "*happy chirp*"))

	qdel(food_item)
	adjustBruteLoss(-5)

/mob/living/simple_animal/hostile/gnome_homunculus/proc/handle_toy_interaction(obj/item/toy/toy_item, mob/living/player)
	SEND_SIGNAL(src, COMSIG_FRIENDSHIP_CHANGE, player, 2)
	SEND_SIGNAL(src, COMSIG_EMOTION_STORE, player, EMOTION_FUNNY, "played with me using [toy_item]!", 2)

	say(pick("*giggle*", "Fun!", "*bounce*", "Play!"))

