GLOBAL_LIST_INIT(dungeon_descents, list())
GLOBAL_LIST_INIT(descent_level_map, list()) // Maps z-levels to their descent objects

/obj/structure/dungeon_descent
	name = "Ancient Stairway"
	desc = "A crumbling stone stairway that descends into the depths below. The air grows colder as it winds downward."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = TRUE
	anchored = TRUE
	appearance_flags = NONE
	opacity = TRUE
	obj_flags = INDESTRUCTIBLE

	var/current_delve_level = 1
	var/target_delve_level = 2
	var/can_descend = TRUE
	var/list/descent_requirements = list()
	var/requires_all = FALSE

/obj/structure/dungeon_descent/Initialize()
	. = ..()
	GLOB.dungeon_descents |= src

	// Register this descent for its current level
	var/current_z = z
	if(!GLOB.descent_level_map["[current_z]"])
		GLOB.descent_level_map["[current_z]"] = list()
	GLOB.descent_level_map["[current_z]"] |= src

	// Set up time-based requirements if needed
	if(LAZYACCESS(descent_requirements, "Time"))
		GLOB.TodUpdate += src

/obj/structure/dungeon_descent/Destroy()
	GLOB.dungeon_descents -= src
	var/current_z = z
	if(GLOB.descent_level_map["[current_z]"])
		GLOB.descent_level_map["[current_z]"] -= src
	if(LAZYACCESS(descent_requirements, "Time"))
		GLOB.TodUpdate -= src
	return ..()

/obj/structure/dungeon_descent/update_tod(todd)
	// Update icon based on time requirements if needed
	if(todd == descent_requirements["Time"])
		icon_state = "shitportal"
		can_descend = TRUE
	else if(descent_requirements["Time"])
		icon_state = "shitportal_blocked"
		can_descend = FALSE

/obj/structure/dungeon_descent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/dungeon_descent/attackby(obj/item/W, mob/user, list/modifiers)
	return use(user)

/obj/structure/dungeon_descent/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/dungeon_descent/proc/use(mob/user, is_ghost = FALSE)
	return

/obj/structure/dungeon_descent/proc/attempt_descent(mob/user, is_ghost = FALSE)
	if(!is_ghost && !can_descend)
		to_chat(user, span_warning("The passage seems blocked by some unseen force."))
		return FALSE

	if(descent_requirements && !is_ghost)
		if(!has_requirements(user))
			return FALSE
	return TRUE

/obj/structure/dungeon_descent/proc/has_requirements(mob/user)
	if(!length(descent_requirements))
		return TRUE

	var/requirements_met = 0
	var/time_req = LAZYACCESS(descent_requirements, "Time")
	if(time_req && GLOB.tod == time_req)
		requirements_met++

	// Add other requirement checks here as needed

	if(!requires_all && requirements_met > 0)
		return TRUE
	if(requirements_met < length(descent_requirements))
		to_chat(user, span_warning("You cannot descend yet. Something holds you back."))
		return FALSE
	return TRUE
