
/datum/devotion_task/pestra_heal
	name = "Ease Suffering"
	desc = "Heal the sick and wounded"
	devotion_reward = 3
	progression_reward = 2
	cooldown_time = 20 SECONDS
	signal_type = COMSIG_LIVING_HEALED_OTHER

/datum/devotion_task/pestra_medicine
	name = "Apply Remedies"
	desc = "Administer medicine to those in need"
	devotion_reward = 2
	progression_reward = 2
	cooldown_time = 15 SECONDS
	signal_type = COMSIG_LIVING_MEDICINE_APPLIED
