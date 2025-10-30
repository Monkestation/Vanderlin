PROCESSING_SUBSYSTEM_DEF(enchantment)
	name = "Enchantments"
	priority = FIRE_PRIORITY_ENCHANTMENT
	flags = SS_BACKGROUND
	wait = 2 SECONDS
	var/list/enchantment_types = list() // cache of enchantment type paths and their properties

/datum/controller/subsystem/processing/enchantment/Initialize()
	. = ..()
	for(var/datum/enchantment/enchantment_path as anything in subtypesof(/datum/enchantment))
		var/weight = initial(enchantment_path.random_enchantment_weight)
		var/list/required = initial(enchantment_path.required_type)
		enchantment_types[enchantment_path] = list(
			"weight" = weight,
			"required_type" = required
		)

/datum/controller/subsystem/processing/enchantment/proc/has_enchantment(atom/item, datum/enchantment/path)
	if(!item || !path)
		return FALSE
	if(!item.enchantments || !length(item.enchantments))
		return FALSE
	for(var/datum/enchantment/E in item.enchantments)
		if(E.type == path)
			return TRUE
	return FALSE

/datum/controller/subsystem/processing/enchantment/proc/has_any_enchantment(atom/item)
	if(!item)
		return FALSE
	return item.enchantments && length(item.enchantments)

/datum/controller/subsystem/processing/enchantment/proc/get_enchantment(atom/item, datum/enchantment/path)
	if(!has_enchantment(item, path))
		return null
	for(var/datum/enchantment/E in item.enchantments)
		if(E.type == path)
			return E
	return null

/datum/controller/subsystem/processing/enchantment/proc/remove_enchantment(atom/item, datum/enchantment/enchantment_instance)
	if(!item || !enchantment_instance)
		return FALSE
	if(!item.enchantments || !(enchantment_instance in item.enchantments))
		return FALSE

	enchantment_instance.remove_item(item)
	item.enchantments -= enchantment_instance
	qdel(enchantment_instance)
	return TRUE

/datum/controller/subsystem/processing/enchantment/proc/remove_all_enchantments(atom/item)
	if(!item || !item.enchantments)
		return FALSE
	var/list/enchantments_copy = item.enchantments.Copy()
	for(var/datum/enchantment/E in enchantments_copy)
		remove_enchantment(item, E)
	return TRUE

/datum/controller/subsystem/processing/enchantment/proc/can_enchant(atom/item, datum/enchantment/enchantment_path)
	if(!item || !enchantment_path)
		return FALSE

	if(!(enchantment_path in enchantment_types))
		return FALSE

	var/list/type_data = enchantment_types[enchantment_path]
	var/required_type = type_data["required_type"]

	if(!required_type)
		return TRUE

	if(islist(required_type))
		for(var/type_path in required_type)
			if(istype(item, type_path))
				return TRUE
		return FALSE
	else
		return istype(item, required_type)

/datum/controller/subsystem/processing/enchantment/proc/enchant_item(atom/item, datum/enchantment/enchantment_path)
	if(!item || !enchantment_path)
		return FALSE

	if(!can_enchant(item, enchantment_path))
		return FALSE

	if(has_enchantment(item, enchantment_path))
		return FALSE

	var/datum/enchantment/new_enchantment = new enchantment_path()
	if(!new_enchantment)
		return FALSE

	LAZYADD(item.enchantments, new_enchantment)
	new_enchantment.add_item(item)

	return TRUE

/datum/controller/subsystem/processing/enchantment/proc/get_valid_enchantments(atom/item)
	var/list/valid = list()
	for(var/enchantment_path in enchantment_types)
		if(can_enchant(item, enchantment_path))
			valid[enchantment_path] = enchantment_types[enchantment_path]["weight"]
	return valid

/obj/item/proc/enchant(datum/enchantment/path)
	if(!path)
		var/list/valid = SSenchantment.get_valid_enchantments(src)
		if(!length(valid))
			return FALSE
		path = pickweight(valid)
	return SSenchantment.enchant_item(src, path)

/obj/item/proc/has_enchantment(datum/enchantment/path)
	return SSenchantment.has_enchantment(src, path)

/obj/item/proc/get_enchantment(datum/enchantment/path)
	return SSenchantment.get_enchantment(src, path)

/obj/item/proc/remove_enchantment(datum/enchantment/enchantment_instance)
	return SSenchantment.remove_enchantment(src, enchantment_instance)

/obj/item/proc/remove_all_enchantments()
	return SSenchantment.remove_all_enchantments(src)
