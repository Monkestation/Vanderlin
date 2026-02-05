/datum/bee_disease/foulbrood
	name = "Foulbrood"
	description = "A bacterial disease that prevents new bees from developing"

/datum/bee_disease/foulbrood/apply_effects(obj/structure/apiary/hive)
	if(prob(hive.disease_severity))
		hive.comb_progress = max(0, hive.comb_progress - 1)

/datum/bee_disease/foulbrood/get_inspection_message()
	return span_warning("The honeycomb has a foul smell and appears discolored!")
