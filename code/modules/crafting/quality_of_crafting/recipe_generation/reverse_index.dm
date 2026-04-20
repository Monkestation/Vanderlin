
/atom
	var/list/obtained_from

/// Global reverse map: "[source_path]" -> list of obtained_from_entry dicts
/// Each entry: list("name", "icon", "icon_state", "_path", "source_label")
GLOBAL_LIST_EMPTY(obtained_from_reverse)
GLOBAL_VAR_INIT(obtained_from_built, FALSE)
GLOBAL_LIST_EMPTY(mob_source_paths) // list of "[mob_typepath]" keys that have butcher drops
GLOBAL_LIST_EMPTY(chimeric_mob_sources) // "[chimeric_table_path]" -> list of mob icon entries

/proc/build_obtained_from_reverse()
	var/list/list = list()
	if(GLOB.obtained_from_built)
		return
	for(var/obj/item/item_type as anything in subtypesof(/obj/item))
		if(IS_ABSTRACT(item_type))
			continue
		if(!(initial(item_type.item_flags) & OBTAINED_DATA))
			continue
		var/obj/item/new_item = new item_type()
		var/list/sources = new_item.obtained_from
		if(!length(sources))
			continue
		for(var/list/entry as anything in sources)
			if(!islist(entry) || length(entry) < 2)
				continue
			var/label = entry[1]
			var/atom/src_path = entry[2]
			if(!ispath(src_path))
				continue
			var/key = "[src_path]"
			if(!list[key])
				list[key] = list()
			list[key] += list(list(
				"name" = initial(item_type.name),
				"icon" = "[initial(item_type.icon)]",
				"icon_state" = "[initial(item_type.icon_state)]",
				"_path" = "[item_type]",
				"source_label" = label,
			))
		qdel(new_item)
	// Mobs
	for(var/mob/living/mob_type as anything in subtypesof(/mob/living))
		if(IS_ABSTRACT(mob_type))
			continue
		if(!initial(mob_type.indexed))
			continue

		var/is_simple  = ispath(mob_type, /mob/living/simple_animal)
		var/mob/living/new_mob = new mob_type(locate(1,1,1))
		var/list/butcher_tiers
		if(is_simple)
			var/mob/living/simple_animal/simple = new_mob
			butcher_tiers = list(
				list("Butchery",         simple.butcher_results),
				list("Perfect Butchery", simple.perfect_butcher_results),
				list("Botched Butchery", simple.botched_butcher_results),
			)
		else
			butcher_tiers = list(
				list("Butchery", new_mob.butcher_results),
			)

		var/had_drops = FALSE
		for(var/list/tier as anything in butcher_tiers)
			var/tier_label = tier[1]
			var/list/drops = tier[2]
			if(!islist(drops) || !length(drops))
				continue
			for(var/drop_type as anything in drops)
				if(!ispath(drop_type))
					continue
				var/key = "[drop_type]"
				if(!list[key])
					list[key] = list()
				list[key] += list(list(
					"name"         = initial(mob_type.name),
					"icon"         = "[initial(mob_type.icon)]",
					"icon_state"   = "[initial(mob_type.icon_state)]",
					"_path"        = "[mob_type]",
					"source_label" = tier_label,
					"amount"       = drops[drop_type],
				))
				had_drops = TRUE

		if(had_drops)
			GLOB.mob_source_paths["[mob_type]"] = TRUE

		qdel(new_mob)

	var/static/list/blacklisted_types = list(
		/mob/living/simple_animal/hostile/retaliate/banker,
		/mob/living/simple_animal/hostile/retaliate/blacksmith,
		/mob/living/simple_animal/hostile/retaliate/voiddragon/red/tsere,
		/mob/living/simple_animal/hostile/retaliate/minotaur/axe,
		/mob/living/simple_animal/hostile/retaliate/minotaur/axe/female,
		/mob/living/simple_animal/hostile/dragon_clone,

	)
	for(var/mob/living/mob_type as anything in subtypesof(/mob/living/simple_animal) - typesof(/mob/living/simple_animal/hostile/skeleton) - typesof(/mob/living/simple_animal/hostile/retaliate/trader) - blacklisted_types)
		if(IS_ABSTRACT(mob_type))
			continue
		var/blood_path = initial(mob_type.animal_type) || /datum/blood_type/animal
		if(!blood_path)
			continue
		var/datum/blood_type/BT = GLOB.blood_types[blood_path]
		if(!BT?.used_table)
			continue
		var/table_key = "[BT.used_table.type]"
		if(!GLOB.chimeric_mob_sources[table_key])
			GLOB.chimeric_mob_sources[table_key] = list()
		GLOB.chimeric_mob_sources[table_key] += list(list(
			"name"       = initial(mob_type.name),
			"icon"       = "[initial(mob_type.icon)]",
			"icon_state" = "[initial(mob_type.icon_state)]",
			"_path"      = "[mob_type]",
		))

	GLOB.obtained_from_built = TRUE
	return list

/atom/return_recipe_data()
	if(!length(obtained_from))
		return null

	var/list/data = list()
	data["type"] = "obtained_from"
	data["name"] = name
	data["category"] = "Sources"
	data["_output_path"] = "[type]"
	data["output_name"] = name
	data["output_icon"] = "[icon]"
	data["output_state"] = "[icon_state]"

	var/list/sources = list()
	for(var/list/entry as anything in obtained_from)
		if(!islist(entry) || length(entry) < 2)
			continue
		var/label    = entry[1]
		var/atom/src_path = entry[2]
		sources += list(list(
			"label" = label,
			"_path" = "[src_path]",
			"name" = initial(src_path.name),
			"icon" = "[initial(src_path.icon)]",
			"icon_state" = "[initial(src_path.icon_state)]",
		))
	data["sources"] = sources

	return data
