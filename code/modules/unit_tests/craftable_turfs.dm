/datum/unit_test/turf_coverage/Run()
	var/list/all_turfs = subtypesof(/turf)
	var/list/all_blueprint_recipes = subtypesof(/datum/blueprint_recipe)
	var/list/used_turfs = list()

	for(var/recipe_type in all_blueprint_recipes)
		var/datum/blueprint_recipe/recipe = new recipe_type()
		if(recipe.result_type && ispath(recipe.result_type, /turf))
			used_turfs |= recipe.result_type
		qdel(recipe)

	var/list/blacklisted_turfs = list(
		/turf/closed,
		/turf/closed/splashscreen,
		/turf/open/floor,
		/turf/open,
		/turf/open/floor/grass/hell,
		/turf/open/floor/grass/eora,
		/turf/open/floor/dirt/ambush,
		/turf/open/floor/cobble/snow,
		/turf/open/floor/volcanic,
		/turf/open/floor/blocks/snow,
		/turf/open/transparent,
		/turf/open/transparent/openspace,
		/turf/baseturf_skipover,
		/turf/baseturf_bottom,
		/turf/closed/basic,
		/turf/open/floor/cobblerock/snow,
		/turf/open/floor/plasteel,
		/turf/open/floor/naturalstone,
		/turf/open/floor/plank/h,
		/turf/open/floor/plank,
		/turf/closed/wall,
		/turf/open/floor/sandstone,
		/turf/closed/transparent,
		/turf/closed/dungeon_void,
		/turf/closed/sea_fog,
		/turf/template_noop,
		/turf/closed/wall/mineral/underbrick/fake_world,
		/turf/closed/wall/mineral,
		/turf/closed/wall/mineral/stonebrick/reddish,
		/turf/closed/wall/mineral/decostone/cand/reddish,
		/obj/structure/stairs/stone/reddish,
		/turf/closed/wall/mineral/roofwall,
		/turf/closed/wall/mineral/abyssal,
		/turf/closed/wall/mineral/desert_soapstone,
		/turf/open/floor/cracked_earth,
		/turf/open/floor/flesh,
		/turf/open/dungeon_trap,
	) \
	+ typesof(/turf/open/floor/mushroom) \
	+ typesof(/turf/open/floor/sandstone_tile) \
	+ typesof(/turf/open/floor/abyss_sand) \
	+ typesof(/turf/open/floor/sand) \
	+ typesof(/turf/open/floor/abyss_tile) \
	+ typesof(/turf/closed/indestructible) \
	+ typesof(/turf/closed/wall/mineral/decostone/fluffstone) \
	+ typesof(/turf/open/floor/plasteel/maniac) \
	+ typesof(/turf/closed/mineral) \
	+ typesof(/turf/open/floor/underworld) \
	+ typesof(/turf/open/floor/snow) \
	+ typesof(/turf/open/floor/woodturned/nosmooth) \
	+ typesof(/turf/open/floor/wood/nosmooth) \
	+ typesof(/turf/open/water) \
	+ typesof(/turf/open/lava) \
	+ typesof(/turf/open/floor/carpet) \
	+ typesof(/turf/closed/wall/mineral/desert_sandstone)
	used_turfs |= blacklisted_turfs

	// Find unused turfs
	var/list/unused_turfs = list()
	for(var/turf_type in all_turfs)
		if(!(turf_type in used_turfs))
			unused_turfs += turf_type

	var/unused_list = ""
	for(var/i = 1; i <= unused_turfs.len; i++)
		unused_list += "[unused_turfs[i]]"
		if(i < unused_turfs.len)
			unused_list += ", "

	TEST_ASSERT(!length(unused_turfs), "The following turfs are not used by any blueprint recipe or in the blacklist: [unused_list]")
