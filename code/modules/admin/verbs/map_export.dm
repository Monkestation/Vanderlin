/client/proc/map_export()
	set category = "Debug.Mapping Custom"
	set name = "Map Export"
	set desc = "Select a part of the map by coordinates and download it."

	var/start_z = input(usr, "Start Z?", "Map Exporter") as null|num
	start_z = clamp(start_z, 1, world.maxz)
	var/end_z = input(usr, "End Z?", "Map Exporter") as null|num
	end_z = clamp(end_z, 1, world.maxz)
	var/start_x = input(usr, "Start X?", "Map Exporter") as null|num
	start_x = clamp(start_x, 1, world.maxx)
	var/start_y = input(usr, "Start Y?", "Map Exporter") as null|num
	start_y = clamp(start_y, 1, world.maxy)
	var/end_x = input(usr, "End X?", "Map Exporter") as null|num
	end_x = clamp(end_x, 1, world.maxx)
	var/end_y = input(usr, "End Y?", "Map Exporter") as null|num
	end_y = clamp(end_y, 1, world.maxy)
	var/date = time2text(world.timeofday, "YYYY-MM-DD_hh-mm-ss")
	var/file_name = sanitize_mapfile(browser_input_text(usr, "Filename?", "Map Exporter", "exported_map_[date]"))
	var/confirm = browser_alert(usr, "Are you sure you want to do this? This will cause extreme lag!", "Map Exporter", list("Yes", "No"))

	if(confirm != "Yes" || !check_rights(R_DEBUG))
		return

	var/map_text = write_map(start_x, start_y, start_z, end_x, end_y, end_z)
	log_admin("Build Mode: [key_name(usr)] is exporting the map area from ([start_x], [start_y], [start_z]) through ([end_x], [end_y], [end_z])")
	send_exported_map(usr, file_name, map_text)

/**
 * A procedure for saving DMM text to a file and then sending it to the user.
 * Arguments:
 * * user - a user which get map
 * * name - name of file + .dmm
 * * map - text with DMM format
 */
/proc/send_exported_map(user, name, map)
	var/file_path = "data/[name].dmm"
	rustg_file_write(map, file_path)
	DIRECT_OUTPUT(user, ftp(file_path, "[name].dmm"))
	var/file_to_delete = file(file_path)
	fdel(file_to_delete)

/proc/sanitize_mapfile(text)
	return hashtag_newlines_and_tabs(text, list("\n"="", "\t"="", "/"="", "\\"="", "?"="", "%"="", "*"="", ":"="", "|"="", "\""="", "<"="", ">"=""))

/proc/hashtag_newlines_and_tabs(text, list/repl_chars = list("\n"="#","\t"="#"))
	for(var/char in repl_chars)
		var/index = findtext(text, char)
		while(index)
			text = copytext(text, 1, index) + repl_chars[char] + copytext(text, index + length(char))
			index = findtext(text, char, index + length(char))
	return text

/proc/generate_uuid()
	var/static/uuid_counter = 0
	uuid_counter++
	return "[GLOB.rogue_round_id]_[uuid_counter]_[rand(10000,99999)]"


/obj
	var/UUID_saving = FALSE
	var/object_uuid = null

/obj/Initialize(mapload, ...)
	. = ..()
	if(UUID_saving)
		if(!object_uuid)
			object_uuid = generate_uuid()
		else
			// We have a UUID from the map, try to restore from stasis
			handle_stasis_restoration()

/obj/proc/handle_stasis_restoration()
	if(!UUID_saving || !object_uuid)
		return FALSE

	var/stasis_path = "data/object_stasis/[object_uuid].sav"
	if(!fexists(stasis_path))
		return FALSE

	var/savefile/F = new(stasis_path)
	if(!F)
		return FALSE

	F.cd = "/"
	var/obj/restored_obj
	F >> restored_obj  // This does an instance restore - creates new object from saved type and data

	if(restored_obj && istype(restored_obj))
		// Move restored object to our location
		restored_obj.forceMove(loc)

		// Delete ourselves as we've been replaced
		qdel(src)
		restored_obj.after_load()
		return TRUE

	return FALSE

/obj/proc/after_load()
	return

/proc/save_object_to_stasis(obj/target)
	if(!target || !target.UUID_saving || !target.object_uuid)
		return FALSE

	var/stasis_path = "data/object_stasis/[target.object_uuid].sav"

	// Clean up any existing stasis file first - this reduces churn
	if(fexists(stasis_path))
		fdel(file(stasis_path))

	var/savefile/F = new(stasis_path)
	if(!F)
		return FALSE

	F.cd = "/"
	F << target  // This does an instance save - saves the full object with type info
	return TRUE

/**
 * A procedure for saving non-standard properties of an object.
 * For example, saving items in vault.
 */
/obj/proc/on_object_saved()
	return null

/**Map exporter
* Inputting a list of turfs into convert_map_to_tgm() will output a string
* with the turfs and their objects / areas on said turf into the TGM mapping format
* for .dmm files. This file can then be opened in the map editor or imported
* back into the game.
* ============================
* This has been made semi-modular so you should be able to use these functions
* elsewhere in code if you ever need to get a file in the .dmm format
**/


