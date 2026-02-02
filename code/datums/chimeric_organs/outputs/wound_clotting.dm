/datum/chimeric_node/output/clotting
	name = "clotting"
	desc = "When activated clots and aids in the healing of wounds."

/datum/chimeric_node/output/clotting/trigger_effect(multiplier)
	. = ..()
	for(var/obj/item/bodypart/bodypart as anything in hosted_carbon.bodyparts)
		for(var/datum/wound/wound as anything in bodypart.wounds)
			for(var/i = 1 to multiplier)
				wound.on_life()

