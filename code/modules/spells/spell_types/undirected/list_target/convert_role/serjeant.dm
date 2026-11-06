/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant
	name = "Promote Serjeant"
	desc = "Promote someone to your trusted serjeant."
	button_icon_state = "recruit_guard"

	new_role = "Serjeant-At-Arms"
	recruitment_faction = "Garrison"
	recruitment_message = "I'd promote you to Serjeant-At-Arms, %RECRUIT."
	accept_message = "I shall take on this responsibility!"
	refuse_message = "I refuse it."

/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.honorary = "Serjeant"
	cast_on.honorary_suffix = null
	cast_on.apply_status_effect(/datum/status_effect/buff/promoted_serjeant)
	var/mob/living/living_owner = owner
	living_owner.remove_spell(src)

/datum/status_effect/buff/promoted_serjeant
	id = "promoted_serjeant"
	alert_type = /atom/movable/screen/alert/status_effect/buff/promoted_serjeant
	effectedstats = list(STAT_ENDURANCE = 1, STAT_PERCEPTION = 1)

/atom/movable/screen/alert/status_effect/buff/promoted_serjeant
	name = "Serjeant"
	desc = span_nicegreen("I've been promoted!")
