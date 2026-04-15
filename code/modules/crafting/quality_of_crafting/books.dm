/// Global cache of typepath -> return_recipe_data() results.
/// null values are cached too so we never re-check a path.
/// Key is "[typepath]", value is the list() or null.
GLOBAL_LIST_EMPTY(recipe_data_cache)

/// Reverse mill index: mill_result path -> list of source snack paths.
/// Built once on first recipe book open, before any cache lookups.
GLOBAL_LIST_INIT(snack_mill_reverse, ensure_snack_mill_reverse())
GLOBAL_LIST_INIT(snack_slice_reverse, ensure_snack_slice_reverse())

/proc/ensure_snack_slice_reverse()
	var/list/list = list()
	for(var/obj/item/reagent_containers/food/snacks/snack_type as anything in subtypesof(/obj/item/reagent_containers/food/snacks))
		if(IS_ABSTRACT(snack_type)) continue
		var/atom/slice = initial(snack_type.slice_path)
		if(!slice) continue
		if(!list[slice])
			list[slice] = list()
		list[slice] += snack_type
	return list

/proc/ensure_snack_mill_reverse()
	var/list/list = list()
	for(var/obj/item/reagent_containers/food/snacks/snack_type as anything in subtypesof(/obj/item/reagent_containers/food/snacks))
		if(IS_ABSTRACT(snack_type)) continue
		var/atom/mill = initial(snack_type.mill_result)
		if(!mill) continue
		if(!list[mill])
			list[mill] = list()
		list[mill] += snack_type
	return list

// Per-book recipe list cache (sidebar entries)
GLOBAL_LIST_EMPTY(book_recipe_cache)
// Per-book linked recipe cache (passes 2-4)
GLOBAL_LIST_EMPTY(linked_recipe_cache)

// recipe_info_path, set this on any /atom to redirect hyperlink
// lookups to a different typepath's return_recipe_data().
// Example: /obj/item/ore/iron { recipe_info_path = /datum/ore_source/iron }
// Example: /obj/item/hammer   { recipe_info_path = /obj/item/recipe_book/blacksmithing }
// When null the atom's own return_recipe_data() is called directly.
/atom/var/recipe_info_path

/obj/item/recipe_book

	icon = 'icons/roguetown/items/books.dmi'
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64
	slot_flags = ITEM_SLOT_HIP
	item_weight = 493 GRAMS
	var/list/types = list()
	var/open
	var/can_spawn = TRUE
	var/current_category = "All"      // Default selected category
	var/current_recipe = null         // Currently viewed recipe
	var/search_query = ""             // Current search query

/obj/item/recipe_book/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "RecipeBook", name)
		ui.open()

