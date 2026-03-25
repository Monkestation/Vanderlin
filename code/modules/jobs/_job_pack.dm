GLOBAL_LIST_INIT(job_pack_singletons, init_jobpacks())

/proc/init_jobpacks()
	var/list/list = list()
	for(var/datum/job_pack/pack as anything in typesof(/datum/job_pack))
		if(IS_ABSTRACT(pack))
			continue
		list[pack] = new pack()
	return list

/datum/job_pack
	abstract_type = /datum/job_pack
	/// Name for identification
	var/name = "Generic"
	/// list of sheets to apply when picking this (should realistically only be 1)
	var/list/pack_sheets = list()
	/// List of Traits
	var/list/pack_traits = list()
	/// List of spells
	var/list/pack_spells = list()
	/// Associative list of item to slot, set null slot for auto
	var/list/pack_contents = list()
	/// Associative list of item paths to number of items for backpack storage
	var/list/pack_backpack_contents = list()

/datum/job_pack/proc/can_pick_pack(mob/living/carbon/human/picker, list/previous_picked_types)
	return TRUE

/datum/job_pack/proc/pick_pack(mob/living/carbon/human/picker)
	for(var/datum/attribute_holder/sheet/job/pack_sheet as anything in pack_sheets)
		picker.attributes?.add_sheet(pack_sheet)

	for(var/trait in pack_traits)
		ADD_TRAIT(picker, trait, JOB_TRAIT)

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

	if(length(pack_backpack_contents))
		var/datum/outfit/inserter = new
		for(var/path in pack_backpack_contents)
			var/number = pack_backpack_contents[path]
			if(!isnum(number)) // Default to 1
				number = 1
			for(var/i in 1 to number)
				var/obj/item/new_item = new path(picker)
				var/obj/item/item = picker.get_item_by_slot(ITEM_SLOT_BACK_L)
				if(!item)
					item = picker.get_item_by_slot(ITEM_SLOT_BACK_R)
				if(!item || !inserter.attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
					item = picker.get_item_by_slot(ITEM_SLOT_BACK_R)
					if(!item || !inserter.attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
						item = picker.get_item_by_slot(ITEM_SLOT_BELT)
						if(!item || !inserter.attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
							item = picker.get_item_by_slot(ITEM_SLOT_NECK)
							if(!item || !inserter.attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
								new_item.forceMove(get_turf(picker))
								message_admins("[type] had pack_backpack_contents set but no room to store:[new_item]")

