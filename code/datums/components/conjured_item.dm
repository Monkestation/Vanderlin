/**
 * Component for adding a generic magical outline to a component, make it disappear if not held / worn
 * by an arcane user after a duration
 */
/datum/component/conjured_item
	/// Duration before we try to clean up
	var/duration
	/// How many times this can have its duration refreshed, -1 for infinite
	var/refresh_count
	/// Skill to determine if we can refresh
	var/refresh_skill
	/// Skill threshold required to refresh, 0 for none
	var/skill_threshold
	/// Outline to add as a filter
	var/outline_color
	/// Weakref to current user
	var/datum/weakref/current_user
	/// Timer id
	var/decay_timer

/datum/component/conjured_item/Initialize(
	duration = 5 MINUTES,
	refresh_count = 4,
	refresh_skill = /datum/skill/magic/arcane,
	skill_threshold = SKILL_LEVEL_JOURNEYMAN,
	outline_color = "#6495ED",
	current_user,
)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.duration = duration
	src.refresh_count = refresh_count
	src.refresh_skill = refresh_skill
	src.outline_color = outline_color
	if(current_user)
		src.current_user = WEAKREF(current_user)

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(clean_up))

	var/obj/item/I = parent
	if(outline_color)
		I.add_filter("conjured_drop", 3, drop_shadow_filter(size = 1, offset = 1, color = outline_color))
	I.smeltresult = null
	I.salvage_result = null

	decay_timer = addtimer(CALLBACK(src, PROC_REF(try_decay)), duration, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/conjured_item/Destroy(force)
	clean_up()
	return ..()

/datum/component/conjured_item/proc/try_decay()
	if(QDELETED(parent))
		clean_up(TRUE)
		return
	var/mob/holder = current_user?.resolve()
	if(QDELETED(holder))
		clean_up(TRUE)
		return
	if(refresh_count != -1 && refresh_count <= 0)
		clean_up(TRUE)
		return
	if(refresh_skill && !holder.has_skill(refresh_skill))
		clean_up(TRUE)
		return
	if(skill_threshold && holder.get_skill_level(refresh_skill) < skill_threshold)
		clean_up(TRUE)
		return

	refresh_count--

	to_chat(holder, span_nicegreen("A faint glow emanates from \the [parent], its enchantment is renewed!"))

	decay_timer = addtimer(CALLBACK(src, PROC_REF(try_decay)), duration, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/conjured_item/proc/clean_up(delete = FALSE)
	current_user = null
	deltimer(decay_timer)
	decay_timer = null
	if(!QDELETED(parent))
		if(isatom(parent))
			var/atom/thing = parent
			thing.visible_message(span_warning("\The [thing] begins to crumble, the enchantment falls!"))
		QDEL_IN(parent, 3 SECONDS)
	if(delete)
		qdel(src)

/datum/component/conjured_item/proc/on_equip(datum/source, mob/user, slot)
	current_user = WEAKREF(user)

/datum/component/conjured_item/proc/on_drop(datum/source, mob/user, slot)
	current_user = null

/datum/component/conjured_item/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += "This item crackles with faint arcane energy. It seems to be conjured."
	examine_list += "It will last for [timeleft(decay_timer) / 10] more seconds."
