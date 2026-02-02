/datum/chimeric_node/output/hallucinate
	name = "hallucinating"
	desc = "Makes everyone around the user hallucinate temporarily."

	var/range = 5

/datum/chimeric_node/output/hallucinate/set_ranges()
	. = ..()
	range *= (node_purity * 0.02) * (tier * 0.5)

/datum/chimeric_node/output/hallucinate/trigger_effect(multiplier)
	. = ..()
	for(var/mob/living/carbon/listening_carbon in range(range * multiplier))
		handle_maniac_hallucinations(listening_carbon, 10)
