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
		if(istype(cast_on, /obj/structure/closet)) // have to call this since the proc is not global
			var/obj/structure/closet/closet = cast_on // from this point on we know it is a closet subtype
			if(closet.check_double_consecration(cast_on, owner)) // Check if the thing we're casting the rites on is a grave with an already-consecrated casket.
				var/obj/structure/closet/dirthole/grave = cast_on // This should only ever get called on graves anyways.
				owner.visible_message(span_rose("The air gets colder as [owner] consecrates [cast_on], woe betide any graverobber."), span_rose("Necra's gaze turns over to [cast_on] as I consecrate it. Any who would rob this grave will pay a dire toll."))
				grave.is_consecrated += 2 // this is how we define a grave as "doubly consecrated"
				if(grave.necra_devotion_gain != DOUBLE_CONSECRATED_GAIN)
					grave.adjust_grave_necra_devotion(DOUBLE_CONSECRATED_GAIN)
				// If there was a body that was not double consecrated yet, reward TRIUMPH
				var/triumphs = grave.unique_body_double_consecrate()
				if(triumphs)
					owner.adjust_triumphs(triumphs, reason = "Pleased the Undermaiden")
			else
				owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on]."))
			if(istype(cast_on, /obj/structure/closet/dirthole)) // if it's a grave, increase it's level of consecration.
				var/obj/structure/closet/dirthole/grave = cast_on
				if(grave.is_consecrated == 0) // We do it this way to ensure the consecration stays at or becomes 1
					grave.adjust_grave_necra_devotion(CONSECRATED_GAIN)
					grave.is_consecrated += 1
				if(grave.is_consecrated < 1) // don't count graves as being consecrated multiple time for Necra
					SEND_SIGNAL(owner, COMSIG_GRAVE_CONSECRATED, cast_on)
					record_round_statistic(STATS_GRAVES_CONSECRATED)
				grave.update_appearance()
			return
		to_chat(owner, span_warning("I failed to perform the rites."))
