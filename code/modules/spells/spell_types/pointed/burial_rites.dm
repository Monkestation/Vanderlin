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
	cooldown_time = 10 SECONDS
	spell_cost = 15

/datum/action/cooldown/spell/burial_rites/is_valid_target(atom/cast_on)
	if(istype(cast_on, /obj/item/weapon/knife/dagger/steel/profane))
		return TRUE
	else if(!istype(cast_on, /obj/structure/closet/dirthole))
		return FALSE
	var/obj/structure/closet/dirthole/grave = cast_on
	if(grave.is_consecrated) // No double dipping
		to_chat(owner, span_warning("You cannot perform burial rites on something that already was consecrated!"))
		return FALSE
	var/has_dead = FALSE
	for(var/mob/mob in grave.get_all_contents())
		if(mob.mind?.has_antag_datum(/datum/antagonist/zombie)) // Zombies are granted peace (death)
			var/mob/living/carbon/human/zombie = mob // We grab it since we know that only humans can be zombies, and mobs dont have a death()....
			zombie.mind.remove_antag_datum(/datum/antagonist/zombie)
			zombie.death()

		if(mob.stat == DEAD)
			has_dead = TRUE
			break
	if(!has_dead)
		to_chat(owner, span_warning("You sense that there are no souls seeking rest in \the [grave]..."))
		return FALSE
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
				grave.update_appearance(UPDATE_ICON)
				if(grave.gravequality >= 0 && grave.gravequality <= 3)
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_warning("My funeral rites have been performed on [cast_on], though they don't seem to be particularly effective..."))
					owner.add_stress(/datum/stress_event/bad_grave) //Terrible grave.
				if(grave.gravequality >= 4 && grave.gravequality <= 6)
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on]."))
					grave.grow_lily()
				if(grave.gravequality >= 7 && grave.gravequality <= 9)
					owner.visible_message(span_rose("The air gets colder as [owner] consecrates [cast_on], woe betide any graverobber."), span_rose("Necra's gaze turns over to [cast_on] as I consecrate it. Any who would rob this grave will pay a dire toll."))
					grave.grow_lily()
				if(grave.gravequality == 10)
					owner.visible_message(span_rose("The air gets colder as [owner] consecrates [cast_on], woe betide any graverobber."), span_rose("Necra's gaze turns over to [cast_on] as I consecrate it. Any who would rob this grave will feel the Undermaiden's full wrath!"))
					grave.grow_lily()
			grave.adjust_grave_necra_devotion()
			grave.stasis()
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
		headstone.inscription = "<span class='big'>Here lies </span><span class='big bold'>[names.Join(", ")]</span>"

	// SECTION 2: Custom Message (Optional)
	if(headstone.custom_message)
		headstone.inscription += span_italics("<br><br>\
		[headstone.custom_message]")

	// SECTION 3: Final Words
	// We have the names of the mobs we buried, now we grab the mobs themselves and prepare a list of final_words
	var/list/their_final_words = list()
	var/list/premade_final_words = file2list("strings/grave_final_words.txt")
	for(var/mob/buried in grave.get_all_contents())
		if(ishuman(buried))
			var/mob/living/carbon/human/corpse = buried
			if(corpse.final_words) // Already have their final words, no need to find them to ask.
				their_final_words += corpse.final_words
				continue

			//Find their observer if it exists, if no words given, we make one up
			var/my_final_words
			// Find the observer
			if(corpse.last_mind?.current_ghost)
				var/mob/ghost = corpse.last_mind.current_ghost
				to_chat(owner, span_warning("Energy flows into \the [grave] from my hands, I must stand by \the [grave] or risk failing the rites..."))
				my_final_words = tgui_input_text(ghost, "You feel your body being put to rest, any final words? Leave blank for a random one. (DO NOT USE THIS TO STATE WHO ATTACKED YOU)", "(OPTIONAL) Final Words", pick(premade_final_words), 50, timeout = 20 SECONDS)
				if(my_final_words)
					log_say("[ghost] put [my_final_words] for their final words.")
					corpse.final_words = my_final_words // They won't be prompted again

			if(!my_final_words) //No Observers, pick a random one
				my_final_words = pick(premade_final_words)
				corpse.final_words = my_final_words

			their_final_words += my_final_words

		else if(isanimal(buried)) // For those that bury their cabbits
			var/mob/living/simple_animal/animal = buried
			if(animal.speak)
				their_final_words += pick(animal.speak)

	// Final words acquired, display them once we verified the caster did not move
	if(!(owner.Adjacent(grave))) // Caster left the area, rite FAILED
		to_chat(owner, span_warning("I feel the energy around \the [grave] dissipate, I need to stand by \the [grave] and try again..."))
		return FALSE

	for(var/final_words in their_final_words)
		headstone.inscription += SPAN_GOD_NECRA("<br>[final_words]")

	if(length(their_final_words))
		grave.say(pick(their_final_words)) //pick a random final words to say

	return TRUE


/// Proc that searches a `obj/structure/closet/dirthole` and grabs all mobs/heads with unique names
/// Returns a list
/datum/action/cooldown/spell/burial_rites/proc/find_names(obj/structure/closet/dirthole/grave)
	var/list/names = list()
	for(var/buried in grave.get_all_contents())
		if(ishuman(buried))
			var/mob/living/carbon/human/corpse = buried
			if(!(corpse.real_name in names))
				names += corpse.real_name
			continue
		else if(istype(buried, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/head = buried
			if(!(head.real_name in names))
				names += head.real_name
		else if(isanimal(buried)) // For those that bury their cabbits
			var/mob/living/simple_animal/animal = buried
			if(!(animal.name in names))
				names += animal.name

	return names
