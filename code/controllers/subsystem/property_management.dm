/obj/effect/abstract/property_noop
	invisibility = INVISIBILITY_ABSTRACT
	var/property_id

/obj/effect/landmark/house_spot
	var/rent_cost = 0
	var/property_id = "" // Unique identifier for this specific property location
	var/save_id = "" // Template type identifier (multiple properties can share same save_id)
	var/owner_ckey = null
	var/owner_property_slot = null // Which slot/ID the owner is using for this property

	var/template_x = 0
	var/template_y = 0
	var/template_z = 1

	var/datum/map_template/default_template
	var/temporary_claim = FALSE // TRUE if claimed only for this round

/obj/effect/landmark/house_spot/Initialize(mapload)
	. = ..()
	SShousing.register_property(src)

/obj/effect/landmark/house_spot/Destroy(force)
	default_template = null
	return ..()

SUBSYSTEM_DEF(housing)
	name = "Housing"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HOUSING

	var/list/properties = list() // All property landmarks
	var/list/property_owners = list() // property_id -> list(ckey, slot) mapping
	var/list/property_controllers = list() // All active property controllers
	var/list/temporary_claims = list() // property_id -> list(ckey, slot) for round-only claims
	var/rent_collection_enabled = TRUE

/datum/controller/subsystem/housing/Initialize()
	load_persistent_owners()
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

		var/list/owner_data = property_owners[property_id]
		if(owner_data)
			var/owner_ckey = owner_data["ckey"]
			var/owner_slot = owner_data["slot"]

			if(!validate_rent_payment(owner_ckey, property))
				property_owners -= property_id
				owner_data = null
				save_persistent_owners()

			if(owner_data)
				property.owner_ckey = owner_ckey
				property.owner_property_slot = owner_slot
				property.temporary_claim = FALSE
				load_property(property, owner_ckey, owner_slot)
				create_property_controller(property)
				continue

		load_default_template(property)

/datum/controller/subsystem/housing/proc/load_persistent_owners()
	if(!fexists("data/property_owners.json"))
		return

	var/json_data = file2text("data/property_owners.json")
	property_owners = json_decode(json_data)
	if(!property_owners)
		property_owners = list()

/datum/controller/subsystem/housing/proc/save_persistent_owners()
	var/json_data = json_encode(property_owners)
	rustg_file_write(json_data, "data/property_owners.json")

/datum/controller/subsystem/housing/proc/validate_rent_payment(ckey, obj/effect/landmark/house_spot/property)
	if(!rent_collection_enabled)
		return TRUE

	var/datum/save_manager/SM = get_save_manager(ckey)
	var/current_balance = SM.get_data("banking", "persistent_balance", 0)

	if(current_balance < property.rent_cost)
		return FALSE

	SM.set_data("banking", "persistent_balance", current_balance - property.rent_cost)
	return TRUE

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

/datum/controller/subsystem/housing/proc/purchase_property(obj/effect/landmark/house_spot/property, mob/user, slot)
	if(!user || !user.client || !property || !slot)
		return FALSE

	var/ckey = user.ckey

	if(property_owners[property.property_id])
		return FALSE

	// Check if user already owns a property (single property limit)
	if(player_owns_property(ckey))
		return FALSE

	var/datum/save_manager/SM = get_save_manager(ckey)
	var/current_balance = SM.get_data("banking", "persistent_balance", 0)

	if(current_balance < property.rent_cost)
		return FALSE

	// Deduct cost
	SM.set_data("banking", "persistent_balance", current_balance - property.rent_cost)

	// Set ownership
	property_owners[property.property_id] = list("ckey" = ckey, "slot" = slot)
	property.owner_ckey = ckey
	property.owner_property_slot = slot
	property.temporary_claim = FALSE
	save_persistent_owners()

	// Reload property with owner's saved data if available
	clear_property_area(property)
	load_property(property, ckey, slot)
	create_property_controller(property)

	return TRUE

/datum/controller/subsystem/housing/proc/claim_temporary(obj/effect/landmark/house_spot/property, mob/user, slot)
	if(!user || !user.client || !property || !slot)
		return FALSE

	var/ckey = user.ckey

	// Check if already owned or claimed
	if(property_owners[property.property_id] || temporary_claims[property.property_id])
		return FALSE

	// Check if user already has a property with this save_id (permanent or temporary)
	if(player_owns_save_id(ckey, property.save_id))
		return FALSE

	// Set temporary claim
	temporary_claims[property.property_id] = list("ckey" = ckey, "slot" = slot)
	property.owner_ckey = ckey
	property.owner_property_slot = slot
	property.temporary_claim = TRUE

	// Load property if user has a saved design
	clear_property_area(property)
	load_property(property, ckey, slot)
	create_property_controller(property)

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

	// Check permanent ownership
	for(var/property_id in property_owners)
		var/list/owner_data = property_owners[property_id]
		if(owner_data["ckey"] != ckey)
			continue
		var/obj/effect/landmark/house_spot/property = properties[property_id]
		if(property && property.save_id == save_id)
			return TRUE

	// Check temporary claims
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

	for(var/property_id in property_owners)
		var/list/owner_data = property_owners[property_id]
		if(owner_data["ckey"] == client_key)
			return TRUE

	return FALSE

