/datum/blueprint_slot
	var/datum/blueprint_recipe/recipe
	var/pixel_x = 0
	var/pixel_y = 0
	var/dir = SOUTH
	var/x_offset = 0
	var/y_offset = 0
	var/z_offset = 0

/datum/building_preview
	var/datum/map_template/template
	var/mutable_appearance/preview_MA
	var/list/blueprint_slots = list()

/datum/building_preview/proc/load_from_template(datum/map_template/T)
	template = T
	var/datum/parsed_map/parsed = T.cached_map || new(file(T.mappath))
	var/list/modelCache = parsed.build_cache(TRUE)
	var/space_key = modelCache["space"]

	var/obj/effect/building_outline/generated = new
	var/list/areaCache = list()

	var/center_x = round(T.width / 2)
	var/center_y = round(T.height / 2)

	// Find origin (top-left corner) from the first z=1 gridset.
	var/datum/grid_set/first_gset
	for(var/gset_item in parsed.gridSets)
		var/datum/grid_set/gset = gset_item
		if(gset.zcrd == 1)
			first_gset = gset
			break

	if(!first_gset)
		qdel(generated)
		return

	var/origin_xcrd = first_gset.xcrd
	var/origin_ycrd = first_gset.ycrd

	Master.StartLoadingMap()
	for(var/gset_item in parsed.gridSets)
		var/datum/grid_set/gset = gset_item
		var/zcrd = gset.zcrd

		var/ycrd = gset.ycrd
		for(var/line in gset.gridLines)
			var/xcrd = gset.xcrd

			for(var/tpos = 1 to length(line) - parsed.key_len + 1 step parsed.key_len)
				var/model_key = copytext(line, tpos, tpos + parsed.key_len)

				if(model_key != space_key)
					var/list/cache = modelCache[model_key]
					if(cache)
						var/list/members = cache[1]
						var/list/members_attributes = cache[2]

						if(zcrd == 1)
							var/x_change = (xcrd - origin_xcrd - center_x) * 32
							var/y_change = (origin_ycrd - ycrd - center_y) * 32

							var/mutable_appearance/tile_MA = parsed.build_coordinate_image(
								areaCache,
								cache,
								locate(xcrd, ycrd, zcrd),
								FALSE,
								FALSE,
								x_change,
								y_change
							)
							if(tile_MA)
								generated.add_overlay(tile_MA)

						// Blueprint slots: scan every member for a recipe.
						// Pass 1: non-turf atoms. Collect ALL matches (multiple per tile allowed).
						var/list/found_pairs = list()
						for(var/i in 1 to members.len)
							var/atom/path = members[i]
							if(!ispath(path) || ispath(path, /area) || ispath(path, /turf))
								continue
							var/datum/blueprint_recipe/R = find_recipe_for_type(path)
							if(R)
								found_pairs += list(list(R, i))

						// Pass 2: turfs, always run, a tile can have both object and turf recipes.
						for(var/i in 1 to members.len)
							var/atom/path = members[i]
							if(!ispath(path, /turf))
								continue
							if(ispath(path, /turf/template_noop))
								break
							var/datum/blueprint_recipe/R = find_recipe_for_type(path)
							if(R)
								found_pairs += list(list(R, i))
							break

						for(var/pair in found_pairs)
							var/datum/blueprint_recipe/found_recipe = pair[1]
							var/found_index = pair[2]

							var/datum/blueprint_slot/slot = new
							slot.recipe = found_recipe
							// Offsets are the tile index from origin, shifted by center so that
							// the center tile gets offset 0,0 — matching the image pixel math.
							slot.x_offset = (xcrd - origin_xcrd) - center_x
							slot.y_offset = (origin_ycrd - ycrd) - center_y
							slot.z_offset = zcrd - 1

							var/list/attrs = members_attributes[found_index]
							if(attrs)
								if("pixel_x" in attrs) slot.pixel_x = attrs["pixel_x"]
								if("pixel_y" in attrs) slot.pixel_y = attrs["pixel_y"]
								if("dir" in attrs) slot.dir = attrs["dir"]

							blueprint_slots += slot

				xcrd++
			ycrd--

	Master.StopLoadingMap()

	generated.alpha = 190
	generated.color = COLOR_CYAN
	preview_MA = new
	preview_MA.appearance = generated.appearance
	qdel(generated)

/datum/building_preview/proc/find_recipe_for_type(atom/path)
	var/datum/blueprint_recipe/best_match = null
	for(var/name in GLOB.blueprint_recipes)
		var/datum/blueprint_recipe/R = GLOB.blueprint_recipes[name]
		if(!ispath(path, R.result_type))
			continue
		if(!best_match)
			best_match = R
			continue
		if(ispath(R.result_type, best_match.result_type))
			best_match = R
	return best_match

/datum/building_preview/proc/place_blueprints(turf/origin, mob/placer)
	if(!length(blueprint_slots))
		to_chat(placer, span_warning("No valid blueprint positions found in this schematic."))
		return null

	var/list/placed = list()
	for(var/datum/blueprint_slot/slot in blueprint_slots)
		var/target_z = origin.z + slot.z_offset
		if(target_z < 1 || target_z > world.maxz)
			continue

		var/turf/target = locate(
			origin.x + slot.x_offset,
			origin.y + slot.y_offset,
			target_z
		)
		if(!target)
			continue

		var/obj/structure/blueprint/BP = new(target)
		BP.recipe = slot.recipe
		BP.creator = placer
		BP.time_when_placed = world.time
		BP.stored_pixel_x = slot.pixel_x
		BP.stored_pixel_y = slot.pixel_y
		BP.blueprint_dir = slot.recipe.supports_directions ? placer.dir : slot.dir
		BP.setup_blueprint()
		placed += BP

	to_chat(placer, span_notice("You roll out the schematic, marking [length(placed)] construction point[length(placed) != 1 ? "s" : ""]."))
	return placed
