SUBSYSTEM_DEF(blueprints)
	name = "Blueprint Visibility Manager"
	flags = SS_NO_FIRE

/datum/controller/subsystem/blueprints/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_ADD_TRAIT, PROC_REF(check_add_trait))
	RegisterSignal(SSdcs, COMSIG_REMOVE_TRAIT, PROC_REF(check_remove_trait))
	return ..()

/datum/controller/subsystem/blueprints/proc/check_add_trait(datum/source, mob/living/target, trait)
	if(!istype(target) || trait != TRAIT_BLUEPRINT_VISION || !target.client)
		return

	// Add viewer to all existing blueprints
	for(var/obj/structure/blueprint/blueprint in GLOB.active_blueprints)
		blueprint.add_viewer(target)

/datum/controller/subsystem/blueprints/proc/check_remove_trait(datum/source, mob/living/target, trait)
	if(!istype(target) || trait != TRAIT_BLUEPRINT_VISION || !target.client)
		return

	// Remove viewer from all blueprints
	for(var/obj/structure/blueprint/blueprint in GLOB.active_blueprints)
		blueprint.remove_viewer(target)

/datum/controller/subsystem/blueprints/proc/add_new_blueprint(obj/structure/blueprint/blueprint)
	// When a new blueprint is created, add it to all players with the trait
	for(var/mob/living/M in GLOB.player_list)
		if(HAS_TRAIT(M, TRAIT_BLUEPRINT_VISION) && M.client)
			blueprint.add_viewer(M)

/datum/controller/subsystem/blueprints/proc/remove_blueprint(obj/structure/blueprint/blueprint)
	// When a blueprint is removed, clean up its viewers
	blueprint.clear_all_viewers()
