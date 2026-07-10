/datum/component/vine_controller
	var/vine_type = /obj/structure/vine
	var/list/obj/structure/vine/vines = list()
	var/list/obj/structure/vine/growth_queue = list()
	var/list/vine_mutations_list = list()
	var/spread_multiplier = 1
	var/spread_cap = 4
	var/vine_cap = 25
	/// how many times SSProcessing needs to be called to actually try and grow. This is roughly 1 second.
	var/grow_speed = 1
	var/mutativeness = 1

	VAR_PRIVATE/processing_calls = 0
	var/delete_after_growing = FALSE

/datum/component/vine_controller/Initialize(vine_path, list/muts, potency, production, datum/round_event/event = null, max_spread, max_vines, seconds_to_grow=1, delete_after_growing=FALSE)
	. = ..()
	if(ispath(vine_path, /obj/structure/vine))
		vine_type = vine_path
	var/obj/structure/vine/SV = spawn_spacevine_piece(get_turf(parent), null, muts)
	if(max_spread > 0)
		spread_cap = max_spread
	if(max_vines > 0)
		vine_cap = max_vines
	src.delete_after_growing = delete_after_growing
	grow_speed = seconds_to_grow
	event?.announce_to_ghosts(SV)
	START_PROCESSING(SSprocessing, src)
	vine_mutations_list = list()
	init_subtypes(/datum/vine_mutation/, vine_mutations_list)
	if(potency != null)
		mutativeness = potency / 10

/datum/component/vine_controller/RegisterWithParent()
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(endvines))

/datum/component/vine_controller/UnregisterFromParent(datum/target, sig_type_or_types)
	. = ..()
	UnregisterSignal(parent, COMSIG_QDELETING)

/datum/component/vine_controller/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_SPACEVINE_PURGE, "Delete Vines")

/datum/component/vine_controller/vv_do_topic(href_list)
	. = ..()
	if(href_list[VV_HK_SPACEVINE_PURGE])
		if(tgui_alert(usr, "Are you sure you want to delete this spacevine cluster?", "Delete Vines", list("Yes", "No")) == "Yes")
			DeleteVines()

/datum/component/vine_controller/proc/DeleteVines()	//this is kill
	QDEL_LIST(vines) //this will also qdel us
	qdel(src)


/datum/component/vine_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	for(var/obj/structure/vine/vine in vines)
		UnregisterSignal(vine, COMSIG_QDELETING)
	vines = null
	growth_queue = null
	return ..()

/datum/component/vine_controller/proc/spawn_spacevine_piece(turf/location, obj/structure/vine/parent, list/datum/vine_mutation/muts)
	if(!location)
		return
	var/obj/structure/vine/new_vine = new vine_type(location)
	growth_queue += new_vine
	vines += new_vine
	RegisterSignal(new_vine, COMSIG_QDELETING, PROC_REF(on_vine_deleted))
	if(length(muts))
		for(var/datum/vine_mutation/M in muts)
			M.add_mutation_to_vinepiece(new_vine)
		return
	if(parent)
		new_vine.mutations |= parent.mutations
		var/parentcolor = parent.atom_colours[FIXED_COLOUR_PRIORITY]
		new_vine.add_atom_colour(parentcolor, FIXED_COLOUR_PRIORITY)
	for(var/datum/vine_mutation/SM in new_vine.mutations)
		SM.on_birth(new_vine)
	location.Entered(new_vine)
	return new_vine

/datum/component/vine_controller/proc/endvines()
	for(var/obj/structure/vine/V as anything in vines)
		V.dieepic()
	qdel(src)

/datum/component/vine_controller/proc/on_vine_deleted(obj/structure/vine/deleted_vine)
	vines -= deleted_vine
	growth_queue -= deleted_vine
	UnregisterSignal(deleted_vine, COMSIG_QDELETING)
	if(!length(vines))
		qdel(src)

/datum/component/vine_controller/process()
	processing_calls++
	if(processing_calls < grow_speed)
		return
	processing_calls = 0
	if(!length(vines))
		if(!(parent))
			qdel(src)
			return
		spawn_spacevine_piece(get_turf(parent), null)
	if(!growth_queue)
		qdel(src) //Sanity check
		return
	var/length = min(spread_cap, max(1, length(vines)/spread_multiplier))
	var/i = 0
	var/list/obj/structure/vine/queue_end = list()

	for(var/obj/structure/vine/grow_vine in growth_queue)
		if(length(vines) >= vine_cap)
			if(delete_after_growing)
				qdel(src)
				return
			break
		if(QDELETED(grow_vine))
			continue
		i++
		queue_end += grow_vine
		growth_queue -= grow_vine
		for(var/datum/vine_mutation/mutation in grow_vine.mutations)
			mutation.process_mutation(grow_vine)
		if(grow_vine.energy < 2) //If tile isn't fully grown
			if(prob(20))
				grow_vine.grow()
		else
			grow_vine.entangle_mob()
		if(i > spread_cap)
			break
		spawn_spacevine_piece(grow_vine.find_spread(), grow_vine)
		if(i > length)
			break
	growth_queue += queue_end