/datum/controller/subsystem/housing/proc/auto_claim_compatible_property(mob/user)
	if(!user || !user.client)
		return null

	var/ckey = user.ckey

	// Look for unclaimed properties that match user's saved designs
	for(var/property_id in properties)
		var/obj/effect/landmark/house_spot/property = properties[property_id]

		// Skip if already owned/claimed
		if(property_owners[property_id] || temporary_claims[property_id])
			continue

		// Check if user has any saved designs for this template type
		var/list/available_slots = get_player_property_slots(ckey, property.save_id)
		if(available_slots.len > 0)
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

/datum/property_controller
	var/obj/effect/landmark/house_spot/linked_property
	var/list/allowed_list = list()

	var/property_bounds_minx
	var/property_bounds_miny
	var/property_bounds_minz
	var/property_bounds_maxx
	var/property_bounds_maxy
	var/property_bounds_maxz

/datum/property_controller/New(obj/effect/landmark/house_spot/property)
	linked_property = property
	if(!property)
		return

	var/turf/start_turf = get_turf(property)
	if(!start_turf)
		return

	property_bounds_minx = start_turf.x
	property_bounds_miny = start_turf.y
	property_bounds_minz = start_turf.z
	property_bounds_maxx = start_turf.x + property.template_x - 1
	property_bounds_maxy = start_turf.y + property.template_y - 1
	property_bounds_maxz = start_turf.z + property.template_z - 1

/datum/property_controller/proc/check_access(mob/user)
	if(!linked_property || !user || !user.client)
		return FALSE

	// Owner has access
	if(user.ckey == linked_property.owner_ckey)
		return TRUE

	// Check allow list
	if(user.ckey in allowed_list)
		return TRUE

	return FALSE

/datum/property_controller/proc/is_in_property_bounds(atom/A)
	if(!linked_property)
		return FALSE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	return (T.x >= property_bounds_minx && T.x <= property_bounds_maxx && \
	        T.y >= property_bounds_miny && T.y <= property_bounds_maxy && \
	        T.z >= property_bounds_minz && T.z <= property_bounds_maxz)

/datum/property_controller/proc/add_access(ckey)
	if(!(ckey in allowed_list))
		allowed_list += ckey

/datum/property_controller/proc/remove_access(ckey)
	allowed_list -= ckey

// ===== PROPERTY SIGNS =====
/obj/structure/sign/property_sign
	name = "Property Sign"
	desc = "A sign for property management."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "questnoti"

	var/obj/effect/landmark/house_spot/linked_property

/obj/structure/sign/property_sign/proc/setup_property_link(obj/effect/landmark/house_spot/property)
	linked_property = property

/obj/structure/sign/property_sign/proc/check_other_players(mob/user)
	if(!linked_property)
		return FALSE

	var/turf/start_turf = get_turf(linked_property)
	if(!start_turf)
		return FALSE

	var/minx = start_turf.x
	var/miny = start_turf.y
	var/minz = start_turf.z
	var/maxx = minx + linked_property.template_x - 1
	var/maxy = miny + linked_property.template_y - 1
	var/maxz = minz + linked_property.template_z - 1

	for(var/turf/T in block(locate(minx, miny, minz), locate(maxx, maxy, maxz)))
		for(var/mob/M in T.contents)
			if(M == user)
				continue
			if(M.client)
				return TRUE
	return FALSE

/obj/structure/sign/property_sign/claim
	var/claimed = FALSE

/obj/structure/sign/property_sign/claim/attack_hand(mob/user)
	. = ..()
	if(!user.client || !linked_property)
		return

	// If already claimed by this user, allow saving
	if(linked_property?.owner_ckey == user.ckey)
		save_property_design(user)
		return

	// Check if already claimed/owned
	if(SShousing.property_owners[linked_property.property_id] || SShousing.temporary_claims[linked_property.property_id])
		to_chat(user, span_warning("This property is already claimed!"))
		return

	// Check if user already owns a property with this save_id
	if(SShousing.player_owns_save_id(user.ckey, linked_property.save_id))
		to_chat(user, span_warning("You already have a property of this type!"))
		return

	if(check_other_players(user))
		to_chat(user, span_warning("Cannot claim while others are present!"))
		return

	// Show slot selection interface
	show_slot_selection(user)

