/datum/augment/stats
	var/list/stat_changes = list() // List of stat changes: list(STAT_STRENGTH = 1, STAT_SPEED = -1)
	color = COLOR_ASSEMBLY_ORANGE

/datum/augment/stats/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	for(var/stat in stat_changes)
		H.change_stat(stat, stat_changes[stat])

/datum/augment/stats/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
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
	stability_cost = -12
	stat_changes = list(STAT_STRENGTH = 2)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/perception_lens
	name = "enhanced optical array"
	desc = "Improves visual acuity and target acquisition."
	stability_cost = -10
	stat_changes = list(STAT_PERCEPTION = 2)
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/stats/processing_core
	name = "overclocked logic engine"
	desc = "Increases processing speed and analytical capability, straining the core matrix."
	stability_cost = -12
	stat_changes = list(STAT_INTELLIGENCE = 3)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS

/datum/augment/stats/suspension_rig
	name = "suspension rig"
	desc = "Strengthens the automaton's frame against damage."
	stability_cost = -12
	stat_changes = list(STAT_CONSTITUTION = 2)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/pressure_tank
	name = "extended capacity pressure tank"
	desc = "Allows for longer operational periods without rest."
	stability_cost = -10
	stat_changes = list(STAT_ENDURANCE = 2)
	engineering_difficulty = SKILL_RANK_APPRENTICE
	installation_time = 12 SECONDS

/datum/augment/stats/pressure_tank/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	var/datum/component/steam_life/sl = H.GetComponent(/datum/component/steam_life)
	sl?.max_steam_charge += 50

/datum/augment/stats/pressure_tank/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	var/datum/component/steam_life/sl = H.GetComponent(/datum/component/steam_life)
	sl?.max_steam_charge -= 50

/datum/augment/stats/mobility_actuator
	name = "high-efficiency actuators"
	desc = "Improves movement speed through advanced mechanical joints."
	stability_cost = -12
	stat_changes = list(STAT_SPEED = 2)
	engineering_difficulty = SKILL_RANK_JOURNEYMAN
	installation_time = 15 SECONDS

/datum/augment/stats/power_limiter
	name = "strength governor"
	desc = "Limits power output to improve core stability."
	stability_cost = 10
	stat_changes = list(STAT_STRENGTH = -1)
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/sensor_dampener
	name = "sensor dampening module"
	desc = "Reduces sensor sensitivity to decrease processing load."
	stability_cost = 8
	stat_changes = list(STAT_PERCEPTION = -1)
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/lightweight_frame
	name = "lightweight chassis"
	desc = "Reduces structural integrity for better energy efficiency."
	stability_cost = 10
	stat_changes = list(STAT_CONSTITUTION = -1)
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/efficiency_mode
	name = "power conservation mode"
	desc = "Reduces operational capacity to improve stability."
	stability_cost = 8
	stat_changes = list(STAT_ENDURANCE = -1)
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/servo_governor
	name = "movement limiter"
	desc = "Restricts movement speed to reduce mechanical stress."
	stability_cost = 10
	stat_changes = list(STAT_SPEED = -1)
	engineering_difficulty = SKILL_RANK_NOVICE
	installation_time = 8 SECONDS

/datum/augment/stats/balanced_matrix
	name = "stabilizing matrix"
	desc = "A carefully balanced augmentation that improves multiple attributes."
	stability_cost = -5
	stat_changes = list(STAT_STRENGTH = 1, STAT_CONSTITUTION = 1)
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS

/datum/augment/stats/core_stabilizer
	name = "core stabilization array"
	desc = "Dramatically improves core stability without affecting performance."
	stability_cost = 25
	stat_changes = list()
	engineering_difficulty = SKILL_RANK_MASTER
	installation_time = 25 SECONDS