/obj/item/recipe_book/attack_self(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/item/recipe_book/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()
	data["book_name"] = name
	data["book_desc"] = desc
	ensure_snack_mill_reverse()
	build_obtained_from_reverse()
	data["recipes"] = get_cached_book_recipes(type, FALSE)
	data["linked_recipes"] = get_cached_linked_recipes(type)
	return data

/obj/item/recipe_book/proc/get_cached_book_recipes(book_type, creation = TRUE)
	if(GLOB.book_recipe_cache["[book_type]"])
		return GLOB.book_recipe_cache["[book_type]"]

	var/obj/item/recipe_book/new_book = src
	if(creation)
		new_book = new book_type()
	var/list/recipes = list()
	for(var/atom/path as anything in new_book.types)
		if(IS_ABSTRACT(path))
			for(var/atom/sub as anything in subtypesof(path))
				if(IS_ABSTRACT(sub)) continue
				if(ispath(sub, /datum/container_craft))
					var/datum/container_craft/sub2 = sub
					if(initial(sub2:hides_from_books))
						continue
				if(ispath(sub, /datum/repeatable_crafting_recipe))
					var/datum/repeatable_crafting_recipe/sub2 = sub
					if(initial(sub2:hides_from_books))
						continue
				if(ispath(sub, /datum/wound))
					var/datum/wound/sub2 = sub
					if(!initial(sub2:show_in_book))
						continue
				var/list/entry = get_cached_recipe_data(sub)
				if(entry) recipes += list(entry)
		else
			var/list/entry = get_cached_recipe_data(path)
			if(entry) recipes += list(entry)

	GLOB.book_recipe_cache["[book_type]"] = recipes
	if(creation)
		qdel(new_book)
	return recipes

/obj/item/recipe_book/proc/get_cached_linked_recipes(book_type)
	if(GLOB.linked_recipe_cache["[book_type]"])
		return GLOB.linked_recipe_cache["[book_type]"]

	var/list/visited = list()
	for(var/list/entry as anything in get_cached_book_recipes(book_type))
		var/p = entry["_output_path"]
		if(p) visited[p] = TRUE

	var/list/linked = list()
	var/list/scan_queue = list()

	for(var/obj/item/recipe_book/other_type as anything in subtypesof(/obj/item/recipe_book))
		if(other_type == book_type) continue
		if(!initial(other_type.can_spawn)) continue
		for(var/list/entry as anything in get_cached_book_recipes(other_type))
			var/p = entry["_output_path"]
			if(p && visited[p]) continue
			if(p) visited[p] = TRUE
			linked += list(entry)

	for(var/list/entry as anything in get_cached_book_recipes(book_type) + linked)
		queue_item_paths_from_entry(entry, scan_queue, visited)

	while(length(scan_queue))
		var/atom/item_path = scan_queue[1]
		scan_queue.Cut(1, 2)
		var/list/entry = get_cached_recipe_data(item_path)
		if(!entry) continue
		linked += list(entry)
		queue_item_paths_from_entry(entry, scan_queue, visited)

	for(var/key in GLOB.mob_source_paths)
		var/atom/mob_path = text2path(key)
		if(!mob_path || visited["[mob_path]"]) continue
		visited["[mob_path]"] = TRUE
		var/list/entry = get_mob_source_page_data(mob_path)
		if(!entry) continue
		linked += list(entry)
		queue_item_paths_from_entry(entry, scan_queue, visited)

	for(var/key in GLOB.obtained_from_reverse)
		var/atom/src_path = text2path(key)
		if(!src_path) continue
		visited["[src_path]"] = TRUE
		var/list/entry = get_source_page_data(src_path)
		if(entry)
			linked += list(entry)
			continue
		var/list/entries = GLOB.obtained_from_reverse[key]
		var/has_mob_source = FALSE
		for(var/list/checker as anything in entries)
			if(GLOB.mob_source_paths[checker["_path"]])
				has_mob_source = TRUE
				break
		if(!has_mob_source)
			continue
		var/list/existing = get_cached_recipe_data(src_path)
		if(existing)
			continue
		var/list/sources = list()
		for(var/list/mob_entry as anything in entries)
			if(!GLOB.mob_source_paths[mob_entry["_path"]])
				continue
			sources += list(list(
				"label"      = mob_entry["source_label"],
				"_path"      = mob_entry["_path"],
				"name"       = mob_entry["name"],
				"icon"       = mob_entry["icon"],
				"icon_state" = mob_entry["icon_state"],
			))
		if(!length(sources))
			continue
		var/list/page = list(
			"type"         = "obtained_from",
			"name"         = initial(src_path.name),
			"category"     = "Sources",
			"_output_path" = "[src_path]",
			"output_name"  = initial(src_path.name),
			"output_icon"  = "[initial(src_path.icon)]",
			"output_state" = "[initial(src_path.icon_state)]",
			"sources"      = sources,
		)
		GLOB.recipe_data_cache["[src_path]"] = page
		linked += list(page)

	GLOB.linked_recipe_cache["[book_type]"] = linked
	return linked

/obj/item/recipe_book/proc/get_source_page_data(atom/src_path)
	var/list/drops = GLOB.obtained_from_reverse["[src_path]"]
	if(!length(drops)) return null
	return list(
		"type"         = "source_page",
		"name"         = initial(src_path.name),
		"category"     = "Sources",
		"_output_path" = "[src_path]",
		"output_name"  = initial(src_path.name),
		"output_icon"  = "[initial(src_path.icon)]",
		"output_state" = "[initial(src_path.icon_state)]",
		"drops"        = drops,
	)

/obj/item/recipe_book/proc/get_mob_source_page_data(atom/mob_path)
	var/list/drops = list()
	for(var/key in GLOB.obtained_from_reverse)
		var/list/entries = GLOB.obtained_from_reverse[key]
		for(var/list/entry as anything in entries)
			if(entry["_path"] != "[mob_path]")
				continue
			var/atom/drop_path = text2path(key)
			if(!drop_path)
				continue
			drops += list(list(
				"name"         = initial(drop_path.name),
				"icon"         = "[initial(drop_path.icon)]",
				"icon_state"   = "[initial(drop_path.icon_state)]",
				"_path"        = "[drop_path]",
				"source_label" = entry["source_label"],
				"amount"       = entry["amount"],
			))

	if(!length(drops))
		return null

	return list(
		"type"         = "source_page",
		"name"         = initial(mob_path.name),
		"category"     = "Sources",
		"_output_path" = "[mob_path]",
		"output_name"  = initial(mob_path.name),
		"output_icon"  = "[initial(mob_path.icon)]",
		"output_state" = "[initial(mob_path.icon_state)]",
		"drops"        = drops,
	)

/// Returns cached recipe data for a typepath, computing and caching it if needed.
/// Respects recipe_info_path, if the atom declares a redirect, that path is
/// used instead so e.g. a hammer can point to the blacksmithing book entry. This is useful for abstract types we direct to
/obj/item/recipe_book/proc/get_cached_recipe_data(atom/path)
	// Resolve any recipe_info_path redirect first
	var/atom/redirect = initial(path.recipe_info_path)
	var/resolved = redirect ? redirect : path

	var/key = "[resolved]"
	if(key in GLOB.recipe_data_cache)
		return GLOB.recipe_data_cache[key]
	var/datum/R = new resolved(locate(1,1,1))//this is incase we create a mob
	var/list/entry = R.return_recipe_data()
	qdel(R)
	GLOB.recipe_data_cache[key] = entry
	return entry

/// Scans a serialized recipe entry for all embedded "_path" keys and queues
/// any typepath that hasn't been visited yet.
/obj/item/recipe_book/proc/queue_item_paths_from_entry(list/entry, list/queue, list/visited)
	// List fields, each element may be a dict with a "_path" key
	var/list/list_fields = list("requirements","tools","extras","materials","items","crops","opt_items","steps","output_items","sources")
	for(var/field in list_fields)
		var/list/items = entry[field]
		if(!islist(items)) continue
		for(var/list/item as anything in items)
			if(!islist(item)) continue
			_try_queue_path(item["_path"], queue, visited)

	// Singular path fields
	var/list/path_fields = list("_output_path","_starting_path","_attacked_path","_bar_path","_base_path","_target_path","_result_path","_container_path","mill_path","slice_path")
	for(var/field in path_fields)
		_try_queue_path(entry[field], queue, visited)

/obj/item/recipe_book/proc/_try_queue_path(path_str, list/queue, list/visited)
	if(!path_str) return
	var/atom/p = text2path(path_str)
	if(!p || visited[p]) return
	// Check if the item itself declares a recipe_info_path redirect
	var/atom/redirect = initial(p.recipe_info_path)
	var/atom/target = redirect ? redirect : p
	if(visited[target]) return
	visited[target] = TRUE
	queue += target

/obj/item/recipe_book/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/recipe_book/leatherworking
	name = "The Tanned Hide Tome: Mastery of Leather and Craft"
	desc = "Penned by Orym Vaynore, Fourth Generation Leatherworker."
	icon_state ="book8_0"
	base_icon_state = "book8"

	types = list(/datum/repeatable_crafting_recipe/leather)

/obj/item/recipe_book/sewing
	name = "Threads of Destiny: A Tailor's Codex"
	desc = "Penned by Elise Heiran, Second Generation Court Tailor."
	icon_state ="book7_0"
	base_icon_state = "book7"

	types = list(
		/datum/book_entry/sewing_repair,
		/datum/repeatable_crafting_recipe/sewing,
		/datum/orderless_slapcraft/bouquet,
		)

/obj/item/recipe_book/sewing_leather
	can_spawn = FALSE
	name = "High Fashion Encyclopedia"
	desc = "The combined works of famed Elise Heiran and Orym Vayore."
	icon_state ="book7_0"
	base_icon_state = "book7"
	types = list(
		/datum/book_entry/sewing_repair,
		/datum/repeatable_crafting_recipe/sewing,
		/datum/orderless_slapcraft/bouquet,
		/datum/repeatable_crafting_recipe/leather,
		)

/obj/item/recipe_book/cooking
	name = "The Hearthstone Grimoire: Culinary Secrets of the Realm"
	desc = "Penned by Aric Dunswell, Head Court Chef, Third Generation."
	icon_state ="book6_0"
	base_icon_state = "book6"

	types = list(
		/datum/book_entry/container_craft,
		/datum/brewing_recipe,
		/datum/container_craft/cooking,
		/datum/container_craft/oven,
		/datum/container_craft/pan,
		/datum/repeatable_crafting_recipe/cooking,
		/datum/repeatable_crafting_recipe/salami,
		/datum/repeatable_crafting_recipe/coppiette,
		/datum/repeatable_crafting_recipe/salo,
		/datum/repeatable_crafting_recipe/saltfish,
		/datum/repeatable_crafting_recipe/raisins,
		/datum/orderless_slapcraft/food/pie,
		/datum/orderless_slapcraft/food/tart.
	)

/obj/item/recipe_book/survival
	name = "The Wilderness Guide: Secrets of Survival"
	desc = "Penned by Kaelen Stormrider, Fourth Generation Trailblazer."
	icon_state ="book5_0"
	base_icon_state = "book5"

	types = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/datum/repeatable_crafting_recipe/survival,
		/datum/repeatable_crafting_recipe/cooking/soap,
		/datum/repeatable_crafting_recipe/cooking/soap/bath,
		/datum/repeatable_crafting_recipe/fishing,
		/datum/repeatable_crafting_recipe/sigsweet,
		/datum/repeatable_crafting_recipe/sigdry,
		/datum/repeatable_crafting_recipe/dryleaf,
		/datum/repeatable_crafting_recipe/westleach,
		/datum/repeatable_crafting_recipe/salami,
		/datum/repeatable_crafting_recipe/coppiette,
		/datum/repeatable_crafting_recipe/salo,
		/datum/repeatable_crafting_recipe/saltfish,
		/datum/repeatable_crafting_recipe/raisins,
		/datum/repeatable_crafting_recipe/parchment,
		/datum/repeatable_crafting_recipe/crafting,
		/datum/repeatable_crafting_recipe/projectile,
	)

