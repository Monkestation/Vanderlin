/datum/quest/objective/thatchwood/build_hall
	title = "Build the Town Hall"
	quest_difficulty = QUEST_DIFFICULTY_HARD
	minimum_payout = QUEST_REWARD_HARD_LOW
	maximum_payout = QUEST_REWARD_HARD_HIGH

	/// The schematic we handed to this quester, null once placed/expired
	var/obj/item/building_schematic/thatchwood_hall/my_schematic
	/// Weakref to the driver so we can call back on placement
	var/datum/weakref/driver_ref

/datum/quest/objective/thatchwood/build_hall/proc/set_driver(datum/objective_quest_driver/town_objective/area/thatchwood/driver)
	driver_ref = WEAKREF(driver)

/datum/quest/objective/thatchwood/build_hall/get_title()
	return "Build the Town Hall"

/datum/quest/objective/thatchwood/build_hall/get_objective_text()
	return "Use the provided schematic to lay the foundation for Thatchwood's town hall, then construct it."

/datum/quest/objective/thatchwood/build_hall/get_location_text()
	return "Construction site: Thatchwood."

/datum/quest/objective/thatchwood/build_hall/register_signals(mob/user)
	. = ..()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return

	// If schematic already placed by another quester, no schematic needed
	if(driver.schematic_placed)
		return

	my_schematic = new /obj/item/building_schematic/thatchwood_hall(user)
	my_schematic.set_driver(driver)
	user.put_in_hand(my_schematic)

/datum/quest/objective/thatchwood/build_hall/unregister_signals(mob/user)
	. = ..()
	if(!QDELETED(my_schematic))
		qdel(my_schematic)
	my_schematic = null

/// Called by the driver once any quester successfully places the schematic
/datum/quest/objective/thatchwood/build_hall/proc/on_schematic_placed()
	// Destroy our schematic if we still have it (we weren't the one who placed)
	if(!QDELETED(my_schematic))
		qdel(my_schematic)
	my_schematic = null

/datum/quest/objective/thatchwood/build_hall/check_completion()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return FALSE
	return driver.town_hall_complete

/datum/quest/objective/thatchwood/build_hall/Destroy()
	if(!QDELETED(my_schematic))
		qdel(my_schematic)
	my_schematic = null
	driver_ref = null
	return ..()
