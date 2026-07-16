/datum/relation
	abstract_type = /datum/relation

	/// Display name shown in UI.
	var/name = "Relation"
	/// Flavour description shown to the holder.
	var/desc = ""
	/// List of /datum/history attached to this relation.
	var/list/relation_history = null
	/// The mind that owns this relation entry.
	var/datum/mind/holder
	/// The mind on the other side.
	var/datum/mind/other
	/// For asymmetric relations, the counterpart datum on other's side.
	var/datum/relation/counterpart = null
	/// Whether this relation is symmetric (both sides share mutual awareness).
	var/symmetric = TRUE
	/// Relation types that cannot coexist with this one on the same pair.
	var/list/incompatible = null
	/// Snapshot of identity data at time of relation creation.
	/// Keys: "name", "vcolor", "job", "gender", "age"
	var/list/snapshot = null
	/// Relation types this one supersedes, adding this relation will remove those.
	var/list/upgrades = null
	/// Category string used for UI tab sorting. e.g. "Rival", "Other"
	var/category = "Known"

/// Called when this relation is first established. Override to do setup.
/datum/relation/proc/on_created()
	return

/// Returns TRUE if this relation type should replace an existing one (upgrade path).
/datum/relation/proc/upgrades_relation(datum/relation/other_rel)
	if(!upgrades || !other_rel)
		return FALSE
	return (other_rel.type in upgrades)

/// Returns a sentence describing the relationship from an outside perspective.
/datum/relation/proc/get_desc_string()
	SHOULD_CALL_PARENT(FALSE)
	return "[holder?.name] and [other?.name] have a relationship."

/// Capture current identity state of the other mob into snapshot.
/datum/relation/proc/refresh_snapshot()
	if(!other?.current || !ishuman(other.current))
		return
	var/mob/living/carbon/human/H = other.current
	snapshot = list(
		"name" = H.real_name,
		"vcolor" = H.voice_color,
		"job" = _get_job_title(H),
		"gender" = H.gender,
		"age" = H.age,
	)

/datum/relation/proc/_get_job_title(mob/living/carbon/human/H)
	if(H.mind?.assigned_role)
		var/datum/job/J = H.mind?.assigned_role
		if(J)
			var/t = J.get_informed_title(H)
			if(t)
				return t
	return "Unknown"

/// Returns TRUE if this relation conflicts with an existing relation type.
/datum/relation/proc/conflicts_with(datum/relation/other_rel)
	if(!incompatible || !other_rel)
		return FALSE
	return (other_rel.type in incompatible)

/// Dissolve this relation from both minds and nullify counterpart links.
/datum/relation/proc/dissolve()
	if(holder)
		holder.relations -= src
	if(symmetric && other)
		// find and remove the mirrored datum on other's side
		for(var/datum/relation/R in other.relations)
			if(R.other == holder && R.type == type)
				other.relations -= R
				break
	if(counterpart)
		counterpart.counterpart = null
		counterpart.dissolve()
		counterpart = null

///this adds a piece of history to a users history list and returns it
/datum/relation/proc/add_history(datum/history/history)
	LAZYADD(relation_history, history)
	return history

/datum/relation/proc/snapshot_name_only(mob/living/carbon/human/H)
	snapshot = list(
		"name" = H.real_name,
		"vcolor" = null,
		"job" = null,
		"gender" = null,
		"age" = null,
	)

/// Enrich an existing partial snapshot with full identity data.
/datum/relation/proc/enrich_snapshot()
	if(!other?.current || !ishuman(other.current))
		return
	var/mob/living/carbon/human/H = other.current
	snapshot["name"] = H.real_name
	snapshot["vcolor"] = H.voice_color
	snapshot["job"] = _get_job_title(H)
	snapshot["gender"] = H.gender
	snapshot["age"] = H.age
