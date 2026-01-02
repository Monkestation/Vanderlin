/datum/oratorium
	var/name = "Oratorium Throni Vacui"
	var/list/mob/living/carbon/human/inquisition_members = list()

	//school roots
	var/datum/inquisition_hierarchy_node/venatari
	var/datum/inquisition_hierarchy_node/benetarus
	var/datum/inquisition_hierarchy_node/sanctae

	var/list/datum/inquisition_hierarchy_node/all_positions = list()

/datum/oratorium/New()
	..()
	initialize_schools()

/datum/oratorium/proc/initialize_schools()
	venatari = new /datum/inquisition_hierarchy_node("Herr Prafekt", "Teacher of the Venatari", 100, "Order of the Venatari")
	venatari.is_school_leader = TRUE
	venatari.can_assign_positions = TRUE
	venatari.max_subordinates = 10
	venatari.position_color = "#8B0000"
	all_positions += venatari

	benetarus = new /datum/inquisition_hierarchy_node("Herr Prafekt", "Teacher of the Benetarus", 100, "Benetarus")
	benetarus.is_school_leader = TRUE
	benetarus.can_assign_positions = TRUE
	benetarus.max_subordinates = 10
	benetarus.position_color = "#8B0000"
	all_positions += benetarus

	sanctae = new /datum/inquisition_hierarchy_node("Herr Prafekt", "Teacher of the Sanctae", 100, "Sanctae")
	sanctae.is_school_leader = TRUE
	sanctae.can_assign_positions = TRUE
	sanctae.max_subordinates = 10
	sanctae.position_color = "#8B0000"
	all_positions += sanctae

/datum/oratorium/proc/get_school_root(school_name)
	switch(school_name)
		if("Order of the Venatari")
			return venatari
		if("Benetarus")
			return benetarus
		if("Sanctae")
			return sanctae
	return null

/datum/oratorium/proc/get_school_positions(school_name)
	var/list/positions = list()
	var/datum/inquisition_hierarchy_node/root = get_school_root(school_name)

	if(root)
		positions += root
		positions += root.get_all_subordinates()

	return positions

/datum/oratorium/proc/create_position(pos_name, pos_desc, datum/inquisition_hierarchy_node/superior, rank, school_name)
	if(!superior || superior.subordinates.len >= superior.max_subordinates)
		return null

	var/datum/inquisition_hierarchy_node/new_pos = new(pos_name, pos_desc, rank, school_name)

	if(superior.add_subordinate(new_pos))
		all_positions += new_pos
		return new_pos

	return null

/datum/oratorium/proc/remove_position(datum/inquisition_hierarchy_node/position)
	if(!position || position.is_school_leader)
		return FALSE
	for(var/datum/inquisition_hierarchy_node/sub in position.subordinates.Copy())
		remove_position(sub)

	if(position.assigned_member)
		position.remove_member()

	if(position.superior)
		position.superior.remove_subordinate(position)

	all_positions -= position
	qdel(position)
	return TRUE

/datum/oratorium/proc/add_member_to_school(mob/living/carbon/human/member, school_name, starting_merits = 0, position_name = "Initiate", position_desc = "A new member")
	if(!member || !school_name)
		return FALSE

	var/datum/inquisition_hierarchy_node/root = get_school_root(school_name)
	if(!root)
		return FALSE

	if(member.inquisition_position)
		to_chat(member, "<span class='warning'>You already have a position in the hierarchy.</span>")
		return FALSE

	var/datum/inquisition_hierarchy_node/new_position = create_position(
		position_name,
		position_desc,
		root,
		starting_merits,
		school_name
	)

	if(!new_position)
		to_chat(member, "<span class='warning'>Failed to create position - the school may be full.</span>")
		return FALSE

	inquisition_members |= member
	member.inquisition = src
	new_position.assign_member(member)
	new_position.merits = starting_merits

	return TRUE

/datum/oratorium/proc/add_member_to_position(mob/living/carbon/human/member, datum/inquisition_hierarchy_node/position, starting_merits = 0)
	if(!member || !position)
		return FALSE

	if(position.assigned_member)
		to_chat(member, "<span class='warning'>This position is already occupied by [position.assigned_member.real_name].</span>")
		return FALSE

	if(member.inquisition_position)
		member.inquisition_position.remove_member()

	inquisition_members |= member
	member.inquisition = src

	if(position.assign_member(member))
		position.merits = starting_merits
		return TRUE

	return FALSE
