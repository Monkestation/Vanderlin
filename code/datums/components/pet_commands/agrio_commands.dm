//not sure if this is what you meant by "write my own for this" or write my own farming.dm.. since this is easier i went for this..
/datum/pet_command/agriopylon
	radial_icon = 'icons/hud/radial_pets.dmi'
	sense_radius = 9
	command_feedback = "ruffles leaves"

/datum/pet_command/agriopylon/tend_crops
	command_name = "Tend Crops"
	command_desc = "Tell your agriopylon to nurture nearby plants."
	radial_icon_state = "tend"
	speech_commands = list("tend", "farm", "grow", "garden", "cultivate")
	command_feedback = "ruffles"

/datum/pet_command/agriopylon/tend_crops/execute_action(datum/ai_controller/controller)
	var/mob/living/pylon = controller.pawn
	controller.set_blackboard_key(BB_GNOME_CROP_MODE, TRUE)
	pylon.visible_message(span_notice("[pylon] begins nurture the plants."))
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/pet_command/agriopylon/stop_tending
	command_name = "Stop Tending"
	command_desc = "Tell your agriopylon to stop tending."
	radial_icon_state = "tend-stop"
	speech_commands = list("stop", "rest", "halt", "pause")
	command_feedback = "sways"

/datum/pet_command/agriopylon/stop_tending/execute_action(datum/ai_controller/controller)
	var/mob/living/pylon = controller.pawn
	controller.set_blackboard_key(BB_GNOME_CROP_MODE, FALSE)
	pylon.visible_message(span_notice("[pylon] stops tending and retracts its roots."))
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/pet_command/agriopylon/search_range
	command_name = "Extend Reach"
	command_desc = "Adjust how far the agriopylon's reach."
	radial_icon_state = "range"
	speech_commands = list("range", "extend", "reach")
	command_feedback = "stretches vines"

/datum/pet_command/agriopylon/search_range/try_activate_command(mob/living/commander, radial_command)
	var/mob/living/pylon = weak_parent.resolve()
	if(!pylon)
		return
	var/datum/ai_controller/controller = pylon.ai_controller
	if(!controller)
		return
	var/choice = input(commander, "Set agriopylon tending range (1 to 15 tiles)", "Tend Range") as num|null
	if(isnull(choice) || choice <= 0)
		controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
		return
	choice = clamp(choice, 1, 15)
	controller.set_blackboard_key(BB_GNOME_CROP_MODE, choice)
	pylon.visible_message(span_notice("[pylon] stretches its vines outward, sensing up to [choice] tiles away."))
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)

