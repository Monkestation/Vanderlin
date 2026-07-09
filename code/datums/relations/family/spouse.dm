/datum/relation/family/spouse
	name = "Spouse"
	bond_type = "spouse"

/datum/relation/family/spouse/dissolve()
	// Before removing the bond, create a divorced relation on both sides.
	if(holder && other)
		var/datum/relation/divorced/D_holder = holder.add_relation(other, /datum/relation/divorced)
		if(D_holder)
			D_holder.refresh_snapshot()
		var/datum/relation/divorced/D_other = other.add_relation(holder, /datum/relation/divorced)
		if(D_other)
			D_other.refresh_snapshot()
