/datum/chimeric_node/output/healing_coma
	name = "comatose"
	desc = "When activated puts you into a sleep to heal"
	weight = 2

	var/amount_healed = 5
	var/healing_until = 40
	var/healing = FALSE

/datum/chimeric_node/output/healing_coma/set_ranges()
	. = ..()
	healing_until *= (2 - (node_purity * 0.01))
	amount_healed *= (node_purity * 0.02) * (tier * 0.5)

/datum/chimeric_node/output/healing_coma/trigger_effect(multiplier)
	. = ..()
	if(healing)
		return

	var/total_damage = hosted_carbon.getBruteLoss() + hosted_carbon.getFireLoss()
	if(total_damage < healing_until)
		return

	healing = TRUE
	START_PROCESSING(SSobj, src)
	enter_coma()

/datum/chimeric_node/output/healing_coma/process()
	var/total_damage = hosted_carbon.getBruteLoss() + hosted_carbon.getFireLoss()
	if(total_damage < healing_until)
		STOP_PROCESSING(SSobj, src)
		exit_coma()
		return
	hosted_carbon.heal_overall_damage(amount_healed, amount_healed)

/datum/chimeric_node/output/healing_coma/proc/enter_coma()
	hosted_carbon.fakedeath("healing_coma")

/datum/chimeric_node/output/healing_coma/proc/exit_coma()
	hosted_carbon.cure_fakedeath("healing_coma")

