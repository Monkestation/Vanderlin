GLOBAL_DATUM_INIT(thaumic_research, /datum/thaumic_research_network, new())

/datum/thaumic_research_network
	var/list/unlocked_research = list()
	var/list/research_nodes = list()

/datum/thaumic_research_network/New()
	. = ..()
	// Initialize with basic research
	unlocked_research += /datum/thaumic_research_node/basic_understanding
	// Cache all research node types for easy access
	for(var/node_type in subtypesof(/datum/thaumic_research_node))
		var/datum/thaumic_research_node/node = new node_type
		if(IS_ABSTRACT(node))
			continue
		research_nodes[node_type] = node

/datum/thaumic_research_network/proc/has_research(research_type)
	return research_type in unlocked_research

/datum/thaumic_research_network/proc/unlock_research(research_type)
	if(research_type in unlocked_research)
		return FALSE
	unlocked_research += research_type
	return TRUE

/datum/thaumic_research_network/proc/get_research_bonus(bonus_category_path)
	var/total_additive = 0
	var/total_multiplicative = 1.0
	var/special_bonus = 0

	// Find all research in this category
	for(var/research_type in unlocked_research)
		var/datum/thaumic_research_node/node = research_nodes[research_type]
		if(!node || !istype(node, bonus_category_path))
			continue

		switch(node.bonus_type)
			if("additive")
				total_additive += node.bonus_value
			if("multiplicative")
				total_multiplicative *= (1.0 - node.bonus_value)
			if("special")
				special_bonus = node.bonus_value

	// Return appropriate value based on bonus type
	if(special_bonus > 0)
		return special_bonus
	else if(istype(bonus_category_path, /datum/thaumic_research_node/gnome_efficency)) //gods greatest shitcode here
		return max(total_multiplicative, 0.05) // Cost reduction, never below 5%
	else
		return 1.0 + total_additive // Speed/efficiency bonuses


/datum/thaumic_research_network/proc/can_use_machine(atom/machine_type)
	for(var/datum/thaumic_research_node/machines/node as anything in unlocked_research)
		if(!ispath(node))
			continue
		if(ispath(machine_type, initial(node.machine_path)))
			return TRUE
	return FALSE

/datum/thaumic_research_network/proc/get_available_research()
	var/list/available = list()
	for(var/datum/thaumic_research_node/node_type as anything in subtypesof(/datum/thaumic_research_node))
		if(IS_ABSTRACT(node_type))
			continue
		if(node_type in unlocked_research)
			continue
		var/datum/thaumic_research_node/node = research_nodes[node_type]
		if(!node)
			continue
		var/can_research = TRUE
		for(var/prereq in node.prerequisites)
			if(!(prereq in unlocked_research))
				can_research = FALSE
				break
		if(can_research)
			available += node_type
	return available

/datum/thaumic_research_network/proc/can_research(datum/thaumic_research_node/node_type)
	return(node_type in get_available_research())
