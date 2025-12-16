/datum/bee_disease/wax_moths
	name = "Wax Moths"
	description = "Moth larvae that consume honeycomb"

/datum/bee_disease/wax_moths/apply_effects(obj/structure/apiary/hive)
	if(prob(hive.disease_severity / 5) && hive.stored_combs > 0)
		hive.stored_combs = max(0, hive.stored_combs - 1)
		hive.update_appearance(UPDATE_ICON_STATE)

/datum/bee_disease/wax_moths/get_inspection_message()
	return span_warning("You see small moths and their larvae in the hive!")
