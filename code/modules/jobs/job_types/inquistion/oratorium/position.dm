/datum/inquisition_hierarchy_node
	var/name = "Position"
	var/desc = "A position within the inquisition hierarchy"
	var/school = "Order of the Venatari"
	var/mob/living/carbon/human/assigned_member
	var/datum/inquisition_hierarchy_node/superior
	var/list/datum/inquisition_hierarchy_node/subordinates = list()
	var/required_merits = 0
	var/max_subordinates = 5
	var/can_assign_positions = FALSE
	var/position_color = "#ffffff"
	var/node_x = 0
	var/node_y = 0
	var/merits = 0
	var/mutable_appearance/cloned_look
	var/is_school_leader = FALSE

/datum/inquisition_hierarchy_node/New(position_name, position_desc, merits = 0, ordo_school = "Order of the Venatari")
	name = position_name
	desc = position_desc
	required_merits = merits
	school = ordo_school
	..()

/datum/inquisition_hierarchy_node/proc/assign_member(mob/living/carbon/human/member)
	if(!member)
		return FALSE

	if(member.inquisition_position)
		member.inquisition_position.remove_member()

	assigned_member = member
	member.inquisition_position = src
	var/old_dir = member?.dir
	member?.dir = SOUTH
	cloned_look = member?.appearance
	member?.dir = old_dir
	return TRUE

/datum/inquisition_hierarchy_node/proc/remove_member()
	if(assigned_member)
		assigned_member.inquisition_position = null
		assigned_member = null
	cloned_look = null

/datum/inquisition_hierarchy_node/proc/add_subordinate(datum/inquisition_hierarchy_node/subordinate)
	if(!subordinate || subordinates.len >= max_subordinates)
		return FALSE

	subordinates += subordinate
	subordinate.superior = src
	return TRUE

/datum/inquisition_hierarchy_node/proc/remove_subordinate(datum/inquisition_hierarchy_node/subordinate)
	subordinates -= subordinate
	subordinate.superior = null

/datum/inquisition_hierarchy_node/proc/get_all_subordinates()
	var/list/all_subs = list()
	for(var/datum/inquisition_hierarchy_node/sub in subordinates)
		all_subs += sub
		all_subs += sub.get_all_subordinates()
	return all_subs

/datum/inquisition_hierarchy_node/proc/get_all_superiors()
	var/list/all_sups = list()
	if(superior)
		all_sups += superior
		all_sups += superior.get_all_superiors()
	return all_sups

/datum/inquisition_hierarchy_node/proc/is_superior_to(datum/inquisition_hierarchy_node/other)
	if(!other)
		return FALSE
	var/list/other_superiors = other.get_all_superiors()
	return (src in other_superiors)

/datum/inquisition_hierarchy_node/proc/is_subordinate_to(datum/inquisition_hierarchy_node/other)
	if(!other)
		return FALSE
	var/list/other_subordinates = other.get_all_subordinates()
	return (src in other_subordinates)
