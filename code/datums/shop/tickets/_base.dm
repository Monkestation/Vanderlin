
/datum/ticket
	/// Unique ID, generated at grant time, never reused
	var/ticket_id
	/// Human-readable name shown in UI
	var/name
	/// Longer description shown in trade / use panels
	var/description
	/// Metadata
	var/granted_by
	var/granted_at
	var/grant_reason

	/// Must match a TICKET_TYPE_* constant.
	/// Subtypes should override this with a fixed value.
	var/ticket_type = TICKET_TYPE_UNKNOWN

// Serialise to an assoc-list that is stored in the savefile
// and sent verbatim to the UI. Subtypes call ..() then add
// their own payload keys so the shape stays compatible.
/datum/ticket/proc/to_list()
	return list(
		"ticket_id" = ticket_id,
		"ticket_type" = ticket_type,
		"name" = name,
		"description" = description,
		"loadout_item_path" = null,
		"special_trait_path"= null,
		"job_boost_job" = null,
		// metadata
		"granted_by" = granted_by,
		"granted_at" = granted_at,
		"grant_reason" = grant_reason,
	)

///this is a string of details we pass back for history purposes
/datum/ticket/proc/details()
	return

// Reconstruct from a savefile assoc-list.
// The manager calls the right subtype constructor before calling
// this, so subtypes only need to ..() and then pull their keys.
/datum/ticket/proc/from_list(list/L)
	ticket_id = L["ticket_id"]
	ticket_type = L["ticket_type"]
	name = L["name"]
	description = L["description"]
	granted_by = L["granted_by"]
	granted_at = L["granted_at"]
	grant_reason= L["grant_reason"]

// Attempt to use this ticket for the given client.
// Returns TRUE on success, FALSE on failure (with a to_chat message).
// Subtypes implement the actual effect.
/datum/ticket/proc/use(client/user)
	return FALSE

// Enrich a ui_data ticket list-entry with sprite/display info.
// Subtypes that have associated assets override this.
/datum/ticket/proc/enrich_ui_entry(list/entry)
	// Subtypes override to fill these four keys.
	// The UI renders exactly these and nothing else.
	entry["ui_icon"] = null // icon file, or null for font-awesome fallback
	entry["ui_icon_state"] = null
	entry["ui_fa_icon"] = "ticket-alt" // font-awesome name
	entry["ui_color"] = "#9e9e9e" // hex accent colour
	entry["ui_type_label"] = "Ticket" // short badge text
	entry["ui_grant_summary"] = name // one-line "what this does" string
