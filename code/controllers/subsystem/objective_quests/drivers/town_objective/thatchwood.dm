/datum/objective_quest_driver/town_objective/area/thatchwood
	area_types = list(
		/area/outdoors/wilderness/outpost/vanderlin,
		/area/indoors/wilderness/tavern,
		/area/indoors/wilderness/garrison,
		/area/indoors/wilderness/shop,
		/area/outdoors/wilderness/beside_thatchwood,
	)
	stages = list(
		list(
			"quest_types" = list(/datum/quest/objective/thatchwood/kill),
			"triumph_reward" = 1,
			"triumph_reason" = "Secured Thatchwood."
		),
		list(
			"quest_types" = list(/datum/quest/objective/thatchwood/clear_trees),
			"triumph_reward" = 1,
			"triumph_reason" = "Cleared Thatchwood's forests."
		),
		list(
			"quest_types" = list(/datum/quest/objective/thatchwood/clear_clutter),
			"triumph_reward" = 1,
			"triumph_reason" = "Cleaned up Thatchwood."
		),
		list(
			"quest_types" = list(/datum/quest/objective/thatchwood/build_hall),
			"triumph_reward" = 2,
			"triumph_reason" = "Built Thatchwood's Town Hall."
		),
	)
	var/mob_count = 0
	var/tree_count = 0
	var/clutter_count = 0

	var/initial_mob_count = 0
	var/initial_tree_count = 0
	var/initial_clutter_count = 0

	/// All blueprint structures placed from the shared schematic
	var/list/town_hall_blueprints = null
	/// TRUE once any quester has placed the schematic
	var/schematic_placed = FALSE
	/// TRUE once all blueprints are built (used by quests to check_completion)
	var/town_hall_complete = FALSE
	///list of our mobs
	var/list/mobs = list()

/datum/objective_quest_driver/town_objective/area/thatchwood/setup_stages()
	for(var/area/managed_area in real_areas)
		for(var/mob/living/living in managed_area.contents)
			mob_count++
			mobs |= living
			RegisterSignal(living, COMSIG_LIVING_DEATH, PROC_REF(mob_death))
		for(var/obj/structure/kneestingers/C in managed_area.contents)
			clutter_count++
			RegisterSignal(C, COMSIG_QDELETING, PROC_REF(clutter_cleanup))
		for(var/obj/structure/flora/newtree/newtree in managed_area.contents)
			tree_count++
			RegisterSignal(newtree, COMSIG_QDELETING, PROC_REF(tree_cleanup))

	initial_mob_count = mob_count
	initial_tree_count = tree_count
	initial_clutter_count = clutter_count


/datum/objective_quest_driver/town_objective/area/thatchwood/proc/mob_death(mob/living/source)
	mob_count--
	mobs -= source
	notify_active_quest(/datum/quest/objective/thatchwood/kill)

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/tree_cleanup(obj/source)
	tree_count--
	notify_active_quest(/datum/quest/objective/thatchwood/clear_trees)

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/clutter_cleanup(obj/source)
	clutter_count--
	notify_active_quest(/datum/quest/objective/thatchwood/clear_clutter)

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/on_schematic_placed(mob/living/placer, list/blueprints)
	if(schematic_placed)
		to_chat(placer, span_warning("The town hall foundation has already been laid!"))
		for(var/obj/structure/blueprint/B in blueprints)
			qdel(B)
		return

	schematic_placed = TRUE
	town_hall_blueprints = blueprints.Copy()

	for(var/obj/structure/blueprint/B in town_hall_blueprints)
		RegisterSignal(B, COMSIG_QDELETING, PROC_REF(on_blueprint_removed))

	// Tell all active build_hall quests to drop their unused schematics
	for(var/datum/quest/objective/thatchwood/build_hall/Q in get_active_build_hall_quests())
		Q.on_schematic_placed()

	to_chat(placer, span_notice("The town hall foundation is set. All questers may now contribute!"))

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/on_blueprint_removed(obj/structure/blueprint/source)
	SIGNAL_HANDLER
	town_hall_blueprints -= source
	if(length(town_hall_blueprints) == 0 && schematic_placed)
		town_hall_complete = TRUE
		complete_active_build_hall_quests()

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/get_active_build_hall_quests()
	var/list/result = list()
	for(var/obj/item/paper/scroll/quest/S in GLOB.quest_scrolls)
		if(!S.assigned_quest || S.assigned_quest.complete || !S.assigned_quest.quest_receiver_reference)
			continue
		if(istype(S.assigned_quest, /datum/quest/objective/thatchwood/build_hall))
			result += S.assigned_quest
	return result

/datum/objective_quest_driver/town_objective/area/thatchwood/proc/complete_active_build_hall_quests()
	for(var/datum/quest/objective/thatchwood/build_hall/Q in get_active_build_hall_quests())
		Q.mark_complete()

/datum/objective_quest_driver/town_objective/area/thatchwood/Destroy()
	if(town_hall_blueprints)
		for(var/obj/structure/blueprint/B in town_hall_blueprints)
			if(!QDELETED(B))
				UnregisterSignal(B, COMSIG_QDELETING)
	town_hall_blueprints = null
	return ..()

/datum/objective_quest_driver/town_objective/area/thatchwood/Destroy()
	for(var/area/managed_area in real_areas)
		for(var/mob/living/living in managed_area.contents)
			UnregisterSignal(living, COMSIG_LIVING_DEATH)
		for(var/obj/structure/kneestingers/C in managed_area.contents)
			UnregisterSignal(C, COMSIG_QDELETING)
		for(var/obj/structure/flora/newtree/newtree in managed_area.contents)
			UnregisterSignal(newtree, COMSIG_QDELETING)
	return ..()