/atom/proc/get_save_vars()
	. = list()
	. += NAMEOF(src, color)
	. += NAMEOF(src, dir)
	. += NAMEOF(src, icon)
	. += NAMEOF(src, icon_state)
	. += NAMEOF(src, name)
	. += NAMEOF(src, pixel_x)
	. += NAMEOF(src, pixel_y)
	. += NAMEOF(src, density)
	. += NAMEOF(src, opacity)

	return .

/atom/movable/get_save_vars()
	. = ..()
	. += NAMEOF(src, anchored)
	return .

/obj/get_save_vars()
	. = ..()
	if(UUID_saving)
		. += NAMEOF(src, object_uuid)
	return .

/obj/structure/get_save_vars()
	. = ..()
	. += NAMEOF(src, redstone_id)
	return .


GLOBAL_LIST_INIT(save_file_chars, list(
	"a","b","c","d","e",
	"f","g","h","i","j",
	"k","l","m","n","o",
	"p","q","r","s","t",
	"u","v","w","x","y",
	"z","A","B","C","D",
	"E","F","G","H","I",
	"J","K","L","M","N",
	"O","P","Q","R","S",
	"T","U","V","W","X",
	"Y","Z",
))

/proc/to_list_string(list/build_from)
	var/list/build_into = list()
	build_into += "list("
	var/first_entry = TRUE
	for(var/item in build_from)
		CHECK_TICK
		if(!first_entry)
			build_into += ", "
		if(isnum(item) || !build_from[item])
			build_into += "[tgm_encode(item)]"
		else
			build_into += "[tgm_encode(item)] = [tgm_encode(build_from[item])]"
		first_entry = FALSE
	build_into += ")"
	return build_into.Join("")

/// Takes a constant, encodes it into a TGM valid string
/proc/tgm_encode(value)
	if(istext(value))
		//Prevent symbols from being because otherwise you can name something
		// [";},/obj/item/gun/energy/laser/instakill{name="da epic gun] and spawn yourself an instakill gun.
		return "\"[hashtag_newlines_and_tabs("[value]", list("{"="", "}"="", "\""="", ";"="", ","=""))]\""
	if(isnum(value) || ispath(value))
		return "[value]"
	if(islist(value))
		return to_list_string(value)
	if(isnull(value))
		return "null"
	if(isicon(value) || isfile(value))
		return "'[value]'"
	// not handled:
	// - pops: /obj{name="foo"}
	// - new(), newlist(), icon(), matrix(), sound()

	// fallback: string
	return tgm_encode("[value]")

GLOBAL_LIST_EMPTY(save_whitelist)

/proc/build_whitelist()
	var/list/list = list()
	list += typesof(/obj/item/bedsheet)
	list += typesof(/obj/item/kitchen)
	return list

/**
 *Procedure for converting a coordinate-selected part of the map into text for the .dmi format
 */
