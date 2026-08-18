SUBSYSTEM_DEF(housing)
	name = "Housing"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HOUSING

	var/list/properties = list() // All property landmarks
	var/list/property_controllers = list() // All active property controllers
	var/list/temporary_claims = list() // property_id -> list(ckey, slot) for round-only claims

/datum/controller/subsystem/housing/Initialize()
	initialize_properties()
	return ..()

/datum/controller/subsystem/housing/proc/register_property(obj/effect/landmark/house_spot/property)
	if(!property.property_id)
		log_admin("Housing: Property at [property.x],[property.y],[property.z] has no property_id!")
		return
	properties[property.property_id] = property

/datum/controller/subsystem/housing/proc/initialize_properties()
	for(var/property_id in properties)
		var/obj/effect/landmark/house_spot/property = properties[property_id]
		load_default_template(property)

/datum/controller/subsystem/housing/proc/load_default_template(obj/effect/landmark/house_spot/property, claim = FALSE)
	if(!property.default_template)
		return FALSE

	var/datum/map_template/template = new property.default_template
	var/turf/spawn_location = get_turf(property)
	template.load(spawn_location)

	var/lock_id = "[rand(10000, 99999)]"
	var/list/lock_list = list(lock_id)
	var/list/turfs = template.get_affected_turfs(spawn_location)
	for(var/turf/T as anything in turfs)
		for(var/obj/structure/sign/property_sign/sign in T.contents)
			sign.setup_property_link(property)
			if(claim)
				var/obj/item/key/new_key = new /obj/item/key(get_turf(sign))
				new_key.lockids = lock_list
		if(claim)
			for(var/obj/structure/door/door in T.contents)
				if(door.lock)
					QDEL_NULL(door.lock)
				door.lock = new /datum/lock/key(door, lock_list)

	return TRUE

/datum/controller/subsystem/housing/proc/load_property(obj/effect/landmark/house_spot/property, ckey, slot)
	var/property_file = "data/properties/[ckey]_[property.save_id]_[slot].dmm"

	if(fexists(property_file))
		var/datum/map_template/saved_template = new /datum/map_template(property_file, "[ckey]_[property.save_id]_[slot]", TRUE)
		var/turf/spawn_location = get_turf(property)
		if(saved_template.cached_map)
			saved_template.load(get_turf(property))
			var/lock_id = "[slot]_[ckey]"
			var/list/lock_list = list(lock_id)
			var/list/turfs = saved_template.get_affected_turfs(spawn_location)
			for(var/turf/T as anything in turfs)
				for(var/obj/structure/sign/property_sign/sign in T.contents)
					sign.setup_property_link(property)
					var/obj/item/key/new_key = new /obj/item/key(get_turf(sign))
					new_key.lockids = lock_list
				for(var/obj/structure/door/door in T.contents)
					if(door.lock)
						QDEL_NULL(door.lock)
					door.lock = new /datum/lock/key(door, lock_list)

			return TRUE
	return load_default_template(property, TRUE)

/datum/controller/subsystem/housing/proc/save_property(obj/effect/landmark/house_spot/property, ckey, slot)
	if(!property || !ckey || !slot)
		return FALSE

	var/turf/start_turf = get_turf(property)
	if(!start_turf)
		return FALSE

	var/minx = start_turf.x
	var/miny = start_turf.y
	var/minz = start_turf.z
	var/maxx = minx + property.template_x - 1
	var/maxy = miny + property.template_y - 1
	var/maxz = minz + property.template_z - 1

	var/save_flags = SAVE_OBJECTS | SAVE_TURFS | SAVE_AREAS | SAVE_OBJECT_PROPERTIES | SAVE_UUID_STASIS | SAVE_WHITELIST
	var/map_data = write_map(minx, miny, minz, maxx, maxy, maxz, save_flags, SAVE_SHUTTLEAREA_DONTCARE, property_noop = property.save_id)

	if(!map_data)
		log_admin("Housing: Failed to generate map data for [ckey]'s property [property.property_id] slot [slot]")
		return FALSE

	var/property_file = "data/properties/[ckey]_[property.save_id]_[slot].dmm"
	if(fexists(property_file))
		fdel(property_file)

	var/file_handle = file(property_file)
	file_handle << map_data

	log_admin("Housing: Saved property [property.property_id] for [ckey] in slot [slot]")
	return TRUE

