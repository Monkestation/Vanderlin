GLOBAL_LIST_EMPTY(active_ghost_vessels)

/datum/component/ghost_vessel
	/// Item type that activates the vessel
	var/obj/item/vessel_item_type
	/// If we are being offered to ghosts
	var/being_offered = FALSE
	/// Whitelist ID
	var/vessel_id = WHITELIST_AUTOMATON
	/// Optional callback invoked once a ghost successfully possesses the vessel.
	/// Called as callback.Invoke(vessel_mob, ghost) — useful for non-living mobs
	/// that need custom setup instead of the default /mob/living/after_creation().
	var/datum/callback/on_possess_callback

/datum/component/ghost_vessel/Initialize(obj/item/item_type, id = WHITELIST_AUTOMATON, datum/callback/possess_callback)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	vessel_item_type = item_type
	vessel_id = id
	on_possess_callback = possess_callback
	if(vessel_item_type)
		return
	if(SSticker.HasRoundStarted())
		addtimer(CALLBACK(src, PROC_REF(begin_ghost_offer)), 5 SECONDS)
	else
		being_offered = TRUE
		astype(parent, /atom).balloon_alert_to_viewers("This vessel awaits a soul...")
		if(!GLOB.active_ghost_vessels[vessel_id])
			GLOB.active_ghost_vessels[vessel_id] = list()
		GLOB.active_ghost_vessels[vessel_id] += parent  // store the mob, not the component

/datum/component/ghost_vessel/Destroy()
	if(vessel_id && GLOB.active_ghost_vessels[vessel_id])
		GLOB.active_ghost_vessels[vessel_id] -= parent
		if(!length(GLOB.active_ghost_vessels[vessel_id]))
			GLOB.active_ghost_vessels -= vessel_id
	on_possess_callback = null
	return ..()

/datum/component/ghost_vessel/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_STASIS, REF(src))
	ADD_TRAIT(parent, TRAIT_IMMOBILIZED, SOULSTONE_TRAIT)
	ADD_TRAIT(parent, TRAIT_HANDS_BLOCKED, SOULSTONE_TRAIT)
	if(!vessel_item_type)
		RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
		RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_deleted))

/datum/component/ghost_vessel/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_STASIS, REF(src))
	REMOVE_TRAIT(parent, TRAIT_IMMOBILIZED, SOULSTONE_TRAIT)
	REMOVE_TRAIT(parent, TRAIT_HANDS_BLOCKED, SOULSTONE_TRAIT)
	if(!vessel_item_type)
		UnregisterSignal(parent, list(COMSIG_ATOM_ITEM_INTERACTION, COMSIG_QDELETING))

/datum/component/ghost_vessel/proc/on_parent_deleted(datum/source)
	return

/datum/component/ghost_vessel/proc/on_item_interaction(datum/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	if(!istype(tool, vessel_item_type))
		return NONE
	if(being_offered)
		return ITEM_INTERACT_BLOCKING
	qdel(tool)
	INVOKE_ASYNC(src, PROC_REF(begin_ghost_offer))
	return ITEM_INTERACT_SUCCESS

/datum/component/ghost_vessel/proc/begin_ghost_offer()
	being_offered = TRUE
	var/mob/vessel_mob = parent
	var/list/candidates = pollCandidatesForMobWhitelisted(
		"A [vessel_id] vessel at [vessel_mob.loc] awaits a soul. Do you wish to inhabit it?",
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
		return
	astype(parent, /atom).balloon_alert_to_viewers("This vessel awaits a soul...")
	if(!GLOB.active_ghost_vessels[vessel_id])
		GLOB.active_ghost_vessels[vessel_id] = list()
	GLOB.active_ghost_vessels[vessel_id] += vessel_mob

/datum/component/ghost_vessel/proc/possess_vessel(mob/dead/observer/ghost)
	if(!ghost?.client)
		return
	being_offered = FALSE
	ghost.client.stop_sounds_rogue()
	var/mob/vessel_mob = parent
	if(isliving(vessel_mob))
		var/mob/living/living_vessel = vessel_mob
		living_vessel.after_creation()
	vessel_mob.key = ghost.client.key
	var/new_name = browser_input_text(vessel_mob, "Choose a new Name", "New Name", vessel_mob.name)
	if(new_name)
		vessel_mob.real_name = new_name
	if(on_possess_callback)
		on_possess_callback.Invoke(vessel_mob, ghost)
	SEND_SIGNAL(vessel_mob, COMSIG_GHOST_VESSEL_POSSESSED, src)
	qdel(src)
