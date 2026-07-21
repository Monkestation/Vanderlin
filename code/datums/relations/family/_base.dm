/datum/relation/family
	name = "Family"
	desc = "You share blood, marriage, or adoption with this person."
	symmetric = FALSE
	category = "Family"

	/// One of: "parent", "child", "sibling", "spouse", "adopted_parent",
	/// "adopted_child", "step_parent", "step_child"
	var/bond_type = FAMILY_MEMBER_SIBLING
	/// TRUE when the bond was formed through adoption rather than blood.
	var/adopted = FALSE
	/// TRUE when the bond was formed by merging two families at marriage
	var/in_law = FALSE

/datum/relation/family/on_created()
	refresh_snapshot()
	update_text()

/datum/relation/family/get_desc_string()
	SHOULD_CALL_PARENT(FALSE)
	var/label = adopted ? "adopted [bond_type]" : bond_type
	return "[holder?.name]'s [label] is [other?.name]."

/datum/relation/family/proc/update_text() //is this better then just a bunch of subtypes? they should be about the same I think
	switch(bond_type)
		if(FAMILY_MEMBER_CHILD)
			if(!adopted)
				name = "Parent"
				desc = "This person is one of your parents."
				if(in_law)
					desc = "This person is one of your parent-in-laws."
			else
				name = "Adoptive Parent"
				desc = "This person is your parent through adoption."

		if(FAMILY_MEMBER_PARENT)
			if(!adopted)
				name = "Child"
				desc = "This person is one of your children."
				if(in_law)
					desc = "This person is one of your children-in-laws."
			else
				name = "Adopted Child"
				desc = "This person is your child through adoption."

		if(FAMILY_MEMBER_SIBLING)
			name = "Sibling"
			desc = "This person is your sibling."
			if(in_law)
				desc = "This person is one of your sibling-in-laws."

		if(FAMILY_MEMBER_SPOUSE)
			name = "Spouse"
			desc = "You are married to this person."
		else
			name = "Family"
			desc = "You share a family bond with this person."
