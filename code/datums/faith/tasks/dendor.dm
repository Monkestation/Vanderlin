
/datum/devotion_task/dendor_harvest
	name = "Reap the Bounty"
	desc = "Harvest crops blessed by Dendor"
	devotion_reward = 2
	progression_reward = 2
	cooldown_time = 0 SECONDS
	signal_type = COMSIG_PLANT_HARVESTED

/datum/devotion_task/dendor_harvest/can_complete(mob/living/carbon/human/user)
	. = ..()
	if(prob(30))
		return TRUE
	return FALSE

/datum/devotion_task/dendor_tend
	name = "Tend to Life"
	desc = "Care for growing plants"
	devotion_reward = 1
	progression_reward = 1
	cooldown_time = 0 SECONDS
	signal_type = COMSIG_PLANT_TENDED

/datum/devotion_task/dendor_tend/can_complete(mob/living/carbon/human/user)
	. = ..()
	if(prob(80))
		return TRUE
	return FALSE

/datum/devotion_task/dendor_bless
	name = "Provide Dendor's Blessing"
	desc = "Spread dendors word to plants"
	devotion_reward = 25
	progression_reward = 12
	cooldown_time = 25 SECONDS
	signal_type = COMSIG_SOIL_BLESSED
