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
	return istype(cast_on, /obj/item/weapon/knife/dagger/steel/profane) || isobj(cast_on)

/datum/action/cooldown/spell/burial_rites/cast(obj/cast_on)
	. = ..()
	if(istype(cast_on, /obj/item/weapon/knife/dagger/steel/profane))
		var/obj/item/weapon/knife/dagger/steel/profane/profane = cast_on
		owner.adjust_triumphs(profane.release_profane_souls(owner)) // Every soul saved earns you a big fat triumph.
		return
	if(pacify_coffin(cast_on, owner))
		if(istype(cast_on, /obj/structure/closet/dirthole))
			var/obj/structure/closet/dirthole/grave = cast_on // from this point on we know it is a grave subtype
			if(grave.is_consecrated)
				to_chat(owner, span_warning("You cannot perform burial rites on something that already was consecrated!"))
				reset_spell_cooldown()
				return . | SPELL_CANCEL_CAST
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
		headstone.inscription = span_big("Here lies <span class 'bold'>[names[1]]</span>")
	else // Multiple names
		headstone.inscription = "<span class 'big'>Here lies <span class 'bold'>[names[1]]"
		for(var/i=2 to length(names)) // may not work, need to test and recall how to do forloop for string lists
			headstone.inscription += ", [names[i]]"
		headstone.inscription += "</span></span>"

	// SECTION 2: Custom Message (Optional)
	if(headstone.custom_message)
		headstone.inscription += span_italics("\n\
		[headstone.custom_message]")

	// SECTION 3: Final Words TODO


	return TRUE


/// Proc that searches a `obj/structure/closet/dirthole` and grabs all mobs/heads with unique names
/// Returns a list
/datum/action/cooldown/spell/burial_rites/proc/find_names(obj/structure/closet/dirthole/grave)
	var/list/names = list()
	for(var/mob/living/simple_animal/animal in grave.contents) // For those that bury their cabbits
		if(!(animal.name in names))
			names += animal.name
	for(var/mob/living/carbon/human/corpse in grave.contents)
		if(!(corpse.real_name in names))
			names += corpse.real_name
	for(var/obj/item/bodypart/head/head in grave.contents)
		if(!(head.real_name in names))
			names += head.real_name

	// We now check for any containers for bodies, we could technically refactor this to be done recursively, but for now will assume that the mob is within any container
	for(var/obj/structure/closet/container in grave.contents)
		for(var/mob/living/simple_animal/animal in grave.contents)
			if(!(animal.name in names))
				names += animal.name
		for(var/mob/living/carbon/human/corpse in grave.contents)
			if(!(corpse.real_name in names))
				names += corpse.real_name
		for(var/obj/item/bodypart/head/head in grave.contents)
			if(!(head.real_name in names))
				names += head.real_name

	return names
