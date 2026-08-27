#define APPRENTICE_SPLITTER "--- APPRENTICES ---"

/datum/attribute_holder/sheet/job/blood_student
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
	)
	clamped_adjustment = list(
		/datum/attribute/skill/magic/blood = list(10, 10),
	)

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic
	name = "Blood Apprenticeship"
	desc = "Teach a student how to wield Blood Magic.<br>This forms a powerful bond between Apprentice and Tutor, \
	should you have cause to revoke that bond their connection to Blood Magic will be forever severed.\
	<br><br>You cannot apprentice a servant of the gods, nor any who already wield the power of Vitae."
	button_icon_state = "dream_summon"
	sound = 'sound/magic/PSY.ogg'

	required_form = null

	cooldown_time = 25 SECONDS
	spell_cost = 0
	spell_type = SPELL_BLOOD

	choose_target_message = "Choose who to teach."
	target_radius = 3
	spell_flags = SPELL_UNETCHABLE
	var/list/current_students = list()

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/New(Target)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO, PROC_REF(cryo_apprentice)) // cryo'd people can just get removed, qol.

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO)
	for(var/datum/weakref/reference in current_students)
		var/mob/living/carbon/human/apprentice = reference.resolve()
		UnregisterSignal(apprentice, COMSIG_BLOOD_ASCENSION)
		revoke_apprenticeship(apprentice, TRUE)
	. = ..()

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/get_list_targets(atom/center, target_radius = 7)
	var/list/things = list()
	if(target_radius)
		for(var/mob/living/carbon/human/nearby_human in oview(target_radius, center))
			if(nearby_human == owner)
				continue
			if(HAS_TRAIT(nearby_human, TRAIT_VITAE_USER) || HAS_TRAIT(nearby_human, TRAIT_BLOOD_MAGIC_BLOCKED) || HAS_TRAIT(nearby_human, TRAIT_BLOOD_STUDENT))
				continue
			if(nearby_human.cleric || nearby_human.stat)
				continue
			things += nearby_human
	if(length(current_students))
		things += APPRENTICE_SPLITTER
		for(var/datum/weakref/ref in current_students)
			var/mob/living/carbon/human/apprentice = ref.resolve()
			things += apprentice
	return things

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/PreActivate(atom/caster)
	var/list/list_targets = get_list_targets(caster, target_radius)
	if(!length(list_targets))
		caster.balloon_alert(caster, "no valid targets!")
		return FALSE

	var/atom/chosen = browser_input_list(caster, choose_target_message, name, list_targets)
	if(chosen == APPRENTICE_SPLITTER || QDELETED(src) || QDELETED(caster) || QDELETED(chosen) || !can_cast_spell())
		return FALSE

	if(get_dist(chosen, caster) > target_radius)
		caster.balloon_alert(caster, "too far!")
		return FALSE

	return Activate(chosen)

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/revoking = FALSE
	var/prompt_message = "Do you wish to offer apprenticeship to [cast_on]?"
	var/prompt_title = "Grant Power"

	if(HAS_TRAIT_FROM(cast_on, TRAIT_BLOOD_STUDENT, owner))
		revoking = TRUE
		prompt_message = "Do you wish to revoke the apprenticeship of [cast_on]?"
		prompt_title = "Revoke Power"

	if(tgui_alert(owner, prompt_message, prompt_title, DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		to_chat(owner, span_notice("You decide not to [LOWER_TEXT(prompt_title)]."))
		return

	if(revoking)
		revoke_apprenticeship(cast_on)
		return

	if(cast_on.cmode)
		to_chat(owner, span_warning("You cannot offer apprenticeship whilst your potential apprentice is in combat."))
		return
	offer_apprenticeship(cast_on)



/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/proc/offer_apprenticeship(mob/living/carbon/human/apprentice)
	if(tgui_alert(apprentice, "You have been offered an Apprenticeship in Blood Magic, do you accept?", "Seek Power", DEFAULT_INPUT_CONFIRMATIONS) != CHOICE_CONFIRM)
		to_chat(owner, span_warning("[apprentice.real_name] has refused your offer of apprenticeship!"))
		return FALSE
	to_chat(owner, span_warning("[apprentice.real_name] has accepted your offer of apprenticeship!"))
	to_chat(apprentice, span_warning("You have accepted an apprenticeship in Blood Magic under [owner.real_name]!"))
	current_students |= WEAKREF(apprentice)
	RegisterSignal(apprentice, COMSIG_BLOOD_ASCENSION, PROC_REF(unlink_apprentice), apprentice, TRUE)
	ADD_TRAIT(apprentice, TRAIT_BLOOD_STUDENT, REF(owner))

	to_chat(apprentice, span_bloody("Your tutor will teach you the ways of Blood Magic and its limitations.\
	<br>Heed them well for if your apprenticeship is revoked you will be marked, never able wield Blood Magic again.\
	<br>It may be possible for you to break the chains of your apprenticeship with sufficient work and strength..."))

	apprentice.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_student)

	apprentice.add_spell(/datum/action/cooldown/spell/status/blood_sight, mastery_spell = TRUE)
	apprentice.add_spell(/datum/action/cooldown/spell/projectile/blood_steal, mastery_spell = TRUE)
	apprentice.adjust_form_mastery_points(3, specific_form = FORM_BLOOD)
	apprentice.adjust_technique_mastery_points(2)

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/proc/revoke_apprenticeship(mob/living/carbon/human/apprentice, death = FALSE)
	current_students -= apprentice.weak_reference
	UnregisterSignal(apprentice, COMSIG_BLOOD_ASCENSION)
	REMOVE_TRAIT(apprentice, TRAIT_BLOOD_STUDENT, REF(owner))
	if(death)
		to_chat(apprentice, span_userdanger("The connection to my Tutor has shattered! I've lost my connection to Blood Magic!"))
		return TRUE
	to_chat(apprentice, span_userdanger("My tutor has revoked my access to Blood Magic!"))
	to_chat(owner, span_warning("I revoke my apprentice's access to Blood Magic."))
	ADD_TRAIT(apprentice, TRAIT_BLOOD_MAGIC_BLOCKED, REF(owner))
	return TRUE

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/proc/unlink_apprentice(datum/source, mob/living/carbon/human/apprentice, ascension = FALSE)
	SIGNAL_HANDLER
	current_students -= apprentice.weak_reference
	UnregisterSignal(apprentice, COMSIG_BLOOD_ASCENSION)
	if(ascension)
		to_chat(owner, span_userdanger("My apprentice, [apprentice.real_name], has become too powerful to remain under my tutelage!"))
		return
	to_chat(owner, span_userdanger("My apprentice, [apprentice.real_name], has departed for distant lands."))

/datum/action/cooldown/spell/undirected/list_target/teach_blood_magic/proc/cryo_apprentice(datum/source, mob/living/carbon/human/apprentice)
	SIGNAL_HANDLER
	if(apprentice.weak_reference in current_students)
		unlink_apprentice(apprentice)
	return

#undef APPRENTICE_SPLITTER
