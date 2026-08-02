/datum/action/cooldown/spell/undirected/list_target/convert_role/guard
	name = "Recruit Guardsmen"
	button_icon_state = "recruit_guard"

	new_role = "Garrison Recruit"
	recruitment_faction = "Garrison"
	recruitment_message = "Join the Garrison, %RECRUIT!"
	accept_message = "I swear fealty to the Crown and its garrison!"

/datum/action/cooldown/spell/undirected/list_target/convert_role/guard/on_conversion(mob/living/cast_on)
	. = ..()
	add_verb(cast_on, /mob/proc/haltyell)

/datum/action/cooldown/spell/undirected/list_target/convert_role/guard/forest
	name = "Recruit Forest Guard"

	new_role = "Forest Garrison Recruit"
	recruitment_faction = "Forest Garrison"
	recruitment_message = "Join the Forest Garrison, %RECRUIT!"
	accept_message = "I swear to protect the forest!"
