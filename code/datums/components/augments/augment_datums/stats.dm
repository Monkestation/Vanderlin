/datum/augment/stats
	var/list/stat_changes = list() // List of stat changes: list(STATKEY_STR = 1, STATKEY_SPD = -1)

/datum/augment/stats/on_install(mob/living/carbon/human/H)
	for(var/stat in stat_changes)
		H.change_stat(stat, stat_changes[stat])

/datum/augment/stats/on_remove(mob/living/carbon/human/H)
	for(var/stat in stat_changes)
		H.change_stat(stat, -stat_changes[stat])

/datum/augment/stats/get_examine_info()
	var/list/info = list()
	info += span_info("Stat changes:")
	for(var/stat in stat_changes)
		var/change = stat_changes[stat]
		info += span_info("  [stat]: [change > 0 ? "+" : ""][change]")
	return info

/datum/augment/stats/strength_servo
	name = "hydraulic strength servo"
	desc = "Enhances physical power through pressurized hydraulics, at the cost of core stability."
	stability_cost = -15
	stat_changes = list(STATKEY_STR = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/perception_lens
	name = "enhanced optical array"
	desc = "Improves visual acuity and target acquisition."
	stability_cost = -10
	stat_changes = list(STATKEY_PER = 2)
	engineering_difficulty = SKILL_LEVEL_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/stats/processing_core
	name = "overclocked logic engine"
	desc = "Increases processing speed and analytical capability, straining the core matrix."
	stability_cost = -20
	stat_changes = list(STATKEY_INT = 3)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

/datum/augment/stats/reinforced_frame
	name = "reinforced skeletal frame"
	desc = "Strengthens the automaton's frame against damage."
	stability_cost = -15
	stat_changes = list(STATKEY_CON = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/endurance_battery
	name = "extended capacity battery"
	desc = "Allows for longer operational periods without rest."
	stability_cost = -10
	stat_changes = list(STATKEY_END = 2)
	engineering_difficulty = SKILL_LEVEL_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/stats/mobility_actuator
	name = "high-efficiency actuators"
	desc = "Improves movement speed through advanced mechanical joints."
	stability_cost = -12
	stat_changes = list(STATKEY_SPD = 2)
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/power_limiter
	name = "strength governor"
	desc = "Limits power output to improve core stability."
	stability_cost = 10
	stat_changes = list(STATKEY_STR = -1)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/sensor_dampener
	name = "sensor dampening module"
	desc = "Reduces sensor sensitivity to decrease processing load."
	stability_cost = 8
	stat_changes = list(STATKEY_PER = -1)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/logic_limiter
	name = "simplified logic circuit"
	desc = "Reduces processing complexity for improved stability."
	stability_cost = 15
	stat_changes = list(STATKEY_INT = -2)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 10 SECONDS

/datum/augment/stats/lightweight_frame
	name = "lightweight chassis"
	desc = "Reduces structural integrity for better energy efficiency."
	stability_cost = 10
	stat_changes = list(STATKEY_CON = -1)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/efficiency_mode
	name = "power conservation mode"
	desc = "Reduces operational capacity to improve stability."
	stability_cost = 8
	stat_changes = list(STATKEY_END = -1)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/servo_governor
	name = "movement limiter"
	desc = "Restricts movement speed to reduce mechanical stress."
	stability_cost = 10
	stat_changes = list(STATKEY_SPD = -1)
	engineering_difficulty = SKILL_LEVEL_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/balanced_matrix
	name = "stabilized enhancement matrix"
	desc = "A carefully balanced augmentation that improves multiple attributes."
	stability_cost = -5
	stat_changes = list(STATKEY_STR = 1, STATKEY_CON = 1)
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 20 SECONDS

/datum/augment/stats/core_stabilizer
	name = "core stabilization array"
	desc = "Dramatically improves core stability without affecting performance."
	stability_cost = 25
	stat_changes = list()
	engineering_difficulty = SKILL_LEVEL_MASTER
	installation_time = 25 SECONDS
