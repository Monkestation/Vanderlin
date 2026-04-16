#define LIST_FINAL_WORDS list("Goodbye!", "Finally, peace...", "I wonder if I can find Ravox...", "The Undermaiden calls for me...", "Hopefully next time is better...")

/datum/action/cooldown/spell/burial_rites
	name = "Burial Rites"
	desc = ""
	button_icon_state = "consecrateburial"
	sound = 'sound/magic/churn.ogg'
	has_visual_effects = FALSE

	cast_range = 1
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/necra)

	invocation = "Undermaiden grant thee passage forth and spare the trials of the forgotten."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 2 SECONDS //DEBUG ONLY, CHANGE BEFORE PR!!!!!
	spell_cost = 0 //DEBUG ONLY, CHANGE BEFORE PR!!!!!

/datum/action/cooldown/spell/burial_rites/is_valid_target(atom/cast_on)
	if(istype(cast_on, /obj/item/weapon/knife/dagger/steel/profane))
		return TRUE
	else if(istype(cast_on, /obj/structure/closet/dirthole))
		var/obj/structure/closet/dirthole/grave = cast_on
		if(grave.is_consecrated) // No double dipping
			to_chat(owner, span_warning("You cannot perform burial rites on something that already was consecrated!"))
			return FALSE
		else
			return TRUE

/datum/action/cooldown/spell/burial_rites/cast(obj/cast_on)
	. = ..()
	if(istype(cast_on, /obj/item/weapon/knife/dagger/steel/profane))
		var/obj/item/weapon/knife/dagger/steel/profane/profane = cast_on
		owner.adjust_triumphs(profane.release_profane_souls(owner)) // Every soul saved earns you a big fat triumph.
		return
	if(pacify_coffin(cast_on, owner))
		if(istype(cast_on, /obj/structure/closet/dirthole))
			var/obj/structure/closet/dirthole/grave = cast_on // from this point on we know it is a grave subtype
			if(grave.headstone) //Inscriptions!
				if(!generate_inscription(grave, grave.headstone))
					grave.headstone.inscription = null //Reset inscription
					reset_spell_cooldown()
					return . | SPELL_CANCEL_CAST
			if(!grave.is_consecrated)
				grave.is_consecrated = TRUE
				SEND_SIGNAL(owner, COMSIG_GRAVE_CONSECRATED, cast_on)
				record_round_statistic(STATS_GRAVES_CONSECRATED)
				if(grave.gravequality >= 1 && grave.gravequality <= 4)
					cast_on.add_overlay("graveconsecrated")
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on]."))
				else if(grave.gravequality >= 5)
					cast_on.icon_state = "gravedoubleconsecrated"
					owner.visible_message(span_rose("The air gets colder as [owner] consecrates [cast_on], woe betide any graverobber."), span_rose("Necra's gaze turns over to [cast_on] as I consecrate it. Any who would rob this grave will pay a dire toll."))
				else //Your grave fucking sucks vro.
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_warning("My funeral rites have been performed on [cast_on], though they don't seem to be particularly effective..."))
			return
		to_chat(owner, span_warning("I failed to perform the rites."))

