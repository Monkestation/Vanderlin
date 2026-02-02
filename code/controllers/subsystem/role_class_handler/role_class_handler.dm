/*
	Basically we got a subsystem for the shitty subjob handling and new menu as of 4/30/2024 that goes with it
*/

/*
	REMINDER TO RETEST THE OVERFILL HELPER
*/
SUBSYSTEM_DEF(role_class_handler)
	name = "Role Class Handler"
	wait = 1 SECONDS
	init_order = INIT_ORDER_ROLE_CLASS_HANDLER
	priority = FIRE_PRIORITY_ROLE_CLASS_HANDLER
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_GAME|RUNLEVEL_SETUP
	flags = SS_NO_FIRE

	/**
	 *	a list of datums dedicated to helping handle a class selection session
	 *	ex: class_select_handlers[ckey] = /datum/class_select_handler
	 *	contents: class_select_handlers = list("ckey" = /datum/class_select_handler, "ckey2" = /datum/class_select_handler,... etc)
	 */
	var/list/class_select_handlers = list()

	/**
	 *	This ones basically a list for if you want to give a specific ckey a specific isolated datum
	 *	ex: special_session_queue[ckey] += /datum/job/advclass/BIGMAN
	 *	contents: special_session_queue = list("ckey" = list("funID" = /datum/job/advclass/class), "ckey2" = list("funID" = /datum/job/advclass/class)... etc)
	 */
	var/list/list/special_session_queue = list()

	/**
	 *	This is basically a big assc list of lists attached to tags which contain /datum/job/advclass datums
	 *	ex: sorted_class_categories[CTAG_GAPEMASTERS] += /datum/job/advclass/GAPER
	 *	contents: sorted_class_categories = list("CTAG_GAPEMASTERS" = list(/datum/job/advclass/GAPER, /datum/job/advclass/GAPER2)... etc)
	 *	Snowflake lists:
	 *		CTAG_ALLCLASS = list(every single class datum that exists outside of the parent)
	 */
	var/list/sorted_class_categories = list()

	/// Whether bandits have been injected in the game
	var/bandits_in_round = FALSE

/datum/controller/subsystem/role_class_handler/Initialize()
	build_category_lists()

	initialized = TRUE

	return ..()

/datum/controller/subsystem/role_class_handler/proc/get_all_advclass_names()
	var/list/compiled = list()
	for(var/cat_name in sorted_class_categories)
		for(var/datum/job/advclass/class in sorted_class_categories[cat_name])
			compiled += class.title
	return compiled

// This covers both class datums and drifter waves
/datum/controller/subsystem/role_class_handler/proc/build_category_lists()
	var/list/all_classes = list()
	for(var/datum/job/job as anything in subtypesof(/datum/job/advclass))
		if(IS_ABSTRACT(job))
			continue
		var/datum/job/real_datum = SSjob.GetJobType(job)
		if(real_datum)
			all_classes += real_datum
	sorted_class_categories[CTAG_ALLCLASS] = all_classes

	//Time to sort these classes, and sort them we shall.
	for(var/datum/job/advclass/class in all_classes)
		for(var/ctag in class.category_tags)
			if(!sorted_class_categories[ctag]) // New cat
				sorted_class_categories[ctag] = list()
			sorted_class_categories[ctag] += class

	//Well that about covers it really.

/*
	We setup the class handler here, aka the menu
	We will cache it per server session via an assc list with a ckey leading to the datum.
*/
/datum/controller/subsystem/role_class_handler/proc/setup_class_handler(mob/living/carbon/human/H, advclass_rolls_override = null)
	if(!H)
		CRASH("setup_class_handler was called without a passed mob in args!")

	if(H.client.has_triumph_buy(TRIUMPH_BUY_ANY_CLASS))
		H.client.activate_triumph_buy(TRIUMPH_BUY_ANY_CLASS)

	// insure they somehow aren't closing the datum they got and opening a new one w rolls
	var/datum/class_select_handler/class_select = class_select_handlers[H.client.ckey]
	if(class_select)
		if(!class_select.linked_client) // this ref will disappear if they disconnect neways probably, as its a client
			class_select.linked_client = H.client // Thus we just give it back to them
		class_select.second_step() // And give them a second dose of something they already dosed on
	else
		class_select = new()
	class_select.linked_client = H.client

	var/used_key = class_select.linked_client.ckey

		// Hack for Migrants
	if(advclass_rolls_override)
		class_select.class_cat_alloc_attempts = advclass_rolls_override
	else
		var/datum/job/job_datum = SSjob.GetJob(H.job)
		if(length(job_datum.advclass_cat_rolls))
			class_select.class_cat_alloc_attempts = job_datum.advclass_cat_rolls

	if(used_key in special_session_queue)
		class_select.special_session_queue = list()
		for(var/funny_key in special_session_queue[used_key])
			var/datum/job/advclass/special_class = special_session_queue[used_key][funny_key]
			if(special_class.total_positions > special_class.current_positions)
				class_select.special_session_queue += special_class

	class_select.initial_setup()
	class_select_handlers[used_key] = class_select

/*
	Attempt to finish the class handling ordeal, aka they picked something
	Since this is class handler related, might as well also have the class handler send itself into the params
*/
/datum/controller/subsystem/role_class_handler/proc/finish_class_handler(mob/living/carbon/human/H, datum/job/advclass/picked_class, datum/class_select_handler/related_handler, special_session_queue)
	if(!picked_class || QDELETED(related_handler) || QDELETED(H)) // Extreme edge case but is possible, likely href exploit or late activation
		return FALSE

	if(picked_class.total_positions != -1)
		if(picked_class.current_positions >= picked_class.total_positions)
			related_handler.rolled_class_is_full(picked_class)
			return FALSE

	SSjob.AssignRole(H, picked_class, TRUE)
	adjust_class_amount(picked_class, 1) // we are handling one guy right now.
	H.finish_class_hugbox()

	qdel(related_handler)

	// At this point the job is the job of the previous advclass "parent" or null
	var/datum/job/old = SSjob.GetJob(H.job)

	picked_class.parent_job = old

	if(picked_class.inherit_parent_title)
		if(old)
			if(H.pronouns == SHE_HER && old.f_title)
				picked_class.title_override = old.f_title
			else
				picked_class.title_override = old.title

	SSjob.EquipRank(H, picked_class, H.client, reset_job_stats = picked_class.should_reset_stats)

	apply_loadouts(H, H.client)

// A dum helper to adjust the class amount, we could do it elsewhere but this will also inform any relevant class handlers open.
/datum/controller/subsystem/role_class_handler/proc/adjust_class_amount(datum/job/advclass/target_datum, amount)
	if(target_datum.total_positions == -1) // Is the class not set to infinite?
		return
	if(target_datum.current_positions < target_datum.total_positions)
		return
	// We just hit a cap, iterate all the class handlers and inform them.
	for(var/HANDLER in class_select_handlers)
		var/datum/class_select_handler/found_menu = class_select_handlers[HANDLER]

		if(target_datum in found_menu.rolled_classes) // We found the target datum in one of the classes they rolled aka in the list of options they got visible,
			found_menu.rolled_class_is_full(target_datum) //  inform the datum of its error.

/datum/controller/subsystem/role_class_handler/proc/cancel_class_handler(mob/living/carbon/human/H)
	H.finish_class_hugbox()

	var/datum/class_select_handler/related_handler = class_select_handlers[H.client.ckey]
	if(related_handler)
		qdel(related_handler)
