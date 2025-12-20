/datum/action/cooldown/spell/extract_heart
	name = "Heart Extraction"
	desc = "An unholy rite to claim hearts as a tribute to Graggar. Only works on fresh corpses."
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_NO_MOVE
	button_icon_state = "curse"
	sound = 'sound/surgery/organ1.ogg'
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	cast_range = 1
	charge_required = FALSE

	/// Base time, reduced by butchery skill
	var/extraction_time = 15 SECONDS

/datum/action/cooldown/spell/extract_heart/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/extract_heart/cast(mob/living/carbon/human/cast_on)
	. = ..()

	if(cast_on.stat != DEAD)
		to_chat(owner, span_warning("The weakling still pulses with life! Graggar demands you finish them off first!"))
		return

	// Calculate actual time based on butchery skill
	var/skill_modifier = 1 - (owner.get_skill_level(/datum/skill/labor/butchering) * 0.1) // 10% reduction per skill level
	var/actual_time = max(extraction_time * skill_modifier, 7.5 SECONDS) // Minimum 7.5 seconds

	owner.visible_message(span_warning("[owner] reaches for [cast_on]'s chest, chanting incoherently..."), \
						span_notice("You begin the ritual extraction of [cast_on]'s heart."))

	if(!do_after(owner, actual_time, cast_on))
		to_chat(owner, span_warning("The profane ritual was interrupted! SHAME!"))
		return

	if(cast_on.stat != DEAD)
		to_chat(owner, span_warning("The weakling still pulses with life! Graggar demands you finish them off first!"))
		return

	var/obj/item/organ/heart/heart = cast_on.getorganslot(ORGAN_SLOT_HEART)
	if(!heart)
		to_chat(owner, span_warning("Only a hollow chest remains!"))
		return

	heart.Remove(cast_on)
	heart.forceMove(cast_on.drop_location())
	owner.put_in_hands(heart)

	cast_on.add_splatter_floor()
	cast_on.adjustBruteLoss(20)

	owner.visible_message(span_warning("[owner] rips [cast_on]'s heart out with a roar!"), \
						span_red("You present the heart to Graggar! The God chuckles upon this offering."))
	owner.emote("rage", forced = TRUE)
