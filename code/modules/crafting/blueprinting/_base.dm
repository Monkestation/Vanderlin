GLOBAL_LIST_EMPTY(blueprint_appearance_cache)
GLOBAL_LIST_EMPTY(active_blueprints)
GLOBAL_LIST_EMPTY(blueprint_recipes)

#define BLUEPRINT_SWITCHSTATE_NONE 0
#define BLUEPRINT_SWITCHSTATE_RECIPES 1

/proc/init_blueprint_recipes()
	if(GLOB.blueprint_recipes.len)
		return
	for(var/datum/blueprint_recipe/recipe as anything in subtypesof(/datum/blueprint_recipe))
		if(IS_ABSTRACT(recipe))
			continue
		GLOB.blueprint_recipes[initial(recipe.name)] = new recipe

/datum/blueprint_recipe
	var/name = "Unknown Structure"
	var/desc = "A mysterious structure."
	var/atom/result_type = null // What gets built
	var/list/required_materials = list() // Materials needed (path = amount)
	var/atom/construct_tool
	var/build_time = 2 SECONDS
	var/category = "General"
	var/supports_directions = FALSE // Whether this recipe can be rotated
	var/default_dir = SOUTH // Default direction for the recipe
	///do we take up the whole floor?
	var/floor_object = FALSE

	var/datum/attribute/skill/skillcraft = /datum/attribute/skill/craft/crafting // What skill this recipe requires (e.g., /datum/attribute/skill/craft/carpentry)
	var/craftdiff = 0 // Difficulty modifier (0 = easy, higher = harder)
	var/verbage = "construct" // What the user does (e.g., "build", "assemble")
	var/verbage_tp = "constructs" // Third person version
	var/craftsound = 'sound/foley/bandage.ogg'
	var/edge_density = TRUE
	var/requires_learning = FALSE
	var/pixel_offsets = TRUE
	var/check_placement = FALSE // Whether to run placement checks
	var/check_above_space = FALSE // Check if space above is clear
	var/check_adjacent_wall = FALSE // Check for adjacent wall
	var/requires_ceiling = FALSE
	var/place_on_wall = FALSE /// do we need to be placed directly on the wall turf itself and then offset?
	var/inverse_check = FALSE

/datum/blueprint_recipe/proc/check_craft_requirements(mob/user, turf/T, obj/structure/blueprint/blueprint)
	if(check_above_space)
		var/turf/checking = GET_TURF_ABOVE(T)
		if(!isopenspace(checking))
			return FALSE

	if(requires_ceiling)
		var/turf/checking = GET_TURF_ABOVE(T)
		if(!checking)
			to_chat(user, "<span class='warning'>Need a ceiling above to hang this!</span>")
			return FALSE
		if(istype(checking, /turf/open/openspace))
			to_chat(user, "<span class='warning'>Need a solid ceiling above!</span>")
			return FALSE

	if(check_placement)
		if(locate(/obj/machinery/light/fueled/lanternpost) in T)
			to_chat(user, "<span class='warning'>There's already a light post here!</span>")
			return FALSE
		if(locate(/obj/machinery/light/fueledstreet) in T)
			to_chat(user, "<span class='warning'>There's already a street lamp here!</span>")
			return FALSE
		if(locate(/obj/structure/noose) in T)
			to_chat(user, "<span class='warning'>There's already a noose here!</span>")
			return FALSE

	if(check_adjacent_wall)
		var/turf/check_turf = get_step(T, blueprint.blueprint_dir)
		if(inverse_check)
			check_turf = get_step(T, REVERSE_DIR(blueprint.blueprint_dir))
		if(!isclosedturf(check_turf))
			to_chat(user, "<span class='warning'>Need a wall to attach this to!</span>")
			return FALSE
	return TRUE

/mob
	var/datum/blueprint_system/blueprints

/mob/proc/enter_blueprint()
	if(!client)
		return
	ADD_TRAIT(src, TRAIT_BLUEPRINT_VISION, TRAIT_GENERIC)
	blueprints = new(client)
