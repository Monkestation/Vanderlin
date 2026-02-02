/datum/chimeric_node/output/wild_magic
	name = "wild magic"
	desc = "When activated triggers a random spell on a random target"

	var/static/list/spell_types = list()

/datum/chimeric_node/output/wild_magic/trigger_effect(multiplier)
	. = ..()
	if(!length(spell_types))
		for(var/datum/spell_node/node in subtypesof(/datum/spell_node))
			if(IS_ABSTRACT(node))
				continue
			if(initial(node.is_passive))
				continue
			if(!initial(node.spell_type))
				continue
			spell_types += initial(node.spell_type)

	var/picked_type = pick(spell_types)
	var/datum/action/cooldown/spell/picked_spell = new picked_type
	var/list/atoms_in_range = list()
	for(var/atom/close_atom as anything in range(3, hosted_carbon))
		if(isitem(close_atom))
			continue
		atoms_in_range |= close_atom

	var/atom/cast_atom = pick_n_take(atoms_in_range)
	while(!picked_spell.can_cast_spell(cast_atom) && length(atoms_in_range))
		cast_atom = pick_n_take(atoms_in_range)
	picked_spell.cast(cast_atom)

	log_game("WILD MAGIC: [picked_spell] cast on [cast_atom] from chimeric organ by [hosted_carbon]")
