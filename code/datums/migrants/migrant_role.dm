/datum/migrant_role
	abstract_type = /datum/migrant_role
	/// Name of the role
	var/name = "MIGRANT ROLE"
	/// greet_text for the role
	var/greet_text = "You are a migrant"
	/// Reference to a job to apply to the migrant role, vars for this are used to determine if selectable.
	var/datum/job/migrant/migrant_job = /datum/job/migrant/generic
	/// Antagonist datum to apply with the migrant be mindful of the job if any.
	var/datum/antagonist/antag_datum

/// Migrant role for advclass rollers like pilgrim
/// Can be supplied a job if the advclass is split up
/datum/migrant_role/advclass
	abstract_type = /datum/migrant_role/advclass
	/// If defined they'll get adv class rolls
	var/list/advclass_cat_rolls