/datum/controller/subsystem/housing/proc/create_property_controller(obj/effect/landmark/house_spot/property)
	var/datum/property_controller/controller = new(property)
	property_controllers += controller
	return controller

/datum/controller/subsystem/housing/proc/claim_temporary(obj/effect/landmark/house_spot/property, mob/user, slot)
	if(!user || !user.client || !property || !slot)
		return FALSE

	var/ckey = user.ckey

	// Check if already claimed
	if(temporary_claims[property.property_id])
		return FALSE

	if(!property.check_job_requirement(user))
		return FALSE

	// Check if user already has a property with this save_id
	if(player_owns_save_id(ckey, property.save_id))
		return FALSE

	// Set claim
	temporary_claims[property.property_id] = list("ckey" = ckey, "slot" = slot)
	property.owner_ckey = ckey
	property.owner_property_slot = slot

	// Load property if user has a saved design
	clear_property_area(property)
	load_property(property, ckey, slot)
	create_property_controller(property)

	property.on_claim(user)

	return TRUE

/datum/controller/subsystem/housing/proc/get_player_property_slots(ckey, save_id)
	if(!ckey || !save_id)
		return list()

	var/list/slots = list()

	// Scan for existing property files
	for(var/i = 1 to 10) // Check up to 10 slots
		var/property_file = "data/properties/[ckey]_[save_id]_[i].dmm"
		if(fexists(property_file))
			slots += i

	return slots

/datum/controller/subsystem/housing/proc/has_saved_property(ckey, save_id, slot)
	if(!ckey || !save_id || !slot)
		return FALSE

	var/property_file = "data/properties/[ckey]_[save_id]_[slot].dmm"
	return fexists(property_file)

/datum/controller/subsystem/housing/proc/player_owns_save_id(ckey, save_id)
	if(!ckey || !save_id)
		return FALSE

	for(var/property_id in temporary_claims)
		var/list/claim_data = temporary_claims[property_id]
		if(claim_data["ckey"] != ckey)
			continue
		var/obj/effect/landmark/house_spot/property = properties[property_id]
		if(property && property.save_id == save_id)
			return TRUE

	return FALSE

/datum/controller/subsystem/housing/proc/player_owns_property(client_key)
	for(var/property_id in temporary_claims)
		var/list/claim_data = temporary_claims[property_id]
		if(claim_data["ckey"] == client_key)
			return TRUE

	return FALSE

/datum/controller/subsystem/housing/proc/auto_claim_compatible_property(mob/user)
	if(!user || !user.client)
		return null

	var/ckey = user.ckey

	// Look for unclaimed properties that match user's saved designs
	for(var/property_id in properties)
		var/obj/effect/landmark/house_spot/property = properties[property_id]

		// Skip if already claimed
		if(temporary_claims[property_id])
			continue

		// Check if user has any saved designs for this template type
		var/list/available_slots = get_player_property_slots(ckey, property.save_id)
		if(length(available_slots) > 0)
			// Auto-claim with first available slot
			if(claim_temporary(property, user, available_slots[1]))
				return property

	return null

/datum/controller/subsystem/housing/proc/clear_property_area(obj/effect/landmark/house_spot/property)
	if(!property)
		return

	var/turf/start_turf = get_turf(property)
	if(!start_turf)
		return

	var/minx = start_turf.x
	var/miny = start_turf.y
	var/minz = start_turf.z
	var/maxx = minx + property.template_x - 1
	var/maxy = miny + property.template_y - 1
	var/maxz = minz + property.template_z - 1

	for(var/turf/T in block(locate(minx, miny, minz), locate(maxx, maxy, maxz)))
		var/has_noop = FALSE
		for(var/obj/O in T.contents)
			if(istype(O, /obj/effect/abstract/property_noop))
				var/obj/effect/abstract/property_noop/effect = O
				if(effect.property_id == property.save_id)
					has_noop = TRUE
					break
		if(!has_noop)
			for(var/obj/O in T.contents)
				if(istype(O, /obj/effect/landmark))
					continue
				qdel(O)

			T.ScrapeAway()

/datum/controller/subsystem/housing/proc/check_access(mob/user)
	if(!has_world_trait(/datum/world_trait/delver))
		return TRUE
	if(!user || !user.client)
		return FALSE

	for(var/datum/property_controller/controller as anything in property_controllers)
		if(controller.check_access(user))
			return TRUE
	return FALSE
