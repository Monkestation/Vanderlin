/datum/action/cooldown/spell/adopt_child
	name = "Adopt Child"
	button_icon_state = "love"
	sound = null
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	cast_range = 1
	charge_required = FALSE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/adopt_child/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return

	if(!ishuman(owner))
		return FALSE

/datum/action/cooldown/spell/adopt_child/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/adopt_child/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.age != AGE_CHILD)
		to_chat(owner, span_warning("You can only adopt children!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(cast_on.family_datum && length(cast_on.family_member_datum?.parents))
		to_chat(owner, span_warning("This child is not an orphan!"))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/adopt_child/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/adopter = owner

	owner.visible_message(
		span_notice("[owner] begins a solemn adoption ritual."),
		span_notice("You begin the adoption ritual with Eora's blessing...")
	)

	if(!do_after(owner, 5 SECONDS, cast_on))
		to_chat(owner, span_warning("The ritual was interrupted!"))
		return FALSE

	var/choice = browser_alert(cast_on, "Do you wish to be adopted by [owner.real_name] and become part of their family?", "Adoption Offer", DEFAULT_INPUT_CHOICES)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return

	if(choice != CHOICE_YES)
		to_chat(owner, span_warning("[cast_on] has rejected your adoption offer!"))
		return FALSE

	var/datum/heritage/family = adopter.family_datum
	if(!family)
		family = new /datum/heritage(owner)
		SSfamilytree.families += family

	var/datum/family_member/parent_member = family.GetFamilyMember(owner)
	if(!parent_member)
		parent_member = family.CreateFamilyMember(owner)

	var/datum/family_member/child_member = family.CreateFamilyMember(cast_on)
	child_member.AddParent(parent_member)
	child_member.adoption_status = TRUE

	if(adopter.spouse_mob)
		var/datum/family_member/spouse_member = family.GetFamilyMember(adopter.spouse_mob)
		if(!spouse_member)
			spouse_member = family.CreateFamilyMember(adopter.spouse_mob)
		child_member.AddParent(spouse_member)

	to_chat(owner, span_love("You have adopted [cast_on.real_name] as your child with Eora's blessing!"))
	to_chat(cast_on, span_love("You have been adopted by [owner.real_name]!"))

	SEND_SIGNAL(owner, COMSIG_ORPHAN_ADOPTED, cast_on)
