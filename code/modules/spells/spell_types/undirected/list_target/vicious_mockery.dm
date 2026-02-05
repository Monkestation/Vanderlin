/datum/action/cooldown/spell/vicious_mockery
	name = "Vicious Mockery"
	desc = "Make a fool of a target and enrage them."
	button_icon_state = "tragedy"
	sound = 'sound/magic/mockery.ogg'

	invocation_type = INVOCATION_SHOUT
	invocation = "Your mother was a hampster and your father smelt of elderberries!"

	spell_type = NONE
	associated_skill = /datum/skill/misc/music
	associated_stat = STATKEY_INT

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	has_visual_effects = FALSE

/datum/action/cooldown/spell/vicious_mockery/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/vicious_mockery/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/message

	if(owner.cmode && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.dna?.species)
			if(check_strings("bard.json", "[H.dna.species.id]_mockery"))
				message = pick_list_replacements("bard.json", "[H.dna.species.id]_mockery")
			else
				message = pick_list_replacements("bard.json", "default_mockery")
	else
		message = browser_input_text(owner, "How will I mock this fool?", "XYLIX")
		if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
			return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	invocation = message

/datum/action/cooldown/spell/vicious_mockery/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_hear())
		SEND_SIGNAL(owner, COMSIG_VICIOUSLY_MOCKED, cast_on)
		cast_on.apply_status_effect(/datum/status_effect/debuff/viciousmockery)
		record_round_statistic(STATS_PEOPLE_MOCKED)


/datum/status_effect/debuff/viciousmockery
	id = "viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/viciousmockery
	duration = 1 MINUTES
	effectedstats = list(STATKEY_PER = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/viciousmockery
	name = "Vicious Mockery"
	desc = "<span class='warning'>THAT SPOONY BARD! ARGH!</span>\n"
	icon_state = "muscles"
