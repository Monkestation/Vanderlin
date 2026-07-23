/obj/item/building_schematic/thatchwood_hall
	name = "town hall schematic"
	desc = "A rolled construction schematic for Thatchwood's new town hall."
	skill = /datum/action/cooldown/spell/place_blueprint/thatchwood_hall
	/// Weakref to the driver so placement can report back
	var/datum/weakref/driver_ref

/obj/item/building_schematic/thatchwood_hall/proc/set_driver(datum/objective_quest_driver/town_objective/area/thatchwood/driver)
	driver_ref = WEAKREF(driver)

/datum/action/cooldown/spell/place_blueprint/thatchwood_hall
	cares_about_placement = TRUE

/datum/action/cooldown/spell/place_blueprint/thatchwood_hall/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		owner.balloon_alert(owner, "Quest expired!")
		return FALSE

	if(driver.schematic_placed)
		owner.balloon_alert(owner, "Foundation already placed!")
		return FALSE

	var/turf/T = get_turf(cast_on)
	var/area/target_area = get_area(T)
	for(var/area/A in driver.real_areas)
		if(target_area == A)
			return TRUE

	owner.balloon_alert(owner, "Must place within Thatchwood!")
	return FALSE

/datum/action/cooldown/spell/place_blueprint/thatchwood_hall
	name = "Place Thatchwood Hall"

/datum/action/cooldown/spell/place_blueprint/thatchwood_hall/cast(atom/cast_on)
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	var/turf/T = get_turf(cast_on)
	if(!is_type_in_list(get_area(T), driver.area_types))
		return
	. = ..()

	var/datum/building_preview/preview = schematic?.get_or_build_preview()
	if(!preview)
		return

	// Deactivate first so the ghost vanishes cleanly before blueprints appear
	unset_click_ability(owner, refund_cooldown = FALSE)

	var/list/placed = preview.place_blueprints(T, owner)
	if(!length(placed))
		return

	if(!driver)
		return

	driver.on_schematic_placed(owner, placed)
