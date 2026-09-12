/datum/action/cooldown/spell/mimicry
	name = "Mimicry"
	desc = "Take on the appearance of your target."
	button_icon_state = "invisibility"
	sound = 'sound/misc/stings/generic.ogg'
	self_cast_possible = FALSE

	required_technique = TECHNIQUE_ILLUSION
	required_form = FORM_ARCANE

	charge_time = 4 SECONDS
	charge_drain = 1
	cooldown_time = 5 MINUTES
	spell_cost = 20

/datum/action/cooldown/spell/mimicry/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/user = owner
	if(user.GetComponent(/datum/component/disguise))
		return TRUE
	return ishuman(cast_on)

/datum/action/cooldown/spell/mimicry/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(user.GetComponent(/datum/component/disguise))
		return_to_normal(user)
		return
	try_transform(cast_on, user)

/datum/action/cooldown/spell/mimicry/proc/try_transform(mob/living/carbon/human/cast_on, mob/living/carbon/human/user)
	user.visible_message(
		"[user]'s skin starts to shift.",
		"I begin to shift into [cast_on].",
	)
	if(!do_after(user, 10 SECONDS, user))
		return
	user.AddComponent(/datum/component/disguise, cast_on)

/datum/action/cooldown/spell/mimicry/proc/return_to_normal(mob/living/carbon/human/user)
	user.visible_message(
		"[user]'s skin starts to shift.",
		"I begin to shift back to normal.",
	)
	user.Immobilize(4 SECONDS)
	if(!do_after(user, 10 SECONDS, user))
		return
	qdel(user.GetComponent(/datum/component/disguise))
