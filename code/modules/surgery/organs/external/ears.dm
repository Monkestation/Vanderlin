/obj/item/organ/ears
	name = "ears"
	icon_state = "ear"
	desc = ""
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_EARS
	slot = ORGAN_SLOT_EARS
	organ_efficiency = list(ORGAN_SLOT_EARS = 50)
	gender = PLURAL
	side = RIGHT_SIDE
	sellprice = DEFAULT_ORGAN_VALUE/2

	pain_multiplier = 0.35 / 2
	organ_volume = 0.25
	max_blood_storage = 2.5
	current_blood = 2.5
	blood_req = 0.25
	oxygen_req = 0.5
	nutriment_req = 0.15
	hydration_req = 0.15

	low_threshold_passed = span_info("My ears begin to resonate with an internal ring sometimes.")
	now_failing = span_warning("I am unable to hear at all!")
	now_fixed = span_info("Noise slowly begins filling my ears once more.")
	low_threshold_cleared = span_info("The ringing in my ears has died down.")

	/// temporary deafness, measured in seconds. While > 0, the person is unable to hear anything.
	var/temporary_deafness = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	/// Resistance against loud noises
	var/bang_protect = EAR_PROTECTION_NONE
	/// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

	var/static/sound/ringing = sound('sound/flash_ring.ogg', FALSE, 0, CHANNEL_EAR_RING, 75)

/obj/item/organ/ears/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	for(var/datum/wound/facial/ears/ear_wound in M.get_wounds())
		qdel(ear_wound)
	if(temporary_deafness)
		on_deafened()

/obj/item/organ/ears/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(temporary_deafness)
		on_undeafened(M)

/obj/item/organ/ears/on_life(delta_time, times_fired)
	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here.
	// Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return
	// no healing if failing
	if(is_failing())
		return
	if(temporary_deafness)
		adjust_temporary_deafness(-delta_time SECONDS)

///Adjust the temporary deafness of the person, up or down
/obj/item/organ/ears/proc/adjust_temporary_deafness(amount)
	// organ failure makes us permanently deafened. Also, doesn't do anything if not in someone or during godmode
	if(amount > 0 && owner && (owner.status_flags & GODMODE))
		return

	temporary_deafness = max(temporary_deafness + amount * damage_multiplier, 0)

	if(!owner)
		return

	if(temporary_deafness && !HAS_TRAIT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		on_deafened()
	else if(!temporary_deafness && HAS_TRAIT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		on_undeafened()

///Called when temporary deafness begins
/obj/item/organ/ears/proc/on_deafened()
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(adjust_speech))
	ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)
	SEND_SOUND(owner, ringing)

///Called when temporary deafness reaches zero. Has to have an 'organ_owner' arg, because by the time it's called on 'on_mob_remove', owner is already null
/obj/item/organ/ears/proc/on_undeafened(mob/living/organ_owner = owner)
	REMOVE_TRAIT(organ_owner, TRAIT_DEAF, EAR_DAMAGE)
	UnregisterSignal(organ_owner, COMSIG_MOB_SAY)

/// Being deafened by loud noises makes you shout
/obj/item/organ/ears/proc/adjust_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return

	var/message = speech_args[SPEECH_MESSAGE]
	// Replace only end-of-sentence punctuation with exclamation marks (hence the empty space)
	// We don't wanna mess with things like ellipses
	message = replacetext(message, ". ", "! ")
	message = replacetext(message, "? ", "?! ")
	// Special case for the last character
	switch(copytext_char(message, -1))
		if(".")
			if(copytext_char(message, -2) != "..") // Once again ignoring ellipses, let people trail off
				message = copytext_char(message, 1, -1) + "!"
		if("?")
			message = copytext_char(message, 1, -1) + "?!"
		if("!")
			pass()
		else
			message += "!"

	speech_args[SPEECH_MESSAGE] = message
	return COMPONENT_UPPERCASE_SPEECH

/obj/item/organ/ears/invincible
	damage_multiplier = 0

/obj/item/organ/ears/cat
	name = "cat ears"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	damage_multiplier = 2

/obj/item/organ/ears/elf
	name = "elf ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elf

/obj/item/organ/ears/elfw
	name = "wood elf ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elfw

/obj/item/organ/ears/halforc
	name = "halforc ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elf

/obj/item/organ/ears/tiefling
	name = "tiefling ears"
	icon_state = "ear_pointed"
	use_mob_sprite_as_obj_sprite = FALSE
	accessory_type = /datum/sprite_accessory/ears/elfw

/obj/item/organ/ears/anthro
	name = "wild-kin ears"

/obj/item/organ/ears/rakshari
	name = "rakshari ears"

/obj/item/organ/ears/rakshari/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	ADD_TRAIT(M, TRAIT_KEENEARS, "[type]")

/obj/item/organ/ears/rakshari/Remove(mob/living/carbon/human/H,  special = 0)
	. = ..()
	REMOVE_TRAIT(H, TRAIT_KEENEARS, "[type]")
