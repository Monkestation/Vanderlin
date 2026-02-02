
/datum/map_template/proc/load_as_building(turf/T, centered = FALSE)
	var/obj/effect/building_outline/generated_image
	var/old_turf_x = T.x
	var/old_turf_y = T.y
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/offset_x = (T.x - old_turf_x) * 32
	var/offset_y = (T.y - old_turf_y) * 32

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	generated_image = parsed.load_as_image(offset_x, offset_y)
	return generated_image


/// Load the parsed map into the world. See [/proc/load_map] for arguments.
/datum/parsed_map/proc/load_as_image(x_offset, y_offset)
	//How I wish for RAII
	Master.StartLoadingMap()
	. = _load_as_image_impl(x_offset, y_offset)
	Master.StopLoadingMap()


// Do not call except via load() above.
/datum/parsed_map/proc/_load_as_image_impl(x_offset = 32, y_offset = 32)
	var/obj/effect/building_outline/generated_image = new
	var/list/areaCache = list()
	var/list/modelCache = build_cache(TRUE)
	var/space_key = modelCache["space"]
	var/list/bounds
	src.bounds = bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/x_num = 0
	for(var/I in gridSets)
		x_num++
		var/datum/grid_set/gset = I
		var/ycrd = gset.ycrd + (y_offset / 32) - 1
		var/zcrd = gset.zcrd
		var/zexpansion = zcrd > world.maxz
		if(zexpansion)
			continue
		var/y_num = 0
		for(var/line in gset.gridLines)
			var/y_change = -y_offset - (32 * y_num)
			y_num++
			if((ycrd - (y_offset / 32) + 1) < -INFINITY || (ycrd - (y_offset / 32) + 1) > INFINITY)				//Reverse operation and check if it is out of bounds of cropping.
				--ycrd
				continue
			if(ycrd <= world.maxy && ycrd >= -INFINITY)
				var/xcrd = gset.xcrd + x_offset - 1
				for(var/tpos = 1 to length(line) - key_len + 1 step key_len)
					var/x_change = x_offset + (32 * (x_num-1))
					if((xcrd - (x_offset / 32) + 1) < -INFINITY || (xcrd - (x_offset / 32) + 1) > INFINITY)			//Same as above.
						++xcrd
						continue								//X cropping.
					if(xcrd > world.maxx)
						break

					if(xcrd >= -INFINITY)
						var/model_key = copytext(line, tpos, tpos + key_len)
						var/no_afterchange = zexpansion
						if(!no_afterchange || (model_key != space_key))
							var/list/cache = modelCache[model_key]
							if(!cache)
								CRASH("Undefined model key in DMM: [model_key]")
							generated_image.add_overlay(build_coordinate_image(areaCache, cache, locate(xcrd, ycrd, zcrd), no_afterchange, FALSE, x_change, y_change))

							// only bother with bounds that actually exist
							bounds[MAP_MINX] = min(bounds[MAP_MINX], xcrd)
							bounds[MAP_MINY] = min(bounds[MAP_MINY], ycrd)
							bounds[MAP_MINZ] = min(bounds[MAP_MINZ], zcrd)
							bounds[MAP_MAXX] = max(bounds[MAP_MAXX], xcrd)
							bounds[MAP_MAXY] = max(bounds[MAP_MAXY], ycrd)
							bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], zcrd)
						#ifdef TESTING
						else
							++turfsSkipped
						#endif
						CHECK_TICK
					++xcrd
			--ycrd

		CHECK_TICK

	return generated_image


/datum/parsed_map/proc/build_coordinate_image(list/areaCache, list/model, turf/crds, no_changeturf as num, placeOnTop as num, offset_x, offset_y)
	var/obj/effect/overlay = new
	var/index
	var/list/members = model[1]
	var/list/members_attributes = model[2]

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//turn off base new Initialization until the whole thing is loaded
	SSatoms.map_loader_begin()
	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		var/mutable_appearance/returned = instance_atom_image(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf,placeOnTop, offset_x, offset_y)
		returned.pixel_y += offset_y
		returned.pixel_x += offset_x
		overlay.add_overlay(returned)

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= members.len - 1) // Last item is an /area
			var/mutable_appearance/returned = instance_atom_image(members[index],members_attributes[index],crds,no_changeturf,placeOnTop)
			returned.pixel_y += offset_y
			returned.pixel_x += offset_x
			overlay.add_overlay(returned)
			index++

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		var/mutable_appearance/returned = instance_atom_image(members[index],members_attributes[index],crds,no_changeturf,placeOnTop)
		returned.pixel_y += offset_y
		returned.pixel_x += offset_x
		overlay.add_overlay(returned)
	//Restore initialization to the previous value
	SSatoms.map_loader_stop()
	return overlay

//Instance an atom at (x,y,z) and gives it the variables in attributes
/datum/parsed_map/proc/instance_atom_image(atom/path,list/attributes, turf/crds, no_changeturf, placeOnTop)
	world.preloader_setup(attributes, path)

	if(ispath(path, /turf))
		if(placeOnTop)
			var/mutable_appearance/MA = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER, plane = ABOVE_LIGHTING_PLANE)

			var/initial_flags = initial(path.smoothing_flags)
			if(initial_flags & USES_BITMASK_SMOOTHING)
				MA.icon_state = "[initial(path.icon_state)]-0"

			if("pixel_x" in attributes)
				MA.pixel_x = attributes["pixel_x"]
			if("pixel_y" in attributes)
				MA.pixel_y = attributes["pixel_y"]
			if("dir" in attributes)
				MA.dir = attributes["dir"]
			. = MA
		else if(!no_changeturf)
			var/mutable_appearance/MA = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER + 0.5, plane = ABOVE_LIGHTING_PLANE)

			var/initial_flags = initial(path.smoothing_flags)
			if(initial_flags & USES_BITMASK_SMOOTHING)
				MA.icon_state = "[initial(path.icon_state)]-0"

			if("pixel_x" in attributes)
				MA.pixel_x = attributes["pixel_x"]
			if("pixel_y" in attributes)
				MA.pixel_y = attributes["pixel_y"]
			if("dir" in attributes)
				MA.dir = attributes["dir"]
			. = MA
		else
			var/mutable_appearance/MA = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER + 0.5, plane = ABOVE_LIGHTING_PLANE)

			var/initial_flags = initial(path.smoothing_flags)
			if(initial_flags & USES_BITMASK_SMOOTHING)
				MA.icon_state = "[initial(path.icon_state)]-0"

			if("pixel_x" in attributes)
				MA.pixel_x = attributes["pixel_x"]
			if("pixel_y" in attributes)
				MA.pixel_y = attributes["pixel_y"]
			if("dir" in attributes)
				MA.dir = attributes["dir"]
			. = MA
	else
		var/mutable_appearance/MA = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER + 0.5, plane = ABOVE_LIGHTING_PLANE)
		if("pixel_x" in attributes)
			MA.pixel_x = attributes["pixel_x"]
		if("pixel_y" in attributes)
			MA.pixel_y = attributes["pixel_y"]
		if("dir" in attributes)
			MA.dir = attributes["dir"]
		. = MA

