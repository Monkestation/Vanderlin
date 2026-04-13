/obj/item/organ/vocal_cords //organs that are activated through speech with the :x/MODE_KEY_VOCALCORDS channel
	name = "vocal cords"
	icon_state = "vocal_cords"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_VOICE
	gender = PLURAL
	decay_factor = 0	//we don't want decaying vocal cords to somehow matter or appear on scanners since they don't do anything damaged
	healing_factor = 0
	var/list/spans = null

/obj/item/organ/vocal_cords/proc/can_speak_with() //if there is any limitation to speaking with these cords
	return TRUE

/obj/item/organ/vocal_cords/proc/speak_with(message) //do what the organ does
	return

/obj/item/organ/vocal_cords/proc/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)

/obj/item/organ/vocal_cords/harpy
	name = "harpy's song"
	icon_state = "harpysong"		//Pulsating heart energy thing.
	desc = "The blessed essence of harpysong. How did you get this... you monster!"
	actions_types = list(/datum/action/item_action/organ_action/use/harpy_sing)
	var/obj/item/instrument/vocals/harpy_vocals/vocals

/obj/item/organ/vocal_cords/harpy/Initialize()
	. = ..()
	vocals = new(src)  //okay, i think it'll be tied to the organ

/obj/item/organ/vocal_cords/harpy/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	M.adjust_skill_level(/datum/attribute/skill/misc/music, 10)

/obj/item/organ/vocal_cords/harpy/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(!QDELING(M))
		M.adjust_skill_level(/datum/attribute/skill/misc/music, -10)

/datum/action/item_action/organ_action/use/harpy_sing
	name = "Harpy's song"
	desc = "Project your voice through song."
	button_icon = 'icons/obj/surgery.dmi'
	button_icon_state = "harpysong"

/datum/action/item_action/organ_action/use/harpy_sing/do_effect(trigger_flags)
	. = ..()
	var/obj/item/organ/vocal_cords/harpy/vocal_cords = owner.getorganslot(ORGAN_SLOT_VOICE)
	if(!istype(vocal_cords) || !vocal_cords.vocals)
		return
	vocal_cords.vocals.attack_self(owner)

/datum/action/item_action/organ_action/use/harpy_sing/update_status_on_signal(datum/source)
	. = ..()
	var/obj/item/organ/vocal_cords/harpy/vocal_cords = owner.getorganslot(ORGAN_SLOT_VOICE)
	if(!istype(vocal_cords) || !vocal_cords.vocals)
		return
	if(owner.stat >= UNCONSCIOUS && vocal_cords.vocals.playing)
		vocal_cords.vocals.terminate_playing(owner)
