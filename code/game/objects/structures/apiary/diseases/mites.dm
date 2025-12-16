/datum/bee_disease/varroa_mites
	name = "Varroa Mites"
	description = "Parasitic mites that weaken and kill bees"

/datum/bee_disease/varroa_mites/apply_effects(obj/structure/apiary/hive)
	if(prob(hive.disease_severity / 10) && hive.bee_count > 0)
		hive.bee_count--
		if(prob(10))
			hive.visible_message(span_warning("A bee falls from [hive], twitching."))
			var/obj/effect/decal/cleanable/insect/dead_bee = new(get_turf(hive))
			dead_bee.name = "dead bee"

/datum/bee_disease/varroa_mites/get_inspection_message()
	return span_warning("You spot tiny mites crawling on the bees!")