/proc/write_map(
	minx,
	miny,
	minz,
	maxx,
	maxy,
	maxz,
	save_flag = ALL,
	shuttle_area_flag = SAVE_SHUTTLEAREA_DONTCARE,
	list/obj_blacklist = typesof(/obj/effect),
	property_noop = null,
)
	var/width = maxx - minx
	var/height = maxy - miny
	var/depth = maxz - minz

	if(!length(GLOB.save_whitelist))
		GLOB.save_whitelist = build_whitelist()

	if(!islist(obj_blacklist))
		CRASH("Non-list being used as object blacklist for map writing")

	// we want to keep crayon writings, blood splatters, cobwebs, etc.
	obj_blacklist -= typesof(/obj/effect/decal)
	obj_blacklist -= typesof(/obj/effect/turf_decal)
	obj_blacklist -= typesof(/obj/effect/landmark) // most landmarks get deleted except for latejoin arrivals shuttle
	obj_blacklist += /obj/effect/landmark/house_spot
	obj_blacklist += /obj/effect/fog_parter
	obj_blacklist += /obj/structure/sign/property_sign
	if(save_flag & SAVE_WHITELIST)
		obj_blacklist += typesof(/obj/effect/landmark/start)

	//Step 0: Calculate the amount of letters we need (26 ^ n > turf count)
	var/turfs_needed = width * height
	var/layers = FLOOR(log(GLOB.save_file_chars.len, turfs_needed) + 0.999,1)

	//Step 1: Run through the area and generate file data
	var/list/header_data = list() //holds the data of a header -> to its key
	var/list/header = list() //The actual header in text
	var/list/contents = list() //The contents in text (bit at the end)
	var/key_index = 1 // How many keys we've generated so far
	for(var/z in 0 to depth)
		for(var/x in 0 to width)
			contents += "\n([x + 1],1,[z + 1]) = {\"\n"
			for(var/y in height to 0 step -1)
				CHECK_TICK
				//====Get turfs Data====
				var/turf/place
				var/area/location
				var/turf/pull_from = locate((minx + x), (miny + y), (minz + z))

				//If there is nothing there, save as a noop (For odd shapes)
				if(isnull(pull_from))
					place = /turf/template_noop
					location = /area/template_noop
				else
					//====CHECK FOR PROPERTY NOOP====
					var/has_property_noop = FALSE
					if(property_noop)
						for(var/obj/effect/abstract/property_noop/noop in pull_from)
							if(noop.property_id == property_noop)
								has_property_noop = TRUE
								break

					//If this turf has a property_noop marker, save as noop
					if(has_property_noop)
						place = /turf/template_noop
						location = /area/template_noop
					else
						//Stuff to add
						var/area/place_area = get_area(pull_from)
						location = place_area.type
						place = pull_from.type

				//====For toggling not saving areas and turfs====
				if(!(save_flag & SAVE_AREAS))
					location = /area/template_noop
				if(!(save_flag & SAVE_TURFS))
					place = /turf/template_noop

				//====Generate Header Character====
				// Info that describes this turf and all its contents
				// Unique, will be checked for existing later
				var/list/current_header = list()
				current_header += "(\n"

				//Add objects to the header file
				var/empty = TRUE

				//====SKIP OBJECTS IF NOOP====
				var/skip_objects = FALSE
				if(property_noop && pull_from)
					for(var/obj/effect/abstract/property_noop/noop in pull_from)
						if(noop.property_id == property_noop)
							skip_objects = TRUE
							break

				//====SAVING OBJECTS====
				if((save_flag & SAVE_OBJECTS) && !skip_objects)
					for(var/obj/thing in pull_from)
						CHECK_TICK

						if(isitem(thing))
							if((save_flag & SAVE_WHITELIST) && !(thing.type in GLOB.save_whitelist)) //we do hard types because its faster then ischecking
								continue
							else if(!(save_flag & SAVE_ITEMS))
								continue
						if(thing.type in obj_blacklist)
							continue

						//====HANDLE UUID STASIS SAVING====
						if((save_flag & SAVE_UUID_STASIS) && thing.UUID_saving)
							// Generate UUID if not present
							if(!thing.object_uuid)
								thing.object_uuid = generate_uuid()
							// Save object to stasis
							save_object_to_stasis(thing)
							// Include the object in the map with its UUID saved
							var/metadata = generate_tgm_metadata(thing)
							current_header += "[empty ? "" : ",\n"][thing.type][metadata]"
							empty = FALSE
							continue

						var/metadata = generate_tgm_metadata(thing)
						current_header += "[empty ? "" : ",\n"][thing.type][metadata]"
						empty = FALSE
						//====SAVING SPECIAL DATA====
						//This is what causes lockers and machines to save stuff inside of them
						if(save_flag & SAVE_OBJECT_PROPERTIES)
							var/custom_data = thing.on_object_saved()
							current_header += "[custom_data ? ",\n[custom_data]" : ""]"

				//====SAVING MOBS====
				if((save_flag & SAVE_MOBS) && !skip_objects)
					for(var/mob/living/thing in pull_from)
						CHECK_TICK
						if(istype(thing, /mob/living/carbon)) //Ignore people, but not animals
							continue
						var/metadata = generate_tgm_metadata(thing)
						current_header += "[empty ? "" : ",\n"][thing.type][metadata]"
						empty = FALSE

				current_header += "[empty ? "" : ",\n"][place],\n[location])\n"

				//====Fill the contents file====
				var/textiftied_header = current_header.Join()
				// If we already know this header just use its key, otherwise we gotta make a new one
				var/key = header_data[textiftied_header]
				if(!key)
					key = calculate_tgm_header_index(key_index, layers)
					key_index++
					header += "\"[key]\" = [textiftied_header]"
					header_data[textiftied_header] = key
				contents += "[key]\n"
			contents += "\"}"
	return "//[DMM2TGM_MESSAGE]\n[header.Join()][contents.Join()]"

/proc/generate_tgm_metadata(atom/object)
	var/list/data_to_add = list()

	var/list/vars_to_save = object.get_save_vars()
	for(var/variable in vars_to_save)
		CHECK_TICK
		var/value = object.vars[variable]
		if(value == initial(object.vars[variable]) || !issaved(object.vars[variable]))
			continue
		if(variable == "icon_state" && object.smoothing_flags)
			continue
		if(variable == "icon" && object.smoothing_flags)
			continue

		var/text_value = tgm_encode(value)
		if(!text_value)
			continue
		data_to_add += "[variable] = [text_value]"

	if(!length(data_to_add))
		return
	return "{\n\t[data_to_add.Join(";\n\t")]\n\t}"

// Could be inlined, not a massive cost tho so it's fine
/// Generates a key matching our index
/proc/calculate_tgm_header_index(index, key_length)
	var/list/output = list()
	// We want to stick the first one last, so we walk backwards
	var/list/pull_from = GLOB.save_file_chars
	var/length = length(pull_from)
	for(var/i in key_length to 1 step -1)
		var/calculated = FLOOR((index-1) / (length ** (i - 1)), 1)
		calculated = (calculated % length) + 1
		output += pull_from[calculated]
	return output.Join()
