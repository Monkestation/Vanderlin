
/datum/preference/bitwise/chat_toggles
	savefile_key = "chat_toggles"
	savefile_identifier = PREF_PLAYER
	category = "toggles"
	can_randomize = FALSE
	should_update_preview = FALSE
	default_value = TOGGLES_DEFAULT_CHAT
	max_value = (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT\
				|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTWHISPER\
				|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD)
