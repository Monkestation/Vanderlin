GLOBAL_LIST_EMPTY(active_ghost_vessels)

/datum/component/ghost_vessel
	var/obj/item/vessel_item_type
	var/mob/living/carbon/human/owner
	var/being_offered = FALSE
	var/vessel_id = WHITELIST_AUTOMATON

/datum/component/ghost_vessel/Initialize(obj/item/item_type, id = WHITELIST_AUTOMATON)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	vessel_item_type = item_type
	vessel_id = id
	ADD_TRAIT(owner, TRAIT_STASIS, REF(src))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, SOULSTONE_TRAIT)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, SOULSTONE_TRAIT)
	if(!vessel_item_type)
		being_offered = TRUE
		owner.balloon_alert_to_viewers("This vessel awaits a soul...")
		if(!GLOB.active_ghost_vessels[vessel_id])
			GLOB.active_ghost_vessels[vessel_id] = list()
		GLOB.active_ghost_vessels[vessel_id] += owner  // store the mob, not the component
		return

	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_deleted))

/datum/component/ghost_vessel/Destroy()
	if(vessel_id && GLOB.active_ghost_vessels[vessel_id])
		GLOB.active_ghost_vessels[vessel_id] -= owner
		if(!length(GLOB.active_ghost_vessels[vessel_id]))
			GLOB.active_ghost_vessels -= vessel_id  // clean up empty keys
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_STASIS, REF(src))
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, SOULSTONE_TRAIT)
		REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, SOULSTONE_TRAIT)
	owner = null
	return ..()

/datum/component/ghost_vessel/proc/on_parent_deleted(datum/source)
	return

/datum/component/ghost_vessel/proc/on_attackby(datum/source, obj/item/W, mob/living/user)
	SIGNAL_HANDLER
	if(!istype(W, vessel_item_type))
		return
	if(being_offered)
		return
	qdel(W)
	INVOKE_ASYNC(src, PROC_REF(begin_ghost_offer))

/datum/component/ghost_vessel/proc/begin_ghost_offer()
	being_offered = TRUE

	var/list/candidates = pollCandidatesForMobWhitelisted(
		"A vessel at [owner.loc] awaits a soul. Do you wish to inhabit it?",
		null,
		null,
		null,
		100,
		parent,
		POLL_IGNORE_GOLEM,
		new_players = TRUE,
		whitelist_type = vessel_id,
	)

	if(length(candidates))
		var/mob/dead/observer/chosen = candidates[1]
		possess_vessel(chosen)
	else
		owner.balloon_alert_to_viewers("This vessel awaits a soul...")
		if(!GLOB.active_ghost_vessels[vessel_id])
			GLOB.active_ghost_vessels[vessel_id] = list()
		GLOB.active_ghost_vessels[vessel_id] += owner  // store the mob, not the component


/datum/component/ghost_vessel/proc/possess_vessel(mob/dead/observer/ghost)
	if(!ghost?.client)
		return

	being_offered = FALSE
	REMOVE_TRAIT(owner, TRAIT_STASIS, REF(src))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, SOULSTONE_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, SOULSTONE_TRAIT)
	owner.after_creation()
	owner.key = ghost.client.key
	var/new_name = browser_input_text(owner, "Choose a new Name", "New Name", owner.name)
	if(new_name)
		owner.real_name = new_name
	qdel(src)