/obj/item/recipe_book/underworld
	name = "The Smuggler’s Guide: A Treatise on Elixirs of the Guild"
	desc = "Penned by Thorne Ashveil, Thieves' Guild's Alchemist, Second Generation."
	icon_state ="book4_0"
	base_icon_state = "book4"
	can_spawn = FALSE

	types = list(
		/datum/repeatable_crafting_recipe/narcotics,
		/datum/container_craft/cooking/drugs,
		/datum/repeatable_crafting_recipe/bomb,
	)

/obj/item/recipe_book/carpentry
	name = "The Woodwright's Codex: Crafting with Timber and Grain"
	desc = "Penned by Eadric Hollowell, Master Carpenter, Fourth Generation."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/blueprint_recipe/carpentry,
	)

/obj/item/recipe_book/engineering
	name = "The Engineer’s Primer: Machines, Mechanisms, and Marvels"
	desc = "Penned by Liora Brasslock, Chief Engineer, Second Generation."
	icon_state ="book2_0"
	base_icon_state = "book2"

	types = list(
		/datum/book_entry/rotation_stress,
		/datum/book_entry/water_pressure,
		/datum/repeatable_crafting_recipe/engineering,
		/datum/blueprint_recipe/engineering,
		/datum/artificer_recipe,
		/datum/orderless_slapcraft/automaton,
	)

