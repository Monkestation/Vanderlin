GLOBAL_LIST_INIT(job_pack_singletons, init_jobpacks())

/proc/init_jobpacks()
	var/list/list = list()
	for(var/datum/job_pack/pack as anything in typesof(/datum/job_pack))
		if(is_abstract(pack))
			continue
		list[pack] = new pack()
	return list

/datum/job_pack
	abstract_type = /datum/job_pack
	/// Name for identification
	var/name = "Generic"
	/// Associative list of statkey to stat value
	var/list/pack_stats = list()
	/// Associative list of skill to skill value
	var/list/pack_skills = list()
	/// List of spells
	var/list/pack_spells = list()
	/// Associative list of item to slot, set null slot for auto
	var/list/pack_contents = list()

/datum/job_pack/proc/can_pick_pack(mob/living/carbon/human/picker, list/previous_picked_types)
	return TRUE

/datum/job_pack/proc/pick_pack(mob/living/carbon/human/picker)
	picker.remove_stat_modifier(STATMOD_PACK) // Reset so no inf stat
	picker.adjust_stat_modifier_list(STATMOD_PACK, pack_stats)

	for(var/datum/skill/skill as anything in pack_skills)
		var/amount_or_list = pack_skills[skill]
		if(islist(amount_or_list))
			picker.clamped_adjust_skillrank(skill, amount_or_list[1], amount_or_list[2], TRUE)
		else
			picker.adjust_skillrank(skill, amount_or_list, TRUE)

	for(var/datum/action/cooldown/spell/spell as anything in pack_spells)
		picker.add_spell(spell, source = src)

	for(var/obj/item/path as anything in pack_contents)
		var/slot = pack_contents[path]
		if(!slot)
			picker.equip_to_appropriate_slot(new path, TRUE)
		else if(slot & ITEM_SLOT_HANDS)
			picker.put_in_hands(new path(picker), TRUE)
		else
			picker.equip_to_slot_or_del(new path, slot, TRUE)
