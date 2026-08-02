/mob/living/carbon/proc/toggle_speech_mod(modifier_type)
	for(var/datum/speech_modifier/speech_modifier in speech_modifiers)
		if(istype(speech_modifier, modifier_type))
			speech_modifier.remove_speech_modifier()
			qdel(speech_modifier)
			return
	var/datum/speech_modifier/speech = new modifier_type()
	speech.add_speech_modifier(src)

/mob/living/carbon/proc/add_speech_modifier(modifier_type)
	for(var/datum/speech_modifier/speech_modifier as anything in speech_modifiers)
		if(istype(speech_modifier, modifier_type))
			return
	var/datum/speech_modifier/speech = new modifier_type()
	speech.add_speech_modifier(src)

/mob/living/carbon/proc/remove_speech_modifier(modifier_type)
	for(var/datum/speech_modifier/speech_modifier as anything in speech_modifiers)
		if(istype(speech_modifier, modifier_type))
			speech_modifier.remove_speech_modifier()
			qdel(speech_modifier)

/datum/speech_modifier
	var/soundtext = ""
	var/mob/living/carbon/affected_mob = null

/datum/speech_modifier/Destroy()
	if(affected_mob)
		remove_speech_modifier()
	return ..()

/datum/speech_modifier/proc/handle_speech(datum/source, list/speech_args)
	return

/datum/speech_modifier/proc/after_add()
	if(affected_mob && soundtext)
		to_chat(affected_mob, "I start [soundtext].")

/datum/speech_modifier/proc/add_speech_modifier(mob/living/carbon/new_owner)
	affected_mob = new_owner
	LAZYADD(affected_mob.speech_modifiers, src)
	RegisterSignal(affected_mob, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	after_add()

/datum/speech_modifier/proc/before_remove()
	if(affected_mob && soundtext)
		to_chat(affected_mob, "I stop [soundtext].")

/datum/speech_modifier/proc/remove_speech_modifier()
	UnregisterSignal(affected_mob, COMSIG_MOB_SAY)
	LAZYREMOVE(affected_mob.speech_modifiers, src)
	affected_mob = null