/obj/structure/sign/property_sign/claim/proc/show_slot_selection(mob/user)
	if(!user || !user.client || !linked_property)
		return

	var/list/available_slots = SShousing.get_player_property_slots(user.ckey, linked_property.save_id)
	var/list/options = list()

	// Add existing slots
	for(var/slot in available_slots)
		options["Load Design [slot]"] = slot

	// Add option to create new slot
	var/next_slot = 1
	if(available_slots.len > 0)
		next_slot = available_slots[available_slots.len] + 1
	options["Create New Design ([next_slot])"] = next_slot

	options["Cancel"] = null

	var/choice = input(user, "Select a property design slot:", "Property Claim") as null|anything in options
	if(!choice || options[choice] == null)
		return

	var/selected_slot = options[choice]

	if(check_other_players(user))
		to_chat(user, span_warning("Someone entered the area!"))
		return

	if(SShousing.claim_temporary(linked_property, user, selected_slot))
		claimed = TRUE
		name = "Claimed Property (Slot [selected_slot])"
		desc = "Click to save your current design to slot [selected_slot]."
		to_chat(user, span_notice("Property claimed with design slot [selected_slot]! Click again to save changes."))
	else
		to_chat(user, span_warning("Failed to claim property!"))

/obj/structure/sign/property_sign/claim/proc/save_property_design(mob/user)
	if(!linked_property || linked_property.owner_ckey != user.ckey)
		return

	var/slot = linked_property.owner_property_slot
	if(!slot)
		to_chat(user, span_warning("No slot assigned to this property!"))
		return

	var/confirm = alert(user, "Save the current state to design slot [slot]?", "Save Property", "Yes", "No")
	if(confirm != "Yes")
		return

	if(SShousing.save_property(linked_property, user.ckey, slot))
		to_chat(user, span_notice("Property saved successfully to slot [slot]!"))
	else
		to_chat(user, span_warning("Failed to save property!"))

/obj/structure/sign/property_sign/for_sale

/obj/structure/sign/property_sign/for_sale/attack_hand(mob/user)
	. = ..()
	if(!user.client || !linked_property)
		return

	// Check if already owned
	if(SShousing.property_owners[linked_property.property_id])
		to_chat(user, span_warning("This property is already owned!"))
		return

	// Check if user already owns a property with this save_id
	if(SShousing.player_owns_save_id(user.ckey, linked_property.save_id))
		to_chat(user, span_warning("You already own a property of this type!"))
		return

	// Check if user already owns any property
	if(SShousing.player_owns_property(user.ckey))
		to_chat(user, span_warning("You already own a property!"))
		return

	var/datum/save_manager/SM = get_save_manager(user.ckey)
	var/current_balance = SM.get_data("banking", "persistent_balance", 0)

	if(current_balance < linked_property.rent_cost)
		to_chat(user, span_warning("You need [linked_property.rent_cost] credits. You have [current_balance]."))
		return

	// Show slot selection for purchase
	show_purchase_slot_selection(user)

/obj/structure/sign/property_sign/for_sale/proc/show_purchase_slot_selection(mob/user)
	if(!user || !user.client || !linked_property)
		return

	var/list/available_slots = SShousing.get_player_property_slots(user.ckey, linked_property.save_id)
	var/list/options = list()

	// Add existing slots
	for(var/slot in available_slots)
		options["Use Design [slot]"] = slot

	// Add option to create new slot
	var/next_slot = 1
	if(available_slots.len > 0)
		next_slot = available_slots[available_slots.len] + 1
	options["Start Fresh ([next_slot])"] = next_slot

	options["Cancel"] = null

	var/choice = input(user, "Select a property design slot:", "Property Purchase") as null|anything in options
	if(!choice || options[choice] == null)
		return

	var/selected_slot = options[choice]

	var/confirm = alert(user, "Purchase this property for [linked_property.rent_cost] credits using slot [selected_slot]?\n\nRent will be deducted each round.", "Property Purchase", "Yes", "No")
	if(confirm != "Yes")
		return

	if(SShousing.purchase_property(linked_property, user, selected_slot))
		to_chat(user, span_notice("Property purchased successfully with design slot [selected_slot]!"))
		qdel(src)
	else
		to_chat(user, span_warning("Purchase failed!"))
