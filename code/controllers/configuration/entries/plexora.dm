/datum/config_entry/flag/plexora_enabled

/datum/config_entry/string/plexora_url
	default = "http://127.0.0.1:1330"

/datum/config_entry/string/plexora_url/ValidateAndSet(str_val)
	if(!findtext(str_val, GLOB.is_http_protocol))
		return FALSE
	return ..()

// The current server ID as defined in the plexora config
/datum/config_entry/string/plexora_server_id
