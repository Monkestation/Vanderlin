
GLOBAL_LIST_INIT(spellcraft_contributions, build_spellcraft_contributions())

GLOBAL_LIST_INIT(spellcraft_items, build_spellcraft_items())

/proc/build_spellcraft_items()
	. = list()
	for(var/datum/spellcraft_contribution/contribution_type as anything in subtypesof(/datum/spellcraft_contribution))
		if(IS_ABSTRACT(contribution_type))
			continue
		var/datum/spellcraft_contribution/contribution = new contribution_type()
		if(!contribution.holder)
			continue
		.[contribution.type] = contribution

/proc/build_spellcraft_contributions()
	. = list()
	for(var/datum/spellcraft_contribution/contribution_type as anything in subtypesof(/datum/spellcraft_contribution))
		if(IS_ABSTRACT(contribution_type))
			continue
		var/datum/spellcraft_contribution/contribution = new contribution_type()
		if(!contribution.atom_path)
			continue
		if(contribution.holder)
			continue
		if(contribution.include_subtypes)
			for(var/sub_path in typesof(contribution.atom_path))
				.[sub_path] = contribution
		else
			.[contribution.atom_path] = contribution
