/datum/component/hideous_face
	var/datum/callback/seen_callback


/datum/component/hideous_face/Initialize(datum/callback/_seen_callback)
	. = ..()
	if(!_seen_callback)
		return COMPONENT_INCOMPATIBLE
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	seen_callback = _seen_callback

/datum/component/hideous_face/Destroy(force)
	seen_callback = null
	. = ..()

/datum/component/hideous_face/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/hideous_face/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE))

/datum/component/hideous_face/proc/on_examine(mob/living/carbon/human/source, mob/living/carbon/human/user, list/examine_list)
	if(!is_human_part_visible(source, HIDEFACE))
		return
	if(user.affects_masquerade())
		var/all_caps_pronoun = uppertext(source.p_their())
		examine_list += span_phobia("[all_caps_pronoun] FACE! WHAT'S WRONG WITH [all_caps_pronoun] FACE?!")
	else
		examine_list += span_boldred("[source.p_their(TRUE)] face is hideous.")
	seen_callback?.Invoke(source, user)

