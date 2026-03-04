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

/datum/component/hideous_face/proc/on_examine(mob/living/carbon/human/source, mob/living/carbon/human/user, list/examine_list, list/P)
	if(!is_human_part_visible(source, HIDEFACE))
		return
	if(source != user && user.affects_masquerade())
		LAZYADDASSOCLIST(., EXAMINE_SECT_FACE, html_tag("h2", span_boldannounce("[uppertext(P[THEIR])] FACE! WHAT'S WRONG WITH [uppertext(P[THEIR])] FACE?!")))
	else
		LAZYADDASSOCLIST(., EXAMINE_SECT_FACE, span_boldannounce("[capitalize(P[THEIR])] face is hideous."))
	seen_callback?.Invoke(source, user)