/obj/item/recipe_book/masonry
	name = "The Stonebinder’s Manual: Foundations of Craft and Fortitude"
	desc = "Penned by Garrin Ironvein, Master Mason, Third Generation."
	icon_state ="book_0"
	base_icon_state = "book"

	types = list(
		/datum/pottery_recipe,
		/datum/blueprint_recipe/masonry,
		/datum/slapcraft_recipe/masonry,
	)

/obj/item/recipe_book/art
	name = "The Artisan's Palette"
	desc = "Created by Elara Moondance, Visionary Painter and Esteemed Tutor."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/repeatable_crafting_recipe/canvas,
		/datum/repeatable_crafting_recipe/paint_palette,
		/datum/repeatable_crafting_recipe/paintbrush,
		/datum/blueprint_recipe/carpentry/easel,
		/datum/repeatable_crafting_recipe/parchment,
		/datum/repeatable_crafting_recipe/crafting/scroll,
		/datum/repeatable_crafting_recipe/reading/guide,
	)

/obj/item/recipe_book/blacksmithing
	name = "The Smith’s Legacy"
	desc = "Penned by Aldric Forgeheart, Master Blacksmith and Keeper of the Ancestral Flame."
	icon_state ="book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/book_entry/smithing_repair,
		/datum/molten_recipe,
		/datum/anvil_recipe,
	)

