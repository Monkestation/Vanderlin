/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant
	name = "Promote Serjeant"
	desc = "Promote someone to your trusted serjeant."
	button_icon_state = "recruit_guard"

	new_role = "Serjeant-at-Arms"
	recruitment_faction = "Garrison"
	recruitment_message = "You are promoted to the rank of Serjeant, %RECRUIT."
	give_choice = FALSE
	accept_message = null
	refuse_message = null

/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant/can_convert(mob/living/carbon/human/cast_on)
	. = ..()
	if(!.)
		return
	var/datum/job/J = SSjob.GetJobType(cast_on.job_type)
	if(!(is_type_in_list(J, /datum/job/men_at_arms, /datum/job/advclass/menatarms) || is_type_in_list(J?.parent_job, /datum/job/men_at_arms, /datum/job/advclass/menatarms)))
		return
	return TRUE

/datum/action/cooldown/spell/undirected/list_target/convert_role/serjeant/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/buff/promoted_serjeant)
	var/mob/living/living_owner = owner
	living_owner.remove_spell(src)

/datum/status_effect/buff/promoted_serjeant
	id = "promoted_serjeant"
	alert_type = /atom/movable/screen/alert/status_effect/buff/promoted_serjeant
	effectedstats = list(STATKEY_END = 1, STATKEY_PER = 1)

/atom/movable/screen/alert/status_effect/buff/promoted_serjeant
	name = "Serjeant"
	desc = span_nicegreen("I've been promoted!")
