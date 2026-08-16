/**
 * ### Conjure Item
 *
 * Create a single item, attaching [/datum/component/conjured_item]
 */
/datum/action/cooldown/spell/undirected/conjure_item
	invocation_type = INVOCATION_NONE
	charge_required = FALSE

	/// List of weakrefs to items summoned
	var/list/datum/weakref/item_refs
	/// If TRUE, we delete any previously created items when we cast the spell
	var/delete_old = TRUE

	/// Typepath of whatever item we summon
	var/obj/item/item_type

	/// Duration of the summon
	var/item_duration = 5 MINUTES

	// [/datum/component/conjured_item] interfacing
	// Only added when duration is not null
	var/uses_component = TRUE
	/// How many times this can have its duration refreshed, -1 for infinite
	var/refresh_count = -1
	/// Skill threshold required to refresh, 0 for none
	var/skill_threshold = SKILL_LEVEL_NONE
	/// Outline to add as a filter
	var/item_outline

/datum/action/cooldown/spell/undirected/conjure_item/Destroy()
	// If we delete_old, clean up all of our items on delete
	if(delete_old)
		QDEL_LAZYLIST(item_refs)

	// If we don't delete_old, just let all the items be free
	else
		LAZYNULL(item_refs)

	return ..()

/datum/action/cooldown/spell/undirected/conjure_item/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/undirected/conjure_item/cast(mob/living/carbon/cast_on)
	if(delete_old && LAZYLEN(item_refs))
		QDEL_LAZYLIST(item_refs)

	var/obj/item/existing_item = cast_on.get_active_held_item()
	if(existing_item)
		cast_on.dropItemToGround(existing_item)

	var/obj/item/created = make_item()
	if(QDELETED(created))
		CRASH("[type] tried to create an item, but failed. It's item type is [item_type].")

	cast_on.put_in_hands(created, del_on_fail = TRUE)
	return ..()

/// Instantiates the item we're conjuring and returns it.
/// Item is made in nullspace and moved out in cast().
/datum/action/cooldown/spell/undirected/conjure_item/proc/make_item()
	var/obj/item/made_item = new item_type()
	LAZYADD(item_refs, WEAKREF(made_item))
	if(item_duration)
		if(uses_component)
			made_item.AddComponent(\
				/datum/component/conjured_item,\
				item_duration,\
				refresh_count,\
				associated_skill,\
				skill_threshold,\
				item_outline\
			)
		else
			QDEL_IN(made_item, item_duration)
	if(item_outline && !uses_component)
		made_item.add_filter("conjure_outline", 3, drop_shadow_filter(size = 1, offset = 2, color = item_outline))
	return made_item
