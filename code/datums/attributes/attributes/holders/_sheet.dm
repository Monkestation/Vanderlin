// This subtype is added to a global list of attribute sheets, and should never be deleted once created
/datum/attribute_holder/sheet
	attribute_min = -INFINITY
	attribute_max = INFINITY
	skill_min = -INFINITY
	skill_max = INFINITY

/datum/attribute_holder/sheet/set_parent(mob/new_parent)
	CRASH("Tried to give an attribute sheet a parent mob! ([type])")
