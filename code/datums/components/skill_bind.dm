#define SKILL_BIND_GLOW_FILTER "skill_bind_glow"

/datum/component/skill_bind
	var/swapped_skill
	var/original_skill
	var/stored = FALSE
	var/datum/weakref/binder_ref
	var/glow_applied = FALSE

/datum/component/skill_bind/Initialize(skill, mob/binder)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(!skill)
		return COMPONENT_INCOMPATIBLE
	swapped_skill = skill
	if(binder)
		binder_ref = WEAKREF(binder)
	var/obj/item/I = parent
	original_skill = I.associated_skill
	stored = TRUE
	I.associated_skill = swapped_skill
	apply_glow(I)
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))

/datum/component/skill_bind/proc/apply_glow(obj/item/I)
	if(glow_applied || already_glows(I))
		return
	I.add_filter(SKILL_BIND_GLOW_FILTER, 2, drop_shadow_filter(0,0,1,2,GLOB.form_colors[FORM_ARCANE]))
	glow_applied = TRUE

/datum/component/skill_bind/proc/already_glows(obj/item/I)
	if(I.GetComponent(/datum/component/conjured_item))
		return TRUE
	for(var/filter_name in I.filter_data)
		var/list/params = I.filter_data[filter_name]
		if(params?["type"] == "outline" || params?["type"] == "drop_shadow")
			return TRUE
	return FALSE

/datum/component/skill_bind/proc/on_pickup(datum/source, mob/taker)
	SIGNAL_HANDLER
	var/mob/binder = binder_ref?.resolve()
	if(taker && taker == binder)
		return
	var/obj/item/I = parent
	if(istype(I))
		I.visible_message(span_warning("The arcyne bond on [I] flickers and dies as it changes hands."))
		if(taker)
			to_chat(taker, span_notice("[I] shudders in my grip as an arcyne bond sloughs off of it."))
	qdel(src)

/datum/component/skill_bind/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += "An arcyne bond guides this weapon; it answers to a conjurer's training."

/datum/component/skill_bind/Destroy()
	var/obj/item/I = parent
	if(istype(I))
		if(stored && I.associated_skill == swapped_skill)
			I.associated_skill = original_skill
		if(glow_applied)
			I.remove_filter(SKILL_BIND_GLOW_FILTER)
			glow_applied = FALSE
	UnregisterSignal(I, list(COMSIG_ATOM_EXAMINE, COMSIG_ITEM_PICKUP))
	return ..()

#undef SKILL_BIND_GLOW_FILTER
