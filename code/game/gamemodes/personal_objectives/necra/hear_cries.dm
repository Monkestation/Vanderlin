/datum/objective/personal/listen_whispers
	name = "Listen to Dead's Whispers"
	category = "Necra's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained a temporary ability to listen to the cries of the dead")
	rewards = list("2 Triumphs", "Necra grows stronger", "Death and suffering won't disturb you")
	var/time_required = 3 MINUTES
	var/time_spent = 0
	var/last_check = 0
	var/check_interval = 10 SECONDS
	var/area/church_area = /area/indoors/town/church
	var/list/heard_messages = list()

/datum/objective/personal/listen_whispers/on_creation()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	update_explanation_text()

/datum/objective/personal/listen_whispers/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/objective/personal/listen_whispers/process()
	if(world.time < last_check + check_interval || completed || !owner?.current)
		return

	last_check = world.time
	check_location()

/datum/objective/personal/listen_whispers/proc/check_location()
	var/mob/living/user = owner.current
	if(!istype(user) || user.stat == DEAD)
		return

	if(!istype(get_area(user), church_area))
		return

	var/amulet_found = FALSE
	for(var/obj/item/clothing/neck/current_item in user.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/psycross/silver/necra))
			amulet_found = TRUE

	if(!amulet_found)
		return

	time_spent += check_interval

	if(prob(25) && length(GLOB.last_words))
		var/message = pick(GLOB.last_words - heard_messages)
		to_chat(user, span_red("[message]"))
		heard_messages += message
		if(prob(50))
			user.playsound_local(user, 'sound/effects/ghost.ogg', 75)

	if(time_spent >= time_required && !completed)
		complete_objective()

/datum/objective/personal/listen_whispers/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have listened to the whispers of the dead long enough to satisfy Necra!"))
	adjust_storyteller_influence(NECRA, 20)
	STOP_PROCESSING(SSprocessing, src)

/datum/objective/personal/listen_whispers/reward_owner()
	. = ..()
	ADD_TRAIT(owner.current, TRAIT_STEELHEARTED, OBJECTIVE_TRAIT)

/datum/objective/personal/listen_whispers/update_explanation_text()
	explanation_text = "Necra wants you to understand death better. Spend at least [time_required / (1 MINUTES)] minutes in the church listening to the whispers of the dead while wearing an amulet of Necra."
