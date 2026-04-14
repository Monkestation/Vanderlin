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
			if(!grave.is_consecrated)
				grave.is_consecrated = TRUE
				SEND_SIGNAL(owner, COMSIG_GRAVE_CONSECRATED, cast_on)
				record_round_statistic(STATS_GRAVES_CONSECRATED)
				if(grave.gravequality >= 1 && grave.gravequality <= 4)
					cast_on.add_overlay("graveconsecrated")ZZ
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on]."))
				else if(grave.gravequality >= 5)
					cast_on.icon_state = "gravedoubleconsecrated"
					owner.visible_message(span_rose("The air gets colder as [owner] consecrates [cast_on], woe betide any graverobber."), span_rose("Necra's gaze turns over to [cast_on] as I consecrate it. Any who would rob this grave will pay a dire toll."))
				else //Your grave fucking sucks vro.
					owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on], though they don't seem to be particularly effective."))
			return
		to_chat(owner, span_warning("I failed to perform the rites."))

/datum/action/cooldown/spell/burial_rites/proc/find_names(obj/cast_on)
	var/list/names = list()
	for(var/mob/living/carbon/human/corpse in grave)
		names +=,
		grave_names += [corpse.realname]
		grave.associated_name = "Here lies: [grave_names]"
	for(var/obj/item/bodypart/head/head in coffin)
		if(!head.brainmob)
			continue
		if(pacify_corpse(head.brainmob, user))
			success = TRUE
	for(var/atom/movable/stuffing in coffin)
			if(isliving(stuffing) || istype(stuffing, /obj/item/bodypart/head))
				continue
			if(pacify_coffin(stuffing, user, deep))
				success = TRUE
