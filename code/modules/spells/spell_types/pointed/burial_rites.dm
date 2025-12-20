/datum/action/cooldown/spell/burial_rites
	name = "Burial Rites"
	desc = ""
	button_icon_state = "consecrateburial"
	sound = 'sound/magic/churn.ogg'
	has_visual_effects = FALSE

	cast_range = 1
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/necra)

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
		cast_on.add_overlay("graveconsecrated")
		owner.visible_message(span_rose("[owner] consecrates [cast_on]."), span_rose("My funeral rites have been performed on [cast_on]."))
		SEND_SIGNAL(owner, COMSIG_GRAVE_CONSECRATED, cast_on)
		record_round_statistic(STATS_GRAVES_CONSECRATED)
		return
	to_chat(owner, span_warning("I failed to perform the rites."))