/obj/item/recipe_book/arcyne
	name = "The Arcanum of Arcyne"
	desc = "Penned by Elyndor Starforge, Grand Arcanist and Keeper of the Ethereal Crucible."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/grimoire,
		/datum/book_entry/attunement,
		/datum/book_entry/mana_sources,
		/datum/repeatable_crafting_recipe/arcyne,
		/datum/blueprint_recipe/arcyne,
		/datum/container_craft/cooking/arcyne,
		/datum/runerituals,
	)


/obj/item/recipe_book/alchemy
	name = "Codex Virellia"
	desc = "Transcribed by Maerion Duskwind, Avid Hater of Gnomes."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/gnome_homunculus,
		/datum/book_entry/essence_crafting,
		/datum/alch_cauldron_recipe,
		/datum/essence_combination,
		/datum/natural_precursor,
		/datum/essence_infusion_recipe,
		/datum/container_craft/cooking/herbal_salve,
		/datum/container_craft/cooking/herbal_tea,
		/datum/container_craft/cooking/herbal_oil,
		/datum/blueprint_recipe/alchemy,
		/datum/repeatable_crafting_recipe/alchemy,
	)

// Shown when MMBing the /atom/movable/screen/craft "craft" HUD element
/obj/item/recipe_book/always_known
	name = "Survival"
	can_spawn = FALSE
	types = list(
		/datum/repeatable_crafting_recipe/survival)

/obj/item/recipe_book/agriculture
	name = "The Farmers Almanac: Principles of Growth and Harvest"
	desc = "Compiled by Elira Greenshade."
	icon_state = "book_0"
	base_icon_state = "book"

	types = list(
		/datum/book_entry/farming_basics,
		/datum/book_entry/soil_management,
		/datum/book_entry/plant_families,
		/datum/book_entry/plant_genetics,
		/datum/plant_def,
		/datum/repeatable_crafting_recipe/bee_treatment,
		/datum/repeatable_crafting_recipe/bee_treatment/antiviral,
		/datum/repeatable_crafting_recipe/bee_treatment/miticide,
		/datum/repeatable_crafting_recipe/bee_treatment/insecticide,
		/datum/blueprint_recipe/carpentry/apiary,
		/datum/repeatable_crafting_recipe/survival/mushmound,
	)

/obj/item/recipe_book/medical
	name = "The Feldsher's Handbook: Field Medicine and Improvised Care"
	desc = "Compiled by Grim the fickle."
	icon_state ="book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/grims_guide,
		/datum/book_entry/cavity_access,
		/datum/book_entry/organ_surgery,
		/datum/book_entry/lobotomy,
		/datum/book_entry/pestran_chimeric,
		/datum/chimeric_table,
		/datum/chimeric_node,
		/datum/wound,
		/datum/surgery,
		/obj/item/organ/heart,
		/obj/item/organ/spleen,
		/obj/item/organ/stomach,
		/obj/item/organ/lungs,
		/obj/item/organ/eyes,
		/obj/item/organ/ears,
		/obj/item/organ/liver,
		/obj/item/organ/tail,
		/obj/item/organ/brain,
		/obj/item/organ/tongue,
		/obj/item/organ/appendix,
	)
