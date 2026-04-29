
/datum/devotion_task/malum_craft
	name = "Forge Divine Works"
	desc = "Craft items to honor Malum"
	devotion_reward = 3
	progression_reward = 2
	cooldown_time = 15 SECONDS
	signal_type = COMSIG_ITEM_CRAFTED

/datum/devotion_task/malum_craft/on_complete(mob/living/carbon/human/user, list/signal_args)
	. = ..()
	if(.)
		user.visible_message(
			span_notice("[user] completes their work with devoted precision."),
			span_notice("My labor honors Malum.")
		)

/datum/devotion_task/malum_smelt
	name = "Smelt with Purpose"
	desc = "Smelt ore into refined materials"
	devotion_reward = 2
	progression_reward = 1
	cooldown_time = 10 SECONDS
	signal_type = COMSIG_ITEM_SMELTED

/datum/devotion_task/malum_forge
	name = "Work the Forge"
	desc = "Forge weapons and tools"
	devotion_reward = 4
	progression_reward = 3
	cooldown_time = 20 SECONDS
	signal_type = COMSIG_ITEM_FORGED
