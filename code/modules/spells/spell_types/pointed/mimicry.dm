/datum/action/cooldown/spell/mimicry
	name = "Mimicry"
	desc = "Take on the appearance of your target."
	button_icon_state = "invisibility"
	sound = 'sound/misc/stings/generic.ogg'
	self_cast_possible = FALSE
	attunements = list(
		/datum/attunement/dark = 0.4,
		/datum/attunement/polymorph = 1.2,
	)

	charge_time = 4 SECONDS
	charge_drain = 1
	cooldown_time = 5 MINUTES
	spell_cost = 20

	var/datum/weakref/old_dna_ref
	var/old_hair
	var/old_hair_color
	var/old_eye_color
	var/old_facial_hair
	var/old_facial_hair_color
	var/old_gender

	var/transformed = FALSE

/datum/action/cooldown/spell/mimicry/Destroy()
	old_dna_ref = null
	return ..()

/datum/action/cooldown/spell/mimicry/Grant(mob/grant_to)
	. = ..()
	if(!ishuman(owner))
		qdel(src)
		return
	var/mob/living/carbon/human/user = owner
	var/datum/bodypart_feature/hair/hair = user.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/facial = user.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	old_dna_ref = WEAKREF(user.dna)
	old_hair = hair?.accessory_type
	old_hair_color = user.get_hair_color()
	old_eye_color = user.get_eye_color()
	old_facial_hair_color = user.get_facial_hair_color()
	old_facial_hair = facial?.accessory_type
	old_gender = user.gender

/datum/action/cooldown/spell/mimicry/Remove(mob/living/carbon/human/remove_from)
	. = ..()
	set_old_appearance(remove_from)

/datum/action/cooldown/spell/mimicry/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/mimicry/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(transformed)
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
	cast_on.dna.transfer_identity(user) // don't take prints
	user.updateappearance(mutcolor_update = TRUE)
	user.real_name = cast_on.dna.real_name
	user.name = cast_on.get_visible_name()
	user.gender = cast_on.gender

	var/datum/bodypart_feature/hair/cast_on_feature = cast_on.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/cast_on_facial = cast_on.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)

	var/picked = FALSE
	if(prob(40))
		var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
		eyes.eye_color = cast_on.get_eye_color()
	else
		picked = TRUE

	if(prob(70) && !picked)
		user.set_hair_color(cast_on.get_hair_color(), FALSE)
	else
		picked = TRUE

	if(prob(70) && !picked)
		user.set_hair_style(cast_on_feature?.accessory_type, FALSE)
	else
		picked = TRUE

	if(prob(70) && !picked)
		user.set_facial_hair_color(cast_on.get_facial_hair_color(), FALSE)
	else
		picked = TRUE

	if(prob(70) && !picked)
		user.set_facial_hair_style(cast_on_facial?.accessory_type, FALSE)
	else
		picked = TRUE

	user.updateappearance(mutcolor_update = TRUE)

/datum/action/cooldown/spell/mimicry/proc/return_to_normal(mob/living/carbon/human/user)
	user.visible_message(
		"[user]'s skin starts to shift.",
		"I begin to shift back to normal.",
	)
	user.Immobilize(4 SECONDS)
	if(!do_after(user, 10 SECONDS, user))
		return
	set_old_appearance(user)

/datum/action/cooldown/spell/mimicry/proc/set_old_appearance(mob/living/carbon/human/user)
	if(!transformed)
		return
	var/datum/dna/old_dna = old_dna_ref.resolve()
	if(old_dna)
		old_dna.transfer_identity(user)
		user.real_name = old_dna.real_name
	user.name = user.get_visible_name()
	user.gender = old_gender
	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	eyes.eye_color = old_eye_color
	user.set_facial_hair_color(old_facial_hair_color, FALSE)
	user.set_facial_hair_style(old_facial_hair, FALSE)
	user.set_hair_color(old_hair_color, FALSE)
	user.set_hair_style(old_hair, FALSE)

	user.updateappearance(mutcolor_update = TRUE)