/// Proc that generates what we are going to set `inscription` in the `headstone` of the `grave` with.
/datum/action/cooldown/spell/burial_rites/proc/generate_inscription(obj/structure/closet/dirthole/grave, obj/item/gravedecor/headstone/headstone)
	// Inscriptions have three sections
	// SECTION 1: Here Lies X
	var/list/names = find_names(grave)
	if(!names)
		// Something has gone terribly wrong if this happens.
		return FALSE
	else if(length(names) == 1) // One name, easy!
		headstone.inscription = "<span class='big'>Here lies </span><span class='big bold'>[names[1]]</span>"
	else // Multiple names
		headstone.inscription = "<span class='big'>Here lies </span><span class='big bold'>[names[1]]"
		for(var/i=2 to length(names)) // may not work, need to test and recall how to do forloop for string lists
			headstone.inscription += ", [names[i]]"
		headstone.inscription += "</span>"

	// SECTION 2: Custom Message (Optional)
	if(headstone.custom_message)
		headstone.inscription += span_italics("\n\n\
		[headstone.custom_message]")

	// SECTION 3: Final Words
	// We have the names of the mobs we buried, now we grab the mobs themselves and prepare a list of final_words
	var/list/their_final_words = list()

	to_chat(owner, span_warning("Energy flows into \the [grave] from my hands, I must stand by \the [grave] or risk failing the rites..."))
	for(var/name in names) //We need them in order
		var/found = FALSE
		for(var/mob/mob in GLOB.mob_list)
			if(found)
				break
			if(ishuman(mob))
				var/mob/living/carbon/human/human = mob
				if(human.real_name == name)
					//Check if final_words set (already moved on)
					if(human.final_words)
						their_final_words += human.final_words
					//Find their observer if it exists, if no words given, we make one up
					var/my_final_words
					// Find the observer
					for(var/mob/dead/observer/Ghost in GLOB.player_list)
						if(!Ghost.mind || QDELETED(Ghost.mind.current))
							continue
						else if(ishuman(Ghost.mind.current))
							if((!Ghost.mind.current == human))
								continue
							else
								my_final_words = tgui_input_text(Ghost, "You feel your body being put to rest, any final words? Leave blank for a random one. (DO NOT USE THIS TO STATE WHO ATTACKED YOU)", "(OPTIONAL) Final Words", pick(LIST_FINAL_WORDS), 50, timeout = 20 SECONDS)
								log_say("[Ghost] put [my_final_words] for their final words.")
								human.final_words = my_final_words // They won't be prompted again
								their_final_words += my_final_words
								break
					if(!my_final_words) //No Observers, pick a random one
						their_final_words += pick(LIST_FINAL_WORDS)

					found = TRUE
					break
			else if(isanimal(mob))
				if(mob.name == name)
					var/mob/living/simple_animal/animal
					if(animal.speak)
						their_final_words[name] = pick(animal.speak)
					found = TRUE

		// Final words acquired, display them once we verified the caster did not move
		if(!(owner.Adjacent(grave))) // Caster left the area, rite FAILED
			to_chat(owner, span_warning("I feel the energy around \the [grave] dissipate, I need to stand by \the [grave] and try again..."))
			return FALSE

		for(var/final_words in their_final_words)
			headstone.inscription += SPAN_GOD_NECRA("\n[final_words]")

		grave.say(pick(their_final_words)) //pick a random final words to say

	return TRUE


/// Proc that searches a `obj/structure/closet/dirthole` and grabs all mobs/heads with unique names
/// Returns a list
/datum/action/cooldown/spell/burial_rites/proc/find_names(obj/structure/closet/dirthole/grave)
	var/list/names = list()
	for(var/mob/living/carbon/human/corpse in grave.contents)
		if(!(corpse.real_name in names))
			names += corpse.real_name
	for(var/obj/item/bodypart/head/head in grave.contents)
		if(!(head.real_name in names))
			names += head.real_name
	for(var/mob/living/simple_animal/animal in grave.contents) // For those that bury their cabbits
		if(!(animal.name in names))
			names += animal.name

	// We now check for any containers for bodies, we could technically refactor this to be done recursively, but for now will assume that the mob is within any container
	for(var/obj/structure/closet/container in grave.contents)
		for(var/mob/living/carbon/human/corpse in container.contents)
			if(!(corpse.real_name in names))
				names += corpse.real_name
		for(var/obj/item/bodypart/head/head in container.contents)
			if(!(head.real_name in names))
				names += head.real_name
		for(var/mob/living/simple_animal/animal in container.contents)
			if(!(animal.name in names))
				names += animal.name

	return names

#undef LIST_FINAL_WORDS
